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

        <div class="mt-4 rounded-2xl border border-base-300 bg-base-200/40 p-3">
          <div class="flex flex-col gap-3 lg:flex-row lg:items-start lg:justify-between">
            <div class="space-y-1">
              <div class="text-sm font-semibold">{{ $t('subscriptionsProvidersInventoryTitle') }}</div>
              <div class="text-xs text-base-content/60">{{ $t('subscriptionsProvidersCardsHint') }}</div>
            </div>
            <label class="label cursor-pointer justify-start gap-2 rounded-xl border border-base-300 bg-base-100 px-3 py-2 lg:self-start">
              <span class="label-text text-xs">{{ $t('subscriptionsAvailableOnlyFilter') }}</span>
              <input v-model="providerQuickAvailableOnly" type="checkbox" class="toggle toggle-xs" />
            </label>
          </div>

          <div class="mt-3 flex flex-wrap gap-2">
            <button
              v-for="provider in inventoryProviders"
              :key="provider.name"
              type="button"
              class="btn h-auto min-h-0 gap-2 rounded-2xl px-3 py-2 normal-case shadow-sm"
              :class="providerChipClass(provider)"
              @click="handleProviderChipClick(provider.name)"
            >
              <span class="max-w-[11rem] truncate font-medium">{{ provider.name }}</span>
              <span class="badge badge-xs badge-neutral badge-outline">{{ provider.nodeCount }} {{ $t('subscriptionsNodesShort') }}</span>
              <span class="badge badge-xs" :class="provider.health.badgeCls">{{ $t(provider.health.labelKey) }}</span>
            </button>
            <span v-if="!inventoryProviders.length" class="text-sm text-base-content/60">{{ $t('subscriptionsNoProvidersFiltered') }}</span>
          </div>
        </div>

        <div v-if="selectionMode === 'custom'" class="mt-4 rounded-2xl border border-base-300 bg-base-200/40 p-3">
          <div class="mb-3 flex flex-wrap items-center gap-2">
            <button class="btn btn-xs" @click="selectAllProviders">{{ $t('subscriptionsSelectAll') }}</button>
            <button class="btn btn-ghost btn-xs" @click="selectAvailableProviders">{{ $t('subscriptionsSelectAvailable') }}</button>
            <button class="btn btn-ghost btn-xs" @click="clearSelectedProviders">{{ $t('clear') }}</button>
          </div>
          <div class="text-xs text-base-content/60">{{ $t('subscriptionsCustomSelectionHint') }}</div>
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
          <span
            v-for="provider in selectedProvidersMeta"
            :key="provider.name"
            class="inline-flex items-center gap-2 rounded-2xl border border-base-300 bg-base-200/40 px-3 py-2 text-sm"
          >
            <span class="font-medium">{{ provider.name }}</span>
            <span class="badge badge-xs badge-neutral badge-outline">{{ provider.nodeCount }} {{ $t('subscriptionsNodesShort') }}</span>
            <span class="badge badge-xs" :class="provider.health.badgeCls">{{ $t(provider.health.labelKey) }}</span>
          </span>
          <span v-if="!selectedProvidersMeta.length" class="text-sm text-base-content/60">{{ $t('subscriptionsNoProviders') }}</span>
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
const providerQuickAvailableOnly = useStorage('config/subscriptions-provider-quick-available-only-v1', false)

const providers = computed(() => (proxyProviederList.value || []).filter((p: any) => String(p?.name || '') !== 'default'))
const providerNames = computed(() => providers.value.map((p: any) => String(p.name || '')).filter(Boolean))

const providerMetaList = computed(() => {
  return providers.value.map((provider: any) => {
    const health = getProviderHealth(provider, agentProviderByName.value?.[provider.name], {
      sslRefreshing: agentProvidersSslRefreshing.value || agentProvidersSslRefreshPending.value,
    })
    const nodeCount = Array.isArray(provider?.proxies) ? provider.proxies.length : 0
    const available = nodeCount > 0 && health.status !== 'offline'
    return {
      provider,
      name: String(provider?.name || ''),
      nodeCount,
      available,
      health,
    }
  })
})

const inventoryProviders = computed(() => {
  return providerQuickAvailableOnly.value
    ? providerMetaList.value.filter((provider) => provider.available)
    : providerMetaList.value
})

const availableProviderNames = computed(() => providerMetaList.value.filter((provider) => provider.available).map((provider) => provider.name))

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

const selectedProvidersMeta = computed(() => {
  const wanted = new Set(selectedProviderNames.value)
  return providerMetaList.value.filter((provider) => wanted.has(provider.name))
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

const providerChipClass = (provider: { name: string; available: boolean; health: { status: string } }) => {
  const selected = selectedProviderNames.value.includes(provider.name)
  return [
    selected ? 'btn-primary text-primary-content' : 'btn-ghost border-base-300 bg-base-100',
    !provider.available && !selected ? 'opacity-80' : '',
    provider.health.status === 'offline' && !selected ? 'border-error/30' : '',
  ]
}

const handleProviderChipClick = (name: string) => {
  if (!name) return
  if (selectionMode.value !== 'custom') {
    selectionMode.value = 'custom'
    customProviderNames.value = [...selectedProviderNames.value]
  }
  const next = new Set(customProviderNames.value || [])
  if (next.has(name)) next.delete(name)
  else next.add(name)
  customProviderNames.value = providerNames.value.filter((providerName) => next.has(providerName))
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
