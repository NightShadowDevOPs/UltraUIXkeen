<template>
  <div class="flex h-full flex-col gap-2 overflow-x-hidden overflow-y-auto p-2">
    <div class="card gap-2 p-3">
      <div class="flex items-center justify-between gap-2">
        <div class="font-semibold">{{ $t('quickActions') }}</div>
      </div>

      <div class="flex flex-wrap items-center gap-2">
        <button type="button" class="btn btn-sm" @click="applyEnforcement" :disabled="busy">
          {{ $t('applyEnforcementNow') }}
        </button>
        <button type="button" class="btn btn-sm" @click="refreshSsl" :disabled="busy || !agentEnabled">
          {{ $t('refreshProvidersSsl') }}
        </button>
      </div>

      <div class="text-xs opacity-70">
        <div>• {{ $t('applyEnforcementTip') }}</div>
        <div>• {{ $t('refreshProvidersSslTip') }}</div>
      </div>
    </div>

    <div class="card gap-2 p-3">
      <div class="flex items-center justify-between gap-2">
        <div class="font-semibold">{{ $t('operationsHistory') }}</div>
        <button type="button" class="btn btn-sm btn-ghost" @click="clearJobs" :disabled="!jobs.length">
          {{ $t('clear') }}
        </button>
      </div>

      <div v-if="!jobs.length" class="text-sm opacity-70">
        {{ $t('noOperationsYet') }}
      </div>

      <div v-else class="overflow-x-auto">
        <table class="table table-sm">
          <thead>
            <tr>
              <th style="width: 140px">{{ $t('time') }}</th>
              <th>{{ $t('operation') }}</th>
              <th style="width: 120px">{{ $t('status') }}</th>
              <th style="width: 110px">{{ $t('duration') }}</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="j in jobs" :key="j.id">
              <td class="font-mono text-xs">{{ fmtTime(j.startedAt) }}</td>
              <td>
                <div class="text-sm">{{ j.title }}</div>
                <div v-if="j.error" class="text-xs text-error">{{ j.error }}</div>
                <div v-else-if="j.meta && Object.keys(j.meta).length" class="text-[11px] opacity-70">
                  <span v-for="(v, k) in j.meta" :key="k" class="mr-2">
                    <span class="opacity-60">{{ k }}:</span>
                    <span class="font-mono">{{ v }}</span>
                  </span>
                </div>
              </td>
              <td>
                <span v-if="j.endedAt && j.ok" class="badge badge-success">{{ $t('done') }}</span>
                <span v-else-if="j.endedAt && j.ok === false" class="badge badge-error">{{ $t('failed') }}</span>
                <span v-else class="badge badge-warning">{{ $t('running') }}</span>
              </td>
              <td class="font-mono text-xs">
                {{ j.endedAt ? fmtMs(j.endedAt - j.startedAt) : '—' }}
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <div class="flex-1"></div>

    <div class="card items-center justify-center gap-2 p-2 sm:flex-row">
      {{ getLabelFromBackend(activeBackend!) }} :
      <BackendVersion />
    </div>
  </div>
</template>

<script setup lang="ts">
import { agentMihomoProvidersAPI } from '@/api/agent'
import BackendVersion from '@/components/common/BackendVersion.vue'
import { getLabelFromBackend } from '@/helper/utils'
import { showNotification } from '@/helper/notification'
import { activeBackend } from '@/store/setup'
import { agentEnabled } from '@/store/agent'
import { clearJobs, finishJob, jobHistory, startJob } from '@/store/jobs'
import { applyUserEnforcementNow } from '@/composables/userLimits'
import dayjs from 'dayjs'
import { computed, ref } from 'vue'

const busy = ref(false)
const jobs = computed(() => jobHistory.value || [])

const fmtTime = (ts: number) => dayjs(ts).format('HH:mm:ss')
const fmtMs = (ms: number) => {
  if (!Number.isFinite(ms)) return '—'
  if (ms < 1000) return `${ms}ms`
  return `${(ms / 1000).toFixed(1)}s`
}

const applyEnforcement = async () => {
  if (busy.value) return
  busy.value = true
  try {
    const id = startJob('Apply limits & blocks')
    try {
      await applyUserEnforcementNow()
      finishJob(id, { ok: true })
      showNotification({ content: 'operationDone', type: 'alert-success', timeout: 1600 })
    } catch (e: any) {
      finishJob(id, { ok: false, error: e?.message || 'failed' })
      showNotification({ content: 'operationFailed', type: 'alert-error', timeout: 2200 })
    }
  } finally {
    busy.value = false
  }
}

const refreshSsl = async () => {
  if (busy.value) return
  if (!agentEnabled.value) {
    showNotification({ content: 'agentDisabled', type: 'alert-warning', timeout: 2000 })
    return
  }
  busy.value = true
  try {
    const id = startJob('Refresh providers SSL')
    try {
      const r: any = await agentMihomoProvidersAPI(true)
      if (!r?.ok) {
        finishJob(id, { ok: false, error: r?.error || 'failed' })
        showNotification({ content: 'operationFailed', type: 'alert-error', timeout: 2200 })
        return
      }
      const n = Array.isArray(r?.providers) ? r.providers.length : 0
      finishJob(id, { ok: true, meta: { providers: n } })
      showNotification({ content: 'sslRefreshed', type: 'alert-success', timeout: 1600 })
    } catch (e: any) {
      finishJob(id, { ok: false, error: e?.message || 'failed' })
      showNotification({ content: 'operationFailed', type: 'alert-error', timeout: 2200 })
    }
  } finally {
    busy.value = false
  }
}
</script>
