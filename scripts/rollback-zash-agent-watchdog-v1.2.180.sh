#!/opt/bin/sh
# UI Mihomo Ultra v1.2.180 — rollback zash-agent watchdog files/cron from lightweight backup.
set -u

BACKUP="${1:-}"
AGENT_DIR="/opt/zash-agent"
CRON_TAG="zash-agent-watchdog"
if [ -z "$BACKUP" ]; then
  BACKUP="$(ls -1td /opt/zash-agent.backup-v1.2.180-watchdog-* 2>/dev/null | head -n 1)"
fi
[ -n "$BACKUP" ] || { echo 'ROLLBACK_STATUS=FAIL_NO_BACKUP'; exit 1; }
echo 'STEP=rollback_zash_agent_watchdog_v1.2.180'
echo "BACKUP_DIR=$BACKUP"

# Remove watchdog cron line from all known root crontabs.
for f in /opt/etc/crontabs/root /opt/var/spool/cron/crontabs/root /etc/crontabs/root /var/spool/cron/crontabs/root; do
  [ -f "$f" ] || continue
  tmp="${f}.tmp.$$"
  grep -v "$CRON_TAG" "$f" > "$tmp" 2>/dev/null || true
  mv "$tmp" "$f" 2>/dev/null || true
  if command -v crontab >/dev/null 2>&1; then crontab "$f" >/dev/null 2>&1 || true; fi
done

# Restore previous files if they existed in backup; otherwise remove files installed by this release.
if [ -f "$BACKUP/zash-agent/restart-agent.sh" ]; then
  cp -p "$BACKUP/zash-agent/restart-agent.sh" "$AGENT_DIR/restart-agent.sh" 2>/dev/null || true
else
  rm -f "$AGENT_DIR/restart-agent.sh" 2>/dev/null || true
fi
if [ -f "$BACKUP/zash-agent/watchdog.sh" ]; then
  cp -p "$BACKUP/zash-agent/watchdog.sh" "$AGENT_DIR/watchdog.sh" 2>/dev/null || true
else
  rm -f "$AGENT_DIR/watchdog.sh" 2>/dev/null || true
fi
for init in /opt/etc/init.d/S10cron /opt/etc/init.d/S10crond /etc/init.d/cron /etc/init.d/crond; do
  [ -x "$init" ] || continue
  "$init" restart >/dev/null 2>&1 || "$init" start >/dev/null 2>&1 || true
  break
done
echo 'ROLLBACK_STATUS=OK'
