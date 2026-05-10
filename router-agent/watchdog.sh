#!/opt/bin/sh
# UI Mihomo Ultra v1.2.184 — zash-agent watchdog.
# Checks status + ha_snapshot transport health and restarts only zash-agent when transport is stuck.
# v1.2.184 fixes false positive restarts: nested ha_snapshot bundle fields are diagnostic only.
# Safe scope: no Mihomo core, no TUN, no QoS/routing changes, no provider SSL changes, no router reboot.
set -u

AGENT_DIR="/opt/zash-agent"
ENV_FILE="$AGENT_DIR/agent.env"
[ -f "$ENV_FILE" ] && . "$ENV_FILE"
PORT="${PORT:-9099}"
BIND_IP="${BIND_IP:-192.168.0.1}"
[ "$BIND_IP" = "0.0.0.0" ] && PROBE_IP="192.168.0.1" || PROBE_IP="$BIND_IP"
BASE_URL="${ZASH_AGENT_BASE_URL:-http://$PROBE_IP:$PORT/cgi-bin/api.sh}"
FAIL_THRESHOLD="${ZASH_AGENT_WATCHDOG_FAIL_THRESHOLD:-2}"
RESTART_COOLDOWN_SECS="${ZASH_AGENT_WATCHDOG_RESTART_COOLDOWN_SECS:-300}"
STATUS_TIMEOUT="${ZASH_AGENT_WATCHDOG_STATUS_TIMEOUT:-8}"
SNAPSHOT_TIMEOUT="${ZASH_AGENT_WATCHDOG_SNAPSHOT_TIMEOUT:-15}"
STATE_DIR="$AGENT_DIR/var"
STATE_FILE="$STATE_DIR/watchdog.state"
LOCK_DIR="$STATE_DIR/watchdog.lock"
LOG_DIR="/opt/var/log/zash-agent"
LOG_FILE="$LOG_DIR/watchdog.log"
RESTART_SCRIPT="$AGENT_DIR/restart-agent.sh"
SH_BIN="/opt/bin/sh"
[ -x "$SH_BIN" ] || SH_BIN="/bin/sh"

mkdir -p "$STATE_DIR" "$LOG_DIR" 2>/dev/null || true
now_epoch() { date +%s 2>/dev/null || echo 0; }
now_human() { date '+%Y-%m-%d %H:%M:%S' 2>/dev/null || date 2>/dev/null || echo now; }
log() { echo "$(now_human) $*" >> "$LOG_FILE" 2>/dev/null || true; echo "$*"; }
rotate_log() {
  [ -f "$LOG_FILE" ] || return 0
  size="$(wc -c < "$LOG_FILE" 2>/dev/null || echo 0)"
  if [ "$size" -gt 262144 ]; then
    tail -n 500 "$LOG_FILE" > "$LOG_FILE.tmp" 2>/dev/null && mv "$LOG_FILE.tmp" "$LOG_FILE" 2>/dev/null || true
  fi
}
cleanup_lock() { rmdir "$LOCK_DIR" 2>/dev/null || true; }

if ! mkdir "$LOCK_DIR" 2>/dev/null; then
  echo 'WATCHDOG_STATUS=SKIP_LOCKED'
  exit 0
fi
trap cleanup_lock EXIT INT TERM
rotate_log

fetch_body() {
  cmd="$1"; timeout="$2"; out="$3"
  rm -f "$out" 2>/dev/null || true
  if command -v curl >/dev/null 2>&1; then
    curl -sS -m "$timeout" "$BASE_URL?cmd=$cmd" > "$out" 2>/dev/null
    return $?
  fi
  wget -q -T "$timeout" -O "$out" "$BASE_URL?cmd=$cmd" 2>/dev/null
  return $?
}
body_has() { grep -qF "$2" "$1" 2>/dev/null; }

check_agent() {
  tmp_base="/tmp/zash-agent-watchdog.$$"
  status_body="$tmp_base.status"
  snapshot_body="$tmp_base.snapshot"
  fetch_body status "$STATUS_TIMEOUT" "$status_body"; status_rc=$?
  fetch_body ha_snapshot "$SNAPSHOT_TIMEOUT" "$snapshot_body"; snapshot_rc=$?

  status_ok=false; snapshot_ok=false; bundle_ok=false
  bundle_status_ok=false; bundle_traffic_ok=false; bundle_users_ok=false; bundle_qos_ok=false
  body_has "$status_body" '"ok":true' && status_ok=true
  body_has "$snapshot_body" '"ok":true' && snapshot_ok=true
  body_has "$snapshot_body" '"status":{"ok":true' && bundle_status_ok=true
  body_has "$snapshot_body" '"traffic":{"ok":true' && bundle_traffic_ok=true
  body_has "$snapshot_body" '"users":{"ok":true' && bundle_users_ok=true
  body_has "$snapshot_body" '"qos":{"ok":true' && bundle_qos_ok=true
  if [ "$bundle_status_ok" = true ] && [ "$bundle_traffic_ok" = true ] && [ "$bundle_users_ok" = true ] && [ "$bundle_qos_ok" = true ]; then
    bundle_ok=true
  fi
  rm -f "$status_body" "$snapshot_body" 2>/dev/null || true

  echo "STATUS_RC=$status_rc STATUS_OK=$status_ok SNAPSHOT_RC=$snapshot_rc SNAPSHOT_OK=$snapshot_ok BUNDLE_OK=$bundle_ok BUNDLE_STATUS_OK=$bundle_status_ok BUNDLE_TRAFFIC_OK=$bundle_traffic_ok BUNDLE_USERS_OK=$bundle_users_ok BUNDLE_QOS_OK=$bundle_qos_ok POLICY=transport_ok"
  # v1.2.184 policy: restart only when transport/root health is bad.
  # A partial nested bundle is a data/cache issue, not a reason to restart uhttpd.
  [ "$status_rc" -eq 0 ] && [ "$snapshot_rc" -eq 0 ] && [ "$status_ok" = true ] && [ "$snapshot_ok" = true ]
}

