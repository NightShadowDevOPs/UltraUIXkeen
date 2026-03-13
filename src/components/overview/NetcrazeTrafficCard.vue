<template>
  <div class="card w-full">
    <div class="card-title flex items-center justify-between gap-2 px-4 pt-4">
      <div class="flex min-w-0 flex-col">
        <span>{{ $t('routerTrafficLive') }}</span>
        <span class="text-xs font-normal opacity-60">{{ $t('routerTrafficLiveTip') }}</span>
      </div>
      <div class="rounded-full border border-base-content/10 bg-base-200/60 px-2 py-1 text-[11px] opacity-70">
        {{ maxLabel }}
      </div>
    </div>

    <div class="card-body gap-2 pt-2">
      <div class="relative h-56 w-full overflow-hidden rounded-lg border border-base-content/10 bg-base-200/30">
        <div ref="chartRef" class="h-full w-full" />
        <span
          ref="colorRef"
          class="border-b-success/25 border-t-success/60 border-l-info/25 border-r-info/60 text-base-content/10 bg-base-100/80 hidden"
        />
      </div>

      <div class="flex flex-wrap items-center gap-x-5 gap-y-2 px-1 text-sm">
        <div class="flex items-center gap-2">
          <span class="h-2.5 w-2.5 rounded-full bg-success" />
          <span class="opacity-80">{{ $t('upload') }}:</span>
          <span class="font-mono">{{ currentUploadLabel }}</span>
        </div>
        <div class="flex items-center gap-2">
          <span class="h-2.5 w-2.5 rounded-full bg-info" />
          <span class="opacity-80">{{ $t('download') }}:</span>
          <span class="font-mono">{{ currentDownloadLabel }}</span>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { prettyBytesHelper } from '@/helper/utils'
import { font, theme } from '@/store/settings'
import { downloadSpeedHistory, uploadSpeedHistory } from '@/store/overview'
import { useElementSize } from '@vueuse/core'
import { LineChart } from 'echarts/charts'
import { GridComponent, TooltipComponent } from 'echarts/components'
import * as echarts from 'echarts/core'
import { CanvasRenderer } from 'echarts/renderers'
import { debounce } from 'lodash'
import { computed, onMounted, ref, watch } from 'vue'
import { useI18n } from 'vue-i18n'

echarts.use([LineChart, GridComponent, TooltipComponent, CanvasRenderer])

const { t } = useI18n()
const chartRef = ref<HTMLElement | null>(null)
const colorRef = ref<HTMLElement | null>(null)

const colorSet = {
  baseContent: '',
  baseContent10: '',
  base70: '',
  success25: '',
  success60: '',
  info30: '',
  info60: '',
}
let fontFamily = ''

const updateColorSet = () => {
  if (!colorRef.value) return
  const colorStyle = getComputedStyle(colorRef.value)
  colorSet.baseContent = colorStyle.getPropertyValue('--color-base-content').trim()
  colorSet.base70 = colorStyle.backgroundColor
  colorSet.baseContent10 = colorStyle.color
  colorSet.success25 = colorStyle.borderBottomColor
  colorSet.success60 = colorStyle.borderTopColor
  colorSet.info30 = colorStyle.borderLeftColor
  colorSet.info60 = colorStyle.borderRightColor
}

const updateFontFamily = () => {
  if (!colorRef.value) return
  fontFamily = getComputedStyle(colorRef.value).fontFamily
}

const latestValue = (items: { value: number }[]) => {
  for (let i = items.length - 1; i >= 0; i -= 1) {
    const v = Number(items[i]?.value || 0)
    if (Number.isFinite(v)) return v
  }
  return 0
}

const maxObserved = computed(() => {
  const values = [...downloadSpeedHistory.value, ...uploadSpeedHistory.value].map((item) => Number(item?.value || 0))
  return Math.max(0, ...values)
})

const roundedPeak = computed(() => {
  const raw = Math.max(maxObserved.value * 1.15, 1024 * 1024)
  const step = raw < 5 * 1024 * 1024 ? 256 * 1024 : 1024 * 1024
  return Math.ceil(raw / step) * step
})

const speedLabel = (value: number) => `${prettyBytesHelper(value, {
  maximumFractionDigits: value >= 1024 * 1024 ? 2 : 0,
  binary: false,
})}/s`

