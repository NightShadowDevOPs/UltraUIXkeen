<template>
  <div class="card w-full max-w-none">
    <div class="card-title flex items-center justify-between gap-2 px-4 pt-4">
      <div class="flex items-center gap-2">
        <button
          type="button"
          class="btn btn-ghost btn-circle btn-sm"
          @click="expanded = !expanded"
          :title="expanded ? $t('collapse') : $t('expand')"
        >
          <ChevronUpIcon v-if="expanded" class="h-4 w-4" />
          <ChevronDownIcon v-else class="h-4 w-4" />
        </button>
        <span>{{ $t('mihomoConfigEditor') }}</span>
      </div>

      <div class="flex flex-wrap items-center gap-2">
        <span class="badge badge-outline">{{ managedMode ? $t('configManagedMode') : $t('configDirectMode') }}</span>
        <button class="btn btn-sm" :class="refreshBusy && 'loading'" @click="refreshAll(true)">
          {{ $t('refresh') }}
        </button>
      </div>
    </div>

    <div class="card-body gap-3">
      <div class="flex flex-wrap items-center gap-2 text-xs opacity-70">
        <span>{{ $t('configPath') }}:</span>
        <span class="font-mono">{{ currentPath }}</span>
      </div>

      <div v-if="managedMode" class="rounded-box border border-base-content/10 bg-base-200/40 p-3 text-xs">
        <div class="flex flex-wrap items-center gap-2">
          <span class="badge" :class="managedStatusBadgeClass">{{ managedStatusText }}</span>
          <span v-if="managedState?.active?.rev" class="badge badge-ghost">{{ $t('configActiveTitle') }} rev {{ managedState?.active?.rev }}</span>
          <span v-if="managedState?.draft?.rev" class="badge badge-ghost">{{ $t('configDraftTitle') }} rev {{ managedState?.draft?.rev }}</span>
          <span v-if="managedState?.validator?.bin" class="badge badge-ghost">{{ managedState?.validator?.bin }}</span>
          <span v-if="managedState?.restart?.mode" class="badge badge-ghost">{{ $t('configDiagRestartMethod') }}: {{ managedState?.restart?.mode }}</span>
        </div>

        <div class="mt-2 grid grid-cols-1 gap-2 md:grid-cols-3">
          <div class="rounded-lg border border-base-content/10 bg-base-100/60 p-2">
            <div class="font-semibold">{{ $t('configActiveTitle') }}</div>
            <div class="mt-1 font-mono text-[11px] opacity-80">{{ managedState?.active?.path || '—' }}</div>
            <div class="mt-1 opacity-70">{{ $t('updatedAt') }}: {{ fmtTextTs(managedState?.active?.updatedAt) }}</div>
            <div class="opacity-70">{{ $t('size') }}: {{ fmtBytes(managedState?.active?.sizeBytes) }}</div>
          </div>

          <div class="rounded-lg border border-base-content/10 bg-base-100/60 p-2">
            <div class="font-semibold">{{ $t('configDraftTitle') }}</div>
            <div class="mt-1 font-mono text-[11px] opacity-80">{{ managedState?.draft?.path || '—' }}</div>
            <div class="mt-1 opacity-70">{{ $t('updatedAt') }}: {{ fmtTextTs(managedState?.draft?.updatedAt) }}</div>
            <div class="opacity-70">{{ $t('size') }}: {{ fmtBytes(managedState?.draft?.sizeBytes) }}</div>
          </div>

          <div class="rounded-lg border border-base-content/10 bg-base-100/60 p-2">
            <div class="font-semibold">{{ $t('configBaselineTitle') }}</div>
            <div class="mt-1 font-mono text-[11px] opacity-80">{{ managedState?.baseline?.path || '—' }}</div>
            <div class="mt-1 opacity-70">{{ $t('updatedAt') }}: {{ fmtTextTs(managedState?.baseline?.updatedAt) }}</div>
            <div class="opacity-70">{{ $t('size') }}: {{ fmtBytes(managedState?.baseline?.sizeBytes) }}</div>
          </div>
        </div>

        <div class="mt-2 text-[11px] opacity-70">
          {{ $t('configManagedTip') }}
        </div>
        <div v-if="managedState?.lastError" class="mt-1 break-words text-[11px] text-warning">
          {{ managedState?.lastError }}
        </div>
      </div>

      <div
        class="transparent-collapse collapse rounded-none shadow-none"
        :class="expanded ? 'collapse-open' : ''"
      >
        <div class="collapse-content p-0">
          <div v-if="expanded" class="grid grid-cols-1 gap-3">
            <div class="text-xs opacity-70">
              {{ managedMode ? $t('configManagedEditorTip') : $t('mihomoConfigEditorTip') }}
            </div>

            <div v-if="managedMode" class="flex flex-wrap items-center gap-2">
              <button class="btn btn-sm" @click="copyFromManaged('active')" :disabled="busyAny">{{ $t('configLoadActiveToDraft') }}</button>
              <button class="btn btn-sm" @click="copyFromManaged('baseline')" :disabled="busyAny || !managedState?.baseline?.exists">{{ $t('configLoadBaselineToDraft') }}</button>
              <button class="btn btn-sm" @click="saveDraft" :disabled="busyAny">{{ $t('saveDraft') }}</button>
              <button class="btn btn-sm" @click="validateDraft" :disabled="busyAny">{{ $t('configValidateDraft') }}</button>
              <button class="btn btn-sm" @click="applyDraft" :disabled="busyAny">{{ $t('configApplyDraft') }}</button>
              <button class="btn btn-sm btn-ghost" @click="setBaselineFromActive" :disabled="busyAny || !managedState?.active?.exists">{{ $t('configPromoteActiveToBaseline') }}</button>
              <button class="btn btn-sm btn-warning" @click="restoreBaseline" :disabled="busyAny || !managedState?.baseline?.exists">{{ $t('configRestoreBaseline') }}</button>
            </div>
            <div v-else class="flex flex-wrap items-center gap-2">
              <button class="btn btn-sm" :class="legacyLoadBusy && 'loading'" @click="legacyLoad">{{ $t('load') }}</button>
              <button class="btn btn-sm" :class="legacyApplyBusy && 'loading'" @click="legacyApply">{{ $t('applyAndReload') }}</button>
              <button class="btn btn-sm" :class="legacyRestartBusy && 'loading'" @click="legacyRestart">{{ $t('restartCore') }}</button>
            </div>

            <textarea
              class="textarea textarea-sm h-[70vh] min-h-[28rem] w-full resize-y overflow-x-auto whitespace-pre font-mono leading-5 [tab-size:2]"
              wrap="off"
              v-model="payload"
              :placeholder="$t('pasteYamlHere')"
            ></textarea>

            <div class="flex flex-wrap items-center justify-between gap-2 text-xs">
              <div class="opacity-60">
                {{ managedMode ? $t('configDraftRemoteSaved') : $t('mihomoConfigDraftSaved') }}
              </div>
              <button class="btn btn-ghost btn-sm" @click="clearDraft">{{ $t('clearDraft') }}</button>
            </div>

            <div v-if="validationOutput" class="rounded-box border border-base-content/10 bg-base-200/40 p-3 text-xs">
              <div class="flex flex-wrap items-center gap-2">
                <span class="badge" :class="validationOk ? 'badge-success' : 'badge-error'">{{ validationOk ? $t('configValidationOk') : $t('configValidationFailed') }}</span>
                <span v-if="validationCmd" class="badge badge-ghost font-mono">{{ validationCmd }}</span>
              </div>
              <pre class="mt-2 whitespace-pre-wrap break-words font-mono text-[11px] opacity-80">{{ validationOutput }}</pre>
            </div>

            <div class="rounded-box border border-base-content/10 bg-base-200/40 p-3 text-xs">
              <div class="mb-2 flex flex-wrap items-start justify-between gap-2">
                <div>
                  <div class="font-semibold">{{ $t('configOverviewTitle') }}</div>
                  <div class="opacity-70">{{ $t('configOverviewTip') }}</div>
                </div>
                <div class="flex flex-wrap items-center gap-2">
                  <span class="badge badge-ghost">{{ $t('configOverviewRows', { count: overviewSummary.stats.totalLines }) }}</span>
                  <span class="badge badge-ghost">{{ $t('configOverviewSectionsCount', { count: overviewSummary.topLevelSections.length }) }}</span>
                  <label class="flex items-center gap-2">
                    <span class="opacity-70">{{ $t('configOverviewSource') }}</span>
                    <select v-model="overviewSource" class="select select-xs max-w-[220px]">
                      <option v-for="option in diffSourceOptions" :key="`overview-${option.value}`" :value="option.value" :disabled="option.disabled">
                        {{ option.label }}
                      </option>
                    </select>
                  </label>
                </div>
              </div>

              <div v-if="!overviewHasContent" class="rounded-lg border border-dashed border-base-content/15 bg-base-100/50 p-3 opacity-70">
                {{ $t('configOverviewEmpty') }}
              </div>

              <div v-else class="space-y-3">
                <div class="grid grid-cols-1 gap-2 xl:grid-cols-2">
                  <div class="rounded-lg border border-base-content/10 bg-base-100/60 p-3">
                    <div class="font-semibold">{{ $t('configOverviewModeTitle') }}</div>
                    <div class="mt-2 grid grid-cols-1 gap-2 md:grid-cols-2">
                      <div>
                        <div class="opacity-60">{{ $t('configOverviewMode') }}</div>
                        <div class="mt-1">{{ overviewText(overviewSummary.scalars.mode) }}</div>
                      </div>
                      <div>
                        <div class="opacity-60">{{ $t('configOverviewLogLevel') }}</div>
                        <div class="mt-1">{{ overviewText(overviewSummary.scalars.logLevel) }}</div>
                      </div>
                      <div>
                        <div class="opacity-60">{{ $t('configOverviewAllowLan') }}</div>
                        <div class="mt-1">{{ overviewBoolText(overviewSummary.scalars.allowLan) }}</div>
                      </div>
                      <div>
                        <div class="opacity-60">{{ $t('configOverviewIpv6') }}</div>
                        <div class="mt-1">{{ overviewBoolText(overviewSummary.scalars.ipv6) }}</div>
                      </div>
                      <div>
                        <div class="opacity-60">{{ $t('configOverviewUnifiedDelay') }}</div>
                        <div class="mt-1">{{ overviewBoolText(overviewSummary.scalars.unifiedDelay) }}</div>
                      </div>
                      <div>
                        <div class="opacity-60">{{ $t('configOverviewFindProcessMode') }}</div>
                        <div class="mt-1">{{ overviewText(overviewSummary.scalars.findProcessMode) }}</div>
                      </div>
                    </div>
                  </div>

                  <div class="rounded-lg border border-base-content/10 bg-base-100/60 p-3">
                    <div class="font-semibold">{{ $t('configOverviewPortsTitle') }}</div>
                    <div class="mt-2 grid grid-cols-2 gap-2 md:grid-cols-3">
                      <div>
                        <div class="opacity-60">{{ $t('configOverviewMixedPort') }}</div>
                        <div class="mt-1">{{ overviewText(overviewSummary.scalars.mixedPort) }}</div>
                      </div>
                      <div>
                        <div class="opacity-60">{{ $t('configOverviewPort') }}</div>
                        <div class="mt-1">{{ overviewText(overviewSummary.scalars.port) }}</div>
                      </div>
                      <div>
                        <div class="opacity-60">{{ $t('configOverviewSocksPort') }}</div>
                        <div class="mt-1">{{ overviewText(overviewSummary.scalars.socksPort) }}</div>
                      </div>
                      <div>
                        <div class="opacity-60">{{ $t('configOverviewRedirPort') }}</div>
                        <div class="mt-1">{{ overviewText(overviewSummary.scalars.redirPort) }}</div>
                      </div>
                      <div>
                        <div class="opacity-60">{{ $t('configOverviewTproxyPort') }}</div>
                        <div class="mt-1">{{ overviewText(overviewSummary.scalars.tproxyPort) }}</div>
                      </div>
                      <div>
                        <div class="opacity-60">{{ $t('configOverviewController') }}</div>
                        <div class="mt-1 break-all font-mono text-[11px]">{{ overviewText(overviewSummary.scalars.controller) }}</div>
                      </div>
                    </div>
                    <div class="mt-2 text-[11px] opacity-70">
                      {{ $t('configOverviewSecretState') }}: {{ overviewText(overviewSummary.scalars.secretState) }}
                    </div>
                  </div>
                </div>

                <div class="grid grid-cols-1 gap-2 xl:grid-cols-2">
                  <div class="rounded-lg border border-base-content/10 bg-base-100/60 p-3">
                    <div class="font-semibold">{{ $t('configOverviewModulesTitle') }}</div>
                    <div class="mt-2 flex flex-wrap gap-2">
                      <span class="badge badge-outline" :class="sectionStateBadgeClass(overviewSummary.sections.tun)">{{ $t('configOverviewTun') }}: {{ sectionStateText(overviewSummary.sections.tun) }}</span>
                      <span class="badge badge-outline" :class="sectionStateBadgeClass(overviewSummary.sections.dns)">{{ $t('configOverviewDns') }}: {{ sectionStateText(overviewSummary.sections.dns) }}</span>
                      <span class="badge badge-outline" :class="sectionStateBadgeClass(overviewSummary.sections.profile)">{{ $t('configOverviewProfile') }}: {{ sectionStateText(overviewSummary.sections.profile) }}</span>
                      <span class="badge badge-outline" :class="sectionStateBadgeClass(overviewSummary.sections.sniffer)">{{ $t('configOverviewSniffer') }}: {{ sectionStateText(overviewSummary.sections.sniffer) }}</span>
                    </div>
                    <div class="mt-2 grid grid-cols-1 gap-2 md:grid-cols-2">
                      <div>
                        <div class="opacity-60">{{ $t('configOverviewGeodataMode') }}</div>
                        <div class="mt-1">{{ overviewText(overviewSummary.scalars.geodataMode) }}</div>
                      </div>
                      <div>
                        <div class="opacity-60">{{ $t('configOverviewTopLevelSections') }}</div>
                        <div class="mt-1 flex flex-wrap gap-1">
                          <span v-for="section in overviewSummary.topLevelSections" :key="section" class="badge badge-ghost badge-sm">{{ section }}</span>
                        </div>
                      </div>
                    </div>
                  </div>

                  <div class="rounded-lg border border-base-content/10 bg-base-100/60 p-3">
                    <div class="font-semibold">{{ $t('configOverviewRoutingTitle') }}</div>
                    <div class="mt-2 grid grid-cols-2 gap-2 md:grid-cols-3">
                      <div class="rounded-lg border border-base-content/10 bg-base-100/70 p-2">
                        <div class="opacity-60">{{ $t('configOverviewProxiesCount') }}</div>
                        <div class="mt-1 text-lg font-semibold">{{ overviewSummary.counts.proxies }}</div>
                      </div>
                      <div class="rounded-lg border border-base-content/10 bg-base-100/70 p-2">
                        <div class="opacity-60">{{ $t('configOverviewProxyGroupsCount') }}</div>
                        <div class="mt-1 text-lg font-semibold">{{ overviewSummary.counts.proxyGroups }}</div>
                      </div>
                      <div class="rounded-lg border border-base-content/10 bg-base-100/70 p-2">
                        <div class="opacity-60">{{ $t('configOverviewRulesCount') }}</div>
                        <div class="mt-1 text-lg font-semibold">{{ overviewSummary.counts.rules }}</div>
                      </div>
                      <div class="rounded-lg border border-base-content/10 bg-base-100/70 p-2">
                        <div class="opacity-60">{{ $t('configOverviewProxyProvidersCount') }}</div>
                        <div class="mt-1 text-lg font-semibold">{{ overviewSummary.counts.proxyProviders }}</div>
                      </div>
                      <div class="rounded-lg border border-base-content/10 bg-base-100/70 p-2">
                        <div class="opacity-60">{{ $t('configOverviewRuleProvidersCount') }}</div>
                        <div class="mt-1 text-lg font-semibold">{{ overviewSummary.counts.ruleProviders }}</div>
                      </div>
                      <div class="rounded-lg border border-base-content/10 bg-base-100/70 p-2">
                        <div class="opacity-60">{{ $t('configOverviewNonEmptyRows') }}</div>
                        <div class="mt-1 text-lg font-semibold">{{ overviewSummary.stats.nonEmptyLines }}</div>
                      </div>
                    </div>
                    <div class="mt-2 text-[11px] opacity-70">{{ $t('configOverviewCommentRows', { count: overviewSummary.stats.commentLines }) }}</div>
                  </div>
                </div>

                <div class="text-[11px] opacity-60">{{ $t('configOverviewApproximate') }}</div>
              </div>
            </div>

            <div v-if="lastAction" class="rounded-box border border-base-content/10 bg-base-200/40 p-3 text-xs">
              <div class="mb-2 flex flex-wrap items-start justify-between gap-2">
                <div>
                  <div class="font-semibold">{{ $t('configDiagnosticsTitle') }}</div>
                  <div class="opacity-70">{{ $t('configDiagnosticsTip') }}</div>
                </div>
                <div class="flex flex-wrap items-center gap-2">
                  <span class="badge" :class="lastAction.ok ? 'badge-success' : 'badge-error'">{{ lastAction.ok ? $t('configDiagStatusOk') : $t('configDiagStatusFailed') }}</span>
                  <span class="badge badge-outline">{{ actionTypeText(lastAction.kind) }}</span>
                  <span v-if="hasText(lastAction.phase)" class="badge badge-ghost">{{ phaseText(lastAction.phase) }}</span>
                  <span v-if="hasText(lastAction.recovery) && lastAction.recovery !== 'none'" class="badge badge-warning badge-outline">{{ recoveryText(lastAction.recovery) }}</span>
                </div>
              </div>

              <div class="grid grid-cols-1 gap-2 md:grid-cols-2 xl:grid-cols-3">
                <div class="rounded-lg border border-base-content/10 bg-base-100/60 p-2">
                  <div class="opacity-60">{{ $t('configDiagAction') }}</div>
                  <div class="mt-1">{{ actionTypeText(lastAction.kind) }}</div>
                </div>
                <div class="rounded-lg border border-base-content/10 bg-base-100/60 p-2">
                  <div class="opacity-60">{{ $t('configDiagPhase') }}</div>
                  <div class="mt-1">{{ phaseText(lastAction.phase) }}</div>
                </div>
                <div class="rounded-lg border border-base-content/10 bg-base-100/60 p-2">
                  <div class="opacity-60">{{ $t('configDiagSource') }}</div>
                  <div class="mt-1">{{ sourceText(lastAction.source) }}</div>
                </div>
                <div v-if="hasText(lastAction.validateCmd)" class="rounded-lg border border-base-content/10 bg-base-100/60 p-2">
                  <div class="opacity-60">{{ $t('configDiagValidateCommand') }}</div>
                  <div class="mt-1 break-all font-mono text-[11px]">{{ lastAction.validateCmd }}</div>
                </div>
                <div v-if="lastAction.exitCode !== null && lastAction.exitCode !== undefined && lastAction.exitCode !== ''" class="rounded-lg border border-base-content/10 bg-base-100/60 p-2">
                  <div class="opacity-60">{{ $t('configDiagExitCode') }}</div>
                  <div class="mt-1">{{ String(lastAction.exitCode) }}</div>
                </div>
                <div v-if="hasText(lastAction.restartMethod)" class="rounded-lg border border-base-content/10 bg-base-100/60 p-2">
                  <div class="opacity-60">{{ $t('configDiagRestartMethod') }}</div>
                  <div class="mt-1">{{ lastAction.restartMethod }}</div>
                </div>
                <div v-if="hasText(lastAction.recovery)" class="rounded-lg border border-base-content/10 bg-base-100/60 p-2">
                  <div class="opacity-60">{{ $t('configDiagRecovery') }}</div>
                  <div class="mt-1">{{ recoveryText(lastAction.recovery) }}</div>
                </div>
                <div v-if="hasText(lastAction.restored)" class="rounded-lg border border-base-content/10 bg-base-100/60 p-2">
                  <div class="opacity-60">{{ $t('configDiagRestored') }}</div>
                  <div class="mt-1">{{ recoveryText(lastAction.restored) }}</div>
                </div>
                <div v-if="hasText(lastAction.updatedAt)" class="rounded-lg border border-base-content/10 bg-base-100/60 p-2">
                  <div class="opacity-60">{{ $t('updatedAt') }}</div>
                  <div class="mt-1">{{ fmtTextTs(lastAction.updatedAt) }}</div>
                </div>
                <div class="rounded-lg border border-base-content/10 bg-base-100/60 p-2">
                  <div class="opacity-60">{{ $t('configDiagCapturedAt') }}</div>
                  <div class="mt-1">{{ fmtTextTs(lastAction.at) }}</div>
                </div>
              </div>

              <div class="mt-2 grid grid-cols-1 gap-2 xl:grid-cols-3">
                <div v-if="hasText(lastAction.error)" class="rounded-lg border border-warning/20 bg-warning/5 p-2">
                  <div class="font-semibold text-warning">{{ $t('configDiagError') }}</div>
                  <pre class="mt-1 whitespace-pre-wrap break-words font-mono text-[11px] opacity-90">{{ lastAction.error }}</pre>
                </div>
                <div v-if="hasText(lastAction.output)" class="rounded-lg border border-base-content/10 bg-base-100/60 p-2">
                  <div class="font-semibold">{{ $t('configDiagOutput') }}</div>
                  <pre class="mt-1 whitespace-pre-wrap break-words font-mono text-[11px] opacity-90">{{ lastAction.output }}</pre>
                </div>
                <div v-if="hasText(lastAction.restartOutput)" class="rounded-lg border border-base-content/10 bg-base-100/60 p-2">
                  <div class="font-semibold">{{ $t('configDiagRestartOutput') }}</div>
                  <pre class="mt-1 whitespace-pre-wrap break-words font-mono text-[11px] opacity-90">{{ lastAction.restartOutput }}</pre>
                </div>
                <div v-if="hasText(lastAction.firstRestartOutput)" class="rounded-lg border border-base-content/10 bg-base-100/60 p-2">
                  <div class="font-semibold">{{ $t('configDiagFirstRestartOutput') }}</div>
                  <div v-if="hasText(lastAction.firstRestartMethod)" class="mt-1 opacity-60">{{ $t('configDiagRestartMethod') }}: {{ lastAction.firstRestartMethod }}</div>
                  <pre class="mt-1 whitespace-pre-wrap break-words font-mono text-[11px] opacity-90">{{ lastAction.firstRestartOutput }}</pre>
                </div>
                <div v-if="hasText(lastAction.rollbackRestartOutput)" class="rounded-lg border border-base-content/10 bg-base-100/60 p-2">
                  <div class="font-semibold">{{ $t('configDiagRollbackOutput') }}</div>
                  <div v-if="hasText(lastAction.rollbackRestartMethod)" class="mt-1 opacity-60">{{ $t('configDiagRestartMethod') }}: {{ lastAction.rollbackRestartMethod }}</div>
                  <pre class="mt-1 whitespace-pre-wrap break-words font-mono text-[11px] opacity-90">{{ lastAction.rollbackRestartOutput }}</pre>
                </div>
                <div v-if="hasText(lastAction.baselineRestartOutput)" class="rounded-lg border border-base-content/10 bg-base-100/60 p-2">
                  <div class="font-semibold">{{ $t('configDiagBaselineOutput') }}</div>
                  <div v-if="hasText(lastAction.baselineRestartMethod)" class="mt-1 opacity-60">{{ $t('configDiagRestartMethod') }}: {{ lastAction.baselineRestartMethod }}</div>
                  <pre class="mt-1 whitespace-pre-wrap break-words font-mono text-[11px] opacity-90">{{ lastAction.baselineRestartOutput }}</pre>
                </div>
              </div>
            </div>

            <div v-if="managedMode" class="rounded-box border border-base-content/10 bg-base-200/40 p-3 text-xs">
              <div class="mb-2 flex flex-wrap items-center justify-between gap-2">
                <div>
                  <div class="font-semibold">{{ $t('configDiffTitle') }}</div>
                  <div class="opacity-70">{{ $t('configDiffTip') }}</div>
                </div>
                <div class="flex flex-wrap items-center gap-2">
                  <label class="label cursor-pointer gap-2 py-0">
                    <span class="label-text text-xs">{{ $t('configDiffOnlyChanges') }}</span>
                    <input v-model="compareChangesOnly" type="checkbox" class="toggle toggle-sm" />
                  </label>
                  <button class="btn btn-xs btn-ghost" @click="swapDiffSources">{{ $t('configSwapCompareSides') }}</button>
                </div>
              </div>

              <div class="grid grid-cols-1 gap-2 lg:grid-cols-[minmax(0,1fr)_auto_minmax(0,1fr)] lg:items-end">
                <label class="form-control gap-1">
                  <span class="label-text text-[11px] opacity-70">{{ $t('configCompareLeft') }}</span>
                  <select v-model="compareLeft" class="select select-sm">
                    <option v-for="option in diffSourceOptions" :key="`left-${option.value}`" :value="option.value" :disabled="option.disabled">
                      {{ option.label }}
                    </option>
                  </select>
                </label>

                <div class="hidden justify-center pb-2 text-lg opacity-40 lg:flex">⇄</div>

                <label class="form-control gap-1">
                  <span class="label-text text-[11px] opacity-70">{{ $t('configCompareRight') }}</span>
                  <select v-model="compareRight" class="select select-sm">
                    <option v-for="option in diffSourceOptions" :key="`right-${option.value}`" :value="option.value" :disabled="option.disabled">
                      {{ option.label }}
                    </option>
                  </select>
                </label>
              </div>

              <div class="mt-2 flex flex-wrap items-center gap-2">
                <span class="badge badge-ghost">{{ $t('configDiffRowsCount', { count: diffRows.length }) }}</span>
                <span class="badge badge-success badge-outline">{{ $t('configDiffAddedCount', { count: diffSummary.added }) }}</span>
                <span class="badge badge-error badge-outline">{{ $t('configDiffRemovedCount', { count: diffSummary.removed }) }}</span>
                <span class="badge badge-ghost">{{ $t('configDiffContextCount', { count: diffSummary.context }) }}</span>
              </div>

              <div v-if="!diffRowsVisible.length" class="mt-2 opacity-60">
                {{ diffHasChanges ? $t('configDiffHiddenByFilter') : $t('configDiffNoChanges') }}
              </div>

              <div v-else class="mt-2 max-h-[28rem] overflow-auto rounded-lg border border-base-content/10 bg-base-100/60">
                <table class="table table-xs w-full font-mono">
                  <thead class="sticky top-0 z-10 bg-base-100/95 text-[10px] uppercase tracking-[0.08em] opacity-70">
                    <tr>
                      <th class="w-12 text-right">#</th>
                      <th>{{ diffSourceLabel(compareLeftResolved) }}</th>
                      <th class="w-12 text-right">#</th>
                      <th>{{ diffSourceLabel(compareRightResolved) }}</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr
                      v-for="(row, index) in diffRowsVisible"
                      :key="`${row.type}-${row.leftNo ?? 'n'}-${row.rightNo ?? 'n'}-${index}`"
                      :class="row.type === 'add' ? 'bg-success/10' : row.type === 'remove' ? 'bg-error/10' : ''"
                    >
                      <td class="w-12 select-none text-right align-top opacity-50">{{ row.leftNo ?? '' }}</td>
                      <td class="whitespace-pre-wrap break-all align-top">{{ row.leftText }}</td>
                      <td class="w-12 select-none text-right align-top opacity-50">{{ row.rightNo ?? '' }}</td>
                      <td class="whitespace-pre-wrap break-all align-top">{{ row.rightText }}</td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>

            <div v-if="managedMode" class="rounded-box border border-base-content/10 bg-base-200/40 p-3 text-xs">
              <div class="mb-2 flex flex-wrap items-center justify-between gap-2">
                <div class="font-semibold">{{ $t('configHistoryTitle') }}</div>
                <button class="btn btn-xs btn-ghost" @click="loadHistory" :disabled="historyBusy">{{ $t('refresh') }}</button>
              </div>
              <div v-if="!historyItems.length" class="opacity-60">{{ $t('configHistoryEmpty') }}</div>
              <div v-else class="space-y-2">
                <div
                  v-for="item in historyItems"
                  :key="`${item.rev}-${item.current ? 'current' : 'old'}`"
                  class="flex flex-wrap items-center justify-between gap-2 rounded-lg border border-base-content/10 bg-base-100/60 p-2"
                >
                  <div>
                    <div class="flex flex-wrap items-center gap-2">
                      <span class="font-mono">rev {{ item.rev }}</span>
                      <span v-if="item.current" class="badge badge-primary badge-xs">{{ $t('current') }}</span>
                      <span v-if="item.source" class="badge badge-ghost badge-xs">{{ sourceText(item.source) }}</span>
                    </div>
                    <div class="mt-1 opacity-70">{{ fmtTextTs(item.updatedAt) }}</div>
                  </div>
                  <div class="flex flex-wrap items-center gap-2">
                    <button class="btn btn-ghost btn-xs" @click="loadHistoryRev(item.rev)">{{ $t('configLoadIntoEditor') }}</button>
                    <button v-if="!item.current" class="btn btn-ghost btn-xs" @click="restoreHistoryRev(item.rev)">{{ $t('configRestoreRevision') }}</button>
                  </div>
                </div>
              </div>
            </div>

            <div class="text-xs opacity-60">
              {{ managedMode ? $t('configManagedFallbackNote') : $t('mihomoConfigLoadNote') }}
            </div>
          </div>
        </div>
      </div>

      <div class="text-xs opacity-60" v-if="!expanded">
        {{ $t('configCollapsedTip') }}
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import {
  agentMihomoConfigAPI,
  agentMihomoConfigManagedApplyAPI,
  agentMihomoConfigManagedCopyAPI,
  agentMihomoConfigManagedGetAPI,
  agentMihomoConfigManagedGetRevAPI,
  agentMihomoConfigManagedHistoryAPI,
  agentMihomoConfigManagedPutDraftAPI,
  agentMihomoConfigManagedRestoreBaselineAPI,
  agentMihomoConfigManagedRestoreRevAPI,
  agentMihomoConfigManagedSetBaselineFromActiveAPI,
  agentMihomoConfigManagedValidateAPI,
  agentMihomoConfigStateAPI,
  type MihomoConfigHistoryItem,
  type MihomoConfigManagedState,
} from '@/api/agent'
import { getConfigsAPI, getConfigsRawAPI, reloadConfigsAPI, restartCoreAPI } from '@/api'
import { decodeB64Utf8 } from '@/helper/b64'
import { showNotification } from '@/helper/notification'
import { agentEnabled } from '@/store/agent'
import { useStorage } from '@vueuse/core'
import { ChevronDownIcon, ChevronUpIcon } from '@heroicons/vue/24/outline'
import axios from 'axios'
import { computed, onMounted, ref } from 'vue'
import { useI18n } from 'vue-i18n'

