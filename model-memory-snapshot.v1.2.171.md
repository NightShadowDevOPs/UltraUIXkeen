# Model memory snapshot — UI Mihomo / Ultra

## Working context
- Date: **2026-04-23**
- UI version: **v1.2.171**
- router-agent version: **0.6.32**

## What changed most recently
- `v1.2.162`: the missed Tasks visible-resume anti-burst patch is restored; fast tab hide/show should no longer stack identical refreshes for router-agent status, live logs and upstream checks
- `v1.2.163`: follow-up dedupe for operational cards; where a component already performs its own refresh on re-activation, `useSafePolling` no longer auto-fires again on `refreshOnEnable` / `refreshOnVisible`
- `v1.2.164`: the same wake-up dedupe pattern is applied to `Overview -> Router Health`; the card keeps its own targeted viewport re-entry refresh, but the helper no longer adds a second duplicate wake-up
- `v1.2.165`: after safe upstream review, only two low-risk UI hardening pieces were taken — a `proxiesRef` guard in `Прокси` and a proper empty-state in `Соединения`; no new polling loops or router-agent changes
- `v1.2.166`: `Router agent` now uses a soft visible-resume cooldown for status refresh, and maintenance polling no longer auto-fires again on wake-up; ordinary polling, router-agent shape and live traffic path stay unchanged
- `v1.2.167`: global UI-build freshness auto-check no longer refetches page HTML on every ordinary visible-resume; it now waits for stale bundle info or a manual check, so the router sees less pointless self-traffic
- `v1.2.168`: `Router -> System` now has a soft visible-resume cooldown, so fast hide/show cycles do not stack duplicate wake-up status refreshes against the router
- `v1.2.169`: `Трафик` workspace no longer duplicates mode controls; it now shows the active mode and the current `user` / `ip` drill-down focus explicitly, with a one-click reset and no runtime changes
- `v1.2.170`: `Трафик -> Пользователи` now splits normal work from diagnostics: compact mode hides service cards by default, advanced mode reveals them on demand, and the chosen mode is remembered locally in the browser
- `v1.2.171`: `Трафик -> Устройства` now follows the same compact/advanced pattern; the main device table stays in the normal operator path, diagnostics are opt-in, and the chosen mode is remembered locally

## Important constraints
- traffic through the router must not degrade because of UI work
- Overview traffic weights chart must keep working normally
- provider SSL checks are off-limits unless explicitly requested
- updater flow on the router remains the built-in UI updater
- router-agent → Home Assistant data structure must stay stable unless explicitly requested otherwise
- TUN stays disabled unless a separate transparent-routing scenario is explicitly approved

## Immediate next check
- verify real-router behavior after `v1.2.171` later:
  1. `Трафик -> Устройства` opens in compact mode and looks calmer
  2. diagnostics can be expanded/collapsed without breaking search, filters or selected actions
  3. local browser persistence for the chosen mode behaves predictably
  4. provider SSL checks keep working normally
  5. HA/export runtime and real traffic through the router stay normal
