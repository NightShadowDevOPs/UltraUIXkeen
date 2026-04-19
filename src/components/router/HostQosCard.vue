<template>
  <div class="card gap-3 p-3">
    <div class="flex flex-wrap items-center justify-between gap-2">
      <div class="flex flex-wrap items-center gap-2">
        <div class="font-semibold">{{ $t('hostQosTitle') }}</div>
        <span v-if="!agentEnabled" class="badge badge-ghost">{{ $t('disabled') }}</span>
        <span v-else-if="status.ok && (qos.supported || status.hostQos)" class="badge badge-success">{{ $t('online') }}</span>
        <span v-else-if="status.ok && !(qos.supported || status.hostQos)" class="badge badge-warning">no-tc</span>
        <span v-else class="badge badge-error">{{ $t('offline') }}</span>
        <span v-if="qos.qosMode === 'wan-only'" class="badge badge-info">safe qos</span>
      </div>

      <div class="flex flex-wrap items-center gap-2 text-xs opacity-70">
        <span v-for="profile in profileOrder" :key="`legend-${profile}`" v-if="qos.defaults?.[profile]" class="badge badge-ghost">
          {{ profileLabel(profile) }}: {{ profileSummary(profile) }}
        </span>
        <span class="badge badge-ghost">{{ $t('hostQosTrackedHosts', { count: rows.length }) }}</span>
        <span class="badge badge-ghost">{{ $t('hostQosAppliedHosts', { count: appliedCount }) }}</span>
        <button type="button" class="btn btn-sm btn-ghost" @click="expanded = !expanded">
          {{ expanded ? $t('collapse') : $t('expand') }}
        </button>
        <button type="button" class="btn btn-sm" @click="refreshAll" :disabled="loading">
          <span v-if="loading" class="loading loading-spinner loading-xs"></span>
          <span v-else>{{ $t('refresh') }}</span>
        </button>
      </div>
    </div>

    <div v-if="!agentEnabled" class="text-sm opacity-70">
      {{ $t('agentDisabledTip') }}
    </div>
    <div v-else-if="!status.ok" class="text-sm opacity-70">
      {{ $t('agentOfflineTip') }}
    </div>
    <div v-else-if="!(qos.supported || status.hostQos)" class="rounded-lg border border-warning/30 bg-warning/10 px-3 py-2 text-sm">
      {{ $t('hostQosNoTcTip') }}
    </div>
    <div v-else-if="!expanded" class="rounded-lg border border-base-content/10 bg-base-200/30 px-3 py-2 text-sm opacity-80">
      {{ $t('hostQosIntro') }}
    </div>

    <div
      v-if="agentEnabled && status.ok && (qos.supported || status.hostQos)"
      class="grid grid-cols-2 gap-2 lg:grid-cols-4"
    >
      <button
        type="button"
        class="rounded-2xl border px-3 py-3 text-left transition hover:border-primary/40 hover:bg-base-200/40"
        :class="profileFilter === 'all' ? 'border-primary/50 bg-primary/10' : 'border-base-content/10 bg-base-100/50'"
        @click="profileFilter = 'all'"
      >
        <div class="text-[11px] uppercase tracking-[0.24em] opacity-60">{{ $t('all') }}</div>
        <div class="mt-1 text-2xl font-semibold">{{ rows.length }}</div>
        <div class="mt-1 text-xs opacity-70">{{ $t('hostQosTrackedHosts', { count: rows.length }) }}</div>
      </button>
      <button
        type="button"
        class="rounded-2xl border px-3 py-3 text-left transition hover:border-primary/40 hover:bg-base-200/40"
        :class="profileFilter === 'limited' ? 'border-primary/50 bg-primary/10' : 'border-base-content/10 bg-base-100/50'"
        @click="profileFilter = 'limited'"
      >
        <div class="text-[11px] uppercase tracking-[0.24em] opacity-60">{{ $t('hostQosFocusLimited') }}</div>
        <div class="mt-1 text-2xl font-semibold">{{ limitedCount }}</div>
        <div class="mt-1 text-xs opacity-70">{{ $t('hostQosFocusLimitedHint') }}</div>
      </button>
      <button
        type="button"
        class="rounded-2xl border px-3 py-3 text-left transition hover:border-primary/40 hover:bg-base-200/40"
        :class="profileFilter === 'blocked' ? 'border-primary/50 bg-primary/10' : 'border-base-content/10 bg-base-100/50'"
        @click="profileFilter = 'blocked'"
      >
        <div class="text-[11px] uppercase tracking-[0.24em] opacity-60">{{ $t('blocked') }}</div>
        <div class="mt-1 text-2xl font-semibold">{{ blockedCount }}</div>
        <div class="mt-1 text-xs opacity-70">{{ $t('hostQosFocusBlockedHint') }}</div>
      </button>
      <button
        type="button"
        class="rounded-2xl border px-3 py-3 text-left transition hover:border-primary/40 hover:bg-base-200/40"
        :class="profileFilter === 'normal' ? 'border-primary/50 bg-primary/10' : 'border-base-content/10 bg-base-100/50'"
        @click="profileFilter = 'normal'"
      >
        <div class="text-[11px] uppercase tracking-[0.24em] opacity-60">{{ profileLabel('normal') }}</div>
        <div class="mt-1 text-2xl font-semibold">{{ Math.max(rows.length - limitedCount - blockedCount, 0) }}</div>
        <div class="mt-1 text-xs opacity-70">{{ $t('hostQosFocusNormalHint') }}</div>
      </button>
    </div>

    <div
      v-if="expanded && agentEnabled && status.ok && (qos.supported || status.hostQos)"
      class="grid grid-cols-1 gap-2 xl:grid-cols-4"
    >
      <button
        v-for="card in diagnosticsCards"
        :key="card.key"
        type="button"
        class="rounded-2xl border px-3 py-3 text-left transition hover:border-primary/40 hover:bg-base-200/40 disabled:cursor-default disabled:hover:border-base-content/10 disabled:hover:bg-base-100/50"
        :class="[
          card.active ? 'border-primary/50 bg-primary/10' : 'border-base-content/10 bg-base-100/50',
          card.tone === 'warning' ? 'shadow-[inset_0_0_0_1px_rgba(245,158,11,0.14)]' : '',
          card.tone === 'error' ? 'shadow-[inset_0_0_0_1px_rgba(239,68,68,0.14)]' : '',
          card.tone === 'success' ? 'shadow-[inset_0_0_0_1px_rgba(34,197,94,0.14)]' : '',
        ]"
        :disabled="!card.clickable"
        @click="card.onClick?.()"
      >
        <div class="flex items-start justify-between gap-3">
          <div>
            <div class="text-[11px] uppercase tracking-[0.24em] opacity-60">{{ card.eyebrow }}</div>
            <div class="mt-1 text-xl font-semibold sm:text-2xl">{{ card.value }}</div>
          </div>
          <span v-if="card.badge" class="badge badge-ghost whitespace-nowrap">{{ card.badge }}</span>
        </div>
        <div class="mt-2 text-sm font-medium">{{ card.title }}</div>
        <div class="mt-1 text-xs opacity-70">{{ card.description }}</div>
      </button>
    </div>

    <template v-if="expanded && agentEnabled && status.ok && (qos.supported || status.hostQos)">
      <div class="rounded-lg border border-base-content/10 bg-base-200/30 p-3 text-sm">
        <div>{{ $t('hostQosIntro') }}</div>
        <div class="mt-1 text-xs opacity-70">{{ $t('hostQosShapeOverrideTip') }}</div>
        <div v-if="qos.qosMode === 'wan-only'" class="mt-1 text-xs text-info/80">Safe mode: uplink/WAN only</div>
      </div>

      <div class="sticky top-2 z-20 -mx-1 rounded-2xl border border-base-content/10 bg-base-100/95 p-3 shadow-sm backdrop-blur supports-[backdrop-filter]:bg-base-100/85">
        <div class="grid grid-cols-1 gap-2 xl:grid-cols-[minmax(0,1fr)_260px]">
          <div class="grid grid-cols-1 gap-2 lg:grid-cols-[minmax(0,1fr)_minmax(0,280px)]">
            <label class="flex min-w-0 flex-col gap-1">
              <span class="text-xs opacity-60">{{ $t('search') }}</span>
              <input v-model.trim="query" class="input input-sm w-full" :placeholder="$t('hostQosSearchPlaceholder')" />
            </label>
            <div class="rounded-xl border border-base-content/10 bg-base-200/50 px-3 py-2 text-xs">
              <div class="flex flex-wrap items-center gap-2">
                <span class="opacity-60">{{ $t('focus') }}:</span>
                <span class="badge badge-ghost">{{ activeFilterLabel }}</span>
                <span v-if="activeDiagnosticTitle" class="badge badge-secondary">{{ $t('diagnostics') }}: {{ activeDiagnosticTitle }}</span>
                <button v-if="query" type="button" class="btn btn-ghost btn-xs" @click="query = ''">{{ $t('clear') }}</button>
                <button v-if="profileFilter !== 'all'" type="button" class="btn btn-ghost btn-xs" @click="profileFilter = 'all'">{{ $t('reset') }}</button>
                <button v-if="activeDiagnosticKey !== 'all'" type="button" class="btn btn-ghost btn-xs" @click="activeDiagnosticKey = 'all'">{{ $t('reset') }}</button>
                <span v-if="props.focusUser || props.focusIp" class="badge badge-info">{{ props.focusUser || props.focusIp }}</span>
              </div>
              <div class="mt-2 opacity-70">{{ $t('hostQosAppliedHosts', { count: appliedCount }) }}</div>
              <div class="opacity-70">{{ $t('hostQosFilteredHosts', { count: filteredRows.length }) }}</div>
            </div>
          </div>
          <div class="rounded-xl border border-base-content/10 bg-base-200/50 px-3 py-2 text-xs opacity-70">
            <div>{{ $t('hostQosTrackedHosts', { count: rows.length }) }}</div>
            <div>{{ $t('hostQosAppliedHosts', { count: appliedCount }) }}</div>
            <div>{{ $t('hostQosLineRates', { wan: qos.wanRateMbit || '—', lan: qos.lanRateMbit || '—' }) }}</div>
            <div v-if="qos.qosMode === 'wan-only'">Safe mode: uplink/WAN only</div>
          </div>
        </div>
      </div>

      <div v-if="error" class="rounded-lg border border-error/30 bg-error/10 px-3 py-2 text-sm text-error">
        {{ error }}
      </div>

      <div class="overflow-x-auto rounded-lg border border-base-content/10 bg-base-100/50">
        <table class="table table-sm">
          <thead>
            <tr>
              <th>{{ $t('host') }}</th>
              <th>{{ $t('current') }}</th>
              <th>{{ $t('hostQosLiveRate') }}</th>
              <th>{{ $t('hostQosSetProfile') }}</th>
              <th class="text-right">{{ $t('actions') }}</th>
            </tr>
          </thead>
          <tbody>
            <tr
              v-for="row in filteredRows"
              :key="row.ip"
              :class="isFocusedRow(row) ? 'bg-info/5' : ''"
            >
              <td class="min-w-[240px]">
                <div class="flex flex-col gap-1">
                  <div class="flex flex-col gap-0.5">
                    <div class="flex flex-wrap items-center gap-2">
                      <span class="font-medium">{{ row.displayName || row.hostname || row.ip }}</span>
                      <span v-if="row.currentProfile" class="inline-flex items-center gap-1 rounded-full border px-1.5 py-0.5 text-[10px] font-medium" :class="profilePillClass(row.currentProfile)">
                        <span aria-hidden="true">{{ profileIcon(row.currentProfile) }}</span>
                        <span class="opacity-80">QoS</span>
                        <span class="inline-flex items-end gap-0.5" aria-hidden="true">
                          <span
                            v-for="bar in qosIndicatorBars(row.currentProfile)"
                            :key="`${row.ip}-title-${bar.key}`"
                            class="w-1 rounded-full"
                            :class="bar.active ? profileBarClass(row.currentProfile) : 'bg-base-content/10'"
                            :style="{ height: `${bar.height}px` }"
                          />
                        </span>
                      </span>
                    </div>
                    <span class="font-mono text-[11px] opacity-70">{{ row.ip }}</span>
                    <span v-if="row.mac" class="font-mono text-[11px] opacity-50">{{ row.mac }}</span>
                  </div>
                  <div
                    v-if="activeDiagnosticKey !== 'all'"
                    class="flex flex-wrap gap-1"
                  >
                    <span
                      class="badge badge-ghost badge-sm border-warning/30 bg-warning/10 text-[10px] uppercase tracking-[0.16em]"
                      :title="diagnosticReasonTitle(row)"
                    >
                      {{ diagnosticReasonLabel(row) }}
                    </span>
                  </div>
                </div>
              </td>
              <td>
                <span v-if="row.currentProfile" class="inline-flex items-center gap-1 rounded-full border px-2 py-1 text-[11px] font-medium" :class="profilePillClass(row.currentProfile)">
                  <span aria-hidden="true">{{ profileIcon(row.currentProfile) }}</span>
                  <span class="opacity-80">QoS</span>
                  <span class="inline-flex items-end gap-0.5" aria-hidden="true">
                    <span
                      v-for="bar in qosIndicatorBars(row.currentProfile)"
                      :key="`${row.ip}-current-${bar.key}`"
                      class="w-1 rounded-full"
                      :class="bar.active ? profileBarClass(row.currentProfile) : 'bg-base-content/10'"
                      :style="{ height: `${bar.height}px` }"
                    />
                  </span>
                  <span>{{ profileLabel(row.currentProfile) }}</span>
                </span>
                <span v-else class="text-xs opacity-60">{{ $t('hostQosNotSet') }}</span>
                <div v-if="row.qosMeta" class="mt-1 flex flex-col gap-0.5 text-[11px] opacity-60">
                  <span>{{ $t('hostQosQueuePriority', { priority: row.qosMeta.priority ?? '—' }) }}</span>
                  <span>{{ $t('hostQosGuarantee', { up: row.qosMeta.upMinMbit || 0, down: row.qosMeta.downMinMbit || 0 }) }}</span>
                </div>
              </td>
              <td>
                <div class="flex flex-col gap-0.5 text-[11px] sm:text-xs">
                  <span>↓ {{ formatRate(row.totalDownBps) }}</span>
                  <span>↑ {{ formatRate(row.totalUpBps) }}</span>
                </div>
              </td>
              <td>
                <div class="flex flex-col gap-1">
                  <select v-model="draftProfiles[row.ip]" class="select select-sm min-w-[170px]">
                    <option v-for="profile in profileOrder" :key="`${row.ip}-${profile}`" :value="profile">{{ profileLabel(profile) }}</option>
                  </select>
                  <span class="text-[11px] opacity-60">{{ profileSummary(draftProfiles[row.ip] || 'normal') }}</span>
                  <span
                    v-if="draftProfiles[row.ip] && draftProfiles[row.ip] !== (row.currentProfile || 'normal')"
                    class="text-[11px] opacity-70"
                  >
                    {{ $t('hostQosWillApply', { profile: profileLabel(draftProfiles[row.ip]) }) }}
                  </span>
                </div>
              </td>
              <td>
                <div class="flex flex-wrap justify-end gap-2">
                  <button
                    v-if="linkedUserLabel(row)"
                    type="button"
                    class="btn btn-ghost btn-xs"
                    :title="$t('trafficWorkspaceOpenUsers')"
                    @click="openUserTraffic(row)"
                  >
                    {{ $t('trafficWorkspaceOpenUsers') }}
                  </button>
                  <button
                    type="button"
                    class="btn btn-xs"
                    @click="applyRow(row.ip)"
                    :disabled="busyIp === row.ip || !draftProfiles[row.ip]"
                  >
                    <span v-if="busyIp === row.ip" class="loading loading-spinner loading-xs"></span>
                    <span v-else>{{ $t('apply') }}</span>
                  </button>
                  <button
                    type="button"
                    class="btn btn-ghost btn-xs"
                    @click="clearRow(row.ip)"
                    :disabled="busyIp === row.ip || !row.currentProfile"
                  >
                    {{ $t('clear') }}
                  </button>
                </div>
              </td>
            </tr>
            <tr v-if="!filteredRows.length">
              <td colspan="5" class="py-6 text-center text-sm opacity-60">{{ $t('hostQosNoHosts') }}</td>
            </tr>
          </tbody>
        </table>
      </div>
    </template>
  </div>
