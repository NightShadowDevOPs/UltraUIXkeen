# Release plan — UI Mihomo / Ultra

## Released
- `v1.2.147` — traffic workspace structure + live refresh hardening + docs sync
- `v1.2.148` — router-agent telemetry cache for heavy traffic endpoints + Host QoS on-demand live refresh
- `v1.2.149` — client-side polling dedupe/cache + stable fallback for overview/traffic live graphs

## Current target
- validate `v1.2.149` on the real router under ordinary and heavier traffic
- confirm that Overview traffic weights remain live and that router throughput/forwarding is unaffected

## Next candidate release
- `v1.2.150`
  - selectively thin remaining non-critical polling in Traffic secondary widgets
  - review useful upstream ideas that can be cherry-picked without adding extra background load
  - keep provider SSL checks and the traffic/runtime path untouched unless explicitly requested

## Guardrails
- do not break automatic SSL certificate checks for proxy providers
- do not worsen real traffic handling on the router for the sake of UI polish
- prefer lazy refresh, dedupe and cache over extra permanent polling
- keep router-agent version in sync in docs/install/status API only when agent code actually changes
