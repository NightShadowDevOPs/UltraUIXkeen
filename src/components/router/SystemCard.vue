<template>
  <div ref="cardRef" class="card gap-3 p-4">
    <div class="flex items-center justify-between gap-2">
      <div class="flex items-center gap-2">
        <div class="font-semibold">{{ $t('routerResources') }}</div>
        <span v-if="agentEnabled && status.ok" class="badge badge-success">{{ $t('online') }}</span>
        <span v-else-if="agentEnabled && !status.ok" class="badge badge-error">{{ $t('offline') }}</span>
        <span v-else class="badge badge-ghost">{{ $t('disabled') }}</span>
      </div>

      <button type="button" class="btn btn-sm" @click="handleRefresh" :disabled="!agentEnabled">
        {{ $t('refresh') }}
      </button>
    </div>

    <div v-if="!agentEnabled" class="text-sm opacity-70">
      {{ $t('agentDisabledTip') }}
    </div>
    <div v-else-if="agentEnabled && !status.ok" class="text-sm opacity-70">
      {{ $t('agentOfflineTip') }}
    </div>

    <template v-else>
      <div class="grid grid-cols-1 gap-3 sm:grid-cols-2">
        <div class="rounded-xl border border-base-content/10 bg-base-200/30 p-3">
          <div class="flex items-center justify-between">
            <div class="text-xs uppercase tracking-wide opacity-60">CPU</div>
            <div class="text-sm font-mono">{{ cpuPctText }}</div>
          </div>
          <progress class="progress mt-2 w-full" :value="status.cpuPct || 0" max="100" />
          <div class="mt-2 text-[11px] opacity-70">
            {{ $t('loadAvg1m') }}: <span class="font-mono">{{ status.load1 ?? '—' }}</span>
            <span class="opacity-50">·</span>
            {{ $t('loadAvg5m') }}: <span class="font-mono">{{ status.load5 ?? '—' }}</span>
            <span class="opacity-50">·</span>
            {{ $t('loadAvg15m') }}: <span class="font-mono">{{ status.load15 ?? '—' }}</span>
            <span class="opacity-50">·</span>
            {{ $t('uptime') }}: <span class="font-mono">{{ uptimeText }}</span>
          </div>
        </div>

        <div class="rounded-xl border border-base-content/10 bg-base-200/30 p-3">
          <div class="flex items-center justify-between">
            <div class="text-xs uppercase tracking-wide opacity-60">{{ $t('memoryUsage') }}</div>
            <div class="text-sm font-mono">{{ memPctText }}</div>
          </div>
          <progress class="progress mt-2 w-full" :value="status.memUsedPct || 0" max="100" />
          <div class="mt-2 text-[11px] opacity-70">
            <span class="font-mono">{{ prettyBytes(status.memUsed) }}</span>
            <span class="opacity-50">/</span>
            <span class="font-mono">{{ prettyBytes(status.memTotal) }}</span>
            <span class="opacity-50">·</span>
            {{ $t('freeMemory') }}: <span class="font-mono">{{ prettyBytes(status.memFree) }}</span>
          </div>
        </div>
      </div>

      <div class="grid grid-cols-2 gap-2 xl:grid-cols-6">
        <div v-for="item in summaryItems" :key="item.key" class="rounded-xl border border-base-content/10 bg-base-100/50 px-3 py-2">
          <div class="text-[11px] uppercase tracking-wide opacity-60">{{ item.label }}</div>
          <div class="mt-1 break-all font-mono text-xs sm:text-sm">{{ item.value }}</div>
        </div>
      </div>

      <div class="grid grid-cols-1 gap-3 xl:grid-cols-2">
        <details class="rounded-xl border border-base-content/10 bg-base-100/40 p-3" @toggle="handleRouterInfoToggle">
          <summary class="flex cursor-pointer list-none items-start justify-between gap-3">
            <div>
              <div class="font-medium">{{ $t('routerInfo') }}</div>
              <div class="text-xs opacity-60">
                {{ detailsLoaded ? $t('routerInfoTip') : $t('routerInfoLoadOnDemand') }}
              </div>
            </div>
            <span class="badge badge-ghost">{{ detailsLoaded ? $t('details') : $t('load') }}</span>
          </summary>

          <div class="mt-3 flex flex-col gap-3">
            <div class="flex flex-wrap items-center gap-2">
              <button type="button" class="btn btn-xs" @click="loadDetails(true)" :disabled="!agentEnabled || detailsLoading">
                <span v-if="detailsLoading" class="loading loading-spinner loading-xs"></span>
                <span v-else>{{ detailsLoaded ? $t('refresh') : $t('load') }}</span>
              </button>
              <span class="text-xs opacity-60">{{ $t('routerDiagnosticsLazyHint') }}</span>
            </div>

            <div v-if="!detailsLoaded" class="rounded-lg border border-dashed border-base-content/20 bg-base-200/20 px-3 py-3 text-sm opacity-70">
              {{ $t('routerInfoLoadOnDemand') }}
            </div>
            <div v-else class="grid grid-cols-1 gap-x-4 gap-y-2 text-sm md:grid-cols-2">
              <div v-for="item in infoItems" :key="item.key" class="rounded-lg border border-base-content/10 bg-base-100/40 px-3 py-2">
                <div class="text-[11px] uppercase tracking-wide opacity-60">{{ item.label }}</div>
                <div class="mt-1 break-all font-mono text-xs sm:text-sm">{{ item.value }}</div>
              </div>
            </div>
          </div>
        </details>

        <details class="rounded-xl border border-base-content/10 bg-base-100/40 p-3" @toggle="handleFirmwareToggle">
          <summary class="flex cursor-pointer list-none items-start justify-between gap-3">
            <div>
              <div class="font-medium">{{ $t('firmwareUpdateCheck') }}</div>
              <div class="text-xs opacity-60">{{ $t('firmwareUpdateCheckTip') }}</div>
            </div>
            <span class="badge" :class="firmwareBadgeClass">{{ firmwareBadgeText }}</span>
          </summary>

          <div class="mt-3 flex flex-col gap-3">
            <div class="flex flex-wrap items-center gap-2">
              <button type="button" class="btn btn-xs btn-ghost" @click="loadDetails(true)" :disabled="!agentEnabled || detailsLoading">
                <span v-if="detailsLoading" class="loading loading-spinner loading-xs"></span>
                <span v-else>{{ detailsLoaded ? $t('refresh') : $t('load') }}</span>
              </button>
              <button type="button" class="btn btn-xs" @click="refreshFirmware(true)" :disabled="!agentEnabled || firmwareLoading || !detailsLoaded">
                <span v-if="firmwareLoading" class="loading loading-spinner loading-xs"></span>
                <span v-else>{{ $t('refresh') }}</span>
              </button>
              <span v-if="firmwareCheck.checkedAt" class="text-[11px] opacity-60">{{ $t('lastCheck') }}: {{ firmwareCheck.checkedAt }}</span>
            </div>

            <div v-if="!detailsLoaded" class="rounded-lg border border-dashed border-base-content/20 bg-base-200/20 px-3 py-3 text-sm opacity-70">
              {{ $t('routerDiagnosticsLazyHint') }}
            </div>

            <div class="flex flex-wrap items-center gap-2 text-xs">
              <span class="badge badge-ghost">{{ $t('firmware') }}: {{ firmwareCurrentLabel }}</span>
              <span v-if="firmwareCheck.latestVersion" class="badge badge-info">site: {{ firmwareCheck.latestVersion }}</span>
              <span v-if="firmwareCheck.mainLatestVersion" class="badge badge-ghost">main: {{ firmwareCheck.mainLatestVersion }}</span>
              <span v-if="firmwareCheck.previewLatestVersion" class="badge badge-ghost">preview: {{ firmwareCheck.previewLatestVersion }}</span>
              <span v-if="firmwareCheck.devLatestVersion" class="badge badge-ghost">dev: {{ firmwareCheck.devLatestVersion }}</span>
              <span v-if="firmwareCheck.channel" class="badge badge-ghost">{{ firmwareCheck.channel }}</span>
              <a v-if="firmwareCheck.sourceUrl" class="link link-hover text-xs" :href="firmwareCheck.sourceUrl" target="_blank" rel="noreferrer">{{ $t('open') }}</a>
            </div>

            <div v-if="firmwareCheck.updateAvailable" class="rounded-lg border border-warning/40 bg-warning/10 px-3 py-2 text-sm">
              {{ $t('firmwareUpdateAvailable', { version: firmwareCheck.latestVersion || '—' }) }}
            </div>
            <div v-else-if="firmwareCheck.ok && firmwareCheck.latestVersion" class="rounded-lg border border-success/30 bg-success/10 px-3 py-2 text-sm">
              {{ $t('firmwareUpToDate') }}
            </div>
            <div v-else-if="firmwareCheck.error" class="rounded-lg border border-error/30 bg-error/10 px-3 py-2 text-sm">
              {{ firmwareCheck.error }}
            </div>
          </div>
        </details>
      </div>
    </template>
  </div>
