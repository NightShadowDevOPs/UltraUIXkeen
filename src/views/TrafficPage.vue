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
      <HostQosCard
        :focus-ip="focusIp"
        :focus-user="focusUser"
        @open-user-focus="openUserFocus"
      />
    </section>

    <section v-else class="grid grid-cols-1 gap-2 overflow-x-hidden">
      <UserTrafficStats
        :focus-user="focusUser"
        :focus-ip="focusIp"
        @open-device-focus="openDeviceFocus"
      />
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

const readQueryValue = (raw: unknown): string => String(raw || '').trim()

const activeView = computed<TrafficViewId>(() => resolveViewId(route.query.view))
const activeViewMeta = computed(() => trafficViews.find((item) => item.id === activeView.value) || trafficViews[0])
const focusUser = computed(() => readQueryValue(route.query.user))
const focusIp = computed(() => readQueryValue(route.query.ip))

const replaceTrafficQuery = (patch: Record<string, string | null | undefined>) => {
  const nextQuery = { ...route.query }
  for (const [key, value] of Object.entries(patch)) {
    const next = String(value || '').trim()
    if (next) nextQuery[key] = next
    else delete nextQuery[key]
  }
  router.replace({
    name: ROUTE_NAME.traffic,
    query: nextQuery,
  })
}

const setView = (id: TrafficViewId) => {
  if (activeView.value === id) return
  replaceTrafficQuery({ view: id })
}

const openUserFocus = (payload: { user?: string; ip?: string }) => {
  replaceTrafficQuery({
    view: 'users',
    user: payload.user,
    ip: payload.ip,
  })
}

const openDeviceFocus = (payload: { user?: string; ip?: string }) => {
  replaceTrafficQuery({
    view: 'devices',
    user: payload.user,
    ip: payload.ip,
  })
}

watch(
  () => route.query.view,
  (value) => {
    const resolved = resolveViewId(value)
    if (String(value || '').trim() === resolved) return
    replaceTrafficQuery({ view: resolved })
  },
  { immediate: true },
)
</script>
