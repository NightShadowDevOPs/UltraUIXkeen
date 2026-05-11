- Verify v1.2.194 in UI by editing one hosting payment date, pressing Save now, and checking router users-db fields.

# NEXT_ACTIONS

1. Deploy/update UI to v1.2.192.
2. Check provider table visually: provider names, access links, hosting date, SSL threshold, SSL expiry should be aligned.
3. Fill hosting due dates provider-by-provider.
4. Later, after SSH forwarding setup on PC, fill `Панель · SSH` per provider.
5. Verify that public panel closure does not break subscriptions and SSL checks.


## v1.2.193 — Provider Hosting Recurring Payments UI

- Added provider hosting payment period metadata: once / 1 / 3 / 6 / 12 months.
- Added `Оплатил` action to move next hosting due date by the selected period.
- Added colored `Осталось ... дней` hosting payment badge.
- Added users-db sync field `providerHostingPeriodMonths`.
- No router runtime, Mihomo, TUN, QoS/routing, Home Assistant, HA DB or SmartLife changes.
