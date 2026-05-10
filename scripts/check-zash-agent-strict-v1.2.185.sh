#!/bin/sh
set +e
API_BASE="${API_BASE:-http://192.168.0.1:9099/cgi-bin/api.sh}"
API_FILE="${API_FILE:-/opt/zash-agent/www/cgi-bin/api.sh}"
echo "CHECK_STRICT_VERSION=v1.2.185"
echo "API_FILE_EXISTS=$([ -f "$API_FILE" ] && echo yes || echo no)"
echo "MARKER_PRESENT=$(grep -q 'v1.2.185 strict endpoint cache fallback' "$API_FILE" 2>/dev/null && echo yes || echo no)"
for c in ha_status ha_traffic ha_users ha_qos ha_snapshot; do
  body="$(curl -sS -m 12 "$API_BASE?cmd=$c" 2>/dev/null | tr -d '\n' | cut -c1-120)"
  case "$body" in *'strict-output-violation'*) state=STRICT_FAIL ;; *'"ok":true'*) state=OK ;; *) state=CHECK ;; esac
  echo "$c=$state"
done