</template>

<script setup lang="ts">
import {
  agentHostTrafficLiveAPI,
  agentLanHostsAPI,
  agentQosStatusAPI,
  agentRemoveHostQosAPI,
  agentSetHostQosAPI,
  agentStatusAPI,
  type AgentHostTrafficLiveItem,
  type AgentLanHost,
  type AgentQosProfile,
  type AgentQosStatus,
  type AgentQosStatusItem,
} from '@/api/agent'
import { getIPLabelFromMap } from '@/helper/sourceip'
import { prettyBytesHelper } from '@/helper/utils'
import { agentEnabled } from '@/store/agent'
import { activeConnections } from '@/store/connections'
import { mergeRouterHostQosAppliedProfiles, routerHostQosAppliedProfiles, routerHostQosDraftProfiles, routerHostQosExpanded, setRouterHostQosAppliedProfile } from '@/store/routerHostQos'
import { computed, onMounted, ref, watch, withDefaults } from 'vue'
import { useSafePolling } from '@/composables/useSafePolling'
import { useI18n } from 'vue-i18n'

const profileOrder: AgentQosProfile[] = ['critical', 'high', 'elevated', 'normal', 'low', 'background']

const props = withDefaults(
  defineProps<{
    focusIp?: string
    focusUser?: string
  }>(),
  {
    focusIp: '',
    focusUser: '',
  },
)

