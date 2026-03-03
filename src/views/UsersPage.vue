<template>
  <div class="grid grid-cols-1 gap-2 overflow-x-hidden p-2">
    <div class="card">
      <div class="card-title px-4 pt-4">{{ t('users') }}</div>
      <div class="card-body gap-3">
        <div class="flex items-start justify-between gap-2">
          <div class="text-sm opacity-70">
            {{ t('usersTip') }}
          </div>
          <button
            type="button"
            class="btn btn-sm"
            @click="toggleImportPanel"
            :disabled="importLoading"
          >
            <ArrowDownTrayIcon class="h-4 w-4" />
            {{ t('importLanHosts') }}
          </button>
        </div>

        <CollapseCard name="usersImportLanHosts">
          <template #title="{ open }">
            <div class="flex items-center justify-between gap-2">
              <div class="flex items-center gap-2">
                <ArrowDownTrayIcon class="h-4 w-4" />
                <span class="text-base font-semibold">{{ t('importLanHostsTitle') }}</span>
                <span v-if="importLoading" class="loading loading-spinner loading-sm"></span>
              </div>
              <ChevronDownIcon
                class="h-4 w-4 opacity-60 transition-transform"
                :class="open ? 'rotate-180' : ''"
              />
            </div>
          </template>

          <template #preview>
            <div class="mt-1 text-sm opacity-70">
              {{ t('importLanHostsTip') }}
            </div>
          </template>

          <template #content>
            <div class="flex flex-col gap-3 pt-1">
              <div class="text-sm opacity-70">{{ t('importLanHostsTip') }}</div>

              <div v-if="importLoading" class="flex items-center gap-2 text-sm opacity-70">
                <span class="loading loading-spinner loading-sm"></span>
                <span>{{ t('update') }}...</span>
              </div>

              <div v-else>
                <div v-if="importError" class="alert alert-error p-2 text-sm">
                  <span>{{ importError }}</span>
                </div>

                <div v-else>
                  <label class="label cursor-pointer justify-start gap-3">
                    <input v-model="overwriteExisting" type="checkbox" class="checkbox checkbox-sm" />
                    <span class="label-text">{{ t('importLanHostsOverwrite') }}</span>
                  </label>

                  <div v-if="!importItems.length" class="text-sm opacity-70">
                    {{ t('importLanHostsNone') }}
                  </div>

                  <div v-else class="overflow-x-auto">
                    <table class="table table-sm">
                      <thead>
                        <tr>
                          <th class="w-10"></th>
                          <th>{{ t('importLanHostsHost') }}</th>
                          <th>{{ t('importLanHostsIp') }}</th>
                          <th class="max-md:hidden">{{ t('importLanHostsMac') }}</th>
                          <th class="max-md:hidden">{{ t('importLanHostsSource') }}</th>
                          <th class="w-24"></th>
                        </tr>
                      </thead>
                      <tbody>
                        <tr v-for="it in importItems" :key="it.ip" class="hover">
                          <td>
                            <input
                              type="checkbox"
                              class="checkbox checkbox-sm"
                              v-model="it.selected"
                              :disabled="it.status === 'same' || it.status === 'nohost'"
                            />
                          </td>
                          <td class="font-medium">
                            <div class="flex flex-col">
                              <span>{{ it.hostname || '—' }}</span>
                              <span v-if="it.currentLabel" class="text-xs opacity-60">{{ it.currentLabel }}</span>
                            </div>
                          </td>
                          <td class="font-mono text-xs">{{ it.ip }}</td>
                          <td class="font-mono text-xs max-md:hidden">{{ it.mac || '—' }}</td>
                          <td class="text-xs max-md:hidden">{{ it.source || '—' }}</td>
                          <td>
                            <span
                              class="badge badge-sm"
                              :class="
                                it.status === 'add'
                                  ? 'badge-success'
                                  : it.status === 'fill'
                                    ? 'badge-info'
                                    : it.status === 'overwrite'
                                      ? 'badge-warning'
                                      : it.status === 'skip'
                                        ? 'badge-ghost'
                                        : 'badge-neutral'
                              "
                            >
                              {{ statusText(it.status) }}
                            </span>
                          </td>
                        </tr>
                      </tbody>
                    </table>
                  </div>

                  <div class="mt-3 flex items-center justify-between gap-2">
                    <div class="text-sm opacity-70">
                      {{ selectedCount }} / {{ importItems.length }}
                    </div>
                    <div class="flex items-center gap-2">
                      <button type="button" class="btn btn-sm btn-ghost" @click="closeImportPanel">
                        {{ t('close') }}
                      </button>
                      <button
                        type="button"
                        class="btn btn-sm btn-primary"
                        :disabled="selectedCount === 0"
                        @click="applyImport"
                      >
                        {{ t('importLanHostsApply') }}
                      </button>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </template>
        </CollapseCard>

        <CollapseCard name="usersSourceIpMapping">
          <template #title="{ open }">
            <div class="flex items-center justify-between gap-2">
              <div class="flex items-center gap-2">
                <TagIcon class="h-4 w-4" />
                <span class="text-base font-semibold">
                  {{ t('sourceIPLabels') }}
                  <span v-if="sourceIPLabelList.length" class="opacity-70">({{ sourceIPLabelList.length }})</span>
                </span>
              </div>
              <ChevronDownIcon
                class="h-4 w-4 opacity-60 transition-transform"
                :class="open ? 'rotate-180' : ''"
              />
            </div>
          </template>

          <template #preview>
            <div class="mt-1 text-sm opacity-70">
              {{ t('usersTip') }}
            </div>
          </template>

          <template #content>
            <div class="flex flex-col gap-2 pt-1">
              <Draggable
                v-if="sourceIPLabelList.length"
                class="flex flex-1 flex-col gap-2"
                v-model="sourceIPLabelList"
                group="list"
                :animation="150"
                :handle="'.drag-handle'"
                :filter="'.no-drag'"
                :prevent-on-filter="false"
                :item-key="'id'"
                @start="disableSwipe = true"
                @end="disableSwipe = false"
              >
                <template #item="{ element: sourceIP }">
                  <div data-nav-kind="user" :data-nav-value="String(sourceIP.key || '')">
                    <SourceIPInput
                      :model-value="sourceIP"
                      @update:model-value="handlerLabelUpdate"
                    >
                      <template #prefix>
                        <ChevronUpDownIcon class="drag-handle h-4 w-4 shrink-0 cursor-grab" />
                        <LockClosedIcon
                          v-if="isBlockedUser(sourceIP)"
                          class="no-drag h-4 w-4 text-error"
                          :title="t('userBlockedTip')"
                        />
                        <CloudIcon
                          v-if="usersDbSyncActive && usersDbSyncedIdSet.has(sourceIP.id)"
                          class="no-drag h-4 w-4 text-success"
                          :title="t('usersDbSyncedUserTip')"
                        />
                      </template>
                      <template #default>
                        <div class="no-drag flex items-center gap-1">
                          <button
                            type="button"
                            class="no-drag btn btn-circle btn-ghost btn-sm relative"
                            @click.stop.prevent="openEgressMenu($event, sourceIP as any)"
                            @pointerdown.stop.prevent
                            @mousedown.stop.prevent
                            @touchstart.stop.prevent
                            :title="egressTitle(sourceIP as any)"
                          >
                            <ArrowRightOnRectangleIcon class="h-4 w-4" />
                            <span
                              v-if="(sourceIP as any).egressProviders?.length"
                              class="badge badge-xs absolute -top-1 -right-1"
                            >
                              {{ (sourceIP as any).egressProviders.length }}
                            </span>
                          </button>
                        <button
                          type="button"
                          class="no-drag btn btn-circle btn-ghost btn-sm"
                          @click.stop.prevent="handlerLabelRemove(sourceIP.id)"
                          @pointerdown.stop.prevent
                          @mousedown.stop.prevent
                          @touchstart.stop.prevent
                          :title="t('delete')"
                        >
                          <TrashIcon class="h-4 w-4" />
                        </button>
                        </div>
                      </template>
                    </SourceIPInput>
                  </div>
                </template>
              </Draggable>

              <div v-else class="text-sm opacity-60">
                {{ t('usersEmpty') }}
              </div>

              <SourceIPInput
                v-model="newLabelForIP"
                @keydown.enter="handlerLabelAdd"
              >
                <template #prefix>
                  <TagIcon class="h-4 w-4 shrink-0" />
                </template>
                <template #default>
                  <button
                    type="button"
                    class="no-drag btn btn-circle btn-sm"
                    @click.stop.prevent="handlerLabelAdd"
                    @pointerdown.stop.prevent
                    @mousedown.stop.prevent
                    @touchstart.stop.prevent
                    :title="t('add')"
                  >
                    <PlusIcon class="h-4 w-4" />
                  </button>
                </template>
              </SourceIPInput>
            </div>
          </template>
        </CollapseCard>

        <CollapseCard name="usersEgressRouting">
          <template #title="{ open }">
            <div class="flex items-center justify-between gap-2">
              <div class="flex items-center gap-2">
                <ArrowRightOnRectangleIcon class="h-4 w-4" />
                <span class="text-base font-semibold">
                  {{ t('userEgressRouting') }}
                  <span v-if="egressUsers.length" class="opacity-70">({{ egressUsers.length }})</span>
                </span>
              </div>
              <ChevronDownIcon
                class="h-4 w-4 opacity-60 transition-transform"
                :class="open ? 'rotate-180' : ''"
              />
            </div>
          </template>

          <template #preview>
            <div class="mt-1 text-sm opacity-70">
              {{ t('userEgressRoutingTip') }}
            </div>
          </template>

          <template #content>
            <div class="flex flex-col gap-3 pt-1">
              <div class="text-sm opacity-70">{{ t('userEgressRoutingTip') }}</div>

              <div v-if="!egressUsers.length" class="text-sm opacity-60">
                {{ t('userEgressRoutingNone') }}
              </div>

              <div v-else class="grid grid-cols-1 gap-3">
                <div class="alert alert-warning p-2 text-sm" v-if="egressWarnings.length">
                  <div class="flex flex-col gap-1">
                    <div class="font-semibold">{{ t('note') }}</div>
                    <div v-for="w in egressWarnings" :key="w" class="opacity-90">• {{ w }}</div>
                  </div>
                </div>

                <div class="flex items-center justify-between gap-2">
                  <div class="font-semibold">{{ t('userEgressRoutingGroups') }}</div>
                  <button class="btn btn-xs" @click="copyText(egressGroupsYaml)">{{ t('copy') }}</button>
                </div>
                <textarea
                  class="textarea textarea-sm font-mono w-full min-h-[10rem] whitespace-pre"
                  readonly
                  :value="egressGroupsYaml"
                ></textarea>

                <div class="flex items-center justify-between gap-2">
                  <div class="font-semibold">{{ t('userEgressRoutingRules') }}</div>
                  <button class="btn btn-xs" @click="copyText(egressRulesYaml)">{{ t('copy') }}</button>
                </div>
                <textarea
                  class="textarea textarea-sm font-mono w-full min-h-[8rem] whitespace-pre"
                  readonly
                  :value="egressRulesYaml"
                ></textarea>

                <div class="text-sm opacity-70">
                  {{ t('userEgressRoutingApplyTip') }}
                </div>
              </div>
            </div>
          </template>
        </CollapseCard>
      </div>
    </div>

    <UserTrafficStats />
  </div>
