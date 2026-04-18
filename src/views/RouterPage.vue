<template>
  <div class="flex flex-col gap-4">
    <div class="card gap-3 p-4">
      <div>
        <div class="text-2xl font-semibold">{{ $t('routerTitle') }}</div>
        <div class="text-sm opacity-70">{{ $t('routerWorkspaceTip') }}</div>
      </div>

      <div class="tabs tabs-boxed w-fit gap-1 self-start">
        <button type="button" class="tab" :class="{ 'tab-active': section === 'overview' }" @click="setSection('overview')">{{ $t('routerSectionOverviewTitle') }}</button>
        <button type="button" class="tab" :class="{ 'tab-active': section === 'backup' }" @click="setSection('backup')">{{ $t('routerSectionBackupTitle') }}</button>
        <button type="button" class="tab" :class="{ 'tab-active': section === 'traffic' }" @click="setSection('traffic')">{{ $t('routerSectionTrafficTitle') }}</button>
        <button type="button" class="tab" :class="{ 'tab-active': section === 'network' }" @click="setSection('network')">{{ $t('routerSectionNetworkTitle') }}</button>
      </div>
    </div>

    <template v-if="section === 'overview'">
      <SystemCard />

      <div class="grid grid-cols-1 gap-4 xl:grid-cols-3">
        <div class="card gap-3 p-4">
          <div>
            <div class="text-xs font-semibold uppercase tracking-[0.2em] opacity-60">{{ $t('routerSectionBackupTitle') }}</div>
            <div class="mt-2 text-lg font-semibold">{{ $t('routerOverviewBackupMovedTitle') }}</div>
            <div class="mt-1 text-sm opacity-70">{{ $t('routerOverviewBackupMovedTip') }}</div>
          </div>
          <div class="mt-auto flex items-center justify-between gap-3">
            <span class="badge badge-outline">create / restore / verify</span>
            <button type="button" class="btn btn-sm" @click="setSection('backup')">{{ $t('open') }}</button>
          </div>
        </div>

        <div class="card gap-3 p-4">
          <div>
            <div class="text-xs font-semibold uppercase tracking-[0.2em] opacity-60">{{ $t('routerSectionTrafficTitle') }}</div>
            <div class="mt-2 text-lg font-semibold">{{ $t('routerSectionTrafficTitle') }}</div>
            <div class="mt-1 text-sm opacity-70">{{ $t('routerSectionTrafficTip') }}</div>
          </div>
          <div class="mt-auto flex items-center justify-between gap-3">
            <span class="badge badge-outline">devices / users / QoS</span>
            <button type="button" class="btn btn-sm" @click="goUsersTraffic">{{ $t('open') }}</button>
          </div>
        </div>

        <div class="card gap-3 p-4">
          <div>
            <div class="text-xs font-semibold uppercase tracking-[0.2em] opacity-60">{{ $t('routerSectionNetworkTitle') }}</div>
            <div class="mt-2 text-lg font-semibold">{{ $t('routerSectionNetworkTitle') }}</div>
            <div class="mt-1 text-sm opacity-70">{{ showIPAndConnectionInfo ? $t('routerSectionNetworkTip') : $t('routerSectionNetworkDisabled') }}</div>
          </div>
          <div class="mt-auto flex items-center justify-between gap-3">
            <span class="badge" :class="showIPAndConnectionInfo ? 'badge-success' : 'badge-ghost'">{{ showIPAndConnectionInfo ? $t('online') : $t('disabled') }}</span>
            <button type="button" class="btn btn-sm" @click="setSection('network')" :disabled="!showIPAndConnectionInfo">{{ $t('open') }}</button>
          </div>
        </div>
      </div>

      <div class="card gap-2 p-4 text-sm">
        <div class="flex flex-wrap items-center gap-2">
          <span class="badge badge-outline">backend {{ backendVersion || '—' }}</span>
          <span class="badge badge-ghost">{{ $t('routerSectionOverviewTitle') }}</span>
        </div>
        <div class="opacity-70">{{ $t('routerSectionOverviewTip') }}</div>
        <div class="text-xs opacity-60">{{ $t('routerDiagnosticsLazyHint') }}</div>
      </div>
    </template>

    <template v-else-if="section === 'backup'">
      <div class="card gap-3 p-4">
        <div class="text-xs font-semibold uppercase tracking-[0.2em] opacity-60">{{ $t('routerSectionBackupTitle') }}</div>
        <div class="text-lg font-semibold">{{ $t('routerBackupWorkspaceTitle') }}</div>
        <div class="text-sm opacity-70">{{ $t('routerSectionBackupTip') }}</div>
      </div>
      <AgentCard />
    </template>

    <template v-else-if="section === 'traffic'">
      <div class="card gap-3 p-4">
        <div class="text-xs font-semibold uppercase tracking-[0.2em] opacity-60">{{ $t('routerSectionTrafficTitle') }}</div>
        <div class="text-lg font-semibold">{{ $t('routerSectionTrafficTitle') }}</div>
        <div class="text-sm opacity-70">{{ $t('routerSectionTrafficTip') }}</div>
        <div>
          <button type="button" class="btn btn-sm" @click="goUsersTraffic">{{ $t('open') }}</button>
        </div>
      </div>
    </template>

    <template v-else>
      <div class="card gap-3 p-4">
        <div class="text-xs font-semibold uppercase tracking-[0.2em] opacity-60">{{ $t('routerSectionNetworkTitle') }}</div>
        <div class="text-lg font-semibold">{{ $t('routerSectionNetworkTitle') }}</div>
        <div class="text-sm opacity-70">{{ showIPAndConnectionInfo ? $t('routerSectionNetworkTip') : $t('routerSectionNetworkDisabled') }}</div>
      </div>
      <ConnectionInfoCard v-if="showIPAndConnectionInfo" />
    </template>
  </div>
</template>

<script setup lang="ts">
import AgentCard from '@/components/router/AgentCard.vue'
import ConnectionInfoCard from '@/components/router/ConnectionInfoCard.vue'
import SystemCard from '@/components/router/SystemCard.vue'
import { version as backendVersion } from '@/api'
import { useUISettings } from '@/composables/useUISettings'
import { computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'

const route = useRoute()
const router = useRouter()
const { uiSettings } = useUISettings()

const section = computed(() => {
  const raw = Array.isArray(route.query.section) ? route.query.section[0] : route.query.section
  if (raw === 'backup' || raw === 'traffic' || raw === 'network') return raw
  return 'overview'
})

const showIPAndConnectionInfo = computed(() => uiSettings.value.showIPAndConnectionInfo !== false)

const setSection = (next: 'overview' | 'backup' | 'traffic' | 'network') => {
  router.replace({ query: { ...route.query, section: next === 'overview' ? undefined : next } })
}

const goUsersTraffic = () => {
  router.push({ name: 'Traffic', query: { view: 'users' } })
}
</script>
