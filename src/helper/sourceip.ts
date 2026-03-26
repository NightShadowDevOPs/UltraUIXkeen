import { sourceIPLabelList } from '@/store/settings'
import { activeBackend, backendList } from '@/store/setup'
import * as ipaddr from 'ipaddr.js'
import { watch } from 'vue'

const CACHE_SIZE = 256
const ipLabelCache = new Map<string, string>()
const sourceIPMap = new Map<string, string>()
const sourceIPRegexList: { regex: RegExp; label: string }[] = []
const sourceIPCIDRList: {
  cidr: [ipaddr.IPv4 | ipaddr.IPv6, number]
  label: string
  key: string
}[] = []

export type SourceIpRuleKind = 'exact' | 'cidr' | 'regex' | 'suffix'

export const isSourceIpScopeVisible = (scope?: string[]) => {
  if (!scope?.length) return true

  const normalizedScope = scope.map((item) => String(item || '').trim()).filter(Boolean)
  if (!normalizedScope.length) return true

  const currentBackendId = String(activeBackend.value?.uuid || '').trim()
  if (currentBackendId && normalizedScope.includes(currentBackendId)) return true

  const localBackendIds = new Set(
    (backendList.value || [])
      .map((backend) => String((backend as any)?.uuid || '').trim())
      .filter(Boolean),
  )

  if (!localBackendIds.size) return true

  const hasAnyLocalScope = normalizedScope.some((id) => localBackendIds.has(id))
  return !hasAnyLocalScope
}

const preprocessSourceIPList = () => {
  ipLabelCache.clear()
  sourceIPMap.clear()
  sourceIPRegexList.length = 0
  sourceIPCIDRList.length = 0

  for (const { key, label, scope } of sourceIPLabelList.value) {
    if (!isSourceIpScopeVisible(scope as string[] | undefined)) continue

    // Regex: /.../
    if (key.startsWith('/')) {
      sourceIPRegexList.push({ regex: new RegExp(key.slice(1), 'i'), label })
      continue
    }

    // CIDR: 192.168.0.0/24 or 2001:db8::/32
    if (key.includes('/')) {
      try {
        const cidr = ipaddr.parseCIDR(key) as [ipaddr.IPv4 | ipaddr.IPv6, number]
        sourceIPCIDRList.push({ cidr, label, key })
        continue
      } catch {
        // fallthrough to exact match map
      }
    }

    sourceIPMap.set(key, label)
  }
}

const cacheResult = (ip: string, label: string) => {
  ipLabelCache.set(ip, label)

  if (ipLabelCache.size > CACHE_SIZE) {
    const firstKey = ipLabelCache.keys().next().value

    if (firstKey) {
      ipLabelCache.delete(firstKey)
    }
  }

  return label
}

watch(() => [sourceIPLabelList.value, activeBackend.value], preprocessSourceIPList, {
  immediate: true,
  deep: true,
})

export const getSourceIpRuleKind = (key: string): SourceIpRuleKind => {
  const raw = String(key || '').trim()
  if (!raw) return 'exact'
  if (raw.startsWith('/')) return 'regex'
  if (raw.includes('/')) {
    try {
      ipaddr.parseCIDR(raw)
      return 'cidr'
    } catch {
      // fall through
    }
  }
  if (raw.includes(':') && !ipaddr.isValid(raw)) return 'suffix'
  return 'exact'
}

export const matchesSourceIpRule = (key: string, ip: string) => {
  const raw = String(key || '').trim()
  const target = String(ip || '').trim()
  if (!raw || !target) return false

  const kind = getSourceIpRuleKind(raw)
  if (kind === 'regex') {
    try {
      return new RegExp(raw.slice(1), 'i').test(target)
    } catch {
      return false
    }
  }

  if (kind === 'cidr') {
    if (!ipaddr.isValid(target)) return false
    try {
      const addr = ipaddr.parse(target) as ipaddr.IPv4 | ipaddr.IPv6
      const cidr = ipaddr.parseCIDR(raw) as [ipaddr.IPv4 | ipaddr.IPv6, number]
      if (addr.kind() !== cidr[0].kind()) return false
      return addr.match(cidr)
    } catch {
      return false
    }
  }

  if (kind === 'suffix') return target.includes(':') && target.endsWith(raw)
  return target === raw
}

const getCIDRLabel = (ip: string) => {
  if (!sourceIPCIDRList.length) return ''
  if (!ipaddr.isValid(ip)) return ''

  let addr: ipaddr.IPv4 | ipaddr.IPv6
  try {
    addr = ipaddr.parse(ip) as ipaddr.IPv4 | ipaddr.IPv6
  } catch {
    return ''
  }

  for (const { cidr, label, key } of sourceIPCIDRList) {
    // IPv4 can't match IPv6 ranges and vice versa
    if (addr.kind() !== cidr[0].kind()) continue

    try {
      if (addr.match(cidr)) {
        // If label is empty, fall back to the key itself.
        return (label || '').trim() ? label : key
      }
    } catch {
      // ignore parse/match edge cases
    }
  }

  return ''
}


export const getExactIPLabelFromMap = (ip: string) => {
  if (!ip) return ip === '' ? 'Inner' : ''

  if (sourceIPMap.has(ip)) {
    const label = sourceIPMap.get(ip)!
    return (label || '').trim() ? label : ip
  }

  return ''
}

export const getIPLabelFromMap = (ip: string) => {
  if (!ip) return ip === '' ? 'Inner' : ''

  if (ipLabelCache.has(ip)) {
    return ipLabelCache.get(ip)!
  }

  const isIPv6 = ip.includes(':')

  if (isIPv6) {
    for (const [key, label] of sourceIPMap.entries()) {
      if (ip.endsWith(key)) {
        // If label is empty, fall back to the key itself.
        return cacheResult(ip, (label || '').trim() ? label : key)
      }
    }

    const cidrLabel = getCIDRLabel(ip)
    if (cidrLabel) return cacheResult(ip, cidrLabel)
  } else if (sourceIPMap.has(ip)) {
    const label = sourceIPMap.get(ip)!
    // If label is empty, fall back to IP itself.
    return cacheResult(ip, (label || '').trim() ? label : ip)
  } else {
    const cidrLabel = getCIDRLabel(ip)
    if (cidrLabel) return cacheResult(ip, cidrLabel)
  }

  for (const { regex, label } of sourceIPRegexList) {
    if (regex.test(ip)) {
      // If label is empty, fall back to IP itself.
      return cacheResult(ip, (label || '').trim() ? label : ip)
    }
  }

  return cacheResult(ip, ip)
}

// Best-effort reverse lookup: map a saved "label" back to the original IP key.
// Used to merge legacy traffic history that was recorded under labels.
// Only supports exact IP keys (not CIDR / regex).
export const getIPKeyFromLabel = (label: string) => {
  const l = (label || '').trim()
  if (!l) return ''

  const backendId = activeBackend.value?.uuid as string | undefined

  for (const it of sourceIPLabelList.value || []) {
    const lb = (it.label || '').trim()
    if (lb !== l) continue

    if (!isSourceIpScopeVisible(it.scope as string[] | undefined)) continue

    const k = (it.key || '').trim()
    if (!k) continue
    if (k.startsWith('/')) continue // regex
    if (k.includes('/')) continue // CIDR

    return k
  }

  return ''
}