const path = useStorage('config/mihomo-config-path', '/opt/etc/mihomo/config.yaml')
const payload = useStorage('config/mihomo-config-payload', '')
const expanded = useStorage('config/mihomo-config-expanded', false)
const compareLeft = useStorage<DiffSourceKind>('config/mihomo-config-diff-left', 'active')
const compareRight = useStorage<DiffSourceKind>('config/mihomo-config-diff-right', 'draft')
const compareChangesOnly = useStorage('config/mihomo-config-diff-only-changes', true)
const overviewSource = useStorage<DiffSourceKind>('config/mihomo-config-overview-source', 'draft')

const { t } = useI18n()

const refreshBusy = ref(false)
const historyBusy = ref(false)
const actionBusy = ref(false)
const managedState = ref<MihomoConfigManagedState | null>(null)
const historyItems = ref<MihomoConfigHistoryItem[]>([])
const validationOutput = ref('')
const validationCmd = ref('')
const validationOk = ref(false)

type ConfigActionKind = 'validate' | 'apply' | 'restore-baseline' | 'restore-revision'
type ConfigActionDiagnostic = {
  kind: ConfigActionKind
  ok: boolean
  phase?: string
  source?: string
  recovery?: string
  restored?: string
  validateCmd?: string
  exitCode?: number | string
  restartMethod?: string
  restartOutput?: string
  firstRestartMethod?: string
  firstRestartOutput?: string
  rollbackRestartMethod?: string
  rollbackRestartOutput?: string
  baselineRestartMethod?: string
  baselineRestartOutput?: string
  error?: string
  output?: string
  updatedAt?: string
  at: string
}