</template>

<script setup lang="ts">
import { agentFirmwareCheckAPI, agentStatusAPI, agentStatusDebugAPI, type AgentStatusDebug } from '@/api/agent'
import { version as backendVersion } from '@/api'
import { prettyBytesHelper } from '@/helper/utils'
import { agentEnabled } from '@/store/agent'
import { computed, ref, watch } from 'vue'
import type { AgentStatus } from '@/api/agent'
import { useI18n } from 'vue-i18n'
import { useSafePolling } from '@/composables/useSafePolling'
import { useDocumentVisibility, useElementVisibility } from '@vueuse/core'

type FirmwareCheckState = {
  ok: boolean
  currentVersion?: string
  latestVersion?: string
  mainLatestVersion?: string
  previewLatestVersion?: string
  devLatestVersion?: string
  updateAvailable?: boolean
  checkedAt?: string
  sourceUrl?: string
  channel?: string
  cached?: boolean
  stale?: boolean
  error?: string
}

const { t } = useI18n()
const cardRef = ref<HTMLElement | null>(null)
const cardVisible = useElementVisibility(cardRef)
const documentVisibility = useDocumentVisibility()
const pollingActive = computed(() => agentEnabled.value && cardVisible.value && documentVisibility.value === 'visible')
const status = ref<AgentStatus>({ ok: false })
const debugStatus = ref<AgentStatusDebug>({ ok: false })
const firmwareCheck = ref<FirmwareCheckState>({ ok: false })
const firmwareLoading = ref(false)
const detailsLoading = ref(false)
const detailsLoaded = ref(false)

