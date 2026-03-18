<template>
  <div class="page px-4 pb-6 pt-4 lg:px-6">
    <div class="mx-auto flex max-w-7xl flex-col gap-4">
      <div class="rounded-2xl border border-base-300 bg-base-100 p-4 shadow-sm">
        <div class="flex flex-col gap-3 lg:flex-row lg:items-start lg:justify-between">
          <div class="space-y-2">
            <h2 class="text-xl font-semibold">{{ $t('subscriptionsTitle') }}</h2>
            <p class="text-sm text-base-content/70">
              {{ $t('subscriptionsDesc') }}
            </p>
            <div class="badge badge-info badge-outline gap-2">
              <span>router-agent</span>
              <span>{{ $t('subscriptionsDirectNote') }}</span>
            </div>
          </div>
          <div class="grid gap-2 sm:grid-cols-2 lg:w-[28rem]">
            <label class="form-control">
              <div class="label py-1">
                <span class="label-text text-xs text-base-content/70">{{ $t('subscriptionsName') }}</span>
              </div>
              <input v-model.trim="bundleName" class="input input-bordered input-sm" :placeholder="$t('subscriptionsNamePlaceholder')" />
            </label>
            <label class="form-control">
              <div class="label py-1">
                <span class="label-text text-xs text-base-content/70">{{ $t('subscriptionsMode') }}</span>
              </div>
              <select v-model="selectionMode" class="select select-bordered select-sm">
                <option value="all">{{ $t('subscriptionsModeAll') }}</option>
                <option value="available">{{ $t('subscriptionsModeAvailable') }}</option>
                <option value="custom">{{ $t('subscriptionsModeCustom') }}</option>
              </select>
            </label>
          </div>
        </div>

        <div class="mt-4 flex flex-wrap items-center gap-2 text-xs text-base-content/70">
          <span class="badge badge-neutral badge-outline">{{ $t('subscriptionsProvidersSelected') }}: {{ selectedProviderNames.length }}</span>
          <span class="badge badge-neutral badge-outline">{{ $t('subscriptionsProvidersTotal') }}: {{ providers.length }}</span>
          <button class="btn btn-ghost btn-xs" @click="refreshProviders">{{ $t('refresh') }}</button>
        </div>
        <div class="mt-2 text-xs text-base-content/60">{{ $t('subscriptionsProvidersHint') }}</div>

        <div v-if="selectionMode === 'custom'" class="mt-4 rounded-2xl border border-base-300 bg-base-200/40 p-3">
          <div class="mb-3 flex flex-wrap items-center gap-2">
            <button class="btn btn-xs" @click="selectAllProviders">{{ $t('subscriptionsSelectAll') }}</button>
            <button class="btn btn-ghost btn-xs" @click="selectAvailableProviders">{{ $t('subscriptionsSelectAvailable') }}</button>
            <button class="btn btn-ghost btn-xs" @click="clearSelectedProviders">{{ $t('clear') }}</button>
          </div>
          <div class="grid gap-2 sm:grid-cols-2 xl:grid-cols-3">
            <label
              v-for="provider in providers"
              :key="provider.name"
              class="flex cursor-pointer items-center gap-3 rounded-xl border border-base-300 bg-base-100 px-3 py-2 text-sm"
            >
              <input v-model="customProviderNames" :value="provider.name" type="checkbox" class="checkbox checkbox-sm" />
              <div class="min-w-0 flex-1">
                <div class="truncate font-medium">{{ provider.name }}</div>
                <div class="truncate text-xs text-base-content/60">{{ providerStatusLabel(provider) }}</div>
              </div>
            </label>
          </div>
        </div>
      </div>

      <div v-if="!agentReady" class="alert alert-warning shadow-sm">
        <span>{{ $t('subscriptionsAgentRequired') }}</span>
      </div>

      <div class="grid gap-4 xl:grid-cols-2">
        <section class="rounded-2xl border border-base-300 bg-base-100 p-4 shadow-sm">
          <div class="mb-4 flex flex-col gap-3 sm:flex-row sm:items-start sm:justify-between">
            <div class="min-w-0 flex-1">
              <h3 class="text-lg font-semibold">{{ $t('subscriptionsMihomoTitle') }}</h3>
              <p class="mt-1 text-sm text-base-content/70">{{ $t('subscriptionsMihomoDesc') }}</p>
            </div>
            <span class="badge badge-primary badge-outline self-start whitespace-nowrap shrink-0">Mihomo / Clash</span>
          </div>

          <div class="space-y-3">
            <label class="form-control">
              <div class="label py-1">
                <span class="label-text text-xs text-base-content/70">{{ $t('subscriptionsLink') }}</span>
              </div>
              <textarea class="textarea textarea-bordered min-h-28 text-xs" :value="mihomoUrl" readonly />
            </label>
            <div class="flex flex-wrap gap-2">
              <button class="btn btn-sm" :disabled="!mihomoUrl" @click="copyText(mihomoUrl)">{{ $t('copyLink') }}</button>
              <a class="btn btn-sm btn-primary" :class="!mihomoUrl && 'btn-disabled'" :href="clashDeepLink || undefined">{{ $t('subscriptionsOpenInClash') }}</a>
            </div>
            <div class="grid gap-4 lg:grid-cols-[minmax(0,1fr)_auto] lg:items-start">
              <div class="space-y-2">
                <label class="form-control max-w-xs">
                  <div class="label py-1">
                    <span class="label-text text-xs text-base-content/70">{{ $t('subscriptionsQrMode') }}</span>
                  </div>
                  <select v-model="mihomoQrMode" class="select select-bordered select-sm">
                    <option value="url">{{ $t('subscriptionsQrModeUrl') }}</option>
                    <option value="clash">{{ $t('subscriptionsQrModeClash') }}</option>
                  </select>
                </label>
                <div class="rounded-2xl bg-base-200/40 p-3 text-xs text-base-content/70">
                  {{ $t('subscriptionsMihomoTip') }}
                </div>
              </div>
              <QrCodeSvg :text="mihomoQrText" />
            </div>
          </div>
        </section>

        <section class="rounded-2xl border border-base-300 bg-base-100 p-4 shadow-sm">
          <div class="mb-4 flex flex-col gap-3 sm:flex-row sm:items-start sm:justify-between">
            <div class="min-w-0 flex-1">
              <h3 class="text-lg font-semibold">{{ $t('subscriptionsUniversalTitle') }}</h3>
              <p class="mt-1 text-sm text-base-content/70">{{ $t('subscriptionsUniversalDesc') }}</p>
            </div>
            <span class="badge badge-secondary badge-outline self-start whitespace-nowrap shrink-0">V2Ray / Xray</span>
          </div>

          <div class="space-y-3">
            <label class="form-control">
              <div class="label py-1">
                <span class="label-text text-xs text-base-content/70">{{ $t('subscriptionsLink') }}</span>
              </div>
              <textarea class="textarea textarea-bordered min-h-28 text-xs" :value="universalUrl" readonly />
            </label>
            <div class="flex flex-wrap gap-2">
              <button class="btn btn-sm" :disabled="!universalUrl" @click="copyText(universalUrl)">{{ $t('copyLink') }}</button>
              <a class="btn btn-sm" :class="!v2rayTunDeepLink && 'btn-disabled'" :href="v2rayTunDeepLink || undefined">V2rayTun</a>
              <a class="btn btn-sm" :class="!v2rayNgDeepLink && 'btn-disabled'" :href="v2rayNgDeepLink || undefined">v2rayNG</a>
              <a class="btn btn-sm" :class="!hiddifyDeepLink && 'btn-disabled'" :href="hiddifyDeepLink || undefined">Hiddify</a>
            </div>
            <div class="grid gap-4 lg:grid-cols-[minmax(0,1fr)_auto] lg:items-start">
              <div class="space-y-2">
                <label class="form-control max-w-xs">
                  <div class="label py-1">
                    <span class="label-text text-xs text-base-content/70">{{ $t('subscriptionsQrMode') }}</span>
                  </div>
                  <select v-model="universalQrMode" class="select select-bordered select-sm">
                    <option value="url">{{ $t('subscriptionsQrModeUrl') }}</option>
                    <option value="v2raytun">V2rayTun</option>
                    <option value="v2rayng">v2rayNG</option>
                    <option value="hiddify">Hiddify</option>
                  </select>
                </label>
                <div class="rounded-2xl bg-base-200/40 p-3 text-xs text-base-content/70">
                  {{ $t('subscriptionsUniversalTip') }}
                </div>
              </div>
              <QrCodeSvg :text="universalQrText" />
            </div>
          </div>
        </section>
      </div>

      <div class="rounded-2xl border border-base-300 bg-base-100 p-4 shadow-sm">
        <h3 class="mb-3 text-lg font-semibold">{{ $t('subscriptionsSelectedProvidersTitle') }}</h3>
        <div class="flex flex-wrap gap-2">
          <span v-for="name in selectedProviderNames" :key="name" class="badge badge-neutral badge-outline">{{ name }}</span>
          <span v-if="!selectedProviderNames.length" class="text-sm text-base-content/60">{{ $t('subscriptionsNoProviders') }}</span>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import QrCodeSvg from '@/components/common/QrCodeSvg.vue'
