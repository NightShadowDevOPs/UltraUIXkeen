<template>
  <div class="bg-base-200/50 home-page flex size-full">
    <SideBar v-if="!isMiddleScreen" />
    <RouterView v-slot="{ Component, route }">
      <div
        class="flex flex-1 flex-col overflow-hidden"
        ref="swiperRef"
      >
        <PageTitleBar :route-name="(route.name as string)" />

        <Transition name="fade">
          <div
            v-if="showUiBuildBanner"
            class="mx-4 mt-3 rounded-2xl border border-warning/40 bg-warning/15 p-3 shadow-sm"
          >
            <div class="flex flex-col gap-3 lg:flex-row lg:items-start">
              <div class="flex items-start gap-3 min-w-0 flex-1">
                <div class="rounded-xl bg-warning/20 p-2 text-warning">
                  <ExclamationTriangleIcon class="h-5 w-5" />
                </div>
                <div class="min-w-0 flex-1">
                  <div class="flex flex-wrap items-center gap-2">
                    <div class="font-semibold">{{ $t('uiBuildBannerTitle') }}</div>
                    <span class="badge badge-warning badge-sm">UI</span>
                  </div>
                  <div class="mt-1 text-sm opacity-80">{{ $t('uiBuildBannerHint') }}</div>

                  <div class="mt-3 grid grid-cols-1 gap-2 text-xs xl:grid-cols-2">
                    <div class="rounded-xl bg-base-100/60 px-3 py-2">
                      <div class="opacity-60">{{ $t('uiLoadedBundle') }}</div>
                      <div class="mt-1 break-all font-mono text-[11px] text-base-content/90">{{ currentBundleTag }}</div>
                    </div>
                    <div class="rounded-xl bg-base-100/60 px-3 py-2">
                      <div class="opacity-60">{{ $t('uiOnlineBundle') }}</div>
                      <div class="mt-1 break-all font-mono text-[11px] text-base-content/90">{{ onlineBundleTag }}</div>
                    </div>
                  </div>
                </div>
              </div>

              <div class="flex flex-wrap items-center gap-2 lg:justify-end">
                <button
                  class="btn btn-warning btn-sm"
                  @click="hardRefreshUiCache"
                >
                  {{ $t('uiHardRefresh') }}
                </button>
                <button
                  class="btn btn-ghost btn-sm"
                  @click="dismissUiBuildBanner"
                >
                  {{ $t('close') }}
                </button>
              </div>
            </div>
          </div>
        </Transition>

        <div
          v-if="ctrlsMap[route.name as string]"
          class="bg-base-100 ctrls-bar w-full"
          ref="ctrlsBarRef"
        >
          <component
            :is="ctrlsMap[route.name as string]"
            :is-large-ctrls-bar="isLargeCtrlsBar"
          />
        </div>

        <div class="relative h-0 flex-1">
          <div class="absolute flex h-full w-full flex-col overflow-y-auto">
            <Transition
              :name="(route.meta.transition as string) || 'fade'"
              v-if="isMiddleScreen"
            >
              <Component :is="Component" />
            </Transition>
            <Component
              v-else
              :is="Component"
            />
          </div>
        </div>
        <template v-if="isMiddleScreen">
          <div
            class="nav-bar shrink-0"
            :style="styleForSafeArea"
          />
          <div
            class="dock dock-sm bg-base-200 z-30"
            :style="styleForSafeArea"
          >
            <button
              v-for="r in renderRoutes"
              :key="r"
              @click="router.push({ name: r })"
              :class="r === route.name && 'dock-active'"
            >
              <component
                :is="ROUTE_ICON_MAP[r]"
                class="size-5"
              />
              <span class="dock-label">
                {{ $t(r) }}
              </span>
            </button>
          </div>
        </template>
      </div>
    </RouterView>

    <DialogWrapper v-model="autoSwitchBackendDialog">
      <h3 class="text-lg font-bold">{{ $t('currentBackendUnavailable') }}</h3>
      <div class="flex justify-end gap-2">
        <button
          class="btn btn-sm"
          @click="autoSwitchBackendDialog = false"
        >
          {{ $t('cancel') }}
        </button>
        <button
          class="btn btn-primary btn-sm"
          @click="autoSwitchBackend"
        >
          {{ $t('confirm') }}
        </button>
      </div>
    </DialogWrapper>

    <!-- Global search / command palette (Ctrl+K / Cmd+K) -->
    <GlobalSearchModal />
  </div>
