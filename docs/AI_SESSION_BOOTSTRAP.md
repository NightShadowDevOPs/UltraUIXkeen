# AI_SESSION_BOOTSTRAP v1.2.192

Continue from UI Mihomo Ultra / router-agent v1.2.192.

Known current state:

- v1.2.187 fixed HA snapshot CPU/load mapping.
- v1.2.188 added provider access link fields and SSL source metadata.
- v1.2.189 added/manualized saved panel SSH URL workflow.
- v1.2.190 improved provider name visibility and URL table basics.
- v1.2.191 added hosting payment due dates.
- v1.2.192 aligns the provider table columns and shortens URL inputs.

Do not touch Home Assistant, HA DB, SmartLife boiler, native HA Energy, Mihomo core, TUN, QoS/routing, users-db or shapers.db unless explicitly approved.


## v1.2.193 — Provider Hosting Recurring Payments UI

- Added provider hosting payment period metadata: once / 1 / 3 / 6 / 12 months.
- Added `Оплатил` action to move next hosting due date by the selected period.
- Added colored `Осталось ... дней` hosting payment badge.
- Added users-db sync field `providerHostingPeriodMonths`.
- No router runtime, Mihomo, TUN, QoS/routing, Home Assistant, HA DB or SmartLife changes.
