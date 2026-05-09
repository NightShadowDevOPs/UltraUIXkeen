#!/opt/bin/sh
# UI Mihomo Ultra v1.2.180 — compact zash-agent watchdog check.
# Read-only except one watchdog probe may update /opt/zash-agent/var/watchdog.state.
set -u

AGENT_DIR="/opt/zash-agent"
ENV_FILE="$AGENT_DIR/agent.env"
[ -f "$ENV_FILE" ] && . "$ENV_FILE"
PORT="${PORT:-9099}"
BIND_IP="${BIND_IP:-192.168.0.1}"
[ "$BIND_IP" = "0.0.0.0" ] && PROBE_IP="192.168.0.1" || PROBE_IP="$BIND_IP"
BASE_URL="${ZASH_AGENT_BASE_URL:-http://$PROBE_IP:$PORT/cgi-bin/api.sh}"
SH_BIN="/opt/bin/sh"
[ -x "$SH_BIN" ] || SH_BIN="/bin/sh"

echo 'CHECK_RELEASE=v1.2.180'
echo 'CHECK_SCOPE=zash_agent_watchdog'
echo "BASE_URL=$BASE_URL"
echo "RESTART_SCRIPT_EXISTS=$([ -x /opt/zash-agent/restart-agent.sh ] && echo yes || echo no)"
echo "WATCHDOG_SCRIPT_EXISTS=$([ -x /opt/zash-agent/watchdog.sh ] && echo yes || echo no)"
echo "AGENT_VERSION=$(grep -o 'AGENT_VERSION="[^"]*"' /opt/zash-agent/www/cgi-bin/api.sh 2>/dev/null | head -n1 | cut -d'"' -f2)"
echo "LISTEN_9099=$(netstat -lntp 2>/dev/null | grep -q ':9099' && echo yes || echo no)"
echo 'CRON_HITS_BEGIN'
for f in /opt/etc/crontabs/root /opt/var/spool/cron/crontabs/root /etc/crontabs/root /var/spool/cron/crontabs/root; do
  [ -f "$f" ] || continue
  grep 'zash-agent-watchdog' "$f" 2>/dev/null | sed "s#^#$f: #"
done
echo 'CRON_HITS_END'
if command -v curl >/dev/null 2>&1; then
  body="$(curl -sS -m 12 "$BASE_URL?cmd=ha_snapshot" 2>/dev/null || true)"
else
  body="$(wget -q -T 12 -O - "$BASE_URL?cmd=ha_snapshot" 2>/dev/null || true)"
fi
echo "SNAPSHOT_OK=$(echo "$body" | grep -q '"ok":true' && echo yes || echo no)"
echo "SNAPSHOT_HAS_STATUS=$(echo "$body" | grep -q '"status":{"ok":true' && echo yes || echo no)"
echo "SNAPSHOT_HAS_TRAFFIC=$(echo "$body" | grep -q '"traffic":{"ok":true' && echo yes || echo no)"
echo "SNAPSHOT_HAS_USERS=$(echo "$body" | grep -q '"users":{"ok":true' && echo yes || echo no)"
echo "SNAPSHOT_HAS_QOS=$(echo "$body" | grep -q '"qos":{"ok":true' && echo yes || echo no)"
if [ -x /opt/zash-agent/watchdog.sh ]; then
  echo 'WATCHDOG_PROBE_BEGIN'
  $SH_BIN /opt/zash-agent/watchdog.sh | tail -n 5
  echo 'WATCHDOG_PROBE_END'
fi
if [ -x /opt/zash-agent/restart-agent.sh ] && [ -x /opt/zash-agent/watchdog.sh ]; then
  echo 'CHECK_STATUS=OK'
else
  echo 'CHECK_STATUS=WARN_MISSING_FILES'
fi
