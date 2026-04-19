# Release plan — UI Mihomo / Ultra

## Released
- `v1.2.147` — traffic workspace structure + live refresh hardening + docs sync
- `v1.2.148` — router-agent telemetry cache for heavy traffic endpoints + Host QoS on-demand live refresh
- `v1.2.149` — client-side polling dedupe/cache + stable fallback for overview/traffic live graphs
- `v1.2.150` — lighter secondary Traffic/QoS polling + short cache windows for repeated status/qos/lan-host reads

## Current target
- validate `v1.2.150` on the real router under ordinary and heavier traffic
- confirm that Overview traffic weights remain live and that router throughput/forwarding is unaffected
- confirm that Traffic → Devices / Users QoS widgets refresh more calmly in the background

## Next candidate release
- `v1.2.151`
  - review useful upstream ideas that can be cherry-picked without adding extra background load
  - if `v1.2.150` behaves well, consider one more round of lazy refresh for clearly secondary widgets only
  - keep provider SSL checks and the traffic/runtime path untouched unless explicitly requested

## Guardrails
- do not break automatic SSL certificate checks for proxy providers
- do not worsen real traffic handling on the router for the sake of UI polish
- prefer lazy refresh, dedupe and cache over extra permanent polling
- keep router-agent version in sync in docs/install/status API only when agent code actually changes
