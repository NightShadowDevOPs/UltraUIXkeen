- Latest release v1.2.194 focuses on provider hosting payment persistence visibility. Continue from provider payment table UX and router users-db verification.

# SESSION_TRANSFER v1.2.192

This release is safe to hand off to another chat/session.

Release scope:

- UI-only provider table alignment.
- No runtime router-agent mutation.
- No HA or SmartLife changes.

Important behavior:

- `Панель · Internet` and `Панель · SSH` are metadata/navigation fields.
- The SSH panel URL is filled manually; there is no automatic SSH tunnel creation on the router.
- Hosting payment dates are filled manually per provider.
- SSL expiry should continue to use subscription certificate data.


## v1.2.193 — Provider Hosting Recurring Payments UI

- Added provider hosting payment period metadata: once / 1 / 3 / 6 / 12 months.
- Added `Оплатил` action to move next hosting due date by the selected period.
- Added colored `Осталось ... дней` hosting payment badge.
- Added users-db sync field `providerHostingPeriodMonths`.
- No router runtime, Mihomo, TUN, QoS/routing, Home Assistant, HA DB or SmartLife changes.
