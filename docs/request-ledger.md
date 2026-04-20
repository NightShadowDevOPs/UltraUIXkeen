# Request ledger — UI Mihomo / Ultra

## 2026-04-20 — pause hidden polling in Tasks live logs without touching HA shape
- User request: make the next release, keep all explanations in Russian, keep updating documentation and memory snapshot, and do **not** additionally break the router data structure exported to Home Assistant through the agent.
- Problem: `Задачи → Живые логи` could continue polling every 5 seconds even when the user was not looking at that widget.
- Action in `v1.2.160`: added visibility-aware pause/resume for the live-logs polling loop and a small badge explaining whether auto-refresh is active or paused.
- Safety rule preserved: no changes to router-agent, provider SSL probing runtime, real traffic forwarding, or the HA/export JSON shape.

## 2026-04-20 — off-screen pause for Overview relationship charts
- User request: continue the work, keep explanations in Russian, and keep reducing load carefully without harming router traffic or the Overview traffic-weights diagram.
- Problem: Overview relationship charts by sources / clients / rules could continue local snapshot refresh even when the user had not scrolled to them or the tab was hidden.
- Action in `v1.2.159`: added visibility-aware pause/resume for those chart polling loops, while keeping the shared refresh setting and visible-state behavior intact.
- Safety rule preserved: no changes to router-agent, live traffic forwarding, provider SSL probing, or the visible-state chart logic.

## 2026-04-20 — provider-row source transparency after cleanup
- User request: continue the release flow and make it visually clear why disabled SSL-capable providers remain in the Tasks list.
- Problem: after the cleanup release, it could still look confusing when an active provider remained visible after delete, because the action removed only saved UI settings while runtime still supplied the row.
- Action in `v1.2.158`: added explicit row-state badges for active runtime and saved UI state, clarified delete behavior with contextual tooltips/notifications, and ensured saved-only rows disappear cleanly without visual tails.
- Safety rule preserved: no changes to router-agent, live traffic flow, or provider SSL probing runtime.

## 2026-04-20 — cleanup saved-only provider-panel rows
- User request: make a release and clarify how disabled SSL-capable providers should be removed from the Tasks list.
- Problem: provider rows could survive in Tasks because their panel URL / icon / SSL threshold stayed in saved UI settings even after the provider disappeared from the active contour.
- Action in `v1.2.157`: added saved-only marking for such rows and UI cleanup actions — delete one row or bulk-clean all disabled/orphaned rows.
- Safety rule preserved: no changes to router-agent, live traffic flow, or provider SSL probing runtime.

## 2026-04-20
- User request: continue after `v1.2.148` and keep reducing router-side pressure without harming real traffic.
- User constraint: traffic through the router must not suffer.
- User constraint: the Overview diagram with traffic weights must keep working normally.
- Action in `v1.2.149`: added UI-side short-lived dedupe/cache for `traffic_live`, `host_traffic_live` and `lan_hosts` requests.
- Action in `v1.2.149`: added fallback to the last stable live telemetry sample for Overview/Traffic graphs and host live stats so brief agent misses do not zero charts.
- Action in `v1.2.150`: slowed down secondary Host QoS / Users QoS background refresh loops, while keeping the main live traffic contour intact.
- Action in `v1.2.150`: added brief cache windows for repeated `status`, `qos_status` and `lan_hosts` reads inside Traffic/QoS widget flows.
- Action in `v1.2.150`: silent background refresh in Host QoS no longer flips the loading state on every timer tick.
- Action in `v1.2.151`: made secondary Host QoS / Users QoS polling viewport-aware so invisible cards pause background refresh.
- Action in `v1.2.151`: when those cards become visible again, UI triggers a soft QoS/runtime refresh without changing the main traffic live contour.
- Follow-up request to keep in scope: keep looking at what can be taken safely from upstream, but only if it does not increase background load or endanger runtime traffic.
- Action in `v1.2.152`: extended the same viewport-aware lazy strategy to Router → Resources and Router agent cards so invisible host-status widgets pause background refresh.
- Action in `v1.2.152`: when those host-status cards return into view, UI triggers a soft runtime refresh without touching the main traffic live contour.
- Action in `v1.2.153`: added viewport-aware lazy polling to Overview → Router Health so its background `/version` probe pauses while the widget is off-screen.
- Action in `v1.2.153`: when Router Health returns into view, UI triggers a soft health refresh without touching the main traffic contour or traffic weights chart.
- Action in `v1.2.154`: added viewport-aware pause for secondary host-detail polling inside Overview → Traffic, while leaving the main live traffic loop intact.
- Action in `v1.2.154`: slightly thinned Host QoS metadata refresh and expanded-host remote-target refresh to cut background pressure without affecting packet forwarding.
- Action in `v1.2.155`: slowed the main Overview → Traffic live polling from 4s to 8s while the card is off-screen, but left visible-card cadence unchanged.
- Action in `v1.2.155`: when the traffic card becomes visible again, UI now refreshes immediately so the traffic weights diagram stays responsive in the visible state.
- Action in `v1.2.156`: manual mass latency tests now run with a small concurrency limit instead of one large parallel burst.
- Action in `v1.2.156`: effective test URLs are now resolved more consistently in single and bulk/manual latency tests when independent latency URLs are enabled.

- Action in `v1.2.161`: extended hidden-tab polling pause to Router/System, Router agent, Host QoS and Users QoS cards, without touching router-agent or HA export shape.
