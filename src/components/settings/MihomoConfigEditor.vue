<template>
  <div class="card w-full max-w-none">
    <div class="card-title flex items-center justify-between gap-2 px-4 pt-4">
      <div class="flex items-center gap-2">
        <button
          type="button"
          class="btn btn-ghost btn-circle btn-sm"
          @click="expanded = !expanded"
          :title="expanded ? $t('collapse') : $t('expand')"
        >
          <ChevronUpIcon v-if="expanded" class="h-4 w-4" />
          <ChevronDownIcon v-else class="h-4 w-4" />
        </button>
        <span>{{ $t('mihomoConfigEditor') }}</span>
      </div>

      <div class="flex flex-wrap items-center gap-2">
        <span class="badge badge-outline">{{ managedMode ? $t('configManagedMode') : $t('configDirectMode') }}</span>
        <button class="btn btn-sm" :class="refreshBusy && 'loading'" @click="refreshAll(true)">
          {{ $t('refresh') }}
        </button>
      </div>
    </div>

    <div class="card-body gap-3">
      <div class="flex flex-wrap items-center gap-2 text-xs opacity-70">
        <span>{{ $t('configPath') }}:</span>
        <span class="font-mono">{{ currentPath }}</span>
      </div>

      <div v-if="managedMode" class="rounded-box border border-base-content/10 bg-base-200/40 p-3 text-xs">
        <div class="flex flex-wrap items-center gap-2">
          <span class="badge" :class="managedStatusBadgeClass">{{ managedStatusText }}</span>
          <span v-if="managedState?.active?.rev" class="badge badge-ghost">active rev {{ managedState?.active?.rev }}</span>
          <span v-if="managedState?.draft?.rev" class="badge badge-ghost">draft rev {{ managedState?.draft?.rev }}</span>
          <span v-if="managedState?.validator?.bin" class="badge badge-ghost">{{ managedState?.validator?.bin }}</span>
          <span v-if="managedState?.restart?.mode" class="badge badge-ghost">restart: {{ managedState?.restart?.mode }}</span>
        </div>

        <div class="mt-2 grid grid-cols-1 gap-2 md:grid-cols-3">
          <div class="rounded-lg border border-base-content/10 bg-base-100/60 p-2">
            <div class="font-semibold">{{ $t('configActiveTitle') }}</div>
            <div class="mt-1 font-mono text-[11px] opacity-80">{{ managedState?.active?.path || '—' }}</div>
            <div class="mt-1 opacity-70">{{ $t('updatedAt') }}: {{ fmtTextTs(managedState?.active?.updatedAt) }}</div>
            <div class="opacity-70">{{ $t('size') }}: {{ fmtBytes(managedState?.active?.sizeBytes) }}</div>
          </div>

          <div class="rounded-lg border border-base-content/10 bg-base-100/60 p-2">
            <div class="font-semibold">{{ $t('configDraftTitle') }}</div>
            <div class="mt-1 font-mono text-[11px] opacity-80">{{ managedState?.draft?.path || '—' }}</div>
            <div class="mt-1 opacity-70">{{ $t('updatedAt') }}: {{ fmtTextTs(managedState?.draft?.updatedAt) }}</div>
            <div class="opacity-70">{{ $t('size') }}: {{ fmtBytes(managedState?.draft?.sizeBytes) }}</div>
          </div>

          <div class="rounded-lg border border-base-content/10 bg-base-100/60 p-2">
            <div class="font-semibold">{{ $t('configBaselineTitle') }}</div>
            <div class="mt-1 font-mono text-[11px] opacity-80">{{ managedState?.baseline?.path || '—' }}</div>
            <div class="mt-1 opacity-70">{{ $t('updatedAt') }}: {{ fmtTextTs(managedState?.baseline?.updatedAt) }}</div>
            <div class="opacity-70">{{ $t('size') }}: {{ fmtBytes(managedState?.baseline?.sizeBytes) }}</div>
          </div>
        </div>

        <div class="mt-2 text-[11px] opacity-70">
          {{ $t('configManagedTip') }}
        </div>
        <div v-if="managedState?.lastError" class="mt-1 break-words text-[11px] text-warning">
          {{ managedState?.lastError }}
        </div>
      </div>

      <div
        class="transparent-collapse collapse rounded-none shadow-none"
        :class="expanded ? 'collapse-open' : ''"
      >
        <div class="collapse-content p-0">
          <div v-if="expanded" class="grid grid-cols-1 gap-3">
            <div class="text-xs opacity-70">
              {{ managedMode ? $t('configManagedEditorTip') : $t('mihomoConfigEditorTip') }}
            </div>

            <div v-if="managedMode" class="flex flex-wrap items-center gap-2">
              <button class="btn btn-sm" @click="copyFromManaged('active')" :disabled="busyAny">{{ $t('configLoadActiveToDraft') }}</button>
              <button class="btn btn-sm" @click="copyFromManaged('baseline')" :disabled="busyAny || !managedState?.baseline?.exists">{{ $t('configLoadBaselineToDraft') }}</button>
              <button class="btn btn-sm" @click="saveDraft" :disabled="busyAny">{{ $t('saveDraft') }}</button>
              <button class="btn btn-sm" @click="validateDraft" :disabled="busyAny">{{ $t('configValidateDraft') }}</button>
              <button class="btn btn-sm" @click="applyDraft" :disabled="busyAny">{{ $t('configApplyDraft') }}</button>
              <button class="btn btn-sm btn-ghost" @click="setBaselineFromActive" :disabled="busyAny || !managedState?.active?.exists">{{ $t('configPromoteActiveToBaseline') }}</button>
              <button class="btn btn-sm btn-warning" @click="restoreBaseline" :disabled="busyAny || !managedState?.baseline?.exists">{{ $t('configRestoreBaseline') }}</button>
            </div>
            <div v-else class="flex flex-wrap items-center gap-2">
              <button class="btn btn-sm" :class="legacyLoadBusy && 'loading'" @click="legacyLoad">{{ $t('load') }}</button>
              <button class="btn btn-sm" :class="legacyApplyBusy && 'loading'" @click="legacyApply">{{ $t('applyAndReload') }}</button>
              <button class="btn btn-sm" :class="legacyRestartBusy && 'loading'" @click="legacyRestart">{{ $t('restartCore') }}</button>
            </div>

            <textarea
              class="textarea textarea-sm h-[70vh] min-h-[28rem] w-full resize-y overflow-x-auto whitespace-pre font-mono leading-5 [tab-size:2]"
              wrap="off"
              v-model="payload"
              :placeholder="$t('pasteYamlHere')"
            ></textarea>

            <div class="flex flex-wrap items-center justify-between gap-2 text-xs">
              <div class="opacity-60">
                {{ managedMode ? $t('configDraftRemoteSaved') : $t('mihomoConfigDraftSaved') }}
              </div>
              <button class="btn btn-ghost btn-sm" @click="clearDraft">{{ $t('clearDraft') }}</button>
            </div>

            <div v-if="validationOutput" class="rounded-box border border-base-content/10 bg-base-200/40 p-3 text-xs">
              <div class="flex flex-wrap items-center gap-2">
                <span class="badge" :class="validationOk ? 'badge-success' : 'badge-error'">{{ validationOk ? $t('configValidationOk') : $t('configValidationFailed') }}</span>
                <span v-if="validationCmd" class="badge badge-ghost font-mono">{{ validationCmd }}</span>
              </div>
              <pre class="mt-2 whitespace-pre-wrap break-words font-mono text-[11px] opacity-80">{{ validationOutput }}</pre>
            </div>

            <div v-if="managedMode" class="rounded-box border border-base-content/10 bg-base-200/40 p-3 text-xs">
              <div class="mb-2 flex flex-wrap items-center justify-between gap-2">
                <div class="font-semibold">{{ $t('configHistoryTitle') }}</div>
                <button class="btn btn-xs btn-ghost" @click="loadHistory" :disabled="historyBusy">{{ $t('refresh') }}</button>
              </div>
              <div v-if="!historyItems.length" class="opacity-60">{{ $t('configHistoryEmpty') }}</div>
              <div v-else class="space-y-2">
                <div
                  v-for="item in historyItems"
                  :key="`${item.rev}-${item.current ? 'current' : 'old'}`"
                  class="flex flex-wrap items-center justify-between gap-2 rounded-lg border border-base-content/10 bg-base-100/60 p-2"
                >
                  <div>
                    <div class="flex flex-wrap items-center gap-2">
                      <span class="font-mono">rev {{ item.rev }}</span>
                      <span v-if="item.current" class="badge badge-primary badge-xs">current</span>
                      <span v-if="item.source" class="badge badge-ghost badge-xs">{{ item.source }}</span>
                    </div>
                    <div class="mt-1 opacity-70">{{ fmtTextTs(item.updatedAt) }}</div>
                  </div>
                  <div class="flex flex-wrap items-center gap-2">
                    <button class="btn btn-ghost btn-xs" @click="loadHistoryRev(item.rev)">{{ $t('configLoadIntoEditor') }}</button>
                    <button v-if="!item.current" class="btn btn-ghost btn-xs" @click="restoreHistoryRev(item.rev)">{{ $t('configRestoreRevision') }}</button>
                  </div>
                </div>
              </div>
            </div>

            <div class="text-xs opacity-60">
              {{ managedMode ? $t('configManagedFallbackNote') : $t('mihomoConfigLoadNote') }}
            </div>
          </div>
        </div>
      </div>

      <div class="text-xs opacity-60" v-if="!expanded">
        {{ $t('configCollapsedTip') }}
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import {
  agentMihomoConfigAPI,
  agentMihomoConfigManagedApplyAPI,
  agentMihomoConfigManagedCopyAPI,
  agentMihomoConfigManagedGetAPI,
  agentMihomoConfigManagedGetRevAPI,
  agentMihomoConfigManagedHistoryAPI,
  agentMihomoConfigManagedPutDraftAPI,
  agentMihomoConfigManagedRestoreBaselineAPI,
  agentMihomoConfigManagedRestoreRevAPI,
  agentMihomoConfigManagedSetBaselineFromActiveAPI,
  agentMihomoConfigManagedValidateAPI,
  agentMihomoConfigStateAPI,
  type MihomoConfigHistoryItem,
  type MihomoConfigManagedState,
} from '@/api/agent'
import { getConfigsAPI, getConfigsRawAPI, reloadConfigsAPI, restartCoreAPI } from '@/api'
import { decodeB64Utf8 } from '@/helper/b64'
import { showNotification } from '@/helper/notification'
import { agentEnabled } from '@/store/agent'
import { useStorage } from '@vueuse/core'
import { ChevronDownIcon, ChevronUpIcon } from '@heroicons/vue/24/outline'
import axios from 'axios'
import { computed, onMounted, ref } from 'vue'

