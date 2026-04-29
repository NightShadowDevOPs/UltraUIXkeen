#!/opt/bin/sh
# UI Mihomo Ultra v1.2.176 — concise zash-agent smoke checks.
# Safe: read-only HTTP/file/process diagnostics. Does not change routing, QoS, TUN or Mihomo config.
set -u

BASE_URL="${ZASH_AGENT_BASE_URL:-http://192.168.0.1:9099/cgi-bin/api.sh}"
TMP_DIR="/tmp/zash-agent-check-v1.2.176.$$"
WGET="/opt/bin/wget"
[ -x "$WGET" ] || WGET="wget"
mkdir -p "$TMP_DIR" 2>/dev/null || TMP_DIR="/tmp"

cleanup() {
  [ "$TMP_DIR" = "/tmp" ] || rm -rf "$TMP_DIR" 2>/dev/null || true
}
trap cleanup EXIT INT TERM

bool_file_has() {
  file="$1"
  needle="$2"
  grep -q "$needle" "$file" 2>/dev/null && echo true || echo false
}

field_json_string() {
  file="$1"
  key="$2"
  sed -n "s/.*\"$key\":\"\([^\"]*\)\".*/\1/p" "$file" 2>/dev/null | head -n 1
}

field_json_number() {
  file="$1"
  key="$2"
  sed -n "s/.*\"$key\":\([0-9][0-9]*\).*/\1/p" "$file" 2>/dev/null | head -n 1
}

fetch_cmd() {
  label="$1"
  cmd="$2"
  timeout="$3"
  hdr="$TMP_DIR/$label.headers"
  body="$TMP_DIR/$label.body"
  rm -f "$hdr" "$body" 2>/dev/null || true

  if "$WGET" -S -O "$body" -T "$timeout" "$BASE_URL?cmd=$cmd" >"$hdr" 2>&1; then
    rc=0
  else
    rc=$?
  fi

  http="$(grep 'HTTP/' "$hdr" 2>/dev/null | tail -n 1 | awk '{print $2}')"
  [ -n "$http" ] || http="NO_HTTP"
  ok="$(bool_file_has "$body" '"ok":true')"
  bytes=0
  [ -f "$body" ] && bytes="$(wc -c < "$body" 2>/dev/null | tr -d ' ')"

  echo "${label}_WGET_RC=$rc"
  echo "${label}_HTTP=$http"
  echo "${label}_OK=$ok"
  echo "${label}_BYTES=$bytes"

  if [ "$label" = "STATUS" ]; then
    version="$(field_json_string "$body" version)"
    server_version="$(field_json_string "$body" serverVersion)"
    cpu="$(field_json_number "$body" cpuPct)"
    mem="$(field_json_number "$body" memUsedPct)"
    temp="$(field_json_string "$body" tempC)"
    [ -n "$version" ] && echo "STATUS_VERSION=$version"
    [ -n "$server_version" ] && echo "STATUS_SERVER_VERSION=$server_version"
    [ -n "$cpu" ] && echo "STATUS_CPU_PCT=$cpu"
    [ -n "$mem" ] && echo "STATUS_MEM_PCT=$mem"
    [ -n "$temp" ] && echo "STATUS_TEMP_C=$temp"
  fi

  if [ "$label" = "HA_SNAPSHOT" ]; then
    contract="$(field_json_string "$body" contract)"
    agent_version="$(field_json_string "$body" agent_version)"
    [ -n "$contract" ] && echo "HA_SNAPSHOT_CONTRACT=$contract"
    [ -n "$agent_version" ] && echo "HA_SNAPSHOT_AGENT_VERSION=$agent_version"
    echo "HA_SNAPSHOT_HAS_STATUS=$(bool_file_has "$body" '"status":{"ok":true')"
    echo "HA_SNAPSHOT_HAS_TRAFFIC=$(bool_file_has "$body" '"traffic":{"ok":true')"
    echo "HA_SNAPSHOT_HAS_USERS=$(bool_file_has "$body" '"users":{"ok":true')"
    echo "HA_SNAPSHOT_HAS_QOS=$(bool_file_has "$body" '"qos":{"ok":true')"
  fi

  if [ "$label" = "MIHOMO_PROVIDERS" ]; then
    echo "MIHOMO_PROVIDERS_HAS_LIST=$(bool_file_has "$body" '"providers":\[')"
    provider_count="$(tr ',' '\n' < "$body" 2>/dev/null | grep -c '"name"' 2>/dev/null || echo 0)"
    echo "MIHOMO_PROVIDERS_NAME_MARKERS=$provider_count"
  fi
}

echo "CHECK_RELEASE=v1.2.176"
echo "BASE_URL=$BASE_URL"

echo
echo '=== env/path ==='
if [ -f /opt/zash-agent/agent.env ]; then
  grep -E '^(BIND_IP|PORT|LAN_IF|WAN_IF|MIHOMO_CONFIG)=' /opt/zash-agent/agent.env 2>/dev/null || true
  if grep -q '^TOKEN=' /opt/zash-agent/agent.env 2>/dev/null; then
    if grep -Eq '^TOKEN=""|^TOKEN=$' /opt/zash-agent/agent.env 2>/dev/null; then
      echo 'TOKEN_SET=false'
    else
      echo 'TOKEN_SET=true'
    fi
  fi
else
  echo 'AGENT_ENV=missing'
fi

echo
echo '=== files/syntax ==='
[ -x /opt/zash-agent/start.sh ] && echo 'START_SH_EXEC=true' || echo 'START_SH_EXEC=false'
[ -x /opt/zash-agent/www/cgi-bin/api.sh ] && echo 'API_SH_EXEC=true' || echo 'API_SH_EXEC=false'
[ -x /opt/etc/init.d/S99zash-agent ] && echo 'INIT_EXEC=true' || echo 'INIT_EXEC=false'
/opt/bin/sh -n /opt/zash-agent/www/cgi-bin/api.sh >/dev/null 2>&1 && echo 'API_SYNTAX=OK' || echo 'API_SYNTAX=FAIL'

echo
echo '=== process/listen ==='
ps w | grep -E '[u]httpd|[z]ash-agent|[a]pi.sh' || true
if netstat -lntp 2>/dev/null | grep ':9099'; then
  echo 'LISTEN_9099=true'
else
  echo 'LISTEN_9099=false'
fi

echo
echo '=== HTTP smoke ==='
fetch_cmd STATUS status 10
fetch_cmd HA_SNAPSHOT ha_snapshot 15
fetch_cmd MIHOMO_PROVIDERS mihomo_providers 15

echo
echo '=== result hint ==='
echo 'PASS when STATUS_HTTP=200, STATUS_OK=true, HA_SNAPSHOT_HTTP=200, HA_SNAPSHOT_OK=true, MIHOMO_PROVIDERS_HTTP=200.'