const emit = defineEmits<{
  (e: 'open-user-focus', payload: { user?: string; ip?: string }): void
}>()

type Row = AgentLanHost & AgentHostTrafficLiveItem & {
  currentProfile?: AgentQosProfile
  qosMeta?: AgentQosStatusItem
  displayName?: string
}

const { t } = useI18n()
const loading = ref(false)
const error = ref('')
const query = ref('')
const profileFilter = ref<'all' | AgentQosProfile | 'blocked' | 'limited'>('all')
const status = ref<{ ok: boolean; hostQos?: boolean }>({ ok: false })
const qos = ref<AgentQosStatus>({ ok: false, supported: false, items: [] })
const hosts = ref<AgentLanHost[]>([])
const traffic = ref<AgentHostTrafficLiveItem[]>([])
const draftProfiles = routerHostQosDraftProfiles
const appliedProfiles = routerHostQosAppliedProfiles
const busyIp = ref('')
const expanded = routerHostQosExpanded

const focusIpNormalized = computed(() => props.focusIp.trim().toLowerCase())
const focusUserNormalized = computed(() => props.focusUser.trim().toLowerCase())

const looksLikeIp = (value: string): boolean => /^(?:\d{1,3}\.){3}\d{1,3}$/.test(value.trim())

const linkedUserLabel = (row: Pick<Row, 'displayName' | 'hostname' | 'ip'>): string => {
  const label = String(row.displayName || row.hostname || '').trim()
  if (!label || looksLikeIp(label) || label === row.ip) return ''
  return label
}