const lastAction = ref<ConfigActionDiagnostic | null>(null)

type DiffSourceKind = 'active' | 'draft' | 'baseline' | 'editor'
type ManagedPayloadKind = Exclude<DiffSourceKind, 'editor'>
type DiffRow = {
  type: 'context' | 'add' | 'remove'
  leftNo: number | null
  rightNo: number | null
  leftText: string
  rightText: string
}

type ConfigOverviewSectionState = 'enabled' | 'disabled' | 'present' | 'missing'

type ConfigOverview = {
  topLevelSections: string[]
  counts: {
    proxies: number
    proxyGroups: number
    rules: number
    proxyProviders: number
    ruleProviders: number
  }
  scalars: {
    mode: string
    logLevel: string
    allowLan: string
    ipv6: string
    unifiedDelay: string
    findProcessMode: string
    geodataMode: string
    controller: string
    secretState: string
    port: string
    mixedPort: string
    socksPort: string
    redirPort: string
    tproxyPort: string
  }
  sections: {
    tun: ConfigOverviewSectionState
    dns: ConfigOverviewSectionState
    profile: ConfigOverviewSectionState
    sniffer: ConfigOverviewSectionState
  }
  stats: {
    totalLines: number
    nonEmptyLines: number
    commentLines: number
  }
}

