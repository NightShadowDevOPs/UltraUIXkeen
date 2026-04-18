<template>
  <div class="bg-base-100 border-b border-base-content/10 px-3 py-2">
    <div class="flex items-center gap-2">
      <component
        v-if="icon"
        :is="icon"
        class="h-5 w-5 opacity-80"
      />
      <div class="min-w-0">
        <div class="truncate text-sm font-semibold">
          {{ title }}
        </div>
      </div>

      <div class="ml-auto flex items-center gap-2">
        <button
          type="button"
          class="btn btn-ghost btn-xs"
          :title="$t('globalSearch')"
          @click="openGlobalSearch"
        >
          <MagnifyingGlassIcon class="h-4 w-4" />
          <span class="hidden md:inline">{{ $t('globalSearch') }}</span>
          <span class="hidden md:inline text-[10px] opacity-60">Ctrl+K</span>
        </button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ROUTE_ICON_MAP } from '@/constant'
import { globalSearchOpen } from '@/store/globalSearch'
import { MagnifyingGlassIcon } from '@heroicons/vue/24/outline'
import { computed } from 'vue'
import { useI18n } from 'vue-i18n'

const props = defineProps<{
  routeName: string | null | undefined
  route?: { query?: Record<string, unknown> } | null | undefined
}>()
const { t } = useI18n()

const titleKey = computed(() => {
  const n = String(props.routeName || '').trim()
  const query = props.route?.query || {}

  if (n === 'router') {
    const rawSection = Array.isArray(query.section) ? query.section[0] : query.section
    if (rawSection === 'backup') return 'routerBackup'
    if (rawSection === 'traffic') return 'routerTraffic'
    if (rawSection === 'network') return 'routerNetwork'
    return 'routerOverview'
  }

  if (n === 'traffic') {
    const rawView = Array.isArray(query.view) ? query.view[0] : query.view
    if (rawView === 'users') return 'trafficUsers'
    if (rawView === 'devices') return 'trafficDevices'
  }

  return n
})

const title = computed(() => {
  const key = String(titleKey.value || '').trim()
  return key ? t(key) : 'UI Mihomo/Ultra'
})

const icon = computed(() => {
  const n = String(props.routeName || '').trim()
  return (ROUTE_ICON_MAP as any)?.[n] || null
})

const openGlobalSearch = () => {
  globalSearchOpen.value = true
}
</script>
