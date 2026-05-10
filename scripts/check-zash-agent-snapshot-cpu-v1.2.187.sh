#!/bin/sh
set +e
API_BASE="${API_BASE:-http://192.168.0.1:9099/cgi-bin/api.sh}"
API_FILE="${API_FILE:-/opt/zash-agent/www/cgi-bin/api.sh}"
echo "CHECK_SNAPSHOT_CPU_VERSION=v1.2.187"
echo "MARKER_PRESENT=$(grep -q 'v1.2.187 ha_snapshot live CPU/load overlay' "$API_FILE" 2>/dev/null && echo yes || echo no)"
i=1
while [ "$i" -le 5 ]; do
  st="$(curl -sS -m 8 "$API_BASE?cmd=status" 2>/dev/null)"
  sn="$(curl -sS -m 8 "$API_BASE?cmd=ha_snapshot" 2>/dev/null)"
  scpu="$(printf '%s' "$st" | sed -n 's/.*"cpuPct":\([0-9][0-9.]*\).*/\1/p' | head -n 1)"
  hcpu="$(printf '%s' "$sn" | sed -n 's/.*"cpu_pct":\([0-9][0-9.]*\).*/\1/p' | head -n 1)"
  hload="$(printf '%s' "$sn" | sed -n 's/.*"load":{\([^}]*\)}.*/{\1}/p' | head -n 1)"
  echo "SAMPLE_$i status_cpu=${scpu:-NA} snapshot_cpu=${hcpu:-NA} load=${hload:-NA}"
  i=$((i+1))
  sleep 1
done
echo "WATCHDOG=$(cat /opt/zash-agent/var/watchdog.state 2>/dev/null | tr '\n' ';')"
