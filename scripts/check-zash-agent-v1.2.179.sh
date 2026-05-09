#!/opt/bin/sh
# UI Mihomo Ultra v1.2.179 — compact zash-agent smoke check.
# Safe/read-only. Does not change routing, QoS, TUN, Mihomo config or provider SSL logic.
set -u

BASE_URL="${ZASH_AGENT_BASE_URL:-http://192.168.0.1:9099/cgi-bin/api.sh}"
TMP_DIR="/tmp/zash-agent-check-v1.2.179.$$"
WGET="/opt/bin/wget"
[ -x "$WGET" ] || WGET="wget"
mkdir -p "$TMP_DIR" 2>/dev/null || TMP_DIR="/tmp"
cleanup() { [ "$TMP_DIR" = "/tmp" ] || rm -rf "$TMP_DIR" 2>/dev/null || true; }
trap cleanup EXIT INT TERM

json_bool() { grep -q "$2" "$1" 2>/dev/null && echo true || echo false; }
json_string() { file="$1"; key="$2"; sed -n 's/.*"'$key'":"\([^"]*\)".*/\1/p' "$file" 2>/dev/null | head -n 1; }

fetch_line() {
  label="$1"; cmd="$2"; timeout="$3"; hdr="$TMP_DIR/$label.headers"; body="$TMP_DIR/$label.body"
  rm -f "$hdr" "$body" 2>/dev/null || true
  if "$WGET" -S -O "$body" -T "$timeout" "$BASE_URL?cmd=$cmd" >"$hdr" 2>&1; then rc=0; else rc=$?; fi
  http="$(grep 'HTTP/' "$hdr" 2>/dev/null | tail -n 1 | awk '{print $2}')"; [ -n "$http" ] || http="NO_HTTP"
  ok="$(json_bool "$body" '"ok":true')"
  bytes=0; [ -f "$body" ] && bytes="$(wc -c < "$body" 2>/dev/null | tr -d ' ')"
  extra=""
  if [ "$label" = "STATUS" ]; then
    v="$(json_string "$body" version)"; [ -n "$v" ] && extra=" STATUS_VERSION=$v"
  fi
  if [ "$label" = "HA_SNAPSHOT" ]; then
    hs="$(json_bool "$body" '"status":{"ok":true')"
    ht="$(json_bool "$body" '"traffic":{"ok":true')"
    hu="$(json_bool "$body" '"users":{"ok":true')"
    hq="$(json_bool "$body" '"qos":{"ok":true')"
    extra=" HAS_STATUS=$hs HAS_TRAFFIC=$ht HAS_USERS=$hu HAS_QOS=$hq"
  fi
  echo "${label}_RC=$rc ${label}_HTTP=$http ${label}_OK=$ok ${label}_BYTES=$bytes$extra"
}

echo 'CHECK_RELEASE=v1.2.179'
echo 'TARGET_AGENT_VERSION=0.6.37'
if [ -f /opt/zash-agent/agent.env ]; then
  token_set=false
  if grep -q '^TOKEN=' /opt/zash-agent/agent.env 2>/dev/null && ! grep -Eq '^TOKEN=""|^TOKEN=$' /opt/zash-agent/agent.env 2>/dev/null; then token_set=true; fi
  echo "AGENT_ENV=present TOKEN_SET=$token_set"
else
  echo 'AGENT_ENV=missing TOKEN_SET=unknown'
fi
/opt/bin/sh -n /opt/zash-agent/www/cgi-bin/api.sh >/dev/null 2>&1 && api_syntax=OK || api_syntax=FAIL
[ -x /opt/zash-agent/www/cgi-bin/api.sh ] && api_exec=true || api_exec=false
[ -x /opt/etc/init.d/S99zash-agent ] && init_exec=true || init_exec=false
echo "FILES_STATUS=api_exec:$api_exec init_exec:$init_exec api_syntax:$api_syntax"
netstat -lntp 2>/dev/null | grep -q ':9099' && listen=true || listen=false
echo "LISTEN_9099=$listen"
fetch_line STATUS status 10
fetch_line HA_STATUS ha_status 12
fetch_line HA_TRAFFIC ha_traffic 12
fetch_line HA_USERS ha_users 15
fetch_line HA_QOS ha_qos 15
fetch_line HA_SNAPSHOT ha_snapshot 15
fetch_line MIHOMO_PROVIDERS mihomo_providers 15
if [ "$api_syntax" = OK ] && [ "$listen" = true ]; then
  echo 'CHECK_STATUS=OK_OR_ENDPOINTS_TO_REVIEW'
else
  echo 'CHECK_STATUS=WARN'
fi
