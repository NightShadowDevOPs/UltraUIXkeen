# Model memory snapshot — UI Mihomo / Ultra

## Working context
- Date: **2026-04-24**
- UI version: **v1.2.172**
- router-agent version: **0.6.32**

## What changed most recently
- `v1.2.172`: `Трафик` got calmer service/empty states in both `Устройства` and `Пользователи`; empty tables now explain no-data vs filtered-empty situations and offer reset actions.
- `v1.2.171`: `Трафик -> Устройства` follows the compact/advanced pattern; diagnostics are opt-in and remembered locally.
- `v1.2.170`: `Трафик -> Пользователи` follows the same compact/advanced pattern.
- `v1.2.169`: `Трафик` no longer duplicates mode controls and shows active drill-down focus explicitly.
- `v1.2.168`: `Router -> System` has visible-resume anti-burst cooldown.
- `v1.2.167`: UI-build freshness auto-check no longer refetches page HTML on every ordinary visible-resume.
- `v1.2.166`: `Router agent` visible-resume cleanup.
- All recent work is UI-only; router-agent and HA/export contracts are untouched.

## Important constraints
- traffic through the router must not degrade because of UI work
- Overview traffic weights chart must keep working normally
- provider SSL checks are off-limits unless explicitly requested
- updater flow on the router remains the built-in UI updater
- router-agent → Home Assistant data structure must stay stable unless explicitly requested otherwise
- TUN stays disabled unless a separate transparent-routing scenario is explicitly approved

## Deferred validation bundle
Later validate the accumulated Traffic line:
1. `v1.2.169`: no duplicate Traffic mode controls; focus banner and reset work.
2. `v1.2.170`: Users compact/advanced mode persists.
3. `v1.2.171`: Devices compact/advanced mode persists.
4. `v1.2.172`: service/empty states are readable and reset buttons work.
5. Provider SSL checks, HA/export runtime and real traffic path remain normal.