const prettyBytes = (v: any) => {
  const n = Number(v || 0)
  return prettyBytesHelper(Number.isFinite(n) ? n : 0)
}

const cpuPctText = computed(() => {
  const v = Number(status.value.cpuPct)
  if (!Number.isFinite(v)) return '—'
  return `${Math.round(v)}%`
})

const memPctText = computed(() => {
  const v = Number(status.value.memUsedPct)
  if (!Number.isFinite(v)) return '—'
  return `${Math.round(v)}%`
})

const uptimeText = computed(() => {
  const s = Number(status.value.uptimeSec)
  if (!Number.isFinite(s) || s <= 0) return '—'
  const sec = Math.floor(s)
  const d = Math.floor(sec / 86400)
  const h = Math.floor((sec % 86400) / 3600)
  const m = Math.floor((sec % 3600) / 60)
  if (d > 0) return `${d}d ${String(h).padStart(2, '0')}:${String(m).padStart(2, '0')}`
  return `${String(h).padStart(2, '0')}:${String(m).padStart(2, '0')}`
})

const firmwareCurrentLabel = computed(() => firmwareCheck.value.currentVersion || debugStatus.value.firmware || '—')

const firmwareBadgeClass = computed(() => {
  if (firmwareLoading.value) return 'badge-ghost'
  if (firmwareCheck.value.updateAvailable) return 'badge-warning'
  if (firmwareCheck.value.ok && firmwareCheck.value.latestVersion) return 'badge-success'
  if (firmwareCheck.value.error) return 'badge-error'
  return 'badge-ghost'
})

const firmwareBadgeText = computed(() => {
  if (firmwareLoading.value) return t('checking')
  if (firmwareCheck.value.updateAvailable) return t('firmwareUpdateAvailableShort')
  if (firmwareCheck.value.ok && firmwareCheck.value.latestVersion) return t('firmwareUpToDateShort')
  if (firmwareCheck.value.error) return t('firmwareCheckFailed')
  return t('firmwareCheckUnknown')
})

const refreshFirmware = async (force = false) => {
  if (!agentEnabled.value) {
    firmwareCheck.value = { ok: false }
    return
  }
  if (!detailsLoaded.value && !force) return
  firmwareLoading.value = true
  try {
    firmwareCheck.value = await agentFirmwareCheckAPI(force)
  } finally {
    firmwareLoading.value = false
  }
}

