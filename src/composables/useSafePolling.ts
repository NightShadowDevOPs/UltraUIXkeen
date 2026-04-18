import { computed, onBeforeUnmount, onMounted, ref, toValue, watch, type MaybeRefOrGetter } from 'vue'
import { useDocumentVisibility } from '@vueuse/core'

type UseSafePollingOptions = {
  callback: () => void | Promise<void>
  intervalMs: MaybeRefOrGetter<number>
  enabled?: MaybeRefOrGetter<boolean>
  immediate?: boolean
  refreshOnVisible?: boolean
  refreshOnEnable?: boolean
  visibleOnly?: boolean
}

export const useSafePolling = ({
  callback,
  intervalMs,
  enabled = true,
  immediate = true,
  refreshOnVisible = true,
  refreshOnEnable = true,
  visibleOnly = true,
}: UseSafePollingOptions) => {
  const documentVisibility = useDocumentVisibility()
  const running = ref(false)
  let timer: number | undefined

  const enabledState = computed(() => Boolean(toValue(enabled)))
  const visibleState = computed(() => !visibleOnly || documentVisibility.value === 'visible')
  const active = computed(() => enabledState.value && visibleState.value)

  const stop = () => {
    if (timer !== undefined) {
      window.clearTimeout(timer)
      timer = undefined
    }
  }

  const run = async () => {
    if (running.value) return false
    running.value = true
    try {
      await callback()
      return true
    } finally {
      running.value = false
    }
  }

  const schedule = () => {
    stop()
    if (!active.value) return
    const ms = Math.max(1000, Number(toValue(intervalMs)) || 0)
    timer = window.setTimeout(async () => {
      timer = undefined
      if (!active.value) return
      await run()
      schedule()
    }, ms)
  }

  onMounted(() => {
    if (immediate && active.value) void run()
    schedule()
  })

  watch(active, () => {
    schedule()
  })

  watch(enabledState, (value, oldValue) => {
    if (value && !oldValue && visibleState.value && refreshOnEnable) {
      void run()
    }
  })

  watch(visibleState, (value, oldValue) => {
    if (value && !oldValue && enabledState.value && refreshOnVisible) {
      void run()
    }
    schedule()
  })

  watch(
    () => Number(toValue(intervalMs)) || 0,
    () => {
      schedule()
    },
  )

  onBeforeUnmount(() => {
    stop()
  })

  return {
    active,
    documentVisibility,
    refresh: run,
    running,
    stop,
  }
}
