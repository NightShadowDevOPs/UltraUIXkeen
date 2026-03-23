import { useStorage } from '@vueuse/core'

/**
 * Router-side helper agent (optional).
 * Used for "adult" bandwidth shaping per client via tc/iptables, because Mihomo API
 * does not provide traffic shaping.
 */

export const agentEnabled = useStorage<boolean>('config/agent-enabled', true)
const agentEnabledBootstrapV1 = useStorage<boolean>('config/agent-enabled-bootstrap-v1', false)
if (!agentEnabledBootstrapV1.value) {
  // Router-agent-backed features (shared limits/QoS/backups) are expected to work
  // on every browser profile without a separate local enable step.
  agentEnabled.value = true
  agentEnabledBootstrapV1.value = true
}
const agentEnabledBootstrapV2 = useStorage<boolean>('config/agent-enabled-bootstrap-v2', false)


/**
 * Default tries same host as the UI, on port 9099.
 * Example: http://192.168.1.1:9099
 */
export const agentUrl = useStorage<string>(
  'config/agent-url',
  typeof window !== 'undefined' ? `http://${window.location.hostname}:9099` : '',
)

/** Optional Bearer token for the agent. */
export const agentToken = useStorage<string>('config/agent-token', '')

/**
 * If enabled, bandwidth limits (Mbps) are enforced by the agent (tc/iptables),
 * NOT by disconnecting connections.
 */
export const agentEnforceBandwidth = useStorage<boolean>('config/agent-enforce-bandwidth', true)
const agentEnforceBandwidthBootstrapV1 = useStorage<boolean>('config/agent-enforce-bandwidth-bootstrap-v1', false)
if (!agentEnforceBandwidthBootstrapV1.value) {
  // If the user sets a bandwidth cap, enforce it via the agent by default.
  agentEnforceBandwidth.value = true
  agentEnforceBandwidthBootstrapV1.value = true
}
const agentEnforceBandwidthBootstrapV2 = useStorage<boolean>('config/agent-enforce-bandwidth-bootstrap-v2', false)

export const ensureAgentDefaults = () => {
  // One-shot migration for browser profiles that already went through older
  // releases but still kept router-agent features disabled locally.
  if (!agentEnabledBootstrapV2.value) {
    agentEnabled.value = true
    agentEnabledBootstrapV2.value = true
  }
  if (!agentEnforceBandwidthBootstrapV2.value) {
    agentEnforceBandwidth.value = true
    agentEnforceBandwidthBootstrapV2.value = true
  }
}

/**
 * Remember which IPs were shaped by the UI, so we can clean up removed limits.
 */
export const managedAgentShapers = useStorage<Record<string, { upMbps: number; downMbps: number }>>(
  'config/agent-managed-shapers-v1',
  {},
)

/**
 * Per-IP shaping status from the agent.
 * Useful to show "applied/failed" badges and allow manual re-apply.
 */
export const agentShaperStatus = useStorage<
  Record<string, { ok: boolean; at: number; error?: string }>
>('config/agent-shaper-status-v1', {})

/**
 * MAC blocks managed by the UI (best-effort). Key = mac.
 */
export const managedAgentBlocks = useStorage<Record<string, { ports: string }>>(
  'config/agent-managed-blocks-v1',
  {},
)

/**
 * IP blocks managed by the UI (best-effort). Key = ip.
 * Useful when a MAC cannot be resolved.
 */
export const managedAgentIpBlocks = useStorage<Record<string, true>>(
  'config/agent-managed-ip-blocks-v1',
  {},
)

/**
 * Scheduled backups (cron). Stored locally; can be applied to the router via the agent.
 * Default: daily at 04:00.
 */
export const agentBackupAutoEnabled = useStorage<boolean>('config/agent-backup-auto-enabled-v1', true)

/** Time in HH:MM (24h). */
export const agentBackupAutoTime = useStorage<string>('config/agent-backup-auto-time-v1', '04:00')