const path = useStorage('config/mihomo-config-path', '/opt/etc/mihomo/config.yaml')
const payload = useStorage('config/mihomo-config-payload', '')
const expanded = useStorage('config/mihomo-config-expanded', false)

const refreshBusy = ref(false)
const historyBusy = ref(false)
const actionBusy = ref(false)
const managedState = ref<MihomoConfigManagedState | null>(null)
const historyItems = ref<MihomoConfigHistoryItem[]>([])
const validationOutput = ref('')
const validationCmd = ref('')
const validationOk = ref(false)

const legacyLoadBusy = ref(false)
const legacyApplyBusy = ref(false)
const legacyRestartBusy = ref(false)

const currentPath = computed(() => managedMode.value ? (managedState.value?.active?.path || path.value) : path.value)
const managedMode = computed(() => agentEnabled.value && Boolean(managedState.value?.ok))
const busyAny = computed(() => refreshBusy.value || historyBusy.value || actionBusy.value)

const fmtTextTs = (value?: string) => {
  const s = String(value || '').trim()
  if (!s) return '—'
  const d = new Date(s)
  if (Number.isNaN(d.getTime())) return s
  return d.toLocaleString()
}

const fmtBytes = (value?: number) => {
  const n = Number(value || 0)
  if (!Number.isFinite(n) || n <= 0) return '0 B'
  if (n < 1024) return `${n} B`
  if (n < 1024 * 1024) return `${(n / 1024).toFixed(1)} KB`
  return `${(n / 1024 / 1024).toFixed(2)} MB`
}