const isFocusedRow = (row: Pick<Row, 'displayName' | 'hostname' | 'ip'>): boolean => {
  const focusIp = focusIpNormalized.value
  const focusUser = focusUserNormalized.value
  const rowIp = String(row.ip || '').trim().toLowerCase()
  const rowUser = linkedUserLabel(row).toLowerCase()
  return (!!focusIp && rowIp === focusIp) || (!!focusUser && rowUser === focusUser)
}

const openUserTraffic = (row: Pick<Row, 'displayName' | 'hostname' | 'ip'>) => {
  const user = linkedUserLabel(row)
  if (!user) return
  emit('open-user-focus', { user, ip: row.ip })
}

watch(
  [() => props.focusIp, () => props.focusUser],
  ([ip, user]) => {
    const focusTerm = String(ip || '').trim() || String(user || '').trim()
    if (!focusTerm) return
    query.value = focusTerm
    expanded.value = true
  },
  { immediate: true },
)

const qosMap = computed<Record<string, AgentQosStatusItem>>(() => {
  const out: Record<string, AgentQosStatusItem> = {}
  for (const item of qos.value.items || []) out[item.ip] = item
  return out
})

const rows = computed<Row[]>(() => {
  const hostMap = new Map<string, AgentLanHost>()
  for (const host of hosts.value) hostMap.set(host.ip, host)
  const trafficMap = new Map<string, AgentHostTrafficLiveItem>()
  for (const item of traffic.value) trafficMap.set(item.ip, item)
  const activeConnectionIps = (activeConnections.value || [])
    .map((conn) => String(conn?.metadata?.sourceIP || '').trim())
    .filter(Boolean)

  const ips = new Set<string>([
    ...Array.from(hostMap.keys()),
    ...Array.from(trafficMap.keys()),
    ...Object.keys(qosMap.value),
    ...Object.keys(appliedProfiles.value),
    ...activeConnectionIps,
  ])
  return Array.from(ips)
    .map((ip) => {
      const host = hostMap.get(ip) || ({ ip } as AgentLanHost)
      const live = trafficMap.get(ip) || ({ ip } as AgentHostTrafficLiveItem)
      const meta = qosMap.value[ip]
      const mappedLabel = getIPLabelFromMap(ip)
      const displayName = mappedLabel && mappedLabel !== ip ? mappedLabel : host.hostname || live.hostname || ip
      return {
        ...host,
        ...live,
        ip,
        displayName,
        hostname: host.hostname || live.hostname || '',
        currentProfile: meta?.profile || appliedProfiles.value[ip],
        qosMeta: meta,
      }
    })
    .sort((a, b) => {
      const an = String(a.displayName || a.hostname || a.ip).toLowerCase()
      const bn = String(b.displayName || b.hostname || b.ip).toLowerCase()
      return an.localeCompare(bn)
    })
})