</template>

<script setup lang="ts">
import { isBackendAvailable } from '@/api'
import DialogWrapper from '@/components/common/DialogWrapper.vue'
import GlobalSearchModal from '@/components/common/GlobalSearchModal.vue'
import PageTitleBar from '@/components/common/PageTitleBar.vue'
import ConnectionCtrl from '@/components/sidebar/ConnectionCtrl.tsx'
import LogsCtrl from '@/components/sidebar/LogsCtrl.tsx'
import ProxiesCtrl from '@/components/sidebar/ProxiesCtrl.tsx'
import RulesCtrl from '@/components/sidebar/RulesCtrl.tsx'
import SideBar from '@/components/sidebar/SideBar.vue'
import { useSettings } from '@/composables/settings'
import { useUiBuild } from '@/composables/uiBuild'
import { initUserTrafficRecorder } from '@/composables/userTraffic'
import { initUserLimitsEnforcer } from '@/composables/userLimits'
import { useSwipeRouter } from '@/composables/swipe'
import { PROXY_TAB_TYPE, ROUTE_ICON_MAP, ROUTE_NAME, RULE_TAB_TYPE } from '@/constant'
import { renderRoutes } from '@/helper'
import { showNotification } from '@/helper/notification'
import { getLabelFromBackend, isMiddleScreen } from '@/helper/utils'
import { fetchConfigs } from '@/store/config'
import { initConnections } from '@/store/connections'
import { initLogs } from '@/store/logs'
import { initSatistic } from '@/store/overview'
import { fetchProxies, fetchProxyProvidersOnly, proxiesTabShow } from '@/store/proxies'
import { fetchRules, rulesTabShow } from '@/store/rules'
import { activeBackend, activeUuid, backendList } from '@/store/setup'
import { agentStatusAPI } from '@/api/agent'
import { agentEnabled, agentEnforceBandwidth, bootstrapRouterAgentForLan } from '@/store/agent'
import type { Backend } from '@/types'
import { useDocumentVisibility, useElementSize, useSessionStorage } from '@vueuse/core'
import { computed, onMounted, onUnmounted, ref, watch, type Component } from 'vue'
import { RouterView, useRouter } from 'vue-router'
import { globalSearchOpen } from '@/store/globalSearch'
import { ExclamationTriangleIcon } from '@heroicons/vue/24/outline'

const ctrlsMap: Record<string, Component> = {
  [ROUTE_NAME.connections]: ConnectionCtrl,
  [ROUTE_NAME.logs]: LogsCtrl,
  [ROUTE_NAME.proxies]: ProxiesCtrl,
  [ROUTE_NAME.proxyProviders]: ProxiesCtrl,
  [ROUTE_NAME.rules]: RulesCtrl,
}

const styleForSafeArea = {
  height: 'calc(var(--spacing) * 14 + env(safe-area-inset-bottom))',
  'padding-bottom': 'env(safe-area-inset-bottom)',
}

const { isFreshUiBuildAvailable, currentBundleTag, onlineBundleTag, hardRefreshUiCache } = useUiBuild()
const dismissedUiBuildBannerTag = useSessionStorage('cache/ui-build-banner-dismissed-tag', '')
const showUiBuildBanner = computed(() => {
  return isFreshUiBuildAvailable.value && dismissedUiBuildBannerTag.value !== onlineBundleTag.value
})
const dismissUiBuildBanner = () => {
  dismissedUiBuildBannerTag.value = onlineBundleTag.value || currentBundleTag.value || String(Date.now())
}

const router = useRouter()
const { swiperRef } = useSwipeRouter()

