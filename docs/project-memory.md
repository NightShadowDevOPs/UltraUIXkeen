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
- UI prepared: **v1.2.167**
- router-agent: **0.6.32**

## Latest delivered step
- `v1.2.167` — global UI-build freshness auto-check no longer refetches page HTML on every ordinary visible-resume; it now waits for stale bundle info or a manual check, so the router sees less pointless self-traffic.
- `v1.2.166` — `Router agent` wake-up cleanup: status refresh on visible resume now has a soft cooldown, and maintenance polling no longer auto-fires again on enable/visible wake-up.
- `v1.2.165` — safe upstream hardening without touching runtime: protected `proxiesRef` usage in `Прокси` and added a visible empty-state for `Соединения`.
- `v1.2.164` removed the remaining wake-up duplicate in `Overview -> Router Health`.
- `v1.2.162` restored the missed Tasks visible-resume anti-burst patch.
- All these steps are UI-only; router-agent and HA/export contracts were left untouched.

## Previous important steps in this chain
- `v1.2.159` paused Overview relationship-chart snapshot polling when charts are off-screen or the tab is hidden.
- `v1.2.158` made provider-panel row state explicit: active runtime vs saved-only UI state.
- `v1.2.157` added cleanup for orphaned saved-only provider-panel rows in Tasks UI.
- `v1.2.151`–`v1.2.156` progressively reduced invisible Host QoS / Router / Overview background work without touching the live traffic contour.

## Immediate next step
- validate `v1.2.167` on the real router
- confirm that ordinary tab resume no longer causes pointless extra UI-build auto-checks
- confirm that manual UI update check still works normally
- confirm that HA/export runtime and Overview traffic weights stay normal
- then continue upstream review for low-risk UI-side reductions only