</template>


<script setup lang="ts">
import UserTrafficStats from '@/components/users/UserTrafficStats.vue'
import SourceIPInput from '@/components/settings/SourceIPInput.vue'
import CollapseCard from '@/components/common/CollapseCard.vue'
import { agentLanHostsAPI } from '@/api/agent'
import { showNotification } from '@/helper/notification'
import { i18n } from '@/i18n'
import { useTooltip } from '@/helper/tooltip'
import { disableSwipe } from '@/composables/swipe'
import { ROUTE_NAME } from '@/constant'
import { cleanupExpiredPendingPageFocus, clearPendingPageFocus, flashNavHighlight, getPendingPageFocusForRoute } from '@/helper/navFocus'
import { collapseGroupMap, sourceIPLabelList } from '@/store/settings'
import { usersDbSyncActive, usersDbSyncedIdSet } from '@/store/usersDbSync'
import { proxyProviederList } from '@/store/proxies'
import type { SourceIPLabel } from '@/types'
import { ArrowDownTrayIcon, ArrowRightOnRectangleIcon, ChevronDownIcon, ChevronUpDownIcon, CloudIcon, LockClosedIcon, PlusIcon, TagIcon, TrashIcon } from '@heroicons/vue/24/outline'
import { v4 as uuid } from 'uuid'
import { computed, nextTick, onMounted, ref, watch } from 'vue'
import Draggable from 'vuedraggable'
import { getUserLimitState } from '@/composables/userLimits'

