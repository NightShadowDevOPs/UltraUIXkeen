import { agentMihomoProvidersAPI, agentSslProbeBatchAPI } from '@/api/agent'
import { useStorage } from '@vueuse/core'
import { computed, ref, watch } from 'vue'
import { agentEnabled } from './agent'
import { proxyProviderPanelUrlMap } from './settings'

export const autoSortProxyProvidersByHealth = useStorage<boolean>(
  'config/auto-sort-proxy-providers-by-health',
  true,
)

/** Provider list sort mode on the Providers tab. */
export const proxyProvidersSortMode = useStorage<'health' | 'activity' | 'name'>(
  'config/proxy-providers-sort-mode',
  'health',
)

/** Show only providers that currently have active connections (best-effort). */
export const showOnlyActiveProxyProviders = useStorage<boolean>(
  'config/show-only-active-proxy-providers',
  false,
)

/** Optional quick filter for providers tab: expired | nearExpiry | offline | degraded | healthy */
export const providerHealthFilter = useStorage<string>('config/provider-health-filter', '')

export const agentProvidersLoading = ref(false)
export const agentProvidersOk = ref(false)
export const agentProvidersError = ref<string | null>(null)
export const agentProvidersAt = ref<number>(0)
export const agentProviders = ref<any[]>([])

// SSL notAfter for provider *panel URLs* (not proxy-provider subscription URLs).
export const agentProviderPanelSslAt = ref<number>(0)
export const agentProviderPanelSslMap = ref<Record<string, string>>({})
export const agentProviderPanelSslOk = ref(false)

export const agentProviderByName = computed<Record<string, any>>(() => {
  const map: Record<string, any> = {}
  for (const p of agentProviders.value || []) {
    if (p?.name) map[String(p.name)] = p
  }
  return map
})

export const fetchAgentProviders = async (force = false) => {
  if (!agentEnabled.value) {
    agentProvidersOk.value = false
    agentProvidersError.value = null
    agentProviders.value = []
    agentProvidersAt.value = Date.now()
    return
  }

  if (agentProvidersLoading.value) return

  agentProvidersLoading.value = true
  try {
    const res = await agentMihomoProvidersAPI(force)
    agentProvidersOk.value = !!res?.ok
    agentProvidersError.value = res?.ok ? null : res?.error || 'offline'
    agentProviders.value = (res as any)?.providers || []
    agentProvidersAt.value = Date.now()

    // Best-effort: also probe SSL for management panel URLs (stored in users-db).
    // This is what users typically care about in Provider cards.
    try {
      await fetchAgentProviderPanelSsl(force)
    } catch {
      /* ignore */
    }
  } finally {
    agentProvidersLoading.value = false
  }
}

export const fetchAgentProviderPanelSsl = async (force = false) => {
  if (!agentEnabled.value) {
    agentProviderPanelSslOk.value = false
    agentProviderPanelSslMap.value = {}
    agentProviderPanelSslAt.value = Date.now()
    return
  }

  const now = Date.now()
  if (!force && agentProviderPanelSslAt.value && now - agentProviderPanelSslAt.value < 60_000) return

  const map = proxyProviderPanelUrlMap.value || {}
  const lines = Object.entries(map)
    .map(([name, url]) => {
      const n = (name || '').trim()
      const u = (url || '').trim()
      if (!n || !u) return ''
      return `${n}\t${u}`
    })
    .filter(Boolean)
    .join('\n')

  if (!lines) {
    agentProviderPanelSslOk.value = true
    agentProviderPanelSslMap.value = {}
    agentProviderPanelSslAt.value = now
    return
  }

  const res = await agentSslProbeBatchAPI(lines + '\n')
  agentProviderPanelSslOk.value = !!res?.ok
  const out: Record<string, string> = {}
  for (const it of res?.items || []) {
    const name = String((it as any)?.name || '').trim()
    const na = String((it as any)?.sslNotAfter || '').trim()
    if (name) out[name] = na
  }
  agentProviderPanelSslMap.value = out
  agentProviderPanelSslAt.value = now
}

// best-effort: refresh when agent toggled
watch(
  agentEnabled,
  (on) => {
    if (on) fetchAgentProviders(false)
  },
  { immediate: true },
)

// When panel URLs change (synced via users-db), refresh panel SSL probe (best-effort).
watch(
  proxyProviderPanelUrlMap,
  () => {
    // don't spam; the function has its own 60s cache
    fetchAgentProviderPanelSsl(false).catch(() => {})
  },
  { deep: true },
)
