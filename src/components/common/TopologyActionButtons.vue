<template>
  <div :class="wrapperClass">
    <button
      type="button"
      :class="btnClass"
      :title="$t('openInTopology')"
      @click.stop="go('none')"
      @pointerdown.stop.prevent
      @mousedown.stop.prevent
      @touchstart.stop.prevent
    >
      <PresentationChartLineIcon :class="iconClass" />
    </button>

    <button
      type="button"
      :class="btnClass"
      :title="$t('topologyOnlyThis')"
      @click.stop="go('only')"
      @pointerdown.stop.prevent
      @mousedown.stop.prevent
      @touchstart.stop.prevent
    >
      <FunnelIcon :class="iconClass" />
    </button>

    <button
      type="button"
      :class="btnClass"
      :title="$t('topologyExcludeThis')"
      @click.stop="go('exclude')"
      @pointerdown.stop.prevent
      @mousedown.stop.prevent
      @touchstart.stop.prevent
    >
      <NoSymbolIcon :class="iconClass" />
    </button>
  </div>
</template>

<script setup lang="ts">
import { ROUTE_NAME } from '@/constant'
import router from '@/router'
import { computed } from 'vue'
import { FunnelIcon, NoSymbolIcon, PresentationChartLineIcon } from '@heroicons/vue/24/outline'

type FocusStage = 'C' | 'R' | 'G' | 'S' | 'P'
type FilterMode = 'none' | 'only' | 'exclude'

type PendingTopologyNavFilter = {
  ts: number
  mode: FilterMode
  focus: { stage: FocusStage; kind: 'value'; value: string }
  // Used by Topology page as a safe highlight/selection target when stage=P.
  fallbackProxyName?: string
}

const props = withDefaults(
  defineProps<{
    stage: FocusStage
    value: string
    fallbackProxyName?: string
    wrapperClass?: string
    btnClass?: string
    iconClass?: string
  }>(),
  {
    wrapperClass: 'join',
    btnClass: 'btn btn-ghost btn-xs join-item',
    iconClass: 'h-4 w-4 opacity-70',
  },
)

const TOPOLOGY_NAV_FILTER_KEY = 'runtime/topology-pending-filter-v1'

const normValue = computed(() => String(props.value || '').trim())

const go = async (mode: FilterMode) => {
  const v = normValue.value
  if (!v) return

  const payload: PendingTopologyNavFilter = {
    ts: Date.now(),
    mode,
    focus: { stage: props.stage, kind: 'value', value: v },
  }

  const fb = String(props.fallbackProxyName || '').trim()
  if (fb) payload.fallbackProxyName = fb

  try {
    localStorage.setItem(TOPOLOGY_NAV_FILTER_KEY, JSON.stringify(payload))
  } catch {
    // ignore
  }

  await router.push({ name: ROUTE_NAME.overview })
}
</script>