const matchesProfileFilter = (row: Row): boolean => {
  if (profileFilter.value === 'all') return true
  if (profileFilter.value === 'limited') return !!row.currentProfile && row.currentProfile !== 'normal' && row.currentProfile !== 'blocked'
  return (row.currentProfile || 'normal') === profileFilter.value
}

const rowHasLiveTraffic = (row: Row) => Number(row.totalDownBps || 0) + Number(row.totalUpBps || 0) > 0

const profileSeverity = (profile?: string) => {
  const value = String(profile || '').trim().toLowerCase()
  if (value === 'critical') return 5
  if (value === 'high') return 4
  if (value === 'elevated') return 3
  if (value === 'low') return 2
  if (value === 'background') return 1
  return 0
}

const pendingDraftSeverity = (row: Row) => profileSeverity(draftProfiles.value[row.ip] || 'normal') - profileSeverity(row.currentProfile || 'normal')

const compareRowsByName = (a: Row, b: Row) => {
  const an = String(a.displayName || a.hostname || a.ip).toLowerCase()
  const bn = String(b.displayName || b.hostname || b.ip).toLowerCase()
  return an.localeCompare(bn)
}

const compareRowsForDiagnosticKey = (key: 'all' | 'active-traffic' | 'unlabeled' | 'pending', a: Row, b: Row) => {
  if (key === 'active-traffic') {
    const trafficDelta = (Number(b.totalDownBps || 0) + Number(b.totalUpBps || 0)) - (Number(a.totalDownBps || 0) + Number(a.totalUpBps || 0))
    if (trafficDelta !== 0) return trafficDelta
  }
  if (key === 'unlabeled') {
    const trafficDelta = (Number(b.totalDownBps || 0) + Number(b.totalUpBps || 0)) - (Number(a.totalDownBps || 0) + Number(a.totalUpBps || 0))
    if (trafficDelta !== 0) return trafficDelta
    const qosDelta = profileSeverity(b.currentProfile || 'normal') - profileSeverity(a.currentProfile || 'normal')
    if (qosDelta !== 0) return qosDelta
  }
  if (key === 'pending') {
    const severityDelta = pendingDraftSeverity(b) - pendingDraftSeverity(a)
    if (severityDelta !== 0) return severityDelta
    const trafficDelta = (Number(b.totalDownBps || 0) + Number(b.totalUpBps || 0)) - (Number(a.totalDownBps || 0) + Number(a.totalUpBps || 0))
    if (trafficDelta !== 0) return trafficDelta
  }
  return compareRowsByName(a, b)
}

