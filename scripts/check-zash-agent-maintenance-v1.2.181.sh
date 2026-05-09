#!/opt/bin/sh
# UI Mihomo Ultra v1.2.181 — compact zash-agent maintenance/watchdog check.
set -u
AGENT_DIR="/opt/zash-agent"
CRON_MAIN="/opt/var/spool/cron/crontabs/root"
SH_BIN="/opt/bin/sh"; [ -x "$SH_BIN" ] || SH_BIN="/bin/sh"

echo 'CHECK_RELEASE=v1.2.181'
echo 'CHECK_SCOPE=zash_agent_reliability_maintenance'
echo "WATCHDOG_SCRIPT_EXISTS=$([ -x $AGENT_DIR/watchdog.sh ] && echo yes || echo no)"
echo "RESTART_SCRIPT_EXISTS=$([ -x $AGENT_DIR/restart-agent.sh ] && echo yes || echo no)"
echo "MAINTENANCE_SCRIPT_EXISTS=$([ -x $AGENT_DIR/maintenance.sh ] && echo yes || echo no)"
echo "CRON_MAIN=$CRON_MAIN"
echo "WATCHDOG_CRON_HIT=$(grep -q 'zash-agent-watchdog' "$CRON_MAIN" 2>/dev/null && echo yes || echo no)"
echo "MAINTENANCE_CRON_HIT=$(grep -q 'zash-agent-maintenance' "$CRON_MAIN" 2>/dev/null && echo yes || echo no)"
echo "CROND_RUNNING=$(ps | grep -E 'crond|cron' | grep -v grep >/dev/null 2>&1 && echo yes || echo no)"
echo "AGENT_SIZE_KB=$(du -sk $AGENT_DIR 2>/dev/null | awk '{print $1}')"
echo "VAR_SIZE_KB=$(du -sk $AGENT_DIR/var 2>/dev/null | awk '{print $1}')"
echo "BACKUPS_SIZE_KB=$(du -sk $AGENT_DIR/var/backups 2>/dev/null | awk '{print $1}')"
echo "BACKUPS_COUNT=$(ls -1 $AGENT_DIR/var/backups/zash-backup-*.tar.gz 2>/dev/null | wc -l)"
echo "AGENT_LOG_BYTES=$(wc -c < $AGENT_DIR/var/agent.log 2>/dev/null || echo 0)"
echo 'WATCHDOG_STATE_BEGIN'
cat "$AGENT_DIR/var/watchdog.state" 2>/dev/null || true
echo 'WATCHDOG_STATE_END'
if [ -x "$AGENT_DIR/maintenance.sh" ]; then
  echo 'MAINTENANCE_DRY_RUN_BEGIN'
  $SH_BIN "$AGENT_DIR/maintenance.sh" dry-run | sed -n '1,16p'
  echo 'MAINTENANCE_DRY_RUN_END'
fi
if [ -x "$AGENT_DIR/watchdog.sh" ]; then
  echo 'WATCHDOG_PROBE_BEGIN'
  $SH_BIN "$AGENT_DIR/watchdog.sh" | tail -n 5
  echo 'WATCHDOG_PROBE_END'
fi
if [ -x "$AGENT_DIR/watchdog.sh" ] && [ -x "$AGENT_DIR/maintenance.sh" ]; then echo 'CHECK_STATUS=OK'; else echo 'CHECK_STATUS=WARN_MISSING_FILES'; fi