const managedStatusText = computed(() => {
  const status = String(managedState.value?.lastApplyStatus || '').trim()
  switch (status) {
    case 'ok':
      return 'OK'
    case 'validate-failed':
      return 'validate failed'
    case 'rolled-back':
      return 'rolled back'
    case 'restored-baseline':
      return 'baseline restored'
    case 'failed':
      return 'failed'
    default:
      return 'idle'
  }
})

const managedStatusBadgeClass = computed(() => {
  const status = String(managedState.value?.lastApplyStatus || '').trim()
  if (status === 'ok') return 'badge-success'
  if (status === 'rolled-back' || status === 'restored-baseline') return 'badge-warning'
  if (status === 'validate-failed' || status === 'failed') return 'badge-error'
  return 'badge-ghost'
})

const loadManagedPayload = async (kind: 'active' | 'draft' | 'baseline') => {
  const r = await agentMihomoConfigManagedGetAPI(kind)
  if (!r.ok || !r.contentB64) return false
  payload.value = decodeB64Utf8(r.contentB64)
  path.value = r.path || path.value
  return true
}

const loadHistory = async () => {
  if (!agentEnabled.value) return
  historyBusy.value = true
  try {
    const r = await agentMihomoConfigManagedHistoryAPI()
    historyItems.value = Array.isArray(r.items) ? r.items : []
  } finally {
    historyBusy.value = false
  }
}

