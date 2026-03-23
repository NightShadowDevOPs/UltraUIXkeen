<template>
  <div class="flex h-full flex-col gap-2 overflow-x-hidden overflow-y-auto p-2">
    <AgentCard />
    <SystemCard />
    <div class="card gap-2 p-3">
      <div class="flex flex-wrap items-center justify-between gap-2">
        <div>
          <div class="font-semibold">{{ t('hostQosTitle') }}</div>
          <div class="text-sm opacity-70">{{ t('hostQosMovedToTrafficTip') }}</div>
        </div>
        <button type="button" class="btn btn-sm" @click="goUsersTraffic">
          {{ t('open') }} · {{ t('traffic') }}
        </button>
      </div>
    </div>
    <NetcrazeTrafficCard />
    <ChartsCard title-key="router" />
    <NetworkCard v-if="showIPAndConnectionInfo" />

    <div class="flex-1"></div>

    <div class="card items-center justify-center gap-2 p-2 sm:flex-row">
      {{ getLabelFromBackend(activeBackend!) }} :
      <BackendVersion />
    </div>
  </div>
</template>

<script setup lang="ts">
import AgentCard from '@/components/router/AgentCard.vue'
import SystemCard from '@/components/router/SystemCard.vue'
import BackendVersion from '@/components/common/BackendVersion.vue'
import ChartsCard from '@/components/overview/ChartsCard.vue'
import NetcrazeTrafficCard from '@/components/overview/NetcrazeTrafficCard.vue'
import NetworkCard from '@/components/overview/NetworkCard.vue'
import { getLabelFromBackend } from '@/helper/utils'
import { i18n } from '@/i18n'
import { ROUTE_NAME } from '@/constant'
import { showIPAndConnectionInfo } from '@/store/settings'
import { activeBackend } from '@/store/setup'
import { useRouter } from 'vue-router'

const router = useRouter()
const t = i18n.global.t
const goUsersTraffic = () => {
  router.push({ name: ROUTE_NAME.traffic })
}
</script>