const managedPayloads = ref<Record<ManagedPayloadKind, string>>({
  active: '',
  draft: '',
  baseline: '',
})

const legacyLoadBusy = ref(false)
const legacyApplyBusy = ref(false)
const legacyRestartBusy = ref(false)

const currentPath = computed(() => managedMode.value ? (managedState.value?.active?.path || path.value) : path.value)
const managedMode = computed(() => agentEnabled.value && Boolean(managedState.value?.ok))
const busyAny = computed(() => refreshBusy.value || historyBusy.value || actionBusy.value)

const fmtTextTs = (value?: string) => {
  const s = String(value || '').trim()
  if (!s) return '—'
  const d = new Date(s)
  if (Number.isNaN(d.getTime())) return s
  return d.toLocaleString()
}

const fmtBytes = (value?: number) => {
  const n = Number(value || 0)
  if (!Number.isFinite(n) || n <= 0) return '0 B'
  if (n < 1024) return `${n} B`
  if (n < 1024 * 1024) return `${(n / 1024).toFixed(1)} KB`
  return `${(n / 1024 / 1024).toFixed(2)} MB`
}

const managedStatusText = computed(() => {
  const status = String(managedState.value?.lastApplyStatus || '').trim()
  switch (status) {
    case 'ok':
      return 'OK'
    case 'validate-failed':
      return 'validate failed'
    case 'rolled-back':
      return 'rolled back'
    case 'restored-baseline':
      return 'baseline restored'
    case 'failed':
      return 'failed'
    default:
      return 'idle'
  }
})

