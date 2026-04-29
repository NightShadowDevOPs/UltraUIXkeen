#!/opt/bin/sh
# UI Mihomo Ultra v1.2.176 — restore /opt/zash-agent from the latest patch backup.
# Safe scope: only /opt/zash-agent and its own uhttpd/CGI processes are touched.
set -u

AGENT_DIR="/opt/zash-agent"
PID_FILE="$AGENT_DIR/var/httpd.pid"
STAMP="$(date +%Y%m%d-%H%M%S 2>/dev/null || echo now)"
KEEP_CURRENT="/opt/zash-agent.rollback-before-v1.2.176-$STAMP.tar.gz"

BACKUP="${1:-}"
if [ -z "$BACKUP" ]; then
  BACKUP="$(ls -1t /opt/zash-agent.backup-v1.2.176-*.tar.gz /opt/zash-agent.backup-v1.2.175-*.tar.gz 2>/dev/null | head -n 1)"
fi

[ -n "$BACKUP" ] || { echo '[zash-agent-rollback] ERROR: no backup found'; exit 1; }
[ -f "$BACKUP" ] || { echo "[zash-agent-rollback] ERROR: backup file not found: $BACKUP"; exit 1; }

echo "[zash-agent-rollback] backup=$BACKUP"
if [ -d "$AGENT_DIR" ]; then
  echo "[zash-agent-rollback] save_current=$KEEP_CURRENT"
  tar -czf "$KEEP_CURRENT" -C /opt zash-agent 2>/dev/null || echo '[zash-agent-rollback] warning: failed to save current agent'
fi

echo '[zash-agent-rollback] scoped_stop=begin'
if [ -f "$PID_FILE" ]; then
  pid="$(cat "$PID_FILE" 2>/dev/null || true)"
  if [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null; then
    kill "$pid" 2>/dev/null || true
    sleep 1
    kill -0 "$pid" 2>/dev/null && kill -9 "$pid" 2>/dev/null || true
  fi
fi
ps w | grep '[u]httpd' | grep '/opt/zash-agent/www' | awk '{print $1}' | while read p; do kill "$p" 2>/dev/null || true; done
ps w | grep '/opt/zash-agent/www/cgi-bin/api.sh' | grep -v grep | awk '{print $1}' | while read p; do kill "$p" 2>/dev/null || true; done
sleep 1

echo '[zash-agent-rollback] restore=begin'
rm -rf "$AGENT_DIR"
tar -xzf "$BACKUP" -C /opt || { echo '[zash-agent-rollback] ERROR: restore failed'; exit 1; }
chmod +x /opt/zash-agent/start.sh /opt/zash-agent/www/cgi-bin/api.sh /opt/etc/init.d/S99zash-agent 2>/dev/null || true

echo '[zash-agent-rollback] restart=begin'
/opt/etc/init.d/S99zash-agent restart 2>/dev/null || {
  /opt/etc/init.d/S99zash-agent stop 2>/dev/null || true
  /opt/etc/init.d/S99zash-agent start
}
sleep 3

echo '[zash-agent-rollback] smoke=status'
/opt/bin/wget -S -O- -T 10 'http://192.168.0.1:9099/cgi-bin/api.sh?cmd=status' 2>&1 | sed -n '1,80p' || true

echo '[zash-agent-rollback] done'
