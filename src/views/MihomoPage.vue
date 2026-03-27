<template>
  <div class="flex h-full flex-col gap-3 overflow-x-hidden overflow-y-auto p-2">
    <div class="grid grid-cols-1 gap-3 xl:grid-cols-3">
      <div class="card gap-3 p-3 xl:col-span-2">
        <div>
          <div class="font-semibold">{{ $t('mihomoWorkspaceTitle') }}</div>
          <div class="text-sm opacity-70">{{ $t('mihomoWorkspaceTip') }}</div>
        </div>

        <div class="flex flex-wrap gap-2">
          <button type="button" class="btn btn-sm" @click="scrollToConfig">
            {{ $t('mihomoWorkspaceOpenConfig') }}
          </button>
          <button type="button" class="btn btn-sm btn-ghost" @click="goTo(ROUTE_NAME.router)">
            {{ $t('mihomoWorkspaceOpenRuntime') }}
          </button>
          <button type="button" class="btn btn-sm btn-ghost" @click="goTo(ROUTE_NAME.proxyProviders)">
            {{ $t('mihomoWorkspaceOpenProviders') }}
          </button>
          <button type="button" class="btn btn-sm btn-ghost" @click="goTo(ROUTE_NAME.rules)">
            {{ $t('mihomoWorkspaceOpenRules') }}
          </button>
        </div>
      </div>

      <div class="card gap-2 p-3">
        <div class="font-semibold">{{ $t('mihomoWorkspaceSafetyTitle') }}</div>
        <div class="text-sm opacity-70">{{ $t('mihomoWorkspaceSafetyTip') }}</div>
        <div class="flex flex-wrap gap-2 text-xs">
          <span class="badge badge-ghost">draft</span>
          <span class="badge badge-ghost">validate</span>
          <span class="badge badge-ghost">rollback</span>
          <span class="badge badge-ghost">baseline</span>
        </div>
      </div>
    </div>

    <div class="grid grid-cols-1 gap-3 xl:grid-cols-3">
      <button type="button" class="card items-start gap-2 p-3 text-left transition hover:bg-base-200/70" @click="goTo(ROUTE_NAME.router)">
        <div class="font-semibold">{{ $t('mihomoCardRuntimeTitle') }}</div>
        <div class="text-sm opacity-70">{{ $t('mihomoCardRuntimeTip') }}</div>
      </button>

      <button type="button" class="card items-start gap-2 p-3 text-left transition hover:bg-base-200/70" @click="goTo(ROUTE_NAME.proxyProviders)">
        <div class="font-semibold">{{ $t('mihomoCardProvidersTitle') }}</div>
        <div class="text-sm opacity-70">{{ $t('mihomoCardProvidersTip') }}</div>
      </button>

      <button type="button" class="card items-start gap-2 p-3 text-left transition hover:bg-base-200/70" @click="goTo(ROUTE_NAME.rules)">
        <div class="font-semibold">{{ $t('mihomoCardRulesTitle') }}</div>
        <div class="text-sm opacity-70">{{ $t('mihomoCardRulesTip') }}</div>
      </button>
    </div>

    <section id="mihomo-config-editor" class="space-y-2">
      <div class="px-1">
        <div class="text-xs font-semibold uppercase tracking-[0.12em] opacity-55">{{ $t('mihomoConfigSectionTitle') }}</div>
        <div class="text-sm opacity-70">{{ $t('mihomoConfigSectionTip') }}</div>
      </div>
      <MihomoConfigEditor />
    </section>
  </div>
</template>

<script setup lang="ts">
import MihomoConfigEditor from '@/components/settings/MihomoConfigEditor.vue'
import { ROUTE_NAME } from '@/constant'
import { useRouter } from 'vue-router'

const router = useRouter()

const goTo = (name: ROUTE_NAME) => {
  router.push({ name })
}

const scrollToConfig = () => {
  document.getElementById('mihomo-config-editor')?.scrollIntoView({ behavior: 'smooth', block: 'start' })
}
</script>
