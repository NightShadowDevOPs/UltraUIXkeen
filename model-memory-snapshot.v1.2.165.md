# Model memory snapshot — UI Mihomo / Ultra

## Working context
- Date: **2026-04-21**
- UI version: **v1.2.165**
- router-agent version: **0.6.32**

## What changed most recently
- `v1.2.157`: stale proxy-provider panel entries can now be deleted from Tasks UI, one by one or in bulk, when they remain only in saved settings
- `v1.2.158`: active vs saved-only provider state is explicit in Tasks UI; delete actions explain whether only saved UI settings were removed or whether the whole orphaned row disappeared
- `v1.2.159`: Overview relationship charts by sources / clients / rules now pause snapshot polling while off-screen or when the tab is hidden, and resume softly when visible again
- `v1.2.160`: Tasks → Live Logs now pauses 5-second auto-refresh while the tab is hidden or the logs card is off-screen, then softly refreshes on return; router-agent → HA data shape stays unchanged
- `v1.2.161`: Router/System, Router agent, Host QoS and Users QoS now also pause background polling while the browser tab is hidden, then softly refresh on return; router-agent → HA data shape stays unchanged
- `v1.2.162`: the missed Tasks visible-resume anti-burst patch is restored; fast tab hide/show should no longer stack identical refreshes for router-agent status, live logs and upstream checks
- `v1.2.163`: follow-up dedupe for operational cards; where a component already performs its own refresh on re-activation, `useSafePolling` no longer auto-fires again on `refreshOnEnable` / `refreshOnVisible`
- `v1.2.164`: the same wake-up dedupe pattern is applied to `Overview -> Router Health`; the card keeps its own targeted viewport re-entry refresh, but the helper no longer adds a second duplicate wake-up
- `v1.2.165`: after safe upstream review, only two low-risk UI hardening pieces were taken — a `proxiesRef` guard in `Прокси` and a proper empty-state in `Соединения`; no new polling loops or router-agent changes

## Important constraints
- traffic through the router must not degrade because of UI work
- Overview traffic weights chart must keep working normally
- provider SSL checks are off-limits unless explicitly requested
- updater flow on the router remains the built-in UI updater
- router-agent → Home Assistant data structure must stay stable unless explicitly requested otherwise

## Immediate next check
- verify real-router behavior after `v1.2.165`:
  1. `Прокси` does not behave oddly when the page restores scroll state early
  2. `Соединения` shows a normal empty-state when there are no rows
  3. Overview traffic weights chart still behaves normally when visible
  4. HA/export runtime and real traffic through the router stay normal
  5. continue safe upstream review only for low-risk load reductions or UI hardening
