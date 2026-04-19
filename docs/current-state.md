# Current state — UI Mihomo / Ultra

- Date: **2026-04-20**
- UI version: **v1.2.149**
- router-agent version: **0.6.32**
- Repository: `NightShadowDevOPs/UltraUIXkeen`
- Local path: `Y:\Мой диск\Git\UltraUIXkeen`
- Router path: `/opt/UltraUIXkeen`

## What was done in v1.2.149
- left router-agent telemetry cache from `v1.2.148` untouched so the forwarding/runtime path stays conservative and safe
- added short-lived client-side dedupe/cache for `traffic_live`, `host_traffic_live` and `lan_hosts`, so simultaneous UI cards do not hammer the router-agent with duplicate reads
- hardened Overview/Traffic live charts with fallback to the last stable sample, so brief telemetry misses do not drop traffic weights and host live stats to zero
- kept the traffic diagram in Overview on the same data path, but made transient polling failures visually flatter instead of noisy
- synchronized docs, changelog and chat-transfer bundle for the new release

## Current focus
- reduce remaining UI polling overhead without touching the actual traffic path
- keep Overview traffic weights chart stable under real router load
- continue lightening the Traffic workspace carefully, without breaking QoS, host stats or provider SSL checks

## Next logical step after this release
- observe `v1.2.149` under real router load
- if the runtime is stable, move to the next safe cleanup: trim non-critical background refreshes in secondary Traffic widgets and review which upstream ideas are worth porting without dragging extra load onto the router
