# CHECKS_AND_STATUS v1.2.192

Static checks performed locally on release source:

```text
CHECK_PROVIDER_TABLE_LAYOUT_VERSION=v1.2.192
SOURCE_FILE_PRESENT=yes
PACKAGE_VERSION=version:1.2.192
COL_COUNT=5
TH_COUNT=5
HAS_PROVIDER_NAME_BADGE=yes
HAS_SHORT_URL_INPUT=yes
HAS_TABLE_FIXED=yes
```

Runtime deploy was not executed by the release builder.


## v1.2.193 — Provider Hosting Recurring Payments UI

- Added provider hosting payment period metadata: once / 1 / 3 / 6 / 12 months.
- Added `Оплатил` action to move next hosting due date by the selected period.
- Added colored `Осталось ... дней` hosting payment badge.
- Added users-db sync field `providerHostingPeriodMonths`.
- No router runtime, Mihomo, TUN, QoS/routing, Home Assistant, HA DB or SmartLife changes.
