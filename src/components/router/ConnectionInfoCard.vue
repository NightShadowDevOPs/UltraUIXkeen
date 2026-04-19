<template>
  <div class="space-y-4">
    <div class="rounded-2xl border border-base-300/70 bg-base-200/40 p-4 shadow-sm backdrop-blur">
      <div class="flex flex-col gap-3 xl:flex-row xl:items-start xl:justify-between">
        <div>
          <h3 class="text-lg font-semibold text-base-content">{{ t('routerSectionNetworkTitle') }}</h3>
          <p class="mt-1 text-sm text-base-content/70">{{ t('routerSectionNetworkTip') }}</p>
        </div>
        <div class="flex flex-wrap gap-2">
          <button class="btn btn-sm btn-outline" type="button" @click="goToRoute(ROUTE_NAME.TRAFFIC)">
            {{ t('routerNetworkOpenTraffic') }}
          </button>
          <button class="btn btn-sm btn-outline" type="button" @click="goToRoute(ROUTE_NAME.PROXY_PROVIDER)">
            {{ t('routerNetworkOpenProviders') }}
          </button>
        </div>
      </div>

      <div class="mt-4 grid gap-3 md:grid-cols-3">
        <div class="rounded-xl border border-base-300/70 bg-base-100/70 p-3">
          <div class="text-xs font-semibold uppercase tracking-[0.22em] text-base-content/45">
            {{ t('routerNetworkWorkspacePublicIp') }}
          </div>
          <div class="mt-2 flex items-center gap-2">
            <span class="badge badge-outline badge-success">{{ publicIpModeLabel }}</span>
            <span class="text-xs text-base-content/60">{{ publicIpAutoLabel }}</span>
          </div>
        </div>

        <div class="rounded-xl border border-base-300/70 bg-base-100/70 p-3">
          <div class="text-xs font-semibold uppercase tracking-[0.22em] text-base-content/45">
            {{ t('routerNetworkWorkspaceConnection') }}
          </div>
          <div class="mt-2 flex items-center gap-2">
            <span class="badge badge-outline badge-info">{{ connectionModeLabel }}</span>
            <span class="text-xs text-base-content/60">{{ connectionAutoLabel }}</span>
          </div>
        </div>

        <div class="rounded-xl border border-base-300/70 bg-base-100/70 p-3">
          <div class="text-xs font-semibold uppercase tracking-[0.22em] text-base-content/45">
            {{ t('routerNetworkWorkspaceTarget') }}
          </div>
          <div class="mt-2 text-sm text-base-content/80">{{ pingTargetLabel }}</div>
        </div>
      </div>

      <p class="mt-3 text-xs text-base-content/55">{{ t('routerNetworkWorkspaceHint') }}</p>
    </div>

    <div class="grid grid-cols-1 gap-4 xl:grid-cols-2">
      <div class="card border border-base-300/60 bg-base-100/60 shadow-sm">
        <div class="card-body gap-3">
          <div>
            <div class="text-xs font-semibold uppercase tracking-[0.2em] opacity-60">IP</div>
            <div class="mt-1 text-lg font-semibold">{{ $t('showIPAndConnectionInfo') }}</div>
          </div>
          <IPCheck />
        </div>
      </div>

      <div class="card border border-base-300/60 bg-base-100/60 shadow-sm">
        <div class="card-body gap-3">
          <div>
            <div class="text-xs font-semibold uppercase tracking-[0.2em] opacity-60">Ping</div>
            <div class="mt-1 text-lg font-semibold">{{ $t('connections') }}</div>
          </div>
          <ConnectionStatus />
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { useRouter } from 'vue-router'
import { useI18n } from 'vue-i18n'
import ConnectionStatus from '@/components/overview/ConnectionStatus.vue'
import IPCheck from '@/components/overview/IPCheck.vue'
import { ROUTE_NAME } from '@/constant'
import { autoConnectionCheck, autoIPCheck, customPingTarget, showIPAndConnectionInfo } from '@/store/settings'

const { t } = useI18n()
const router = useRouter()

const publicIpModeLabel = computed(() => (
  showIPAndConnectionInfo.value ? t('routerNetworkStateEnabled') : t('routerNetworkStateHidden')
))

const publicIpAutoLabel = computed(() => (
  autoIPCheck.value ? t('routerNetworkAutoEnabled') : t('routerNetworkAutoManual')
))

const connectionModeLabel = computed(() => (
  showIPAndConnectionInfo.value ? t('routerNetworkStateEnabled') : t('routerNetworkStateHidden')
))

const connectionAutoLabel = computed(() => (
  autoConnectionCheck.value ? t('routerNetworkAutoEnabled') : t('routerNetworkAutoManual')
))

const pingTargetLabel = computed(() => customPingTarget.value?.trim() || t('routerNetworkTargetDefault'))

function goToRoute(name: string) {
  router.push({ name })
}
</script>