const t = i18n.global.t

const newLabelForIP = ref<Omit<SourceIPLabel, 'id'>>({
  key: '',
  label: '',
})

const handlerLabelAdd = () => {
  if (!newLabelForIP.value.key || !newLabelForIP.value.label) {
    return
  }
  sourceIPLabelList.value.push({
    ...newLabelForIP.value,
    id: uuid(),
  })
  newLabelForIP.value = {
    key: '',
    label: '',
  }
}

const handlerLabelRemove = (id: string) => {
  const idx = sourceIPLabelList.value.findIndex((item) => item.id === id)
  if (idx >= 0) sourceIPLabelList.value.splice(idx, 1)
}

const handlerLabelUpdate = (sourceIP: Partial<SourceIPLabel>) => {
  const index = sourceIPLabelList.value.findIndex((item) => item.id === sourceIP.id)
  if (index < 0) return
  sourceIPLabelList.value[index] = {
    ...sourceIPLabelList.value[index],
    ...sourceIP,
  }
}

const isBlockedUser = (sourceIP: Partial<SourceIPLabel>) => {
  const user = (sourceIP.label || sourceIP.key || '').toString().trim()
  if (!user) return false
  return getUserLimitState(user).blocked
}

// --- Per-user egress providers (routing by SRC-IP-CIDR) ---
const { showTip } = useTooltip()

