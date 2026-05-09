#!/opt/bin/sh
# UI Mihomo Ultra v1.2.180 — scoped zash-agent restart helper.
# Restarts only /opt/zash-agent uhttpd and stale CGI children.
# Does not touch Mihomo core, TUN, QoS rules, routing, provider SSL checks or router reboot.
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
SH_BIN="/opt/bin/sh"
[ -x "$SH_BIN" ] || SH_BIN="/bin/sh"

mkdir -p "$AGENT_DIR/var" "$LOG_DIR" 2>/dev/null || true
now() { date '+%Y-%m-%d %H:%M:%S' 2>/dev/null || date 2>/dev/null || echo now; }
log() { echo "$(now) $*" >> "$LOG_FILE" 2>/dev/null || true; echo "$*"; }
rotate_log() {
  [ -f "$LOG_FILE" ] || return 0
  size="$(wc -c < "$LOG_FILE" 2>/dev/null || echo 0)"
  if [ "$size" -gt 262144 ]; then
    tail -n 500 "$LOG_FILE" > "$LOG_FILE.tmp" 2>/dev/null && mv "$LOG_FILE.tmp" "$LOG_FILE" 2>/dev/null || true
  fi
}

probe_status() {
  if command -v curl >/dev/null 2>&1; then
    body="$(curl -sS -m 8 "$BASE_URL?cmd=status" 2>/dev/null || true)"
  else
    body="$(wget -q -T 8 -O - "$BASE_URL?cmd=status" 2>/dev/null || true)"
  fi
  echo "$body" | grep -q '"ok":true'
}

stop_agent() {
  log 'STOP_AGENT=BEGIN'
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
  log 'STOP_AGENT=OK'
}

start_agent() {
  log 'START_AGENT=BEGIN'
  if [ -x /opt/etc/init.d/S99zash-agent ]; then
    /opt/etc/init.d/S99zash-agent start >> "$LOG_FILE" 2>&1 || true
  elif [ -x "$AGENT_DIR/start.sh" ]; then
    "$SH_BIN" "$AGENT_DIR/start.sh" >> "$LOG_FILE" 2>&1 || true
  else
    log 'START_AGENT=FAIL_NO_START_SCRIPT'
    return 1
  fi
  sleep 4
  if probe_status; then
    log 'START_AGENT=OK'
    return 0
  fi
  log 'START_AGENT=WARN_STATUS_PROBE_FAILED'
  return 1
}

rotate_log
log 'RESTART_AGENT=BEGIN'
log "BASE_URL=$BASE_URL"
stop_agent
start_agent
rc=$?
if [ "$rc" -eq 0 ]; then
  log 'RESTART_AGENT=OK'
  echo 'RESTART_AGENT_STATUS=OK'
else
  log 'RESTART_AGENT=FAIL'
  echo 'RESTART_AGENT_STATUS=FAIL'
fi
exit "$rc"