const refreshManaged = async (loadEditor = false) => {
  const state = await agentMihomoConfigStateAPI()
  managedState.value = state
  if (!state.ok) return false
  if (loadEditor) {
    const loadedDraft = state.draft?.exists ? await loadManagedPayload('draft') : false
    if (!loadedDraft && state.active?.exists) {
      await loadManagedPayload('active')
    }
  }
  await loadHistory()
  return true
}

const refreshAll = async (loadEditor = false) => {
  if (refreshBusy.value) return
  refreshBusy.value = true
  try {
    if (agentEnabled.value) {
      const ok = await refreshManaged(loadEditor)
      if (ok) return
    }
    await legacyLoad()
  } finally {
    refreshBusy.value = false
  }
}

const ensureDraftSaved = async () => {
  const r = await agentMihomoConfigManagedPutDraftAPI(payload.value || '')
  if (!r.ok) {
    throw new Error(r.error || 'save-failed')
  }
  await refreshManaged(false)
}

const saveDraft = async () => {
  if (!managedMode.value || actionBusy.value) return
  actionBusy.value = true
  try {
    await ensureDraftSaved()
    showNotification({ content: 'configDraftSavedRemoteSuccess', type: 'alert-success' })
  } catch (e: any) {
    showNotification({ content: 'configDraftSaveFailed', params: { error: e?.message || 'failed' }, type: 'alert-error' })
  } finally {
    actionBusy.value = false
  }
}

const copyFromManaged = async (from: 'active' | 'baseline') => {
  if (!managedMode.value || actionBusy.value) return
  actionBusy.value = true
  try {
    const r = await agentMihomoConfigManagedCopyAPI(from)
    if (!r.ok) throw new Error(r.error || 'copy-failed')
    await refreshManaged(false)
    await loadManagedPayload('draft')
    validationOutput.value = ''
    showNotification({ content: from === 'active' ? 'configDraftLoadedFromActive' : 'configDraftLoadedFromBaseline', type: 'alert-success' })
  } catch (e: any) {
    showNotification({ content: 'configDraftCopyFailed', params: { error: e?.message || 'failed' }, type: 'alert-error' })
  } finally {
    actionBusy.value = false
  }
}

const validateDraft = async () => {
  if (!managedMode.value || actionBusy.value) return
  actionBusy.value = true
  try {
    await ensureDraftSaved()
    const r = await agentMihomoConfigManagedValidateAPI('draft')
    validationOk.value = Boolean(r.ok)
    validationCmd.value = String(r.cmd || '')
    validationOutput.value = String(r.output || r.error || '')
    showNotification({ content: r.ok ? 'configValidationSuccess' : 'configValidationFailedToast', type: r.ok ? 'alert-success' : 'alert-error' })
  } catch (e: any) {
    validationOk.value = false
    validationCmd.value = ''
    validationOutput.value = e?.message || 'failed'
    showNotification({ content: 'configValidationFailedToast', type: 'alert-error' })
  } finally {
    actionBusy.value = false
  }
}