const diagnosticReasonLabel = (row: Row) => {
  if (activeDiagnosticKey.value === 'active-traffic') return t('hostQosDiagnosticReasonActiveTraffic', { rate: formatRate(Number(row.totalDownBps || 0) + Number(row.totalUpBps || 0)) })
  if (activeDiagnosticKey.value === 'unlabeled') return t('hostQosDiagnosticReasonUnlabeled')
  if (activeDiagnosticKey.value === 'pending') return t('hostQosDiagnosticReasonPending', { profile: profileLabel((draftProfiles.value[row.ip] || 'normal') as AgentQosProfile) })
  return ''
}

const diagnosticReasonTitle = (row: Row) => {
  if (activeDiagnosticKey.value === 'active-traffic') return t('hostQosDiagnosticReasonActiveTrafficTitle')
  if (activeDiagnosticKey.value === 'unlabeled') return t('hostQosDiagnosticReasonUnlabeledTitle')
  if (activeDiagnosticKey.value === 'pending') return t('hostQosDiagnosticReasonPendingTitle', { current: profileLabel((row.currentProfile || 'normal') as AgentQosProfile), draft: profileLabel((draftProfiles.value[row.ip] || 'normal') as AgentQosProfile) })
  return ''
}

const rowMatchesDiagnostic = (row: Row) => {
  if (activeDiagnosticKey.value === 'all') return true
  if (activeDiagnosticKey.value === 'active-traffic') return rowHasLiveTraffic(row)
  if (activeDiagnosticKey.value === 'unlabeled') return !linkedUserLabel(row) && !String(row.hostname || '').trim()
  if (activeDiagnosticKey.value === 'pending') return (draftProfiles.value[row.ip] || 'normal') !== (row.currentProfile || 'normal')
  return true
}

const filteredRows = computed(() => {
  const q = query.value.trim().toLowerCase()
  const filtered = rows.value.filter((row) => {
    if (!matchesProfileFilter(row)) return false
    if (!rowMatchesDiagnostic(row)) return false
    if (!q) return true
    return [row.displayName, row.hostname, row.ip, row.mac, row.currentProfile]
      .filter(Boolean)
      .some((v) => String(v).toLowerCase().includes(q))
  })
  if (activeDiagnosticKey.value !== 'all') return [...filtered].sort((a, b) => compareRowsForDiagnosticKey(activeDiagnosticKey.value, a, b))
  return filtered
})

const appliedCount = computed(() => (qos.value.items || []).length)
const limitedCount = computed(() => rows.value.filter((row) => !!row.currentProfile && row.currentProfile !== 'normal' && row.currentProfile !== 'blocked').length)
const blockedCount = computed(() => rows.value.filter((row) => row.currentProfile === 'blocked').length)
const activeFilterLabel = computed(() => {
  if (profileFilter.value === 'all') return t('all')
  if (profileFilter.value === 'limited') return t('hostQosFocusLimited')
  if (profileFilter.value === 'blocked') return t('blocked')
  return profileLabel(profileFilter.value)
})

const activeTrafficRows = computed(() =>
  [...rows.value]
    .filter((row) => Number(row.totalDownBps || 0) + Number(row.totalUpBps || 0) > 0)
    .sort((a, b) => (Number(b.totalDownBps || 0) + Number(b.totalUpBps || 0)) - (Number(a.totalDownBps || 0) + Number(a.totalUpBps || 0))),
)

const unlabeledRows = computed(() =>
  [...rows.value]
    .filter((row) => !linkedUserLabel(row) && !String(row.hostname || '').trim())
    .sort((a, b) => compareRowsForDiagnosticKey('unlabeled', a, b)),
)

const pendingDraftRows = computed(() =>
  [...rows.value]
    .filter((row) => (draftProfiles.value[row.ip] || 'normal') !== (row.currentProfile || 'normal'))
    .sort((a, b) => compareRowsForDiagnosticKey('pending', a, b)),
)

const activateDiagnostic = (key: 'active-traffic' | 'unlabeled' | 'pending') => {
  if (activeDiagnosticKey.value === key) {
    activeDiagnosticKey.value = 'all'
    return
  }
  activeDiagnosticKey.value = key
  profileFilter.value = 'all'
  query.value = ''
}

