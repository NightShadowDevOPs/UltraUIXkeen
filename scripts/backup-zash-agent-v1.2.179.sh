#!/opt/bin/sh
# UI Mihomo Ultra v1.2.179 — lightweight local backup for installed zash-agent files.
# Does not stop services, does not delete files, does not print secrets.
set -u
AGENT_DIR="/opt/zash-agent"
STAMP="$(date +%Y%m%d-%H%M%S 2>/dev/null || echo now)"
BACKUP_DIR="/opt/zash-agent.backup-v1.2.179-$STAMP"

echo 'STEP=backup_zash_agent_v1.2.179'
echo "BACKUP_DIR=$BACKUP_DIR"
if [ ! -d "$AGENT_DIR" ]; then
  echo 'BACKUP_STATUS=FAIL'
  echo 'BACKUP_ERROR=agent_dir_missing'
  exit 1
fi
mkdir -p "$BACKUP_DIR/zash-agent/www/cgi-bin" "$BACKUP_DIR/init.d" 2>/dev/null || { echo 'BACKUP_STATUS=FAIL'; echo 'BACKUP_ERROR=mkdir_failed'; exit 1; }
[ -f "$AGENT_DIR/agent.env" ] && cp -p "$AGENT_DIR/agent.env" "$BACKUP_DIR/zash-agent/agent.env" 2>/dev/null || true
[ -f "$AGENT_DIR/start.sh" ] && cp -p "$AGENT_DIR/start.sh" "$BACKUP_DIR/zash-agent/start.sh" 2>/dev/null || true
[ -f "$AGENT_DIR/ssl-refresh.sh" ] && cp -p "$AGENT_DIR/ssl-refresh.sh" "$BACKUP_DIR/zash-agent/ssl-refresh.sh" 2>/dev/null || true
[ -f "$AGENT_DIR/www/cgi-bin/api.sh" ] && cp -p "$AGENT_DIR/www/cgi-bin/api.sh" "$BACKUP_DIR/zash-agent/www/cgi-bin/api.sh" 2>/dev/null || true
[ -f /opt/etc/init.d/S99zash-agent ] && cp -p /opt/etc/init.d/S99zash-agent "$BACKUP_DIR/init.d/S99zash-agent" 2>/dev/null || true
count="$(find "$BACKUP_DIR" -type f 2>/dev/null | wc -l | tr -d ' ')"
echo "BACKUP_FILE_COUNT=$count"
echo 'BACKUP_DELETE_STATUS=NO_DELETE'
echo 'BACKUP_STATUS=OK'
