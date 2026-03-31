v1.2.114
- lazy-load overview diagnostics and maintenance panels

# UI Mihomo / Ultra — chat transfer

## v1.2.113 — 2026-03-31
- third router optimization pass: split the agent hot-path into lightweight `status` and slower `status_debug`
- `status` now keeps only fast-changing resource/runtime essentials (cpu/load/memory/temp, uptime, WAN/LAN flags, agent versions)
- `status_debug` now carries storage, firmware/model/kernel/arch, Mihomo/xkeen versions, and shaping diagnostics
- `SystemCard` refreshes heavy router info separately and much less often, so normal overview polling no longer pays the full debug cost
- router-agent updated to `0.6.26`

## v1.2.112 — 2026-03-31
- second router optimization pass: `status` / `qos_status` no longer try to create/repair shaper state on every poll; they now report passive readiness only
- router-agent `status` no longer blocks on a live CPU sleep sample; it uses cached `/proc/stat` deltas instead, which is much lighter on the router
- router-agent caches the computed `status` payload for a short TTL and clears it after shaping changes, reducing repeated work during simultaneous card refreshes
- frontend now coalesces short-lived `status` / `qos_status` requests so multiple router cards stop hammering the same endpoints in parallel
- router-agent updated to `0.6.25`

## v1.2.111 — 2026-03-31
- started router-side optimization pass: hidden `Router` sections now unmount instead of polling in the background
- reduced and visibility-gated live polling for router cards, QoS views, traffic cards, and Tasks logs/upstream checks
- `NetcrazeTrafficCard` now polls less aggressively and stops when the browser tab is hidden
- `router-agent` did not change in this release and stays on `0.6.24`