const currentUploadLabel = computed(() => speedLabel(latestValue(uploadSpeedHistory.value)))
const currentDownloadLabel = computed(() => speedLabel(latestValue(downloadSpeedHistory.value)))
const maxLabel = computed(() => `${t('peakScale')}: ${speedLabel(roundedPeak.value)}`)

const formatTime = (value: number) => {
  if (!value) return '—'
  const dt = new Date(Number(value))
  const hh = String(dt.getHours()).padStart(2, '0')
  const mm = String(dt.getMinutes()).padStart(2, '0')
  const ss = String(dt.getSeconds()).padStart(2, '0')
  return `${hh}:${mm}:${ss}`
}

const options = computed(() => ({
  grid: {
    left: 12,
    top: 12,
    right: 12,
    bottom: 26,
    containLabel: true,
  },
  tooltip: {
    trigger: 'axis',
    confine: true,
    backgroundColor: colorSet.base70,
    borderColor: colorSet.base70,
    textStyle: {
      color: colorSet.baseContent,
      fontFamily,
    },
    formatter: (params: ToolTipParams[]) => {
      const time = formatTime(Number(params?.[0]?.name || 0))
      const lines = [
        `<div style="padding:6px 8px">`,
        `<div style="font-size:12px;opacity:.75;margin-bottom:4px">${time}</div>`,
      ]
      for (const item of params || []) {
        lines.push(
          `<div style="display:flex;align-items:center;gap:8px;margin:2px 0">` +
            `<span style="display:inline-block;width:8px;height:8px;border-radius:9999px;background:${item.color}"></span>` +
            `<span>${item.seriesName}: ${speedLabel(Number(item.value || 0))}</span>` +
          `</div>`,
        )
      }
      lines.push(`</div>`)
      return lines.join('')
    },
  },
  xAxis: {
    type: 'category',
    boundaryGap: false,
    data: downloadSpeedHistory.value.map((item) => item.name),
    axisLine: {
      lineStyle: { color: colorSet.baseContent10 },
    },
    axisTick: { show: false },
    axisLabel: {
      color: colorSet.baseContent,
      fontFamily,
      formatter: (value: number, index: number) => {
        const last = downloadSpeedHistory.value.length - 1
        return index === 0 || index === last ? formatTime(Number(value)) : ''
      },
    },
    splitLine: { show: false },
  },
  yAxis: {
    type: 'value',
    min: 0,
    max: roundedPeak.value,
    splitNumber: 4,
    axisLine: { show: false },
    axisTick: { show: false },
    axisLabel: {
      color: colorSet.baseContent,
      fontFamily,
      formatter: (value: number) => (Number(value) === roundedPeak.value ? speedLabel(value) : ''),
    },
    splitLine: {
      show: true,
      lineStyle: {
        type: 'dashed',
        color: colorSet.baseContent10,
      },
    },
  },
  series: [
    {
      name: t('upload'),
      type: 'line',
      smooth: true,
      symbol: 'none',
      data: uploadSpeedHistory.value,
      color: '#22c55e',
      lineStyle: { width: 2 },
      areaStyle: {
        color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
          { offset: 0, color: colorSet.success60 || 'rgba(34,197,94,0.55)' },
          { offset: 1, color: colorSet.success25 || 'rgba(34,197,94,0.08)' },
        ]),
      },
      emphasis: { focus: 'series' },
    },
    {
      name: t('download'),
      type: 'line',
      smooth: true,
      symbol: 'none',
      data: downloadSpeedHistory.value,
      color: colorSet.info60 || '#60a5fa',
      lineStyle: { width: 2 },
      areaStyle: {
        color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
          { offset: 0, color: colorSet.info60 || 'rgba(96,165,250,0.55)' },
          { offset: 1, color: colorSet.info30 || 'rgba(96,165,250,0.08)' },
        ]),
      },
      emphasis: { focus: 'series' },
    },
  ],
}))

onMounted(() => {
  updateColorSet()
  updateFontFamily()
  watch(theme, updateColorSet)
  watch(font, updateFontFamily)

  const chart = echarts.init(chartRef.value!)
  chart.setOption(options.value)

  watch(options, () => {
    chart.setOption(options.value)
  })

  const { width } = useElementSize(chartRef)
  const resize = debounce(() => chart.resize(), 100)
  watch(width, resize)
})
</script>
