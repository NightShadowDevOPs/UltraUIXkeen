v1.2.119
- Fixed AgentCard runtime refs so Router → Backups really renders again

# UI Mihomo / Ultra — chat transfer

## v1.2.119 — 2026-04-18
- fixed the actual runtime blocker in `AgentCard`: `maintenanceLoaded` and `maintenanceLoading` were used in template and logic but were never declared, which could collapse the backup workspace render
- preserved the backup workspace split introduced in v1.2.117 and completed the repair started in v1.2.118
- router-agent version stays `0.6.28`

## Fixed near-term roadmap
- v1.2.120 — Traffic functional linking: devices ↔ users, duplicate cleanup, clearer QoS/profile actions
- v1.2.121 — Host overview cleanup after backup extraction
- v1.2.122 — Providers operational pass (status/SSL clarity, without breaking automatic SSL checks)
- v1.2.123 — QoS/shaping reliability follow-up

## v1.2.118 — 2026-04-18
- fixed the template-scope bug in `AgentCard` upload results block
- this turned out to be only part of the empty-backup fix; the remaining runtime blocker was closed in v1.2.119
- router-agent version stays `0.6.28`


## v1.2.117 — 2026-04-18
- Router workspace now has an explicit `Backups` tab inside `Router`, so backup creation, archive lists, restore, delete, verification, and schedule actions are no longer buried inside `Overview`
- `Router → Overview` is reduced back toward a short operational summary instead of mixing health cards with maintenance workflow
- direct internal navigation between `Overview` and `Backups` makes the backup flow visible on first glance
- router-agent version stays `0.6.28`

## v1.2.116 — 2026-04-18
- Traffic page is now a real workspace instead of one long mixed block
- added two internal modes: `Devices` for live LAN hosts + host QoS, and `Users` for accumulated traffic, limits and blocking rules
- route query `?view=devices|users` is normalized automatically, so direct links open the intended traffic mode
- default traffic view now opens `Devices`, which is better for live operational triage before switching to persistent user policies
- router-agent version stays `0.6.28`

## v1.2.115 — 2026-04-18
- added shared safe polling for visible-only live refresh loops so overview/router/tasks cards stop running their own timer zoo
- Tasks page live logs and upstream checks now resume from one safe polling path instead of separate background intervals
- shared provider/users DB sync stores now skip interval ticks while the tab is hidden, reducing pointless background pressure on router-agent
- router-agent version stays `0.6.28`

## v1.2.114 — 2026-04-18
- lazy-loaded overview diagnostics and maintenance panels to keep the main Router page lighter on first render
- prepared the router UI for the next polling cleanup pass without changing router-agent
- router-agent version stays `0.6.28`

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
