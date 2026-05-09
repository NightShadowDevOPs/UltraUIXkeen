#!/opt/bin/sh
# UI Mihomo Ultra v1.2.179 — restore selected /opt/zash-agent files from lightweight backup.
set -u

AGENT_DIR="/opt/zash-agent"
BACKUP="${1:-}"
if [ -z "$BACKUP" ]; then
  BACKUP="$(ls -1td /opt/zash-agent.backup-v1.2.179-* 2>/dev/null | head -n 1)"
fi
if [ -z "$BACKUP" ]; then
  echo 'ROLLBACK_STATUS=FAIL'
  echo 'ROLLBACK_ERROR=no_v1.2.179_lightweight_backup_found'
  exit 1
fi

echo 'STEP=rollback_zash_agent_v1.2.179'
echo "BACKUP_DIR=$BACKUP"
PID_FILE="$AGENT_DIR/var/httpd.pid"
if [ -f "$PID_FILE" ]; then
  pid="$(cat "$PID_FILE" 2>/dev/null || true)"
  if [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null; then
    if ps w | awk -v p="$pid" '$1==p {print}' | grep -q '/opt/zash-agent/www'; then kill "$pid" 2>/dev/null || true; fi
  fi
fi
ps w | grep '[u]httpd' | grep '/opt/zash-agent/www' | awk '{print $1}' | while read p; do [ -n "$p" ] && kill "$p" 2>/dev/null || true; done
ps w | grep '/opt/zash-agent/www/cgi-bin/api.sh' | grep -v grep | awk '{print $1}' | while read p; do [ -n "$p" ] && kill "$p" 2>/dev/null || true; done
sleep 1

if [ -d "$BACKUP/zash-agent" ]; then
  mkdir -p "$AGENT_DIR/www/cgi-bin" "$AGENT_DIR/var" 2>/dev/null || true
  [ -f "$BACKUP/zash-agent/agent.env" ] && cp -p "$BACKUP/zash-agent/agent.env" "$AGENT_DIR/agent.env" 2>/dev/null || true
  [ -f "$BACKUP/zash-agent/start.sh" ] && cp -p "$BACKUP/zash-agent/start.sh" "$AGENT_DIR/start.sh" 2>/dev/null || true
  [ -f "$BACKUP/zash-agent/ssl-refresh.sh" ] && cp -p "$BACKUP/zash-agent/ssl-refresh.sh" "$AGENT_DIR/ssl-refresh.sh" 2>/dev/null || true
  [ -f "$BACKUP/zash-agent/www/cgi-bin/api.sh" ] && cp -p "$BACKUP/zash-agent/www/cgi-bin/api.sh" "$AGENT_DIR/www/cgi-bin/api.sh" 2>/dev/null || true
  [ -f "$BACKUP/init.d/S99zash-agent" ] && cp -p "$BACKUP/init.d/S99zash-agent" /opt/etc/init.d/S99zash-agent 2>/dev/null || true
else
  echo 'ROLLBACK_STATUS=FAIL'
  echo 'ROLLBACK_ERROR=unsupported_backup_layout'
  exit 1
fi
chmod +x /opt/zash-agent/start.sh /opt/zash-agent/www/cgi-bin/api.sh /opt/etc/init.d/S99zash-agent 2>/dev/null || true
/opt/etc/init.d/S99zash-agent restart 2>/dev/null || { /opt/etc/init.d/S99zash-agent stop 2>/dev/null || true; /opt/etc/init.d/S99zash-agent start; }
sleep 3
/opt/bin/sh "$PWD/scripts/check-zash-agent-v1.2.179.sh" 2>/dev/null || true
echo 'ROLLBACK_STATUS=OK'
