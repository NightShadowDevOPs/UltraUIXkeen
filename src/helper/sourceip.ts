import { sourceIPLabelList } from '@/store/settings'
import { activeBackend } from '@/store/setup'
import { watch } from 'vue'

const CACHE_SIZE = 256
const ipLabelCache = new Map<string, string>()
const sourceIPMap = new Map<string, string>()
const sourceIPRegexList: { regex: RegExp; label: string }[] = []

const preprocessSourceIPList = () => {
  ipLabelCache.clear()
  sourceIPMap.clear()
  sourceIPRegexList.length = 0

  for (const { key, label, scope } of sourceIPLabelList.value) {
    if (scope && !scope.includes(activeBackend.value?.uuid as string)) continue
    if (key.startsWith('/')) {
      sourceIPRegexList.push({ regex: new RegExp(key.slice(1), 'i'), label })
    } else {
      sourceIPMap.set(key, label)
    }
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
  } else if (sourceIPMap.has(ip)) {
    const label = sourceIPMap.get(ip)!
    // If label is empty, fall back to IP itself.
    return cacheResult(ip, (label || '').trim() ? label : ip)
  }

  for (const { regex, label } of sourceIPRegexList) {
    if (regex.test(ip)) {
      // If label is empty, fall back to IP itself.
      return cacheResult(ip, (label || '').trim() ? label : ip)
    }
  }

  return cacheResult(ip, ip)
}
