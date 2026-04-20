# Release plan — UI Mihomo / Ultra

## Recently delivered
- `v1.2.158` — explicit active vs saved-state transparency for provider-panel rows in Tasks UI
- `v1.2.157` — cleanup for disabled/saved-only provider-panel rows in Tasks UI
- `v1.2.151` — viewport-aware lazy polling for Host QoS / Users QoS cards
- `v1.2.152` — viewport-aware lazy polling for Router → Resources / Router agent cards
- `v1.2.153` — viewport-aware lazy polling for Overview router health card
- `v1.2.154` — viewport-aware pause for Overview → Traffic secondary host-detail polling
- `v1.2.155` — reduced main Overview → Traffic live cadence while the card is off-screen
- `v1.2.156` — safer mass latency-test execution with limited concurrency and more consistent test-URL resolution

## Next likely step
- validate `v1.2.158` on the real router: удаление provider-panel настроек должно быть визуально понятным и не должно ломать активные panel URL / SSL-индикаторы
- if stable, keep reviewing upstream for safe operational cherry-picks that reduce burst load or redundant UI work
- continue rejecting anything that increases constant polling, CPU churn or router runtime risk

## Non-negotiable guardrails
- real router traffic must not suffer because of UI work
- the Overview traffic weights chart must keep working normally
- provider SSL checks stay untouched unless explicitly requested
- router updater flow remains the built-in UI updater
