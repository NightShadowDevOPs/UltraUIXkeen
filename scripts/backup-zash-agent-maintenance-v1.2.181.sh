#!/opt/bin/sh
# UI Mihomo Ultra v1.2.181 — backup zash-agent maintenance/watchdog files and cron.
set -u
TS=$(date +%Y%m%d-%H%M%S 2>/dev/null || echo manual)
B="/opt/zash-agent/var/release-backups/v1.2.181-$TS"
mkdir -p "$B" 2>/dev/null || { echo 'BACKUP_STATUS=FAIL_MKDIR'; exit 1; }
for f in /opt/zash-agent/maintenance.sh /opt/zash-agent/watchdog.sh /opt/zash-agent/restart-agent.sh /opt/var/spool/cron/crontabs/root; do
  [ -f "$f" ] && cp -p "$f" "$B/$(basename "$f")" 2>/dev/null || true
done
echo "BACKUP_DIR=$B"
echo 'BACKUP_STATUS=OK'
