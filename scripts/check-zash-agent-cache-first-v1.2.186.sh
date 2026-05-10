#!/bin/sh
set +e
API_BASE="${API_BASE:-http://192.168.0.1:9099/cgi-bin/api.sh}"
API_FILE="${API_FILE:-/opt/zash-agent/www/cgi-bin/api.sh}"
echo "CHECK_CACHE_FIRST_VERSION=v1.2.186"
echo "MARKER_PRESENT=$(grep -q 'v1.2.186 direct HA cache-first stale fallback' "$API_FILE" 2>/dev/null && echo yes || echo no)"
for c in ha_status ha_traffic ha_users ha_qos ha_snapshot; do
  t="$(curl -sS -o /dev/null -m 15 -w '%{http_code}/%{time_total}' "$API_BASE?cmd=$c" 2>/dev/null)"
  echo "$c=$t"
done
echo "WATCHDOG=$(cat /opt/zash-agent/var/watchdog.state 2>/dev/null | tr '
' ';')"