read_state() {
  FAIL_COUNT=0
  LAST_RESTART=0
  if [ -f "$STATE_FILE" ]; then
    . "$STATE_FILE" 2>/dev/null || true
  fi
  FAIL_COUNT="${FAIL_COUNT:-0}"
  LAST_RESTART="${LAST_RESTART:-0}"
}
write_state() {
  {
    echo "FAIL_COUNT=${FAIL_COUNT:-0}"
    echo "LAST_RESTART=${LAST_RESTART:-0}"
    echo "LAST_CHECK=$(now_epoch)"
    echo "LAST_CHECK_ISO=$(now_human)"
    echo "LAST_STATUS=${LAST_STATUS:-unknown}"
  } > "$STATE_FILE" 2>/dev/null || true
}

read_state
if check_agent >/tmp/zash-watchdog-last.$$ 2>/dev/null; then
  CHECK_LINE="$(cat /tmp/zash-watchdog-last.$$ 2>/dev/null)"
  rm -f /tmp/zash-watchdog-last.$$ 2>/dev/null || true
  FAIL_COUNT=0
  LAST_STATUS=OK
  write_state
  log "WATCHDOG_OK BASE_URL=$BASE_URL $CHECK_LINE"
  echo "WATCHDOG_STATUS=OK $CHECK_LINE"
  exit 0
fi
CHECK_LINE="$(cat /tmp/zash-watchdog-last.$$ 2>/dev/null)"
rm -f /tmp/zash-watchdog-last.$$ 2>/dev/null || true

FAIL_COUNT=$((FAIL_COUNT + 1))
now="$(now_epoch)"
log "WATCHDOG_FAIL_COUNT=$FAIL_COUNT THRESHOLD=$FAIL_THRESHOLD BASE_URL=$BASE_URL $CHECK_LINE"

if [ "$FAIL_COUNT" -lt "$FAIL_THRESHOLD" ]; then
  LAST_STATUS=WARN_FAIL_COUNT
  write_state
  echo "WATCHDOG_STATUS=WARN_FAIL_COUNT FAIL_COUNT=$FAIL_COUNT THRESHOLD=$FAIL_THRESHOLD $CHECK_LINE"
  exit 0
fi

age=$((now - LAST_RESTART))
if [ "$LAST_RESTART" -gt 0 ] && [ "$age" -lt "$RESTART_COOLDOWN_SECS" ]; then
  LAST_STATUS=WARN_COOLDOWN
  write_state
  echo "WATCHDOG_STATUS=WARN_COOLDOWN FAIL_COUNT=$FAIL_COUNT COOLDOWN_LEFT=$((RESTART_COOLDOWN_SECS - age)) $CHECK_LINE"
  exit 0
fi

if [ ! -x "$RESTART_SCRIPT" ]; then
  LAST_STATUS=FAIL_NO_RESTART_SCRIPT
  write_state
  log "WATCHDOG_RESTART=FAIL_NO_RESTART_SCRIPT path=$RESTART_SCRIPT"
  echo "WATCHDOG_STATUS=FAIL_NO_RESTART_SCRIPT"
  exit 1
fi

log 'WATCHDOG_RESTART=BEGIN'
$SH_BIN "$RESTART_SCRIPT" >> "$LOG_FILE" 2>&1 || /bin/sh "$RESTART_SCRIPT" >> "$LOG_FILE" 2>&1 || true
LAST_RESTART="$(now_epoch)"
sleep 5
if check_agent >/tmp/zash-watchdog-after.$$ 2>/dev/null; then
  AFTER_LINE="$(cat /tmp/zash-watchdog-after.$$ 2>/dev/null)"
  rm -f /tmp/zash-watchdog-after.$$ 2>/dev/null || true
  FAIL_COUNT=0
  LAST_STATUS=RESTARTED_OK
  write_state
  log "WATCHDOG_RESTART=OK $AFTER_LINE"
  echo "WATCHDOG_STATUS=RESTARTED_OK $AFTER_LINE"
  exit 0
fi
AFTER_LINE="$(cat /tmp/zash-watchdog-after.$$ 2>/dev/null)"
rm -f /tmp/zash-watchdog-after.$$ 2>/dev/null || true
LAST_STATUS=RESTARTED_BUT_STILL_FAIL
write_state
log "WATCHDOG_RESTART=FAIL_AFTER_RESTART $AFTER_LINE"
echo "WATCHDOG_STATUS=RESTARTED_BUT_STILL_FAIL $AFTER_LINE"
exit 1
