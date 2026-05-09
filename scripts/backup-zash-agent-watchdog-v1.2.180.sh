#!/opt/bin/sh
# UI Mihomo Ultra v1.2.180 — backup watchdog-related files only.
set -u
STAMP="$(date +%Y%m%d-%H%M%S 2>/dev/null || echo now)"
BACKUP_DIR="/opt/zash-agent.backup-v1.2.180-watchdog-manual-$STAMP"
mkdir -p "$BACKUP_DIR/zash-agent" "$BACKUP_DIR/cron" 2>/dev/null || true
[ -f /opt/zash-agent/restart-agent.sh ] && cp -p /opt/zash-agent/restart-agent.sh "$BACKUP_DIR/zash-agent/restart-agent.sh" 2>/dev/null || true
[ -f /opt/zash-agent/watchdog.sh ] && cp -p /opt/zash-agent/watchdog.sh "$BACKUP_DIR/zash-agent/watchdog.sh" 2>/dev/null || true
for f in /opt/etc/crontabs/root /opt/var/spool/cron/crontabs/root /etc/crontabs/root /var/spool/cron/crontabs/root; do
  [ -f "$f" ] && cp -p "$f" "$BACKUP_DIR/cron/$(echo "$f" | sed 's#[/ ]#_#g')" 2>/dev/null || true
done
echo "BACKUP_DIR=$BACKUP_DIR"
echo 'BACKUP_STATUS=OK'