const diagnosticsCards = computed(() => {
  const topTrafficRow = activeTrafficRows.value[0]
  const unlabeledCount = unlabeledRows.value.length
  const pendingCount = pendingDraftRows.value.length
  const activeCount = activeTrafficRows.value.length

  return [
    {
      key: 'active-traffic',
      eyebrow: t('hostQosDiagnosticsEyebrowTraffic'),
      value: String(activeCount),
      badge: topTrafficRow ? formatRate(Number(topTrafficRow.totalDownBps || 0) + Number(topTrafficRow.totalUpBps || 0)) : '',
      title: t('hostQosDiagnosticsTrafficTitle'),
      description: topTrafficRow
        ? t('hostQosDiagnosticsTrafficHint', { host: topTrafficRow.displayName || topTrafficRow.hostname || topTrafficRow.ip })
        : t('hostQosDiagnosticsTrafficEmpty'),
      tone: activeCount > 0 ? 'warning' : 'success',
      clickable: activeCount > 0,
      active: activeDiagnosticKey.value === 'active-traffic',
      onClick: activeCount > 0 ? () => activateDiagnostic('active-traffic') : undefined,
    },
    {
      key: 'unlabeled',
      eyebrow: t('hostQosDiagnosticsEyebrowHosts'),
      value: String(unlabeledCount),
      badge: unlabeledRows.value[0]?.ip || '',
      title: t('hostQosDiagnosticsUnlabeledTitle'),
      description: unlabeledCount
        ? t('hostQosDiagnosticsUnlabeledHint')
        : t('hostQosDiagnosticsUnlabeledEmpty'),
      tone: unlabeledCount > 0 ? 'warning' : 'success',
      clickable: unlabeledCount > 0,
      active: activeDiagnosticKey.value === 'unlabeled',
      onClick: unlabeledCount > 0 ? () => activateDiagnostic('unlabeled') : undefined,
    },
    {
      key: 'pending',
      eyebrow: t('hostQosDiagnosticsEyebrowProfiles'),
      value: String(pendingCount),
      badge: pendingDraftRows.value[0]?.ip || '',
      title: t('hostQosDiagnosticsPendingTitle'),
      description: pendingCount
        ? t('hostQosDiagnosticsPendingHint')
        : t('hostQosDiagnosticsPendingEmpty'),
      tone: pendingCount > 0 ? 'error' : 'success',
      clickable: pendingCount > 0,
      active: activeDiagnosticKey.value === 'pending',
      onClick: pendingCount > 0 ? () => activateDiagnostic('pending') : undefined,
    },
    {
      key: 'focus',
      eyebrow: t('hostQosDiagnosticsEyebrowFocus'),
      value: String(filteredRows.value.length),
      badge: activeFilterLabel.value,
      title: t('hostQosDiagnosticsFocusTitle'),
      description: t('hostQosDiagnosticsFocusHint', { count: filteredRows.value.length, total: rows.value.length }),
      tone: profileFilter.value !== 'all' || !!query.value.trim() || activeDiagnosticKey.value !== 'all' ? 'warning' : 'success',
      clickable: profileFilter.value !== 'all' || !!query.value.trim() || activeDiagnosticKey.value !== 'all',
      active: activeDiagnosticKey.value === 'all' && (profileFilter.value !== 'all' || !!query.value.trim()),
      onClick: () => {
        profileFilter.value = 'all'
        query.value = ''
        activeDiagnosticKey.value = 'all'
      },
    },
  ]
})

const activeDiagnosticTitle = computed(() =>
  diagnosticsCards.value.find((card) => card.key === activeDiagnosticKey.value)?.title || '',
)

const syncAppliedProfiles = () => {
  const next: Record<string, AgentQosProfile> = {}
  for (const item of qos.value.items || []) {
    if (item?.ip && item?.profile) next[item.ip] = item.profile
  }
  mergeRouterHostQosAppliedProfiles(next)
}

const ensureDrafts = () => {
  const next = { ...draftProfiles.value }
  for (const row of rows.value) {
    if (!next[row.ip]) next[row.ip] = row.currentProfile || appliedProfiles.value[row.ip] || 'normal'
  }
  draftProfiles.value = next
}

const formatRate = (bps?: number) => {
  const n = Number(bps || 0)
  if (!Number.isFinite(n) || n <= 0) return '0 B/s'
  return `${prettyBytesHelper(n)}/s`
}

const profileLabel = (profile?: AgentQosProfile) => {
  if (profile === 'critical') return t('hostQosCritical')
  if (profile === 'high') return t('hostQosHigh')
  if (profile === 'elevated') return t('hostQosElevated')
  if (profile === 'low') return t('hostQosLow')
  if (profile === 'background') return t('hostQosBackground')
  return t('hostQosNormal')
}

const profileIcon = (profile?: AgentQosProfile) => {
  if (profile === 'critical') return '⏫'
  if (profile === 'high') return '⬆'
  if (profile === 'elevated') return '↗'
  if (profile === 'low') return '↘'
  if (profile === 'background') return '⬇'
  return '•'
}

const qosLevel = (profile?: AgentQosProfile) => {
  if (profile === 'critical') return 6
  if (profile === 'high') return 5
  if (profile === 'elevated') return 4
  if (profile === 'low') return 2
  if (profile === 'background') return 1
  return 3
}