const ensureRouterAgentOnline = async () => {
  bootstrapRouterAgentForLan()
  try {
    const st = await agentStatusAPI()
    if (!st?.ok) return false
    if (!agentEnabled.value) agentEnabled.value = true
    if (!agentEnforceBandwidth.value) agentEnforceBandwidth.value = true
    return true
  } catch {
    return false
  }
}

// Global search keyboard shortcut (Ctrl+K / Cmd+K)
const globalSearchKeydown = (e: KeyboardEvent) => {
  if (e.key.toLowerCase() !== 'k') return
  if (!(e.ctrlKey || e.metaKey)) return
  // Avoid hijacking inside text inputs.
  const t = e.target as any
  const tag = String(t?.tagName || '').toLowerCase()
  if (tag === 'input' || tag === 'textarea' || t?.isContentEditable) return
  e.preventDefault()
  globalSearchOpen.value = true
}

onMounted(() => {
  document.addEventListener('keydown', globalSearchKeydown)
})

onUnmounted(() => {
  document.removeEventListener('keydown', globalSearchKeydown)
})

const ctrlsBarRef = ref<HTMLDivElement>()
const { width: ctrlsBarWidth } = useElementSize(ctrlsBarRef)
const isLargeCtrlsBar = computed(() => {
  return ctrlsBarWidth.value > 720
})

watch(
  activeUuid,
  () => {
    if (!activeUuid.value) return
    rulesTabShow.value = RULE_TAB_TYPE.RULES
    proxiesTabShow.value = PROXY_TAB_TYPE.PROXIES
    fetchConfigs()
    fetchProxies()
    fetchRules()
    initConnections()
    initUserTrafficRecorder()
    initUserLimitsEnforcer()
    initLogs()
    initSatistic()
    void ensureRouterAgentOnline()
  },
  {
    immediate: true,
  },
)

const autoSwitchBackendDialog = ref(false)

const autoSwitchBackend = async () => {
  const otherEnds = backendList.value.filter((end) => end.uuid !== activeUuid.value)

  autoSwitchBackendDialog.value = false
  const avaliable = await Promise.race<Backend>(
    otherEnds.map((end) => {
      return new Promise((resolve, reject) => {
        setTimeout(() => {
          reject()
        }, 10000)
        isBackendAvailable(end).then((res) => {
          if (res) {
            resolve(end)
          }
        })
      })
    }),
  )

  if (avaliable) {
    activeUuid.value = avaliable.uuid
    showNotification({
      content: 'backendSwitchTo',
      params: {
        backend: getLabelFromBackend(avaliable),
      },
    })
  }
}

const documentVisible = useDocumentVisibility()

watch(
  documentVisible,
  async () => {
    if (
      !activeBackend.value ||
      backendList.value.length < 2 ||
      documentVisible.value !== 'visible'
    ) {
      return
    }
    try {
      const activeBackendUuid = activeBackend.value.uuid
      const isAvailable = await isBackendAvailable(activeBackend.value)

      if (activeBackendUuid !== activeUuid.value) {
        return
      }

      if (!isAvailable) {
        autoSwitchBackendDialog.value = true
      }
    } catch {
      autoSwitchBackendDialog.value = true
    }
  },
  {
    immediate: true,
  },
)

let lastVisibleProxiesRefresh = 0

watch(documentVisible, () => {
  if (documentVisible.value !== 'visible') return

  // Avoid aggressive full refresh when switching browser tabs.
  // The Providers tab should refresh "softly" (only providers), without remounting the whole page.
  const now = Date.now()
  if (now - lastVisibleProxiesRefresh < 4000) return
  lastVisibleProxiesRefresh = now

  // Only refresh proxies data when user is on the Proxies page.
  const routeName = router.currentRoute.value?.name
  if (routeName !== ROUTE_NAME.proxies && routeName !== ROUTE_NAME.proxyProviders) return

  if (proxiesTabShow.value === PROXY_TAB_TYPE.PROVIDER) {
    fetchProxyProvidersOnly()
  } else {
    fetchProxies()
  }
})

const { checkUIUpdate } = useSettings()

checkUIUpdate()
</script>