const providerNames = computed(() => {
  const names = (proxyProviederList.value || [])
    .map((p: any) => String(p?.name || '').trim())
    .filter(Boolean)
  // stable order
  return Array.from(new Set(names)).sort((a, b) => a.localeCompare(b))
})

const normalizeProviders = (arr: any): string[] => {
  if (!Array.isArray(arr)) return []
  const out = arr
    .map((v: any) => String(v || '').trim())
    .filter(Boolean)
  return Array.from(new Set(out)).sort((a, b) => a.localeCompare(b))
}

const egressTitle = (it: any) => {
  const sel = normalizeProviders(it?.egressProviders)
  if (!sel.length) return t('userEgressSelectProviders')
  return `${t('userEgressProviders')}: ${sel.join(', ')}`
}

const openEgressMenu = (e: Event, it: any) => {
  const root = document.createElement('div')
  root.classList.add('flex', 'flex-col', 'gap-2', 'py-1')

  const header = document.createElement('div')
  header.classList.add('text-xs', 'opacity-70', 'px-1')
  header.textContent = t('userEgressSelectProviders')
  root.append(header)

  const names = providerNames.value
  if (!names.length) {
    const empty = document.createElement('div')
    empty.classList.add('text-sm', 'opacity-60', 'px-1')
    empty.textContent = t('userEgressNoProviders')
    root.append(empty)
  } else {
    const actions = document.createElement('div')
    actions.classList.add('flex', 'items-center', 'gap-2', 'px-1')

    const btnAll = document.createElement('button')
    btnAll.type = 'button'
    btnAll.className = 'btn btn-xs'
    btnAll.textContent = t('selectAll')
    btnAll.addEventListener('click', (ev) => {
      ev.preventDefault()
      it.egressProviders = [...names]
    })

    const btnClear = document.createElement('button')
    btnClear.type = 'button'
    btnClear.className = 'btn btn-xs btn-ghost'
    btnClear.textContent = t('clear')
    btnClear.addEventListener('click', (ev) => {
      ev.preventDefault()
      delete it.egressProviders
    })

    actions.append(btnAll, btnClear)
    root.append(actions)

    const list = document.createElement('div')
    list.classList.add('flex', 'flex-col', 'gap-2', 'py-1', 'px-1', 'max-h-72', 'overflow-auto')

    for (const name of names) {
      const label = document.createElement('label')
      label.classList.add('flex', 'items-center', 'gap-2', 'cursor-pointer')
      const checkbox = document.createElement('input')
      checkbox.type = 'checkbox'
      checkbox.classList.add('checkbox', 'checkbox-sm')
      checkbox.checked = normalizeProviders(it.egressProviders).includes(name)
      checkbox.addEventListener('change', (ev) => {
        const checked = (ev.target as HTMLInputElement).checked
        const cur = normalizeProviders(it.egressProviders)
        const next = checked ? [...cur, name] : cur.filter((x) => x !== name)
        const fin = normalizeProviders(next)
        if (fin.length) it.egressProviders = fin
        else delete it.egressProviders
      })
      const span = document.createElement('span')
      span.textContent = name
      label.append(checkbox, span)
      list.append(label)
    }
    root.append(list)
  }

  showTip(e, root, {
    theme: 'base',
    placement: 'bottom-start',
    trigger: 'click',
    appendTo: document.body,
    interactive: true,
    arrow: false,
  })
}

