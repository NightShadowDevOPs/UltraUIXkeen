<template>
  <div ref="pageRef" class="flex h-full flex-col gap-3 overflow-x-hidden overflow-y-auto p-2" @scroll.passive="syncActiveSection">
    <div class="card gap-3 p-3">
      <div class="flex flex-col gap-3 xl:flex-row xl:items-start xl:justify-between">
        <div>
          <div class="font-semibold">{{ $t('mihomoWorkspaceTitle') }}</div>
          <div class="text-sm opacity-70">{{ $t('mihomoWorkspaceTip') }}</div>
        </div>

        <div class="flex flex-wrap gap-2">
          <button type="button" class="btn btn-sm" @click="goToSection('config')">
            {{ $t('mihomoWorkspaceOpenConfig') }}
          </button>
          <button type="button" class="btn btn-sm btn-ghost" @click="goToRoute(ROUTE_NAME.router)">
            {{ $t('mihomoWorkspaceOpenRuntime') }}
          </button>
          <button type="button" class="btn btn-sm btn-ghost" @click="goToRoute(ROUTE_NAME.proxyProviders)">
            {{ $t('mihomoWorkspaceOpenProviders') }}
          </button>
          <button type="button" class="btn btn-sm btn-ghost" @click="goToRoute(ROUTE_NAME.rules)">
            {{ $t('mihomoWorkspaceOpenRules') }}
          </button>
        </div>
      </div>

      <div class="overflow-x-auto">
        <div class="flex min-w-max flex-wrap gap-2 md:min-w-0 md:flex-wrap">
          <button
            v-for="section in mihomoSections"
            :key="section.id"
            type="button"
            class="btn btn-sm"
            :class="activeSection === section.id ? 'btn-primary' : 'btn-ghost'"
            @click="goToSection(section.id)"
          >
            {{ $t(section.labelKey) }}
          </button>
        </div>
      </div>
    </div>

    <section id="mihomo-overview" class="space-y-2">
      <div class="px-1">
        <div class="text-xs font-semibold uppercase tracking-[0.12em] opacity-55">{{ $t('mihomoSectionOverviewTitle') }}</div>
        <div class="text-sm opacity-70">{{ $t('mihomoSectionOverviewTip') }}</div>
      </div>

      <div class="grid grid-cols-1 gap-3 xl:grid-cols-3">
        <div class="card gap-3 p-3 xl:col-span-2">
          <div>
            <div class="font-semibold">{{ $t('mihomoOverviewStructureTitle') }}</div>
            <div class="text-sm opacity-70">{{ $t('mihomoOverviewStructureTip') }}</div>
          </div>

          <div class="grid grid-cols-1 gap-2 md:grid-cols-2 xl:grid-cols-4">
            <button type="button" class="card items-start gap-1 p-3 text-left transition hover:bg-base-200/70" @click="goToSection('runtime')">
              <div class="font-semibold">{{ $t('mihomoSectionRuntimeTitle') }}</div>
              <div class="text-xs opacity-70">{{ $t('mihomoSectionRuntimeTip') }}</div>
            </button>
            <button type="button" class="card items-start gap-1 p-3 text-left transition hover:bg-base-200/70" @click="goToSection('providers')">
              <div class="font-semibold">{{ $t('mihomoSectionProvidersTitle') }}</div>
              <div class="text-xs opacity-70">{{ $t('mihomoSectionProvidersTip') }}</div>
            </button>
            <button type="button" class="card items-start gap-1 p-3 text-left transition hover:bg-base-200/70" @click="goToSection('rules')">
              <div class="font-semibold">{{ $t('mihomoSectionRulesTitle') }}</div>
              <div class="text-xs opacity-70">{{ $t('mihomoSectionRulesTip') }}</div>
            </button>
            <button type="button" class="card items-start gap-1 p-3 text-left transition hover:bg-base-200/70" @click="goToSection('config')">
              <div class="font-semibold">{{ $t('mihomoConfigSectionTitle') }}</div>
              <div class="text-xs opacity-70">{{ $t('mihomoConfigSectionTip') }}</div>
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
    </section>

    <section id="mihomo-runtime" class="space-y-2">
      <div class="px-1">
        <div class="text-xs font-semibold uppercase tracking-[0.12em] opacity-55">{{ $t('mihomoSectionRuntimeTitle') }}</div>
        <div class="text-sm opacity-70">{{ $t('mihomoSectionRuntimeTip') }}</div>
      </div>

      <div class="grid grid-cols-1 gap-3 xl:grid-cols-3">
        <button type="button" class="card items-start gap-2 p-3 text-left transition hover:bg-base-200/70" @click="goToRoute(ROUTE_NAME.router)">
          <div class="font-semibold">{{ $t('mihomoCardRuntimeTitle') }}</div>
          <div class="text-sm opacity-70">{{ $t('mihomoCardRuntimeTip') }}</div>
        </button>

        <button type="button" class="card items-start gap-2 p-3 text-left transition hover:bg-base-200/70" @click="goToRoute(ROUTE_NAME.traffic)">
          <div class="font-semibold">{{ $t('mihomoRuntimeTrafficTitle') }}</div>
          <div class="text-sm opacity-70">{{ $t('mihomoRuntimeTrafficTip') }}</div>
        </button>

        <button type="button" class="card items-start gap-2 p-3 text-left transition hover:bg-base-200/70" @click="goToRoute(ROUTE_NAME.connections)">
          <div class="font-semibold">{{ $t('mihomoRuntimeConnectionsTitle') }}</div>
          <div class="text-sm opacity-70">{{ $t('mihomoRuntimeConnectionsTip') }}</div>
        </button>
      </div>
    </section>

    <section id="mihomo-providers" class="space-y-2">
      <div class="px-1">
        <div class="text-xs font-semibold uppercase tracking-[0.12em] opacity-55">{{ $t('mihomoSectionProvidersTitle') }}</div>
        <div class="text-sm opacity-70">{{ $t('mihomoSectionProvidersTip') }}</div>
      </div>

      <div class="grid grid-cols-1 gap-3 xl:grid-cols-3">
        <button type="button" class="card items-start gap-2 p-3 text-left transition hover:bg-base-200/70" @click="goToRoute(ROUTE_NAME.proxyProviders)">
          <div class="font-semibold">{{ $t('mihomoCardProvidersTitle') }}</div>
          <div class="text-sm opacity-70">{{ $t('mihomoCardProvidersTip') }}</div>
        </button>

        <button type="button" class="card items-start gap-2 p-3 text-left transition hover:bg-base-200/70" @click="goToRoute(ROUTE_NAME.proxies)">
          <div class="font-semibold">{{ $t('mihomoProvidersGroupsTitle') }}</div>
          <div class="text-sm opacity-70">{{ $t('mihomoProvidersGroupsTip') }}</div>
        </button>

        <button type="button" class="card items-start gap-2 p-3 text-left transition hover:bg-base-200/70" @click="goToRoute(ROUTE_NAME.subscriptions)">
          <div class="font-semibold">{{ $t('mihomoProvidersSubscriptionsTitle') }}</div>
          <div class="text-sm opacity-70">{{ $t('mihomoProvidersSubscriptionsTip') }}</div>
        </button>
      </div>
    </section>

    <section id="mihomo-rules" class="space-y-2">
      <div class="px-1">
        <div class="text-xs font-semibold uppercase tracking-[0.12em] opacity-55">{{ $t('mihomoSectionRulesTitle') }}</div>
        <div class="text-sm opacity-70">{{ $t('mihomoSectionRulesTip') }}</div>
      </div>

      <div class="grid grid-cols-1 gap-3 xl:grid-cols-3">
        <button type="button" class="card items-start gap-2 p-3 text-left transition hover:bg-base-200/70" @click="goToRoute(ROUTE_NAME.rules)">
          <div class="font-semibold">{{ $t('mihomoCardRulesTitle') }}</div>
          <div class="text-sm opacity-70">{{ $t('mihomoCardRulesTip') }}</div>
        </button>

        <button type="button" class="card items-start gap-2 p-3 text-left transition hover:bg-base-200/70" @click="goToRoute(ROUTE_NAME.policies)">
          <div class="font-semibold">{{ $t('mihomoRulesPoliciesTitle') }}</div>
          <div class="text-sm opacity-70">{{ $t('mihomoRulesPoliciesTip') }}</div>
        </button>

        <button type="button" class="card items-start gap-2 p-3 text-left transition hover:bg-base-200/70" @click="goToRoute(ROUTE_NAME.tasks)">
          <div class="font-semibold">{{ $t('mihomoRulesTasksTitle') }}</div>
          <div class="text-sm opacity-70">{{ $t('mihomoRulesTasksTip') }}</div>
        </button>
      </div>
    </section>

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
import { nextTick, onMounted, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'

const router = useRouter()
const route = useRoute()
const pageRef = ref<HTMLElement | null>(null)
const activeSection = ref<'overview' | 'runtime' | 'providers' | 'rules' | 'config'>('overview')

const mihomoSections = [
  { id: 'overview', labelKey: 'mihomoSectionOverviewTitle', domId: 'mihomo-overview' },
  { id: 'runtime', labelKey: 'mihomoSectionRuntimeTitle', domId: 'mihomo-runtime' },
  { id: 'providers', labelKey: 'mihomoSectionProvidersTitle', domId: 'mihomo-providers' },
  { id: 'rules', labelKey: 'mihomoSectionRulesTitle', domId: 'mihomo-rules' },
  { id: 'config', labelKey: 'mihomoConfigSectionTitle', domId: 'mihomo-config-editor' },
] as const

type MihomoSectionId = (typeof mihomoSections)[number]['id']

const resolveSectionId = (raw: unknown): MihomoSectionId => {
  const value = String(raw || '').trim()
  return (mihomoSections.find((item) => item.id === value)?.id || 'overview') as MihomoSectionId
}

const syncActiveSection = () => {
  const root = pageRef.value
  if (!root) return

  const rootTop = root.getBoundingClientRect().top
  let best: MihomoSectionId = activeSection.value
  let bestDistance = Number.POSITIVE_INFINITY

  for (const section of mihomoSections) {
    const el = document.getElementById(section.domId)
    if (!el) continue
    const distance = Math.abs(el.getBoundingClientRect().top - rootTop - 88)
    if (distance < bestDistance) {
      bestDistance = distance
      best = section.id
    }
  }

  activeSection.value = best
}

const goToRoute = (name: ROUTE_NAME) => {
  router.push({ name })
}

const goToSection = async (id: MihomoSectionId) => {
  activeSection.value = id
  await router.replace({
    name: ROUTE_NAME.mihomo,
    query: {
      ...route.query,
      section: id,
    },
  })
  await nextTick()
  document.getElementById(mihomoSections.find((item) => item.id === id)?.domId || '')?.scrollIntoView({ behavior: 'smooth', block: 'start' })
}

const applyRouteSection = async () => {
  const id = resolveSectionId(route.query.section)
  activeSection.value = id
  await nextTick()
  const el = document.getElementById(mihomoSections.find((item) => item.id === id)?.domId || '')
  if (!el) return
  el.scrollIntoView({ behavior: 'auto', block: 'start' })
}

onMounted(async () => {
  await applyRouteSection()
  requestAnimationFrame(syncActiveSection)
})

watch(
  () => route.query.section,
  async () => {
    await applyRouteSection()
    requestAnimationFrame(syncActiveSection)
  },
)
</script>
