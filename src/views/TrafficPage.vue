<template>
  <div class="flex h-full flex-col gap-3 overflow-x-hidden overflow-y-auto p-2">
    <div class="card gap-3 p-3">
      <div class="flex flex-col gap-3 xl:flex-row xl:items-start xl:justify-between">
        <div>
          <div class="font-semibold">{{ t('trafficWorkspaceTitle') }}</div>
          <div class="text-sm opacity-70">{{ t('trafficWorkspaceTip') }}</div>
        </div>

        <div class="flex flex-wrap gap-2">
          <button
            type="button"
            class="btn btn-sm"
            :class="activeView === 'devices' ? '' : 'btn-ghost'"
            @click="setView('devices')"
          >
            {{ t('trafficWorkspaceDevicesTitle') }}
          </button>
          <button
            type="button"
            class="btn btn-sm"
            :class="activeView === 'users' ? '' : 'btn-ghost'"
            @click="setView('users')"
          >
            {{ t('trafficWorkspaceUsersTitle') }}
          </button>
        </div>
      </div>

      <div class="overflow-x-auto">
        <div class="tabs tabs-boxed inline-flex min-w-max gap-1 bg-base-200/60 p-1">
          <button
            v-for="view in trafficViews"
            :key="view.id"
            type="button"
            class="tab whitespace-nowrap border-0"
            :class="activeView === view.id ? 'tab-active !bg-base-100 shadow-sm' : 'opacity-80 hover:opacity-100'"
            @click="setView(view.id)"
          >
            {{ t(view.labelKey) }}
          </button>
        </div>
      </div>

      <div class="grid grid-cols-1 gap-2 xl:grid-cols-[minmax(0,1fr),22rem]">
        <div class="rounded-lg border border-base-content/10 bg-base-100/70 p-3">
          <div class="text-xs font-semibold uppercase tracking-[0.12em] opacity-55">{{ t(activeViewMeta.labelKey) }}</div>
          <div class="mt-1 text-sm opacity-70">{{ t(activeViewMeta.tipKey) }}</div>
        </div>
        <div class="rounded-lg border border-base-content/10 bg-base-100/70 p-3 text-sm opacity-75">
          <div class="font-semibold">{{ t('trafficWorkspaceHowToTitle') }}</div>
          <div class="mt-1">{{ t('trafficWorkspaceHowToTip') }}</div>
        </div>
      </div>
    </div>

    <section v-if="activeView === 'devices'" class="grid grid-cols-1 gap-2 overflow-x-hidden">
      <HostQosCard />
    </section>

    <section v-else class="grid grid-cols-1 gap-2 overflow-x-hidden">
      <UserTrafficStats />
    </section>
  </div>
</template>

<script setup lang="ts">
import HostQosCard from '@/components/router/HostQosCard.vue'
import UserTrafficStats from '@/components/users/UserTrafficStats.vue'
import { ROUTE_NAME } from '@/constant'
import { i18n } from '@/i18n'
import { computed, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'

const router = useRouter()
const route = useRoute()
const t = i18n.global.t

const trafficViews = [
  { id: 'devices', labelKey: 'trafficWorkspaceDevicesTitle', tipKey: 'trafficWorkspaceDevicesTip' },
  { id: 'users', labelKey: 'trafficWorkspaceUsersTitle', tipKey: 'trafficWorkspaceUsersTip' },
] as const

type TrafficViewId = (typeof trafficViews)[number]['id']

const resolveViewId = (raw: unknown): TrafficViewId => {
  const value = String(raw || '').trim()
  return (trafficViews.find((item) => item.id === value)?.id || 'devices') as TrafficViewId
}

const activeView = computed<TrafficViewId>(() => resolveViewId(route.query.view))
const activeViewMeta = computed(() => trafficViews.find((item) => item.id === activeView.value) || trafficViews[0])

const setView = (id: TrafficViewId) => {
  if (activeView.value === id) return
  router.replace({
    name: ROUTE_NAME.traffic,
    query: {
      ...route.query,
      view: id,
    },
  })
}

watch(
  () => route.query.view,
  (value) => {
    const resolved = resolveViewId(value)
    if (String(value || '').trim() === resolved) return
    router.replace({
      name: ROUTE_NAME.traffic,
      query: {
        ...route.query,
        view: resolved,
      },
    })
  },
  { immediate: true },
)
</script>
