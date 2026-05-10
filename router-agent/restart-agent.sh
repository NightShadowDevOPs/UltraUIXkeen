#!/opt/bin/sh
# UI Mihomo Ultra v1.2.182 — zash-agent restart helper.
# Preferred path: Entware init service /opt/etc/init.d/S99zash-agent restart.
# Fallback remains scoped to /opt/zash-agent uhttpd and stale CGI children only.
# Does not touch Mihomo core, TUN, QoS rules, routing, provider SSL checks, users-db, shapers.db or router reboot.
set -u

AGENT_DIR="/opt/zash-agent"
ENV_FILE="$AGENT_DIR/agent.env"
[ -f "$ENV_FILE" ] && . "$ENV_FILE"
PORT="${PORT:-9099}"
BIND_IP="${BIND_IP:-192.168.0.1}"
[ "$BIND_IP" = "0.0.0.0" ] && PROBE_IP="192.168.0.1" || PROBE_IP="$BIND_IP"
BASE_URL="${ZASH_AGENT_BASE_URL:-http://$PROBE_IP:$PORT/cgi-bin/api.sh}"
PID_FILE="$AGENT_DIR/var/httpd.pid"
LOG_DIR="/opt/var/log/zash-agent"
LOG_FILE="$LOG_DIR/restart-agent.log"
INIT_SCRIPT="/opt/etc/init.d/S99zash-agent"
SH_BIN="/opt/bin/sh"
[ -x "$SH_BIN" ] || SH_BIN="/bin/sh"

mkdir -p "$AGENT_DIR/var" "$LOG_DIR" 2>/dev/null || true
now() { date '+%Y-%m-%d %H:%M:%S' 2>/dev/null || date 2>/dev/null || echo now; }
log() { echo "$(now) $*" >> "$LOG_FILE" 2>/dev/null || true; echo "$*"; }
rotate_log() {
  [ -f "$LOG_FILE" ] || return 0
  size="$(wc -c < "$LOG_FILE" 2>/dev/null || echo 0)"
  if [ "$size" -gt 262144 ] 2>/dev/null; then
    tail -n 500 "$LOG_FILE" > "$LOG_FILE.tmp" 2>/dev/null && mv "$LOG_FILE.tmp" "$LOG_FILE" 2>/dev/null || true
  fi
}
fetch_cmd() {
  url="$1"
  if command -v curl >/dev/null 2>&1; then
    curl -sS -m 8 "$url" 2>/dev/null || true
  else
    wget -q -T 8 -O - "$url" 2>/dev/null || true
  fi
}
probe_status() {
  body="$(fetch_cmd "$BASE_URL?cmd=status")"
  echo "$body" | grep -q '"ok":true'
}
probe_snapshot() {
  body="$(fetch_cmd "$BASE_URL?cmd=ha_snapshot")"
  echo "$body" | grep -q '"ok":true' || return 1
  echo "$body" | grep -q '"status":{"ok":true' || return 1
  echo "$body" | grep -q '"traffic":{"ok":true' || return 1
  echo "$body" | grep -q '"users":{"ok":true' || return 1
  echo "$body" | grep -q '"qos":{"ok":true' || return 1
  return 0
}
probe_bundle() {
  probe_status && probe_snapshot
}
service_restart() {
  [ -x "$INIT_SCRIPT" ] || return 1
  log "SERVICE_RESTART=BEGIN INIT=$INIT_SCRIPT"
  "$INIT_SCRIPT" restart >> "$LOG_FILE" 2>&1 || true
  sleep 5
  if probe_bundle; then
    log 'SERVICE_RESTART=OK'
    return 0
  fi
  log 'SERVICE_RESTART=WARN_PROBE_FAILED'
  return 1
}
stop_agent_scoped() {
  log 'SCOPED_STOP=BEGIN'
  if [ -f "$PID_FILE" ]; then
    pid="$(cat "$PID_FILE" 2>/dev/null || true)"
    if [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null; then
      if ps w | awk -v p="$pid" '$1 == p {print}' | grep -q '/opt/zash-agent/www'; then
        kill "$pid" 2>/dev/null || true
        sleep 1
        kill -0 "$pid" 2>/dev/null && kill -9 "$pid" 2>/dev/null || true
      else
        log "PID_FILE_FOREIGN_OR_STALE=$pid"
      fi
    fi
    rm -f "$PID_FILE" 2>/dev/null || true
  fi
  ps w | grep '[u]httpd' | grep '/opt/zash-agent/www' | awk '{print $1}' | while read p; do [ -n "$p" ] && kill "$p" 2>/dev/null || true; done
  sleep 1
  ps w | grep '[u]httpd' | grep '/opt/zash-agent/www' | awk '{print $1}' | while read p; do [ -n "$p" ] && kill -9 "$p" 2>/dev/null || true; done
  ps w | grep '/opt/zash-agent/www/cgi-bin/api.sh' | grep -v grep | awk '{print $1}' | while read p; do [ -n "$p" ] && kill "$p" 2>/dev/null || true; done
  sleep 1
  ps w | grep '/opt/zash-agent/www/cgi-bin/api.sh' | grep -v grep | awk '{print $1}' | while read p; do [ -n "$p" ] && kill -9 "$p" 2>/dev/null || true; done
  log 'SCOPED_STOP=OK'
}
start_agent_fallback() {
  log 'FALLBACK_START=BEGIN'
  if [ -x "$INIT_SCRIPT" ]; then
    "$INIT_SCRIPT" start >> "$LOG_FILE" 2>&1 || true
  elif [ -x "$AGENT_DIR/start.sh" ]; then
    "$SH_BIN" "$AGENT_DIR/start.sh" >> "$LOG_FILE" 2>&1 || true
  else
    log 'FALLBACK_START=FAIL_NO_START_SCRIPT'
    return 1
  fi
  sleep 5
  if probe_bundle; then
    log 'FALLBACK_START=OK'
    return 0
  fi
  log 'FALLBACK_START=WARN_PROBE_FAILED'
  return 1
}
manual_fallback_restart() {
  log 'MANUAL_FALLBACK_RESTART=BEGIN'
  stop_agent_scoped
  start_agent_fallback
}

rotate_log
log 'RESTART_AGENT=BEGIN VERSION=v1.2.182'
log "BASE_URL=$BASE_URL"
if service_restart; then
  echo 'RESTART_AGENT_MODE=service_restart'
  echo 'RESTART_AGENT_STATUS=OK'
  exit 0
fi
log 'RESTART_AGENT=FALLBACK_SCOPED'
manual_fallback_restart
rc=$?
if [ "$rc" -eq 0 ]; then
  log 'RESTART_AGENT=OK_FALLBACK_SCOPED'
  echo 'RESTART_AGENT_MODE=fallback_scoped'
  echo 'RESTART_AGENT_STATUS=OK'
else
  log 'RESTART_AGENT=FAIL'
  echo 'RESTART_AGENT_MODE=fallback_scoped'
  echo 'RESTART_AGENT_STATUS=FAIL'
fi
exit "$rc"
