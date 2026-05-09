#!/opt/bin/sh
# UI Mihomo Ultra v1.2.179 — lightweight zash-agent patch installer.
# Scope: /opt/zash-agent files and /opt/etc/init.d/S99zash-agent only.
# Does not change Mihomo core, TUN, QoS semantics, routing rules or provider SSL logic.
set -u

SCRIPT_PATH="$0"
SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$SCRIPT_PATH")" 2>/dev/null && pwd)"
RELEASE_DIR="$(CDPATH= cd -- "$SCRIPT_DIR/.." 2>/dev/null && pwd)"
INSTALLER="$RELEASE_DIR/router-agent/install.sh"
CHECK_SCRIPT="$RELEASE_DIR/scripts/check-zash-agent-v1.2.179.sh"
AGENT_DIR="/opt/zash-agent"
PID_FILE="$AGENT_DIR/var/httpd.pid"
STAMP="$(date +%Y%m%d-%H%M%S 2>/dev/null || echo now)"
BACKUP_DIR="/opt/zash-agent.backup-v1.2.179-$STAMP"
SH_BIN="/opt/bin/sh"
[ -x "$SH_BIN" ] || SH_BIN="/bin/sh"

fail() {
  echo "[zash-agent-patch] ERROR: $*" >&2
  echo 'APPLY_STATUS=FAIL'
  return 1
}

[ -f "$INSTALLER" ] || { fail "installer not found: $INSTALLER"; exit 1; }
[ -d /opt ] || { fail '/opt is missing'; exit 1; }
mkdir -p "$AGENT_DIR/var" 2>/dev/null || true

echo 'STEP=apply_zash_agent_v1.2.179'
echo 'RELEASE_VERSION=v1.2.179'
echo 'TARGET_AGENT_VERSION=0.6.37'
echo "RELEASE_DIR=$RELEASE_DIR"
echo "AGENT_DIR=$AGENT_DIR"

if [ -d "$AGENT_DIR" ]; then
  echo "BACKUP_DIR=$BACKUP_DIR"
  mkdir -p "$BACKUP_DIR/zash-agent/www/cgi-bin" "$BACKUP_DIR/init.d" 2>/dev/null || true
  [ -f "$AGENT_DIR/agent.env" ] && cp -p "$AGENT_DIR/agent.env" "$BACKUP_DIR/zash-agent/agent.env" 2>/dev/null || true
  [ -f "$AGENT_DIR/start.sh" ] && cp -p "$AGENT_DIR/start.sh" "$BACKUP_DIR/zash-agent/start.sh" 2>/dev/null || true
  [ -f "$AGENT_DIR/ssl-refresh.sh" ] && cp -p "$AGENT_DIR/ssl-refresh.sh" "$BACKUP_DIR/zash-agent/ssl-refresh.sh" 2>/dev/null || true
  [ -f "$AGENT_DIR/www/cgi-bin/api.sh" ] && cp -p "$AGENT_DIR/www/cgi-bin/api.sh" "$BACKUP_DIR/zash-agent/www/cgi-bin/api.sh" 2>/dev/null || true
  [ -f /opt/etc/init.d/S99zash-agent ] && cp -p /opt/etc/init.d/S99zash-agent "$BACKUP_DIR/init.d/S99zash-agent" 2>/dev/null || true
  echo "ROLLBACK_HINT=/opt/bin/sh $RELEASE_DIR/scripts/rollback-zash-agent-v1.2.179.sh $BACKUP_DIR"
else
  echo 'BACKUP_DIR=skipped_no_existing_agent_dir'
fi

echo 'SCOPED_STOP_STATUS=BEGIN'
if [ -f "$PID_FILE" ]; then
  pid="$(cat "$PID_FILE" 2>/dev/null || true)"
  if [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null; then
    if ps w | awk -v p="$pid" '$1==p {print}' | grep -q '/opt/zash-agent/www'; then
      kill "$pid" 2>/dev/null || true
      sleep 1
      kill -0 "$pid" 2>/dev/null && kill -9 "$pid" 2>/dev/null || true
    else
      echo "PID_FILE_FOREIGN_OR_STALE=$pid"
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
echo 'SCOPED_STOP_STATUS=OK'

echo 'INSTALL_STATUS=BEGIN'
chmod +x "$INSTALLER" 2>/dev/null || true
"$SH_BIN" "$INSTALLER" || { fail 'installer failed'; exit 1; }
echo 'INSTALL_STATUS=OK'

sleep 3

if [ -f "$CHECK_SCRIPT" ]; then
  "$SH_BIN" "$CHECK_SCRIPT"
else
  echo "CHECK_SCRIPT_STATUS=MISSING:$CHECK_SCRIPT"
fi

echo 'APPLY_STATUS=OK'