const egressUsers = computed(() => {
  return (sourceIPLabelList.value || []).filter((x: any) => Array.isArray(x?.egressProviders) && x.egressProviders.length)
})

const isIPv4 = (s: string) => {
  const m = (s || '').trim().match(/^([0-9]{1,3}\.){3}[0-9]{1,3}$/)
  if (!m) return false
  const parts = s.split('.').map((n) => Number(n))
  return parts.length === 4 && parts.every((n) => Number.isFinite(n) && n >= 0 && n <= 255)
}

const isIPv4Cidr = (s: string) => {
  const t = (s || '').trim()
  const m = t.match(/^([0-9]{1,3}\.){3}[0-9]{1,3}\/(\d{1,2})$/)
  if (!m) return false
  const prefix = Number(m[2])
  if (!Number.isFinite(prefix) || prefix < 0 || prefix > 32) return false
  const ip = t.split('/')[0]
  return isIPv4(ip)
}

const toSrcCidr = (key: string): { ok: true; cidr: string } | { ok: false; reason: string } => {
  const k = String(key || '').trim()
  if (!k) return { ok: false, reason: 'empty' }
  if (k.startsWith('/')) return { ok: false, reason: 'regex' }
  if (isIPv4Cidr(k)) return { ok: true, cidr: k }
  if (isIPv4(k)) return { ok: true, cidr: `${k}/32` }
  if (k.includes(':')) {
    if (k.includes('/')) return { ok: true, cidr: k }
    return { ok: true, cidr: `${k}/128` }
  }
  return { ok: false, reason: 'unsupported' }
}

const mkGroupName = (key: string) => {
  const base = String(key || '').trim().replace(/[^0-9A-Za-z]+/g, '_')
  const name = `USR_${base}`.replace(/_+/g, '_')
  // Keep it reasonably short for UIs.
  return name.length > 64 ? name.slice(0, 64) : name
}

const egressWarnings = computed(() => {
  const warnings: string[] = []
  for (const it of egressUsers.value as any[]) {
    const key = String(it?.key || '').trim()
    const cidr = toSrcCidr(key)
    if (!cidr.ok) {
      warnings.push(`${key}: ${cidr.reason === 'regex' ? t('userEgressWarnRegex') : t('userEgressWarnUnsupported')}`)
    }
    const sel = normalizeProviders(it?.egressProviders)
    const missing = sel.filter((p) => !providerNames.value.includes(p))
    if (missing.length) warnings.push(`${key}: ${t('userEgressWarnMissingProviders')} ${missing.join(', ')}`)
  }
  return warnings
})

const egressGroupsYaml = computed(() => {
  if (!egressUsers.value.length) return '# (empty)\n'
  const blocks: string[] = []
  for (const it of egressUsers.value as any[]) {
    const key = String(it?.key || '').trim()
    const group = mkGroupName(key)
    const sel = normalizeProviders(it?.egressProviders)
    if (!sel.length) continue
    blocks.push(
      `  - name: "${group}"\n` +
        `    type: select\n` +
        `    proxies:\n` +
        `      - DIRECT\n` +
        `    use:\n` +
        sel.map((p) => `      - ${JSON.stringify(p)}`).join('\n') +
        `\n`,
    )
  }
  return (
    '# Paste these items under your existing "proxy-groups:" list\n' +
    (blocks.length ? blocks.join('\n') : '# (empty)\n')
  )
})

const egressRulesYaml = computed(() => {
  if (!egressUsers.value.length) return '# (empty)\n'
  const lines: string[] = []
  for (const it of egressUsers.value as any[]) {
    const key = String(it?.key || '').trim()
    const cidr = toSrcCidr(key)
    if (!cidr.ok) continue
    const group = mkGroupName(key)
    lines.push(`  - SRC-IP-CIDR,${cidr.cidr},${group}`)
  }
  return (
    '# Paste these lines near the TOP of your existing "rules:" list (before other rules)\n' +
    (lines.length ? lines.join('\n') + '\n' : '# (empty)\n')
  )
})