const profileBadgeClass = (profile: AgentQosProfile) => {
  if (profile === 'critical') return 'badge-error'
  if (profile === 'high') return 'badge-success'
  if (profile === 'elevated') return 'badge-accent'
  if (profile === 'low') return 'badge-warning'
  if (profile === 'background') return 'badge-ghost'
  return 'badge-info'
}

const profilePillClass = (profile: AgentQosProfile) => {
  if (profile === 'critical') return 'border-error/30 bg-error/10 text-error'
  if (profile === 'high') return 'border-success/30 bg-success/10 text-success'
  if (profile === 'elevated') return 'border-accent/30 bg-accent/10 text-accent'
  if (profile === 'low') return 'border-warning/30 bg-warning/10 text-warning'
  if (profile === 'background') return 'border-base-content/10 bg-base-200/50 text-base-content/70'
  return 'border-info/30 bg-info/10 text-info'
}

const profileBarClass = (profile: AgentQosProfile) => {
  if (profile === 'critical') return 'bg-error'
  if (profile === 'high') return 'bg-success'
  if (profile === 'elevated') return 'bg-accent'
  if (profile === 'low') return 'bg-warning'
  if (profile === 'background') return 'bg-base-content/45'
  return 'bg-info'
}

const qosIndicatorBars = (profile?: AgentQosProfile) => {
  const active = qosLevel(profile)
  return [6, 8, 10, 12, 14, 16].map((height, index) => ({
    key: String(index),
    height,
    active: index < active,
  }))
}

const profileSummary = (profile: AgentQosProfile) => {
  const item = qos.value.defaults?.[profile]
  if (!item) return '—'
  return `${item.pct || 0}% · prio ${item.priority ?? '—'}`
}

const refreshSummary = async () => {
  const [st, q, h] = await Promise.all([
    agentStatusAPI(),
    agentQosStatusAPI(),
    agentLanHostsAPI(),
  ])
  status.value = { ok: !!st.ok, hostQos: !!st.hostQos }
  qos.value = q.ok ? q : { ok: false, supported: false, items: [], error: q.error }
  if (q.ok) syncAppliedProfiles()
  hosts.value = h.ok && h.items ? h.items : []
  ensureDrafts()
  if (!st.ok) error.value = st.error || t('agentOfflineTip')
  else if (!q.ok) error.value = q.error || t('hostQosStatusFailed')
}

const refreshAll = async ({ includeLive = expanded.value || Boolean(props.focusUser || props.focusIp) }: { includeLive?: boolean } = {}) => {
  if (!agentEnabled.value) return
  loading.value = true
  error.value = ''
  try {
    if (!includeLive) {
      await refreshSummary()
      traffic.value = []
      return
    }
    const [st, q, h, tr] = await Promise.all([
      agentStatusAPI(),
      agentQosStatusAPI(),
      agentLanHostsAPI(),
      agentHostTrafficLiveAPI(),
    ])
    status.value = { ok: !!st.ok, hostQos: !!st.hostQos }
    qos.value = q.ok ? q : { ok: false, supported: false, items: [], error: q.error }
    if (q.ok) syncAppliedProfiles()
    hosts.value = h.ok && h.items ? h.items : []
    traffic.value = tr.ok && tr.items ? tr.items : []
    ensureDrafts()
    if (!st.ok) error.value = st.error || t('agentOfflineTip')
    else if (!q.ok) error.value = q.error || t('hostQosStatusFailed')
  } finally {
    loading.value = false
  }
}

const applyRow = async (ip: string) => {
  const profile = draftProfiles.value[ip]
  if (!profile) return
  busyIp.value = ip
  error.value = ''
  try {
    const res = await agentSetHostQosAPI({ ip, profile })
    if (!res.ok) {
      error.value = res.error || t('hostQosApplyFailed')
      return
    }
    setRouterHostQosAppliedProfile(ip, profile)
    draftProfiles.value = { ...draftProfiles.value, [ip]: profile }
    await refreshAll()
  } finally {
    busyIp.value = ''
  }
}

const clearRow = async (ip: string) => {
  busyIp.value = ip
  error.value = ''
  try {
    const res = await agentRemoveHostQosAPI(ip)
    if (!res.ok) {
      error.value = res.error || t('hostQosApplyFailed')
      return
    }
    setRouterHostQosAppliedProfile(ip)
    draftProfiles.value = { ...draftProfiles.value, [ip]: 'normal' }
    await refreshAll()
  } finally {
    busyIp.value = ''
  }
}


watch(rows, () => {
  ensureDrafts()
}, { deep: true })

watch(appliedProfiles, () => {
  ensureDrafts()
}, { deep: true })

useSafePolling({
  callback: refreshAll,
  intervalMs: 15_000,
  enabled: () => expanded.value,
  immediate: false,
})

watch(expanded, async (value) => {
  if (value) await refreshAll({ includeLive: true })
})

onMounted(async () => {
  await refreshAll({ includeLive: expanded.value || Boolean(props.focusUser || props.focusIp) })
})
</script>
