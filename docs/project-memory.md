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
- UI: **v1.2.161**
- router-agent: **0.6.32**

## Latest delivered step
- `v1.2.160` pauses Tasks → Live Logs auto-refresh when the browser tab is hidden or when the logs widget is outside the viewport.
- `v1.2.161` extends hidden-tab pause to Router/System, Router agent, Host QoS and Users QoS polling loops.
- A small status badge now explains whether logs polling is active or paused.
- This is UI-only; router-agent and HA/export contracts were left untouched.

## Previous important steps in this chain
- `v1.2.159` paused Overview relationship-chart snapshot polling when charts are off-screen or the tab is hidden.
- `v1.2.158` made provider-panel row state explicit: active runtime vs saved-only UI state.
- `v1.2.157` added cleanup for orphaned saved-only provider-panel rows in Tasks UI.
- `v1.2.151`–`v1.2.155` progressively reduced invisible Host QoS / Router / Overview background work without touching the live traffic contour.
- `v1.2.156` softened burst load for mass latency tests.

## Immediate next step
- validate `v1.2.160` + `v1.2.161` on the real router
- confirm that Tasks → Live Logs stops polling while off-screen
- confirm that returning into view resumes polling cleanly
- confirm that HA/export runtime and Overview traffic weights stay normal
- then continue upstream review for one more safe UI-side reduction of redundant work