const copyText = async (text: string) => {
  try {
    await navigator.clipboard.writeText(String(text || ''))
    showNotification(t('copySuccess'))
  } catch (e: any) {
    showNotification(e?.message || 'copy failed')
  }
}


type ImportItem = {
  ip: string
  hostname: string
  mac?: string
  source?: string
  status: 'add' | 'fill' | 'overwrite' | 'skip' | 'same' | 'nohost'
  selected: boolean
  currentLabel?: string
}

const importLoading = ref(false)
const importError = ref('')
const overwriteExisting = ref(false)
const importItems = ref<ImportItem[]>([])

const IMPORT_COLLAPSE_NAME = 'usersImportLanHosts'
const importLastFetchAt = ref(0)

const MAPPING_COLLAPSE_NAME = 'usersSourceIpMapping'
if (collapseGroupMap.value[MAPPING_COLLAPSE_NAME] === undefined) {
  // Keep the mapping visible by default (same behavior as before),
  // while allowing users to collapse it when the list grows.
  collapseGroupMap.value[MAPPING_COLLAPSE_NAME] = true
}

// --- Cross-page navigation focus (Topology -> Users) ---
const findUserEl = (ip: string) => {
  const v = String(ip || '').trim()
  if (!v) return null
  const items = Array.from(document.querySelectorAll('[data-nav-kind="user"]')) as HTMLElement[]
  return (
    items.find((el) => String((el as any).dataset?.navValue || '').trim() === v) ||
    null
  )
}

let focusApplied = false
const tryApplyPendingFocus = async () => {
  if (focusApplied) return
  const pf = getPendingPageFocusForRoute(ROUTE_NAME.users)
  if (!pf || pf.kind !== 'user') return

  const ip = String(pf.value || '').trim()
  if (!ip) return

  // Ensure mapping accordion is open.
  collapseGroupMap.value[MAPPING_COLLAPSE_NAME] = true

  const start = performance.now()
  const loop = async () => {
    await nextTick()
    const el = findUserEl(ip)
    if (el) {
      el.scrollIntoView({ behavior: 'smooth', block: 'center' })
      flashNavHighlight(el)
      clearPendingPageFocus()
      focusApplied = true
      return
    }
    if (performance.now() - start < 2400) requestAnimationFrame(() => loop())
  }
  loop()
}

onMounted(() => {
  cleanupExpiredPendingPageFocus()
  tryApplyPendingFocus()
})

watch(sourceIPLabelList, () => {
  tryApplyPendingFocus()
})

const fetchImportItems = async () => {
  // Avoid re-fetch spam when user quickly toggles the panel.
  const now = Date.now()
  if (importLoading.value) return
  if (importItems.value.length && now - importLastFetchAt.value < 3000) return

  importLastFetchAt.value = now
  importLoading.value = true
  importError.value = ''
  importItems.value = []

  const res = await agentLanHostsAPI()
  importLoading.value = false

  if (!res?.ok) {
    importError.value = res?.error || 'offline'
    return
  }

  buildImportItems((res as any).items || [])
}

const normalizeName = (s: string) => (s || '').toString().trim().replace(/\s+/g, ' ').toLowerCase()

