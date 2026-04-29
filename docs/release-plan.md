# Release plan — UI Mihomo / Ultra

## Current release
- `v1.2.173` — zash-agent startup self-call hotfix: remove internal HTTP self-calls from startup/cron, harden stop/start cleanup, auto-detect missing/stale `MIHOMO_CONFIG`.

## Why it was prioritized
- The router recovered after manual stop/kill/start, but the observed failure showed that agent availability could degrade even when `uhttpd` was listening.
- Providers UI depends on a responsive agent. If agent HTTP blocks, the interface reports “agent unavailable” and provider data disappears.
- This patch targets the operational root cause without touching live routing or traffic handling.

## Deferred validation
- validate `v1.2.173` on router
- verify status/providers/SSL checks/HA export
- then verify accumulated traffic-chain releases `v1.2.169`–`v1.2.173`

## Next safe candidates after v1.2.173
1. QoS/shaping transparency: show saved config vs runtime-applied state more clearly.
2. Provider diagnostics: clearer distinction between Mihomo controller unavailable, config path missing, empty provider block, and UI parsing issue.
3. Agent watchdog/status page: a lightweight self-check panel that does not add aggressive polling.
