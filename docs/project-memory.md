# Project memory — UI Mihomo / Ultra

## Stable project facts
- Main repository: `NightShadowDevOPs/UltraUIXkeen`
- Local folder: `Y:\Мой диск\Git\UltraUIXkeen`
- Router path: `/opt/UltraUIXkeen`
- UI updates on the router are done through the built-in UI updater, not through `git pull`
- In router command blocks always include `clear`
- If `router-agent` changes, sync the version in `install.sh`, status API and documentation
- Automatic SSL-certificate checks for proxy providers must stay intact
- Do not additionally break the router-agent → Home Assistant data structure unless explicitly requested

## Current validated baseline
- UI prepared: **v1.2.163**
- router-agent: **0.6.32**

## Latest delivered step
- `v1.2.163` removes another class of duplicate wake-up refreshes in operational cards that already had their own `watch(...active...)` refresh path. Patched zones: `Router -> System`, `Router -> Router agent`, `Router -> Host QoS`, `Traffic / Users` QoS statistics.
- `v1.2.162` restores the missed Tasks visible-resume anti-burst patch: quick hide/show of the browser tab should no longer stack identical refreshes for router-agent status, live logs and upstream checks.
- `v1.2.161` extends hidden-tab pause to Router/System, Router agent, Host QoS and Users QoS polling loops.
- All these steps are UI-only; router-agent and HA/export contracts were left untouched.

## Previous important steps in this chain
- `v1.2.159` paused Overview relationship-chart snapshot polling when charts are off-screen or the tab is hidden.
- `v1.2.158` made provider-panel row state explicit: active runtime vs saved-only UI state.
- `v1.2.157` added cleanup for orphaned saved-only provider-panel rows in Tasks UI.
- `v1.2.151`–`v1.2.156` progressively reduced invisible Host QoS / Router / Overview background work without touching the live traffic contour.

## Immediate next step
- validate `v1.2.163` on the real router
- confirm that quick tab/card resume no longer causes duplicate wake-up refreshes in System / Router agent / Host QoS / Users QoS
- confirm that manual refresh still works normally
- confirm that HA/export runtime and Overview traffic weights stay normal
- then continue upstream review for one more safe UI-side reduction of redundant wake-up work
