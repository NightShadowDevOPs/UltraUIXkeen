# Release plan — UI Mihomo / Ultra

## Recently delivered
- `v1.2.168` — Router/System visible-resume cooldown: мягкий anti-burst для wake-up refresh системной карточки без изменений polling cadence и без включения TUN
- `v1.2.167` — UI-build visible-resume dedupe: глобальная проверка свежести UI-сборки больше не делает лишний fetch HTML на каждый обычный visible-resume
- `v1.2.166` — Router agent visible-resume anti-burst: soft cooldown for wake-up status refresh plus no extra maintenance auto-wake-up
- `v1.2.165` — safe upstream UI hardening: `proxiesRef` guard in `Прокси` and empty-state for `Соединения`
- `v1.2.164` — removed the remaining wake-up duplicate in `Overview -> Router Health`
- `v1.2.163` — wake-up dedupe follow-up for operational cards: System, Router agent, Host QoS and Users QoS stats
- `v1.2.162` — restored the missed Tasks visible-resume anti-burst patch for router-agent status, live logs and upstream checks
- `v1.2.161` — hidden-tab pause extended to Router/System, Router agent, Host QoS and Users QoS polling loops
- `v1.2.160` — viewport-aware pause for `Задачи → Живые логи` auto-refresh when the block is off-screen or the tab is hidden
- `v1.2.159` — viewport-aware pause for Overview relationship/traffic-weight charts when they are off-screen or the tab is hidden
- `v1.2.158` — explicit active vs saved-state transparency for provider-panel rows in Tasks UI
- `v1.2.157` — cleanup for disabled/saved-only provider-panel rows in Tasks UI

## Next likely step
- validate `v1.2.168` on the real router
- if stable, continue upstream review only for safe operational cherry-picks that reduce UI rough edges or pointless wake-up work
- reject anything that increases constant polling, CPU churn or router runtime risk
- keep HA/export shape frozen unless there is an explicit request to change it

## Non-negotiable guardrails
- real router traffic must not suffer because of UI work
- the Overview traffic weights chart must keep working normally
- provider SSL checks stay untouched unless explicitly requested
- router updater flow remains the built-in UI updater
- router-agent → Home Assistant contract must remain stable by default