const managedStatusBadgeClass = computed(() => {
  const status = String(managedState.value?.lastApplyStatus || '').trim()
  if (status === 'ok') return 'badge-success'
  if (status === 'rolled-back' || status === 'restored-baseline') return 'badge-warning'
  if (status === 'validate-failed' || status === 'failed') return 'badge-error'
  return 'badge-ghost'
})

const hasText = (value?: string | number | null) => String(value ?? '').trim().length > 0

const actionTypeText = (kind?: string) => {
  switch (kind) {
    case 'validate':
      return t('configDiagActionValidate')
    case 'apply':
      return t('configDiagActionApply')
    case 'restore-baseline':
      return t('configDiagActionRestoreBaseline')
    case 'restore-revision':
      return t('configDiagActionRestoreRevision')
    default:
      return '—'
  }
}

const phaseText = (phase?: string) => {
  switch (String(phase || '').trim()) {
    case 'validate':
      return t('configDiagPhaseValidate')
    case 'apply':
      return t('configDiagPhaseApply')
    case 'restart':
      return t('configDiagPhaseRestart')
    default:
      return '—'
  }
}

const recoveryText = (value?: string) => {
  switch (String(value || '').trim()) {
    case 'none':
      return t('configDiagRecoveryNone')
    case 'previous-active':
      return t('configDiagRecoveryPreviousActive')
    case 'baseline':
      return t('configDiagRecoveryBaseline')
    case 'failed':
      return t('configDiagRecoveryFailed')
    default:
      return value || '—'
  }
}

const sourceText = (value?: string) => {
  const source = String(value || '').trim()
  if (!source) return '—'
  if (source === 'draft') return t('configCompareSourceDraft')
  if (source === 'baseline') return t('configCompareSourceBaseline')
  if (source === 'active') return t('configCompareSourceActive')
  if (source.startsWith('history:')) return `${t('configHistoryRevisionLabel')} ${source.slice('history:'.length)}`
  return source
}

const setLastAction = (next: Omit<ConfigActionDiagnostic, 'at'>) => {
  lastAction.value = {
    ...next,
    at: new Date().toISOString(),
  }
}

const fetchManagedPayloadText = async (kind: ManagedPayloadKind): Promise<string> => {
  const r = await agentMihomoConfigManagedGetAPI(kind)
  if (!r.ok || !r.contentB64) return ''
  return decodeB64Utf8(r.contentB64)
}

const refreshManagedPayloads = async (state: MihomoConfigManagedState) => {
  const next: Record<ManagedPayloadKind, string> = {
    active: '',
    draft: '',
    baseline: '',
  }

  const kinds: ManagedPayloadKind[] = ['active', 'draft', 'baseline']
  await Promise.all(kinds.map(async (kind) => {
    if (state[kind]?.exists) {
      next[kind] = await fetchManagedPayloadText(kind)
    }
  }))

  managedPayloads.value = next
  return next
}

const loadHistory = async () => {
  if (!agentEnabled.value) return
  historyBusy.value = true
  try {
    const r = await agentMihomoConfigManagedHistoryAPI()
    historyItems.value = Array.isArray(r.items) ? r.items : []
  } finally {
    historyBusy.value = false
  }
}

const refreshManaged = async (loadEditor = false) => {
  const state = await agentMihomoConfigStateAPI()
  managedState.value = state
  if (!state.ok) return false

  const managedTexts = await refreshManagedPayloads(state)

  if (loadEditor) {
    if (state.draft?.exists) {
      payload.value = managedTexts.draft
      path.value = state.draft?.path || path.value
    } else if (state.active?.exists) {
      payload.value = managedTexts.active
      path.value = state.active?.path || path.value
    }
  }
  await loadHistory()
  return true
}

const refreshAll = async (loadEditor = false) => {
  if (refreshBusy.value) return
  refreshBusy.value = true
  try {
    if (agentEnabled.value) {
      const ok = await refreshManaged(loadEditor)
      if (ok) return
    }
    await legacyLoad()
  } finally {
    refreshBusy.value = false
  }
}

const ensureDraftSaved = async () => {
  const r = await agentMihomoConfigManagedPutDraftAPI(payload.value || '')
  if (!r.ok) {
    throw new Error(r.error || 'save-failed')
  }
  await refreshManaged(false)
}

const saveDraft = async () => {
  if (!managedMode.value || actionBusy.value) return
  actionBusy.value = true
  try {
    await ensureDraftSaved()
    showNotification({ content: 'configDraftSavedRemoteSuccess', type: 'alert-success' })
  } catch (e: any) {
    showNotification({ content: 'configDraftSaveFailed', params: { error: e?.message || 'failed' }, type: 'alert-error' })
  } finally {
    actionBusy.value = false
  }
}

const copyFromManaged = async (from: 'active' | 'baseline') => {
  if (!managedMode.value || actionBusy.value) return
  actionBusy.value = true
  try {
    const r = await agentMihomoConfigManagedCopyAPI(from)
    if (!r.ok) throw new Error(r.error || 'copy-failed')
    await refreshManaged(false)
    payload.value = managedPayloads.value.draft
    validationOutput.value = ''
    showNotification({ content: from === 'active' ? 'configDraftLoadedFromActive' : 'configDraftLoadedFromBaseline', type: 'alert-success' })
  } catch (e: any) {
    showNotification({ content: 'configDraftCopyFailed', params: { error: e?.message || 'failed' }, type: 'alert-error' })
  } finally {
    actionBusy.value = false
  }
}

const validateDraft = async () => {
  if (!managedMode.value || actionBusy.value) return
  actionBusy.value = true
  try {
    await ensureDraftSaved()
    const r = await agentMihomoConfigManagedValidateAPI('draft')
    validationOk.value = Boolean(r.ok)
    validationCmd.value = String(r.cmd || '')
    validationOutput.value = String(r.output || r.error || '')
    setLastAction({
      kind: 'validate',
      ok: Boolean(r.ok),
      phase: r.phase || 'validate',
      source: r.source || 'draft',
      validateCmd: String(r.cmd || ''),
      exitCode: r.exitCode,
      output: String(r.output || ''),
      error: String(r.error || ''),
    })
    showNotification({ content: r.ok ? 'configValidationSuccess' : 'configValidationFailedToast', type: r.ok ? 'alert-success' : 'alert-error' })
  } catch (e: any) {
    validationOk.value = false
    validationCmd.value = ''
    validationOutput.value = e?.message || 'failed'
    setLastAction({
      kind: 'validate',
      ok: false,
      phase: 'validate',
      source: 'draft',
      error: e?.message || 'failed',
    })
    showNotification({ content: 'configValidationFailedToast', type: 'alert-error' })
  } finally {
    actionBusy.value = false
  }
}

const applyDraft = async () => {
  if (!managedMode.value || actionBusy.value) return
  actionBusy.value = true
  try {
    await ensureDraftSaved()
    const r = await agentMihomoConfigManagedApplyAPI()
    await refreshManaged(true)
    validationOk.value = Boolean(r.ok)
    validationCmd.value = String(r.validateCmd || '')
    validationOutput.value = String(r.restartOutput || r.output || r.error || '')
    setLastAction({
      kind: 'apply',
      ok: Boolean(r.ok),
      phase: r.phase || (r.ok ? 'apply' : 'restart'),
      source: r.appliedFrom || r.source || 'draft',
      recovery: r.recovery,
      restored: r.restored,
      validateCmd: r.validateCmd,
      restartMethod: r.restartMethod,
      restartOutput: r.restartOutput,
      firstRestartMethod: r.firstRestartMethod,
      firstRestartOutput: r.firstRestartOutput,
      rollbackRestartMethod: r.rollbackRestartMethod,
      rollbackRestartOutput: r.rollbackRestartOutput,
      baselineRestartMethod: r.baselineRestartMethod,
      baselineRestartOutput: r.baselineRestartOutput,
      error: r.error,
      output: r.output,
      updatedAt: r.updatedAt,
    })
    if (!r.ok) throw new Error(r.error || r.output || r.restartOutput || r.firstRestartOutput || 'apply-failed')
    showNotification({ content: 'configApplySuccess', type: 'alert-success' })
  } catch (e: any) {
    if (!lastAction.value || lastAction.value.kind !== 'apply') {
      setLastAction({
        kind: 'apply',
        ok: false,
        phase: 'apply',
        source: 'draft',
        error: e?.message || 'failed',
      })
    }
    showNotification({ content: 'configApplyFailed', params: { error: e?.message || 'failed' }, type: 'alert-error' })
  } finally {
    actionBusy.value = false
  }
}