const applyDraft = async () => {
  if (!managedMode.value || actionBusy.value) return
  actionBusy.value = true
  try {
    await ensureDraftSaved()
    const r = await agentMihomoConfigManagedApplyAPI()
    await refreshManaged(true)
    validationOk.value = Boolean(r.ok)
    validationCmd.value = String(r.validateCmd || '')
    validationOutput.value = String(r.restartOutput || r.output || r.error || '')
    if (!r.ok) throw new Error(r.error || r.output || r.restartOutput || 'apply-failed')
    showNotification({ content: 'configApplySuccess', type: 'alert-success' })
  } catch (e: any) {
    showNotification({ content: 'configApplyFailed', params: { error: e?.message || 'failed' }, type: 'alert-error' })
  } finally {
    actionBusy.value = false
  }
}

const setBaselineFromActive = async () => {
  if (!managedMode.value || actionBusy.value) return
  if (!window.confirm('Сделать текущий активный конфиг новым эталонным?')) return
  actionBusy.value = true
  try {
    const r = await agentMihomoConfigManagedSetBaselineFromActiveAPI()
    if (!r.ok) throw new Error(r.error || 'baseline-failed')
    await refreshManaged(false)
    showNotification({ content: 'configBaselinePromoted', type: 'alert-success' })
  } catch (e: any) {
    showNotification({ content: 'configBaselinePromoteFailed', params: { error: e?.message || 'failed' }, type: 'alert-error' })
  } finally {
    actionBusy.value = false
  }
}

const restoreBaseline = async () => {
  if (!managedMode.value || actionBusy.value) return
  if (!window.confirm('Восстановить эталонный конфиг как активный?')) return
  actionBusy.value = true
  try {
    const r = await agentMihomoConfigManagedRestoreBaselineAPI()
    await refreshManaged(true)
    if (!r.ok) throw new Error(r.error || 'restore-failed')
    showNotification({ content: 'configBaselineRestored', type: 'alert-success' })
  } catch (e: any) {
    showNotification({ content: 'configBaselineRestoreFailed', params: { error: e?.message || 'failed' }, type: 'alert-error' })
  } finally {
    actionBusy.value = false
  }
}

const loadHistoryRev = async (rev: number) => {
  if (actionBusy.value) return
  actionBusy.value = true
  try {
    const r = await agentMihomoConfigManagedGetRevAPI(rev)
    if (!r.ok || !r.contentB64) throw new Error(r.error || 'not-found')
    payload.value = decodeB64Utf8(r.contentB64)
    validationOutput.value = ''
    validationCmd.value = ''
    showNotification({ content: 'configHistoryLoadedIntoEditor', type: 'alert-success' })
  } catch (e: any) {
    showNotification({ content: 'configHistoryLoadFailed', params: { error: e?.message || 'failed' }, type: 'alert-error' })
  } finally {
    actionBusy.value = false
  }
}

const restoreHistoryRev = async (rev: number) => {
  if (actionBusy.value) return
  if (!window.confirm(`Восстановить ревизию ${rev} как активный конфиг?`)) return
  actionBusy.value = true
  try {
    const r = await agentMihomoConfigManagedRestoreRevAPI(rev)
    await refreshManaged(true)
    if (!r.ok) throw new Error(r.error || 'restore-failed')
    showNotification({ content: 'configHistoryRestoreSuccess', type: 'alert-success' })
  } catch (e: any) {
    showNotification({ content: 'configHistoryRestoreFailed', params: { error: e?.message || 'failed' }, type: 'alert-error' })
  } finally {
    actionBusy.value = false
  }
}