import { ROUTE_NAME } from '@/constant'
import { getProviderHealth } from '@/helper/providerHealth'
import { showNotification } from '@/helper/notification'
import { agentToken, agentUrl } from '@/store/agent'
import {
  agentProviderByName,
  agentProvidersSslRefreshPending,
  agentProvidersSslRefreshing,
} from '@/store/providerHealth'
import { fetchProxyProvidersOnly, proxyProviederList } from '@/store/proxies'
import { useStorage } from '@vueuse/core'
import { computed, onMounted, ref } from 'vue'
import { useI18n } from 'vue-i18n'

const { t } = useI18n()
defineOptions({ name: ROUTE_NAME.subscriptions })

type SelectionMode = 'all' | 'available' | 'custom'

const bundleName = useStorage('config/subscriptions-bundle-name-v1', 'Zash Aggregated')
const selectionMode = useStorage<SelectionMode>('config/subscriptions-selection-mode-v1', 'all')
const customProviderNames = useStorage<string[]>('config/subscriptions-custom-providers-v1', [])
const mihomoQrMode = useStorage<'url' | 'clash'>('config/subscriptions-mihomo-qr-mode-v1', 'url')
const universalQrMode = useStorage<'url' | 'v2raytun' | 'v2rayng' | 'hiddify'>(
  'config/subscriptions-universal-qr-mode-v1',
  'url',
)
const busy = ref(false)