const summaryItems = computed(() => {
  const backendVer = String(backendVersion.value || '').trim()
  return [
    { key: 'agentVersion', label: t('agentVersion'), value: status.value.version || '—' },
    { key: 'agentServerVersion', label: t('agentServerVersion'), value: status.value.serverVersion || '—' },
    { key: 'firmware', label: t('firmware'), value: firmwareCurrentLabel.value },
    { key: 'mihomo', label: t('mihomoVersion'), value: debugStatus.value.mihomoBinVersion || backendVer || '—' },
    { key: 'temperature', label: t('temperature'), value: status.value.tempC ? `${status.value.tempC} °C` : '—' },
    { key: 'memoryFree', label: t('freeMemory'), value: prettyBytes(status.value.memFree) },
  ]
})

const infoItems = computed(() => {
  const backendVer = String(backendVersion.value || '').trim()
  return [
    { key: 'hostname', label: t('hostname'), value: debugStatus.value.hostname || '—' },
    { key: 'model', label: t('model'), value: debugStatus.value.model || '—' },
    { key: 'agentVersion', label: t('agentVersion'), value: status.value.version || debugStatus.value.version || '—' },
    { key: 'agentServerVersion', label: t('agentServerVersion'), value: status.value.serverVersion || debugStatus.value.serverVersion || '—' },
    { key: 'firmware', label: t('firmware'), value: debugStatus.value.firmware || firmwareCheck.value.currentVersion || '—' },
    { key: 'kernel', label: t('kernel'), value: debugStatus.value.kernel || '—' },
    { key: 'arch', label: t('architecture'), value: debugStatus.value.arch || '—' },
    { key: 'mihomo', label: t('mihomoVersion'), value: debugStatus.value.mihomoBinVersion || backendVer || '—' },
    { key: 'xkeen', label: t('xkeenVersion'), value: debugStatus.value.xkeenVersion || '—' },
    { key: 'temperature', label: t('temperature'), value: status.value.tempC ? `${status.value.tempC} °C` : '—' },
    { key: 'memoryFree', label: t('freeMemory'), value: prettyBytes(status.value.memFree) },
    {
      key: 'storage',
      label: t('storage'),
      value: debugStatus.value.storageTotal
        ? `${prettyBytes(debugStatus.value.storageUsed)} / ${prettyBytes(debugStatus.value.storageTotal)} · ${t('free')}: ${prettyBytes(debugStatus.value.storageFree)}${debugStatus.value.storagePath ? ` · ${debugStatus.value.storagePath}` : ''}`
        : '—',
    },
  ]
})

const refresh = async () => {
  if (!agentEnabled.value) {
    status.value = { ok: false }
    debugStatus.value = { ok: false }
    firmwareCheck.value = { ok: false }
    detailsLoaded.value = false
    return
  }
  status.value = (await agentStatusAPI()) as any
}

const refreshDebug = async (force = false) => {
  if (!agentEnabled.value) {
    debugStatus.value = { ok: false }
    detailsLoaded.value = false
    return
  }
  debugStatus.value = (await agentStatusDebugAPI({ force, maxAgeMs: force ? 0 : 60_000 })) as any
  detailsLoaded.value = true
}

const loadDetails = async (force = false) => {
  if (!agentEnabled.value) return
  detailsLoading.value = true
  try {
    await refreshDebug(force)
    await refreshFirmware(force)
  } finally {
    detailsLoading.value = false
  }
}

const ensureDetailsLoaded = () => {
  if (!agentEnabled.value || detailsLoaded.value || detailsLoading.value) return
  void loadDetails()
}

const handleRouterInfoToggle = (event: Event) => {
  const detailsEl = event.currentTarget as HTMLDetailsElement | null
  if (detailsEl?.open) ensureDetailsLoaded()
}

const handleFirmwareToggle = (event: Event) => {
  const detailsEl = event.currentTarget as HTMLDetailsElement | null
  if (detailsEl?.open) ensureDetailsLoaded()
}

const handleRefresh = () => {
  void refresh()
}

useSafePolling({
  callback: refresh,
  intervalMs: 20_000,
  enabled: () => pollingActive.value,
  immediate: false,
})

watch(agentEnabled, (enabled) => {
  if (!enabled) {
    status.value = { ok: false }
    debugStatus.value = { ok: false }
    firmwareCheck.value = { ok: false }
    detailsLoaded.value = false
  }
}, { immediate: true })

watch(pollingActive, (active, prev) => {
  if (active && !prev) {
    void refresh()
  }
}, { immediate: true })
</script>