const dumpYaml = (value: any): string => {
  const isScalar = (v: any) => v === null || ['string', 'number', 'boolean'].includes(typeof v)

  const scalarInline = (v: any) => {
    if (v === null) return 'null'
    if (typeof v === 'string') return JSON.stringify(v)
    if (typeof v === 'number' || typeof v === 'boolean') return String(v)
    return JSON.stringify(String(v))
  }

  const emit = (v: any, indent = 0): string[] => {
    const sp = ' '.repeat(indent)

    if (isScalar(v)) {
      if (typeof v === 'string' && v.includes('\n')) {
        const lines = v.split(/\r?\n/)
        return [sp + '|-', ...lines.map((l) => sp + '  ' + l)]
      }
      return [sp + scalarInline(v)]
    }

    if (Array.isArray(v)) {
      if (!v.length) return [sp + '[]']
      const out: string[] = []
      for (const item of v) {
        if (isScalar(item)) {
          if (typeof item === 'string' && item.includes('\n')) {
            const lines = item.split(/\r?\n/)
            out.push(sp + '- |-')
            out.push(...lines.map((l) => sp + '  ' + l))
          } else {
            out.push(sp + '- ' + scalarInline(item))
          }
        } else {
          out.push(sp + '-')
          out.push(...emit(item, indent + 2))
        }
      }
      return out
    }

    if (typeof v === 'object') {
      const keys = Object.keys(v || {})
      if (!keys.length) return [sp + '{}']
      const out: string[] = []
      for (const k of keys) {
        const key = /^[A-Za-z0-9_.-]+$/.test(k) ? k : JSON.stringify(k)
        const val = (v as any)[k]
        if (isScalar(val)) {
          if (typeof val === 'string' && val.includes('\n')) {
            const lines = val.split(/\r?\n/)
            out.push(sp + key + ': |-')
            out.push(...lines.map((l) => sp + '  ' + l))
          } else {
            out.push(sp + key + ': ' + scalarInline(val))
          }
        } else {
          if (Array.isArray(val) && !val.length) {
            out.push(sp + key + ': []')
          } else {
            out.push(sp + key + ':')
            out.push(...emit(val, indent + 2))
          }
        }
      }
      return out
    }

    return [sp + JSON.stringify(String(v))]
  }

  return emit(value, 0).join('\n') + '\n'
}

const looksLikeFullConfig = (s: string) => {
  const t = (s || '').trim()
  if (!t) return false
  return (
    /(^|\n)\s*proxies\s*:/m.test(t) ||
    /(^|\n)\s*proxy-groups\s*:/m.test(t) ||
    /(^|\n)\s*proxy-providers\s*:/m.test(t) ||
    /(^|\n)\s*rule-providers\s*:/m.test(t) ||
    /(^|\n)\s*rules\s*:/m.test(t)
  )
}

const looksLikeRuntimeConfigs = (obj: any) => {
  if (!obj || typeof obj !== 'object') return false
  const keys = Object.keys(obj)
  const hasPorts = keys.some((k) => ['port', 'socks-port', 'redir-port', 'tproxy-port', 'mixed-port'].includes(k))
  const hasGroups = keys.some((k) => ['proxy-groups', 'proxies', 'rules', 'proxy-providers', 'rule-providers'].includes(k))
  return hasPorts && !hasGroups
}

const tryLoadFromFileLikeEndpoints = async (pathValue: string): Promise<string | null> => {
  const candidates: Array<{ url: string; params?: Record<string, any> }> = [
    { url: '/configs', params: { path: pathValue, format: 'raw' } },
    { url: '/configs', params: { path: pathValue, raw: true } },
    { url: '/configs', params: { path: pathValue, file: true } },
    { url: '/configs', params: { path: pathValue, download: true } },
    { url: '/configs/raw', params: { path: pathValue } },
    { url: '/configs/file', params: { path: pathValue } },
  ]

  for (const c of candidates) {
    try {
      const r = await axios.get(c.url, {
        params: c.params,
        responseType: 'text',
        silent: true as any,
        headers: {
          Accept: 'text/plain, application/x-yaml, application/yaml, */*',
          'X-Zash-Silent': '1',
        } as any,
      })
      const data: any = (r as any)?.data
      if (typeof data === 'string') {
        const s = data.trim()
        if (looksLikeFullConfig(s)) return data
        if ((s.startsWith('{') || s.startsWith('[')) && (s.endsWith('}') || s.endsWith(']'))) {
          try {
            const parsed = JSON.parse(s)
            const payloadValue = (parsed && (parsed.payload || parsed.data?.payload || parsed.config || parsed.yaml)) as any
            if (typeof payloadValue === 'string' && looksLikeFullConfig(payloadValue)) return payloadValue
          } catch {
            // ignore
          }
        }
      } else if (data && typeof data === 'object') {
        const payloadValue = (data.payload || data.data?.payload || data.config || data.yaml) as any
        if (typeof payloadValue === 'string' && looksLikeFullConfig(payloadValue)) return payloadValue
      }
    } catch {
      // try next
    }
  }
  return null
}

