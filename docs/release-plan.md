# Release plan — UI Mihomo / Ultra

## Recently delivered
- `v1.2.150` — lighter Host QoS / Users QoS secondary background refresh
- `v1.2.151` — viewport-aware lazy polling for Host QoS / Users QoS cards
- `v1.2.152` — viewport-aware lazy polling for Router → Resources / Router agent cards
- `v1.2.153` — viewport-aware lazy polling for Overview router health card
- `v1.2.154` — viewport-aware pause for Overview → Traffic secondary host-detail polling
- `v1.2.155` — reduced main Overview → Traffic live cadence while the card is off-screen

## Next likely step
- validate `v1.2.155` on the real router under ordinary and heavier traffic
- if stable, pick one more cheap secondary telemetry contour that can be paused or slowed off-screen without harming the main traffic UX
- separately keep reviewing upstream for safe ideas, but only accept cherry-picks that do not increase constant polling, CPU churn or router runtime risk

## Non-negotiable guardrails
- real router traffic must not suffer because of UI work
- the Overview traffic weights chart must keep working normally
- provider SSL checks stay untouched unless explicitly requested
- router updater flow remains the built-in UI updater
