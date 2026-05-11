#!/bin/sh
set +e
cd /opt/etc/mihomo 2>/dev/null || true
ROOT="${1:-/opt/etc/mihomo}"
echo "CHECK_HOSTING_RECURRING_VERSION=v1.2.193"
if [ -f "$ROOT/package.json" ]; then
  grep -q '"version"[[:space:]]*:[[:space:]]*"1.2.193"' "$ROOT/package.json" && echo "PACKAGE_VERSION_OK=yes" || echo "PACKAGE_VERSION_OK=no"
else
  echo "PACKAGE_VERSION_OK=unknown"
fi
FOUND_PERIOD=$(grep -Rsl 'proxyProviderHostingPeriodMonthsMap\|hostingPaymentPeriod\|markProviderHostingPaid' "$ROOT/src" "$ROOT/ui" "$ROOT/ultraui" "$ROOT/zash" "$ROOT/messire" 2>/dev/null | wc -l)
FOUND_BADGE=$(grep -Rsl 'hostingPaymentLeft\|badge-success\|Осталось' "$ROOT/src" "$ROOT/ui" "$ROOT/ultraui" "$ROOT/zash" "$ROOT/messire" 2>/dev/null | wc -l)
FOUND_SYNC=$(grep -Rsl 'providerHostingPeriodMonths' "$ROOT/src" "$ROOT/ui" "$ROOT/ultraui" "$ROOT/zash" "$ROOT/messire" 2>/dev/null | wc -l)
echo "HOSTING_PERIOD_MARKERS=$FOUND_PERIOD"
echo "HOSTING_LEFT_BADGE_MARKERS=$FOUND_BADGE"
echo "HOSTING_SYNC_MARKERS=$FOUND_SYNC"
if [ "$FOUND_PERIOD" -gt 0 ] && [ "$FOUND_BADGE" -gt 0 ] && [ "$FOUND_SYNC" -gt 0 ]; then
  echo "DECISION=OK"
else
  echo "DECISION=WARN_MARKERS_NOT_FOUND"
fi