const legacyLoad = async () => {
  if (legacyLoadBusy.value) return
  legacyLoadBusy.value = true
  try {
    if (agentEnabled.value) {
      const res = await agentMihomoConfigAPI()
      if (res?.ok && res?.contentB64) {
        payload.value = decodeB64Utf8(res.contentB64)
        showNotification({ content: 'mihomoConfigLoadSuccess', type: 'alert-success' })
        return
      }
    }

    const fileText = await tryLoadFromFileLikeEndpoints(path.value)
    if (fileText) {
      payload.value = fileText
      showNotification({ content: 'mihomoConfigLoadSuccess', type: 'alert-success' })
      return
    }

    const raw = await getConfigsRawAPI({ path: path.value })
    const data: any = raw?.data
    if (typeof data === 'string' && data.trim().length > 0) {
      const s = data.trim()
      if (looksLikeFullConfig(s)) {
        payload.value = data
        showNotification({ content: 'mihomoConfigLoadSuccess', type: 'alert-success' })
        return
      }
      if (s.startsWith('{') || s.startsWith('[')) {
        try {
          const parsed = JSON.parse(s)
          if (looksLikeRuntimeConfigs(parsed)) {
            payload.value =
              `# Mihomo API /configs does not expose the full YAML file on this build.\n` +
              `# Showing runtime config (ports/tun/etc). If your backend supports reading the file,\n` +
              `# enable it to load: ${path.value}\n\n` +
              dumpYaml(parsed)
            showNotification({ content: 'mihomoConfigLoadPartial', type: 'alert-info' })
            return
          }
          payload.value = `# Converted from /configs (JSON)\n# Comments/ordering may differ from the original mihomo YAML.\n\n${dumpYaml(parsed)}`
          showNotification({ content: 'mihomoConfigLoadPartial', type: 'alert-info' })
          return
        } catch {
          // ignore
        }
      }
      payload.value = data
      showNotification({ content: 'mihomoConfigLoadSuccess', type: 'alert-success' })
      return
    }

    const json = await getConfigsAPI()
    payload.value = `# Converted from /configs (JSON)\n# Comments/ordering may differ from the original mihomo YAML.\n\n${dumpYaml(json.data)}`
    showNotification({ content: 'mihomoConfigLoadPartial', type: 'alert-info' })
  } catch {
    showNotification({ content: 'mihomoConfigLoadFailed', type: 'alert-error' })
  } finally {
    legacyLoadBusy.value = false
  }
}

const legacyApply = async () => {
  if (legacyApplyBusy.value) return
  legacyApplyBusy.value = true
  try {
    await reloadConfigsAPI({ path: path.value || '', payload: payload.value || '' })
    showNotification({ content: 'reloadConfigsSuccess', type: 'alert-success' })
  } catch {
    // interceptor handles details
  } finally {
    legacyApplyBusy.value = false
  }
}

const legacyRestart = async () => {
  if (legacyRestartBusy.value) return
  legacyRestartBusy.value = true
  try {
    await restartCoreAPI()
    showNotification({ content: 'restartCoreSuccess', type: 'alert-success' })
  } catch {
    // interceptor handles details
  } finally {
    legacyRestartBusy.value = false
  }
}

const clearDraft = () => {
  payload.value = ''
}

onMounted(async () => {
  await refreshAll(true)
})
</script>
