<template>
  <div class="card gap-2 p-3">
    <div class="flex items-center justify-between gap-2">
      <div class="flex items-center gap-2">
        <div class="font-semibold">{{ $t('routerAgent') }}</div>
        <span v-if="!agentEnabled" class="badge badge-ghost">{{ $t('disabled') }}</span>
        <span v-else class="badge" :class="status.ok ? 'badge-success' : 'badge-error'">
          {{ status.ok ? $t('online') : $t('offline') }}
        </span>
        <span v-if="agentEnabled && status.ok && status.tc" class="badge badge-success">tc</span>
        <span v-if="agentEnabled && status.ok && !status.tc" class="badge badge-warning">no-tc</span>
      </div>

      <div class="flex items-center gap-2">
        <button type="button" class="btn btn-sm" @click="refresh">{{ $t('test') }}</button>
        <button
          type="button"
          class="btn btn-sm btn-outline"
          @click="runBackup"
          :disabled="!agentEnabled || !status.ok || backupLoading || backup.running"
          :title="$t('agentBackupNow')"
        >
          <span v-if="backupLoading || backup.running" class="loading loading-spinner loading-xs"></span>
          <span v-else>{{ $t('agentBackup') }}</span>
        </button>
      </div>
    </div>

    <div class="grid grid-cols-1 sm:grid-cols-2 gap-2">
      <label class="flex items-center justify-between gap-2">
        <span class="text-sm">{{ $t('enable') }}</span>
        <input type="checkbox" class="toggle" v-model="agentEnabled" />
      </label>

      <label class="flex items-center justify-between gap-2">
        <span class="text-sm">{{ $t('enforceBandwidth') }}</span>
        <input type="checkbox" class="toggle" v-model="agentEnforceBandwidth" :disabled="!agentEnabled" />
      </label>
    </div>

    <div class="grid grid-cols-1 sm:grid-cols-2 gap-2">
      <label class="flex flex-col gap-1">
        <span class="text-sm opacity-70">{{ $t('agentUrl') }}</span>
        <input class="input input-sm" v-model="agentUrl" placeholder="http://192.168.1.1:9099" :disabled="!agentEnabled" />
      </label>

      <label class="flex flex-col gap-1">
        <span class="text-sm opacity-70">{{ $t('agentToken') }}</span>
        <input class="input input-sm" v-model="agentToken" placeholder="(optional)" :disabled="!agentEnabled" />
      </label>
    </div>

        <div class="text-xs opacity-70">
      <div v-if="agentEnabled && status.ok">
        {{ $t('agentDetected') }}: {{ status.lan || 'br0' }} → {{ status.wan || 'eth4' }}
        <div v-if="status.version || status.serverVersion" class="mt-0.5 flex flex-wrap items-center gap-2">
          <span v-if="status.version" class="font-mono">v{{ status.version }}</span>
          <span v-if="status.serverVersion" class="opacity-60">
            latest <span class="font-mono">{{ status.serverVersion }}</span>
          </span>
          <span v-if="needsUpdate" class="badge badge-warning badge-sm">{{ $t('agentUpdate') }}</span>
          <span v-else-if="isAhead" class="badge badge-info badge-sm">{{ $t('agentAhead') }}</span>
        </div>

        <div class="mt-1">
          <div class="flex flex-wrap items-center gap-2">
            <span class="opacity-60">{{ $t('agentBackupLast') }}:</span>
            <span v-if="backup.running" class="badge badge-info badge-sm">{{ $t('agentBackupRunning') }}</span>
            <span v-else-if="backup.success" class="badge badge-success badge-sm">{{ $t('agentBackupOk') }}</span>
            <span v-else-if="backup.finishedAt || backup.startedAt" class="badge badge-warning badge-sm">{{ $t('agentBackupFail') }}</span>
            <span v-if="backup.finishedAt || backup.startedAt" class="font-mono">{{ backup.finishedAt || backup.startedAt }}</span>
            <span v-if="backup.file" class="opacity-60 font-mono">{{ backup.file }}</span>
            <button type="button" class="btn btn-ghost btn-xs" @click="refreshBackup" :disabled="backupLoading">↻</button>
          </div>
          <details class="mt-1" @toggle="onBackupLogToggle">
            <summary class="cursor-pointer text-xs opacity-80">{{ $t('agentBackupViewLog') }}</summary>
            <pre class="mt-1 max-h-40 overflow-auto whitespace-pre-wrap rounded-lg bg-base-200/60 p-2 text-[11px]">{{ backupLog || '…' }}</pre>
          </details>
        </div>
      </div>
      <div v-else-if="agentEnabled && !status.ok">
        {{ $t('agentOfflineTip') }}
      </div>
      <div v-else>
        {{ $t('agentDisabledTip') }}
      </div>
    </div>

  </div>
</template>

<script setup lang="ts">
import { agentBackupLogAPI, agentBackupStartAPI, agentBackupStatusAPI, agentStatusAPI } from '@/api/agent'
import { agentEnabled, agentEnforceBandwidth, agentToken, agentUrl } from '@/store/agent'
import { computed, onMounted, ref } from 'vue'

const status = ref<{ ok: boolean; version?: string; serverVersion?: string; tc?: boolean; wan?: string; lan?: string }>({ ok: false })

const backup = ref<any>({ ok: true, running: false })
const backupLog = ref('')
const backupLoading = ref(false)


const versionCmp = (a?: string, b?: string) => {
  const as = (a || '').match(/\d+/g)?.map((x) => parseInt(x, 10)) || []
  const bs = (b || '').match(/\d+/g)?.map((x) => parseInt(x, 10)) || []
  const n = Math.max(as.length, bs.length)
  for (let i = 0; i < n; i++) {
    const av = as[i] ?? 0
    const bv = bs[i] ?? 0
    if (av < bv) return -1
    if (av > bv) return 1
  }
  return 0
}

const needsUpdate = computed(() => {
  if (!status.value?.ok || !status.value?.version || !status.value?.serverVersion) return false
  return versionCmp(status.value.version, status.value.serverVersion) < 0
})

const isAhead = computed(() => {
  if (!status.value?.ok || !status.value?.version || !status.value?.serverVersion) return false
  return versionCmp(status.value.version, status.value.serverVersion) > 0
})


const refreshBackup = async () => {
  if (!agentEnabled.value) {
    backup.value = { ok: false }
    return
  }
  if (!status.value?.ok) {
    backup.value = { ok: true, running: false }
    return
  }
  backupLoading.value = true
  backup.value = await agentBackupStatusAPI()
  backupLoading.value = false
}

const runBackup = async () => {
  if (!agentEnabled.value || !status.value?.ok) return
  backupLoading.value = true
  await agentBackupStartAPI()
  await refreshBackup()
  backupLoading.value = false
}

const loadBackupLog = async () => {
  if (!agentEnabled.value || !status.value?.ok) return
  const res = await agentBackupLogAPI(200)
  if (res?.ok && res?.contentB64) {
    try {
      backupLog.value = atob(res.contentB64)
    } catch {
      backupLog.value = ''
    }
  } else {
    backupLog.value = res?.error ? String(res.error) : ''
  }
}

const onBackupLogToggle = async (e: any) => {
  if (e?.target?.open) {
    await loadBackupLog()
  }
}

const refresh = async () => {
  if (!agentEnabled.value) {
    status.value = { ok: false }
    return
  }
  status.value = await agentStatusAPI()
  await refreshBackup()
}

onMounted(() => {
  refresh()
})
</script>