const providers = computed(() => (proxyProviederList.value || []).filter((p: any) => String(p?.name || '') !== 'default'))
const providerNames = computed(() => providers.value.map((p: any) => String(p.name || '')).filter(Boolean))

const availableProviderNames = computed(() => {
  return providers.value
    .filter((provider: any) => {
      const health = getProviderHealth(provider, agentProviderByName.value?.[provider.name], {
        sslRefreshing: agentProvidersSslRefreshing.value || agentProvidersSslRefreshPending.value,
      })
      return Array.isArray(provider?.proxies) && provider.proxies.length > 0 && health.status !== 'offline'
    })
    .map((provider: any) => String(provider.name || ''))
})

const selectedProviderNames = computed(() => {
  if (selectionMode.value === 'custom') {
    const wanted = new Set(customProviderNames.value || [])
    return providerNames.value.filter((name) => wanted.has(name))
  }
  if (selectionMode.value === 'available') {
    return availableProviderNames.value.length ? availableProviderNames.value : providerNames.value
  }
  return providerNames.value
})

const agentBase = computed(() => String(agentUrl.value || '').trim().replace(/\/+$/g, ''))
const agentReady = computed(() => !!agentBase.value)
const safeBundleName = computed(() => String(bundleName.value || '').trim() || 'Zash Aggregated')
const noProvidersSelected = computed(() => selectionMode.value === 'custom' && selectedProviderNames.value.length === 0)

const buildSubscriptionUrl = (format: 'mihomo' | 'b64' | 'plain') => {
  if (!agentBase.value || noProvidersSelected.value) return ''
  const params = new URLSearchParams({
    cmd: 'subscription',
    format,
    name: safeBundleName.value,
  })
  const token = String(agentToken.value || '').trim()
  if (token) params.set('token', token)
  if (selectedProviderNames.value.length && selectedProviderNames.value.length !== providerNames.value.length) {
    params.set('providers', selectedProviderNames.value.join(','))
  }
  return `${agentBase.value}/cgi-bin/api.sh?${params.toString()}`
}

const mihomoUrl = computed(() => buildSubscriptionUrl('mihomo'))
const universalUrl = computed(() => buildSubscriptionUrl('b64'))
const clashDeepLink = computed(() => (mihomoUrl.value ? `clash://install-config?url=${encodeURIComponent(mihomoUrl.value)}` : ''))
const v2rayTunDeepLink = computed(() => (universalUrl.value ? `v2raytun://import/${universalUrl.value}` : ''))
const v2rayNgDeepLink = computed(() => (
  universalUrl.value
    ? `v2rayng://install-config?url=${encodeURIComponent(universalUrl.value)}&name=${encodeURIComponent(safeBundleName.value)}`
    : ''
))
const hiddifyDeepLink = computed(() => (
  universalUrl.value
    ? `hiddify://install-sub?url=${encodeURIComponent(universalUrl.value)}#${encodeURIComponent(safeBundleName.value)}`
    : ''
))

const mihomoQrText = computed(() => (mihomoQrMode.value === 'clash' ? clashDeepLink.value : mihomoUrl.value))
const universalQrText = computed(() => {
  switch (universalQrMode.value) {
    case 'v2raytun':
      return v2rayTunDeepLink.value
    case 'v2rayng':
      return v2rayNgDeepLink.value
    case 'hiddify':
      return hiddifyDeepLink.value
    default:
      return universalUrl.value
  }
})

const providerStatusLabel = (provider: any) => {
  const health = getProviderHealth(provider, agentProviderByName.value?.[provider.name], {
    sslRefreshing: agentProvidersSslRefreshing.value || agentProvidersSslRefreshPending.value,
  })
  return t(health.labelKey)
}

const copyText = async (value: string) => {
  if (!value) return
  try {
    await navigator.clipboard.writeText(value)
    showNotification({ content: 'copySuccess', type: 'alert-success', timeout: 1400 })
  } catch {
    showNotification({ content: 'operationFailed', type: 'alert-error', timeout: 2200 })
  }
}

const refreshProviders = async () => {
  if (busy.value) return
  busy.value = true
  try {
    await fetchProxyProvidersOnly()
  } finally {
    busy.value = false
  }
}

const selectAllProviders = () => {
  customProviderNames.value = [...providerNames.value]
}

const selectAvailableProviders = () => {
  customProviderNames.value = [...availableProviderNames.value]
}

const clearSelectedProviders = () => {
  customProviderNames.value = []
}

onMounted(() => {
  if (!providerNames.value.length) {
    fetchProxyProvidersOnly()
  }
})
</script>