const buildImportItems = (raw: any[]) => {
  const byIp = new Map<string, any>()
  for (const it of raw || []) {
    const ip = String((it as any)?.ip || '').trim()
    if (!ip) continue
    const hostname = String((it as any)?.hostname || '').trim()
    const mac = String((it as any)?.mac || '').trim()
    const source = String((it as any)?.source || '').trim()

    // Prefer items with a hostname.
    if (!byIp.has(ip)) {
      byIp.set(ip, { ip, hostname, mac, source })
    } else {
      const cur = byIp.get(ip)
      if (!cur.hostname && hostname) byIp.set(ip, { ip, hostname, mac: mac || cur.mac, source: source || cur.source })
    }
  }

  const out: ImportItem[] = []
  for (const v of Array.from(byIp.values())) {
    const ip = v.ip
    const hostname = v.hostname
    const existing = sourceIPLabelList.value.find((x) => String(x.key || '').trim() === ip) || null
    const currentLabel = existing ? String(existing.label || '').trim() : ''

    let status: ImportItem['status'] = 'add'
    let selected = false

    if (!hostname) {
      status = 'nohost'
      selected = false
    } else if (!existing) {
      status = 'add'
      selected = true
    } else {
      const curN = normalizeName(currentLabel)
      const hostN = normalizeName(hostname)
      const keyN = normalizeName(existing.key || '')

      if (curN && curN === hostN) {
        status = 'same'
        selected = false
      } else if (!curN || curN === keyN) {
        status = 'fill'
        selected = true
      } else {
        status = overwriteExisting.value ? 'overwrite' : 'skip'
        selected = overwriteExisting.value
      }
    }

    out.push({
      ip,
      hostname,
      mac: v.mac,
      source: v.source,
      status,
      selected,
      currentLabel: currentLabel ? `${t('user')}: ${currentLabel}` : '',
    } as any)
  }

  out.sort((a, b) => {
    const ah = normalizeName(a.hostname)
    const bh = normalizeName(b.hostname)
    if (ah && bh && ah !== bh) return ah.localeCompare(bh)
    return a.ip.localeCompare(b.ip)
  })

  importItems.value = out
}

watch(overwriteExisting, () => {
  // Recompute statuses for items with existing custom labels.
  importItems.value = importItems.value.map((it) => {
    if (it.status === 'skip' || it.status === 'overwrite') {
      const existing = sourceIPLabelList.value.find((x) => String(x.key || '').trim() === it.ip) || null
      const currentLabel = existing ? String(existing.label || '').trim() : ''
      const curN = normalizeName(currentLabel)
      const hostN = normalizeName(it.hostname)
      const keyN = existing ? normalizeName(existing.key || '') : ''

      if (!existing) return { ...it, status: 'add', selected: true }
      if (curN && curN === hostN) return { ...it, status: 'same', selected: false }
      if (!curN || curN === keyN) return { ...it, status: 'fill', selected: true }
      return overwriteExisting.value
        ? { ...it, status: 'overwrite', selected: true }
        : { ...it, status: 'skip', selected: false }
    }
    return it
  })
})

const selectedCount = computed(() => importItems.value.filter((x) => x.selected).length)

const statusText = (s: ImportItem['status']) => {
  switch (s) {
    case 'add':
      return t('importLanHostsStatusAdd')
    case 'fill':
      return t('importLanHostsStatusFill')
    case 'overwrite':
      return t('importLanHostsStatusOverwrite')
    case 'skip':
      return t('importLanHostsStatusSkip')
    case 'same':
      return t('importLanHostsStatusSame')
    default:
      return '—'
  }
}

const closeImportPanel = () => {
  collapseGroupMap.value[IMPORT_COLLAPSE_NAME] = false
}

const openImportPanel = async () => {
  collapseGroupMap.value[IMPORT_COLLAPSE_NAME] = true

  await fetchImportItems()
}

const toggleImportPanel = async () => {
  const isOpen = !!collapseGroupMap.value[IMPORT_COLLAPSE_NAME]
  if (isOpen) {
    closeImportPanel()
    return
  }

  await openImportPanel()
}

watch(
  () => !!collapseGroupMap.value[IMPORT_COLLAPSE_NAME],
  (open) => {
    if (open && !importItems.value.length && !importLoading.value && !importError.value) {
      void fetchImportItems()
    }
  },
)

const applyImport = () => {
  let added = 0
  let updated = 0

  for (const it of importItems.value) {
    if (!it.selected) continue
    if (!it.hostname) continue

    const existing = sourceIPLabelList.value.find((x) => String(x.key || '').trim() === it.ip) || null
    if (!existing) {
      sourceIPLabelList.value.push({ id: uuid(), key: it.ip, label: it.hostname })
      added++
      continue
    }

    const cur = String(existing.label || '').trim()
    const curN = normalizeName(cur)
    const keyN = normalizeName(existing.key || '')
    const hostN = normalizeName(it.hostname)

    if (curN && curN === hostN) continue

    if (overwriteExisting.value || !curN || curN === keyN) {
      existing.label = it.hostname
      updated++
    }
  }

  showNotification({
    content: 'importLanHostsDone',
    params: { added: String(added), updated: String(updated) },
    type: 'alert-success',
  })

  closeImportPanel()
}
</script>
