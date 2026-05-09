#!/opt/bin/sh
# UI Mihomo Ultra v1.2.181 — rollback only maintenance cron and script.
# Does not rollback zash-agent runtime or Mihomo.
set -u
CRON_FILE="/opt/var/spool/cron/crontabs/root"
if [ -f "$CRON_FILE" ]; then
  tmp="$CRON_FILE.tmp.$$"
  grep -v 'zash-agent-maintenance' "$CRON_FILE" 2>/dev/null > "$tmp" || true
  mv "$tmp" "$CRON_FILE" 2>/dev/null || true
fi
rm -f /opt/zash-agent/maintenance.sh 2>/dev/null || true
echo 'ROLLBACK_SCOPE=remove_maintenance_cron_and_script_only'
echo 'ROLLBACK_STATUS=OK'