const setBaselineFromActive = async () => {
  if (!managedMode.value || actionBusy.value) return
  if (!window.confirm('Сделать текущий активный конфиг новым эталонным?')) return
  actionBusy.value = true
  try {
    const r = await agentMihomoConfigManagedSetBaselineFromActiveAPI()
    if (!r.ok) throw new Error(r.error || 'baseline-failed')
    await refreshManaged(false)
    showNotification({ content: 'configBaselinePromoted', type: 'alert-success' })
  } catch (e: any) {
    showNotification({ content: 'configBaselinePromoteFailed', params: { error: e?.message || 'failed' }, type: 'alert-error' })
  } finally {
    actionBusy.value = false
  }
}

const restoreBaseline = async () => {
  if (!managedMode.value || actionBusy.value) return
  if (!window.confirm('Восстановить эталонный конфиг как активный?')) return
  actionBusy.value = true
  try {
    const r = await agentMihomoConfigManagedRestoreBaselineAPI()
    await refreshManaged(true)
    setLastAction({
      kind: 'restore-baseline',
      ok: Boolean(r.ok),
      phase: r.phase || (r.ok ? 'apply' : 'restart'),
      source: r.source || 'baseline',
      recovery: r.recovery,
      restored: r.restored,
      validateCmd: r.validateCmd,
      restartMethod: r.restartMethod,
      restartOutput: r.restartOutput,
      firstRestartMethod: r.firstRestartMethod,
      firstRestartOutput: r.firstRestartOutput,
      rollbackRestartMethod: r.rollbackRestartMethod,
      rollbackRestartOutput: r.rollbackRestartOutput,
      baselineRestartMethod: r.baselineRestartMethod,
      baselineRestartOutput: r.baselineRestartOutput,
      error: r.error,
      output: r.output,
      updatedAt: r.updatedAt,
    })
    if (!r.ok) throw new Error(r.error || r.output || r.restartOutput || r.firstRestartOutput || 'restore-failed')
    showNotification({ content: 'configBaselineRestored', type: 'alert-success' })
  } catch (e: any) {
    if (!lastAction.value || lastAction.value.kind !== 'restore-baseline') {
      setLastAction({
        kind: 'restore-baseline',
        ok: false,
        phase: 'apply',
        source: 'baseline',
        error: e?.message || 'failed',
      })
    }
    showNotification({ content: 'configBaselineRestoreFailed', params: { error: e?.message || 'failed' }, type: 'alert-error' })
  } finally {
    actionBusy.value = false
  }
}

const loadHistoryRev = async (rev: number) => {
  if (actionBusy.value) return
  actionBusy.value = true
  try {
    const r = await agentMihomoConfigManagedGetRevAPI(rev)
    if (!r.ok || !r.contentB64) throw new Error(r.error || 'not-found')
    payload.value = decodeB64Utf8(r.contentB64)
    validationOutput.value = ''
    validationCmd.value = ''
    showNotification({ content: 'configHistoryLoadedIntoEditor', type: 'alert-success' })
  } catch (e: any) {
    showNotification({ content: 'configHistoryLoadFailed', params: { error: e?.message || 'failed' }, type: 'alert-error' })
  } finally {
    actionBusy.value = false
  }
}

const restoreHistoryRev = async (rev: number) => {
  if (actionBusy.value) return
  if (!window.confirm(`Восстановить ревизию ${rev} как активный конфиг?`)) return
  actionBusy.value = true
  try {
    const r = await agentMihomoConfigManagedRestoreRevAPI(rev)
    await refreshManaged(true)
    setLastAction({
      kind: 'restore-revision',
      ok: Boolean(r.ok),
      phase: r.phase || (r.ok ? 'apply' : 'restart'),
      source: r.source || `history:${rev}`,
      recovery: r.recovery,
      restored: r.restored,
      validateCmd: r.validateCmd,
      restartMethod: r.restartMethod,
      restartOutput: r.restartOutput,
      firstRestartMethod: r.firstRestartMethod,
      firstRestartOutput: r.firstRestartOutput,
      rollbackRestartMethod: r.rollbackRestartMethod,
      rollbackRestartOutput: r.rollbackRestartOutput,
      baselineRestartMethod: r.baselineRestartMethod,
      baselineRestartOutput: r.baselineRestartOutput,
      error: r.error,
      output: r.output,
      updatedAt: r.updatedAt,
    })
    if (!r.ok) throw new Error(r.error || r.output || r.restartOutput || r.firstRestartOutput || 'restore-failed')
    showNotification({ content: 'configHistoryRestoreSuccess', type: 'alert-success' })
  } catch (e: any) {
    if (!lastAction.value || lastAction.value.kind !== 'restore-revision') {
      setLastAction({
        kind: 'restore-revision',
        ok: false,
        phase: 'apply',
        source: `history:${rev}`,
        error: e?.message || 'failed',
      })
    }
    showNotification({ content: 'configHistoryRestoreFailed', params: { error: e?.message || 'failed' }, type: 'alert-error' })
  } finally {
    actionBusy.value = false
  }
}

const diffSourceLabel = (kind: DiffSourceKind) => {
  switch (kind) {
    case 'active':
      return t('configCompareSourceActive')
    case 'draft':
      return t('configCompareSourceDraft')
    case 'baseline':
      return t('configCompareSourceBaseline')
    case 'editor':
    default:
      return t('configCompareSourceEditor')
  }
}

const diffSourceAvailable = (kind: DiffSourceKind) => {
  if (kind === 'editor') return true
  return Boolean(managedState.value?.[kind]?.exists)
}

const normalizeDiffSource = (kind: DiffSourceKind): DiffSourceKind => {
  if (diffSourceAvailable(kind)) return kind
  if (kind !== 'editor') return 'editor'
  return 'editor'
}

const diffSourceOptions = computed(() => ([
  { value: 'active' as DiffSourceKind, label: diffSourceLabel('active'), disabled: !diffSourceAvailable('active') },
  { value: 'draft' as DiffSourceKind, label: diffSourceLabel('draft'), disabled: !diffSourceAvailable('draft') },
  { value: 'baseline' as DiffSourceKind, label: diffSourceLabel('baseline'), disabled: !diffSourceAvailable('baseline') },
  { value: 'editor' as DiffSourceKind, label: diffSourceLabel('editor'), disabled: false },
]))

const overviewSourceResolved = computed<DiffSourceKind>(() => normalizeDiffSource(overviewSource.value as DiffSourceKind))

const emptyConfigOverview = (): ConfigOverview => ({
  topLevelSections: [],
  counts: {
    proxies: 0,
    proxyGroups: 0,
    rules: 0,
    proxyProviders: 0,
    ruleProviders: 0,
  },
  scalars: {
    mode: '',
    logLevel: '',
    allowLan: '',
    ipv6: '',
    unifiedDelay: '',
    findProcessMode: '',
    geodataMode: '',
    controller: '',
    secretState: '',
    port: '',
    mixedPort: '',
    socksPort: '',
    redirPort: '',
    tproxyPort: '',
  },
  sections: {
    tun: 'missing',
    dns: 'missing',
    profile: 'missing',
    sniffer: 'missing',
  },
  stats: {
    totalLines: 0,
    nonEmptyLines: 0,
    commentLines: 0,
  },
})

const unquoteYamlKey = (value: string) => {
  const s = String(value || '').trim()
  if ((s.startsWith("'") && s.endsWith("'")) || (s.startsWith('"') && s.endsWith('"'))) return s.slice(1, -1)
  return s
}

const sanitizeScalarValue = (value: string) => {
  const trimmed = String(value || '').trim()
  if (!trimmed) return ''
  const withoutComment = trimmed.replace(/\s+#.*$/, '').trim()
  if ((withoutComment.startsWith("'") && withoutComment.endsWith("'")) || (withoutComment.startsWith('"') && withoutComment.endsWith('"'))) {
    return withoutComment.slice(1, -1)
  }
  return withoutComment
}

const countListItemsInSection = (lines: string[]) => lines.reduce((acc, line) => acc + (/^\s{2}-\s+/.test(line) ? 1 : 0), 0)

const countMapItemsInSection = (lines: string[]) => lines.reduce((acc, line) => {
  if (/^\s{2}(?:[^#\s][^:]*|"[^"]+"|'[^']+'):\s*(?:#.*)?$/.test(line)) return acc + 1
  return acc
}, 0)

const detectSectionState = (sectionLines: string[] | undefined): ConfigOverviewSectionState => {
  if (!sectionLines || !sectionLines.length) return 'missing'
  const enabledLine = sectionLines.find((line) => /^\s{2}enabled:\s*/.test(line) || /^\s{2}enable:\s*/.test(line))
  if (!enabledLine) return 'present'
  const raw = sanitizeScalarValue(enabledLine.replace(/^\s{2}(?:enabled|enable):\s*/, ''))
  const lowered = raw.toLowerCase()
  if (['true', 'on', 'yes'].includes(lowered)) return 'enabled'
  if (['false', 'off', 'no'].includes(lowered)) return 'disabled'
  return 'present'
}

const buildConfigOverview = (value: string): ConfigOverview => {
  const normalized = normalizeDiffText(value)
  const overview = emptyConfigOverview()
  const trimmed = normalized.trim()
  if (!trimmed) return overview

  const lines = normalized.split('\n')
  overview.stats.totalLines = lines.length
  overview.stats.nonEmptyLines = lines.filter((line) => line.trim().length > 0).length
  overview.stats.commentLines = lines.filter((line) => /^\s*#/.test(line)).length

  const sectionLines: Record<string, string[]> = {}
  let currentTopLevel = ''

  for (const rawLine of lines) {
    const line = rawLine.replace(/\r$/, '')
    const trimmedLine = line.trim()
    if (!trimmedLine.length) {
      if (currentTopLevel) sectionLines[currentTopLevel].push(line)
      continue
    }
    if (/^#/.test(trimmedLine)) {
      if (currentTopLevel) sectionLines[currentTopLevel].push(line)
      continue
    }

    const topMatch = line.match(/^([A-Za-z0-9_.@-]+|"[^"]+"|'[^']+'):\s*(.*)$/)
    if (topMatch && !/^\s/.test(line)) {
      const key = unquoteYamlKey(topMatch[1])
      currentTopLevel = key
      if (!overview.topLevelSections.includes(key)) overview.topLevelSections.push(key)
      sectionLines[key] = []
      const rest = sanitizeScalarValue(topMatch[2])
      if (rest && !['|', '|-', '>', '>-', '{}', '[]'].includes(rest)) {
        switch (key) {
          case 'mode': overview.scalars.mode = rest; break
          case 'log-level': overview.scalars.logLevel = rest; break
          case 'allow-lan': overview.scalars.allowLan = rest; break
          case 'ipv6': overview.scalars.ipv6 = rest; break
          case 'unified-delay': overview.scalars.unifiedDelay = rest; break
          case 'find-process-mode': overview.scalars.findProcessMode = rest; break
          case 'geodata-mode': overview.scalars.geodataMode = rest; break
          case 'external-controller': overview.scalars.controller = rest; break
          case 'secret': overview.scalars.secretState = rest ? t('configOverviewSecretSet') : t('configOverviewSecretEmpty'); break
          case 'port': overview.scalars.port = rest; break
          case 'mixed-port': overview.scalars.mixedPort = rest; break
          case 'socks-port': overview.scalars.socksPort = rest; break
          case 'redir-port': overview.scalars.redirPort = rest; break
          case 'tproxy-port': overview.scalars.tproxyPort = rest; break
        }
      }
      continue
    }

    if (currentTopLevel) sectionLines[currentTopLevel].push(line)
  }

  overview.counts.proxies = countListItemsInSection(sectionLines['proxies'] || [])
  overview.counts.proxyGroups = countListItemsInSection(sectionLines['proxy-groups'] || [])
  overview.counts.rules = countListItemsInSection(sectionLines['rules'] || [])
  overview.counts.proxyProviders = countMapItemsInSection(sectionLines['proxy-providers'] || [])
  overview.counts.ruleProviders = countMapItemsInSection(sectionLines['rule-providers'] || [])

  overview.sections.tun = detectSectionState(sectionLines.tun)
  overview.sections.dns = detectSectionState(sectionLines.dns)
  overview.sections.profile = detectSectionState(sectionLines.profile)
  overview.sections.sniffer = detectSectionState(sectionLines.sniffer)

  if (!overview.scalars.secretState) overview.scalars.secretState = overview.topLevelSections.includes('secret') ? t('configOverviewSecretEmpty') : t('configOverviewSecretNotSet')

  return overview
}

const overviewSummary = computed(() => buildConfigOverview(diffSourceContent(overviewSourceResolved.value)))
const overviewHasContent = computed(() => overviewSummary.value.stats.totalLines > 0)

const overviewText = (value?: string | number | null) => {
  const text = String(value ?? '').trim()
  return text || '—'
}

const overviewBoolText = (value?: string | number | null) => {
  const text = String(value ?? '').trim().toLowerCase()
  if (!text) return '—'
  if (['true', 'on', 'yes'].includes(text)) return t('enabled')
  if (['false', 'off', 'no'].includes(text)) return t('disabled')
  return String(value ?? '')
}

const sectionStateText = (value: ConfigOverviewSectionState) => {
  switch (value) {
    case 'enabled':
      return t('enabled')
    case 'disabled':
      return t('disabled')
    case 'present':
      return t('configOverviewPresent')
    default:
      return t('configOverviewMissing')
  }
}

const sectionStateBadgeClass = (value: ConfigOverviewSectionState) => {
  switch (value) {
    case 'enabled':
      return 'badge-success'
    case 'disabled':
      return 'badge-error'
    case 'present':
      return 'badge-ghost'
    default:
      return 'badge-neutral'
  }
}

const compareLeftResolved = computed<DiffSourceKind>(() => normalizeDiffSource(compareLeft.value as DiffSourceKind))
const compareRightResolved = computed<DiffSourceKind>(() => normalizeDiffSource(compareRight.value as DiffSourceKind))

const diffSourceContent = (kind: DiffSourceKind) => {
  if (kind === 'editor') return String(payload.value || '')
  return String(managedPayloads.value[kind] || '')
}

const normalizeDiffText = (value: string) => String(value || '').replace(/\r\n/g, '\n')

const splitDiffLines = (value: string) => {
  const normalized = normalizeDiffText(value)
  if (!normalized.length) return [] as string[]
  const lines = normalized.split('\n')
  if (lines.length && lines[lines.length - 1] === '') lines.pop()
  return lines
}

const buildLineDiffRows = (leftLines: string[], rightLines: string[]): DiffRow[] => {
  const m = leftLines.length
  const n = rightLines.length
  const dp = Array.from({ length: m + 1 }, () => new Uint32Array(n + 1))

  for (let i = m - 1; i >= 0; i -= 1) {
    for (let j = n - 1; j >= 0; j -= 1) {
      if (leftLines[i] === rightLines[j]) dp[i][j] = dp[i + 1][j + 1] + 1
      else dp[i][j] = Math.max(dp[i + 1][j], dp[i][j + 1])
    }
  }

  const rows: DiffRow[] = []
  let i = 0
  let j = 0
  let leftNo = 1
  let rightNo = 1

  while (i < m && j < n) {
    if (leftLines[i] === rightLines[j]) {
      rows.push({
        type: 'context',
        leftNo,
        rightNo,
        leftText: leftLines[i],
        rightText: rightLines[j],
      })
      i += 1
      j += 1
      leftNo += 1
      rightNo += 1
      continue
    }

    if (dp[i + 1][j] >= dp[i][j + 1]) {
      rows.push({
        type: 'remove',
        leftNo,
        rightNo: null,
        leftText: leftLines[i],
        rightText: '',
      })
      i += 1
      leftNo += 1
    } else {
      rows.push({
        type: 'add',
        leftNo: null,
        rightNo,
        leftText: '',
        rightText: rightLines[j],
      })
      j += 1
      rightNo += 1
    }
  }

  while (i < m) {
    rows.push({
      type: 'remove',
      leftNo,
      rightNo: null,
      leftText: leftLines[i],
      rightText: '',
    })
    i += 1
    leftNo += 1
  }

  while (j < n) {
    rows.push({
      type: 'add',
      leftNo: null,
      rightNo,
      leftText: '',
      rightText: rightLines[j],
    })
    j += 1
    rightNo += 1
  }

  return rows
}

const diffRows = computed(() => buildLineDiffRows(
  splitDiffLines(diffSourceContent(compareLeftResolved.value)),
  splitDiffLines(diffSourceContent(compareRightResolved.value)),
))

const diffRowsVisible = computed(() => (compareChangesOnly.value ? diffRows.value.filter((row) => row.type !== 'context') : diffRows.value))

const diffSummary = computed(() => diffRows.value.reduce((acc, row) => {
  if (row.type === 'add') acc.added += 1
  else if (row.type === 'remove') acc.removed += 1
  else acc.context += 1
  return acc
}, { context: 0, added: 0, removed: 0 }))

const diffHasChanges = computed(() => diffSummary.value.added > 0 || diffSummary.value.removed > 0)

const swapDiffSources = () => {
  const currentLeft = compareLeft.value
  compareLeft.value = compareRight.value
  compareRight.value = currentLeft
}

const dumpYaml = (value: any): string => {
  const isScalar = (v: any) => v === null || ['string', 'number', 'boolean'].includes(typeof v)

  const scalarInline = (v: any) => {
    if (v === null) return 'null'
    if (typeof v === 'string') return JSON.stringify(v)
    if (typeof v === 'number' || typeof v === 'boolean') return String(v)
    return JSON.stringify(String(v))
  }

  const emit = (v: any, indent = 0): string[] => {
    const sp = ' '.repeat(indent)

    if (isScalar(v)) {
      if (typeof v === 'string' && v.includes('\n')) {
        const lines = v.split(/\r?\n/)
        return [sp + '|-', ...lines.map((l) => sp + '  ' + l)]
      }
      return [sp + scalarInline(v)]
    }

    if (Array.isArray(v)) {
      if (!v.length) return [sp + '[]']
      const out: string[] = []
      for (const item of v) {
        if (isScalar(item)) {
          if (typeof item === 'string' && item.includes('\n')) {
            const lines = item.split(/\r?\n/)
            out.push(sp + '- |-')
            out.push(...lines.map((l) => sp + '  ' + l))
          } else {
            out.push(sp + '- ' + scalarInline(item))
          }
        } else {
          out.push(sp + '-')
          out.push(...emit(item, indent + 2))
        }
      }
      return out
    }

    if (typeof v === 'object') {
      const keys = Object.keys(v || {})
      if (!keys.length) return [sp + '{}']
      const out: string[] = []
      for (const k of keys) {
        const key = /^[A-Za-z0-9_.-]+$/.test(k) ? k : JSON.stringify(k)
        const val = (v as any)[k]
        if (isScalar(val)) {
          if (typeof val === 'string' && val.includes('\n')) {
            const lines = val.split(/\r?\n/)
            out.push(sp + key + ': |-')
            out.push(...lines.map((l) => sp + '  ' + l))
          } else {
            out.push(sp + key + ': ' + scalarInline(val))
          }
        } else {
          if (Array.isArray(val) && !val.length) {
            out.push(sp + key + ': []')
          } else {
            out.push(sp + key + ':')
            out.push(...emit(val, indent + 2))
          }
        }
      }
      return out
    }

    return [sp + JSON.stringify(String(v))]
  }

  return emit(value, 0).join('\n') + '\n'
}

const looksLikeFullConfig = (s: string) => {
  const t = (s || '').trim()
  if (!t) return false
  return (
    /(^|\n)\s*proxies\s*:/m.test(t) ||
    /(^|\n)\s*proxy-groups\s*:/m.test(t) ||
    /(^|\n)\s*proxy-providers\s*:/m.test(t) ||
    /(^|\n)\s*rule-providers\s*:/m.test(t) ||
    /(^|\n)\s*rules\s*:/m.test(t)
  )
}

const looksLikeRuntimeConfigs = (obj: any) => {
  if (!obj || typeof obj !== 'object') return false
  const keys = Object.keys(obj)
  const hasPorts = keys.some((k) => ['port', 'socks-port', 'redir-port', 'tproxy-port', 'mixed-port'].includes(k))
  const hasGroups = keys.some((k) => ['proxy-groups', 'proxies', 'rules', 'proxy-providers', 'rule-providers'].includes(k))
  return hasPorts && !hasGroups
}

const tryLoadFromFileLikeEndpoints = async (pathValue: string): Promise<string | null> => {
  const candidates: Array<{ url: string; params?: Record<string, any> }> = [
    { url: '/configs', params: { path: pathValue, format: 'raw' } },
    { url: '/configs', params: { path: pathValue, raw: true } },
    { url: '/configs', params: { path: pathValue, file: true } },
    { url: '/configs', params: { path: pathValue, download: true } },
    { url: '/configs/raw', params: { path: pathValue } },
    { url: '/configs/file', params: { path: pathValue } },
  ]

  for (const c of candidates) {
    try {
      const r = await axios.get(c.url, {
        params: c.params,
        responseType: 'text',
        silent: true as any,
        headers: {
          Accept: 'text/plain, application/x-yaml, application/yaml, */*',
          'X-Zash-Silent': '1',
        } as any,
      })
      const data: any = (r as any)?.data
      if (typeof data === 'string') {
        const s = data.trim()
        if (looksLikeFullConfig(s)) return data
        if ((s.startsWith('{') || s.startsWith('[')) && (s.endsWith('}') || s.endsWith(']'))) {
          try {
            const parsed = JSON.parse(s)
            const payloadValue = (parsed && (parsed.payload || parsed.data?.payload || parsed.config || parsed.yaml)) as any
            if (typeof payloadValue === 'string' && looksLikeFullConfig(payloadValue)) return payloadValue
          } catch {
            // ignore
          }
        }
      } else if (data && typeof data === 'object') {
        const payloadValue = (data.payload || data.data?.payload || data.config || data.yaml) as any
        if (typeof payloadValue === 'string' && looksLikeFullConfig(payloadValue)) return payloadValue
      }
    } catch {
      // try next
    }
  }
  return null
}

const legacyLoad = async () => {
  if (legacyLoadBusy.value) return
  legacyLoadBusy.value = true
  try {
    if (agentEnabled.value) {
      const res = await agentMihomoConfigAPI()
      if (res?.ok && res?.contentB64) {
        payload.value = decodeB64Utf8(res.contentB64)
        showNotification({ content: 'mihomoConfigLoadSuccess', type: 'alert-success' })
        return
      }
    }

    const fileText = await tryLoadFromFileLikeEndpoints(path.value)
    if (fileText) {
      payload.value = fileText
      showNotification({ content: 'mihomoConfigLoadSuccess', type: 'alert-success' })
      return
    }

    const raw = await getConfigsRawAPI({ path: path.value })
    const data: any = raw?.data
    if (typeof data === 'string' && data.trim().length > 0) {
      const s = data.trim()
      if (looksLikeFullConfig(s)) {
        payload.value = data
        showNotification({ content: 'mihomoConfigLoadSuccess', type: 'alert-success' })
        return
      }
      if (s.startsWith('{') || s.startsWith('[')) {
        try {
          const parsed = JSON.parse(s)
          if (looksLikeRuntimeConfigs(parsed)) {
            payload.value =
              `# Mihomo API /configs does not expose the full YAML file on this build.\n` +
              `# Showing runtime config (ports/tun/etc). If your backend supports reading the file,\n` +
              `# enable it to load: ${path.value}\n\n` +
              dumpYaml(parsed)
            showNotification({ content: 'mihomoConfigLoadPartial', type: 'alert-info' })
            return
          }
          payload.value = `# Converted from /configs (JSON)\n# Comments/ordering may differ from the original mihomo YAML.\n\n${dumpYaml(parsed)}`
          showNotification({ content: 'mihomoConfigLoadPartial', type: 'alert-info' })
          return
        } catch {
          // ignore
        }
      }
      payload.value = data
      showNotification({ content: 'mihomoConfigLoadSuccess', type: 'alert-success' })
      return
    }

    const json = await getConfigsAPI()
    payload.value = `# Converted from /configs (JSON)\n# Comments/ordering may differ from the original mihomo YAML.\n\n${dumpYaml(json.data)}`
    showNotification({ content: 'mihomoConfigLoadPartial', type: 'alert-info' })
  } catch {
    showNotification({ content: 'mihomoConfigLoadFailed', type: 'alert-error' })
  } finally {
    legacyLoadBusy.value = false
  }
}

const legacyApply = async () => {
  if (legacyApplyBusy.value) return
  legacyApplyBusy.value = true
  try {
    await reloadConfigsAPI({ path: path.value || '', payload: payload.value || '' })
    showNotification({ content: 'reloadConfigsSuccess', type: 'alert-success' })
  } catch {
    // interceptor handles details
  } finally {
    legacyApplyBusy.value = false
  }
}

const legacyRestart = async () => {
  if (legacyRestartBusy.value) return
  legacyRestartBusy.value = true
  try {
    await restartCoreAPI()
    showNotification({ content: 'restartCoreSuccess', type: 'alert-success' })
  } catch {
    // interceptor handles details
  } finally {
    legacyRestartBusy.value = false
  }
}

const clearDraft = () => {
  payload.value = ''
}

onMounted(async () => {
  await refreshAll(true)
})
</script>
