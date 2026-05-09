#!/opt/bin/sh
# UI Mihomo Ultra v1.2.180 — zash-agent watchdog installer.
# Scope: /opt/zash-agent restart/watchdog helpers + cron only.
# Does not change Mihomo core, TUN, QoS semantics, routing rules or provider SSL logic.
set -u

SCRIPT_PATH="$0"
SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$SCRIPT_PATH")" 2>/dev/null && pwd)"
RELEASE_DIR="$(CDPATH= cd -- "$SCRIPT_DIR/.." 2>/dev/null && pwd)"
INSTALL_WATCHDOG="$RELEASE_DIR/router-agent/install-watchdog.sh"
AGENT_DIR="/opt/zash-agent"
STAMP="$(date +%Y%m%d-%H%M%S 2>/dev/null || echo now)"
BACKUP_DIR="/opt/zash-agent.backup-v1.2.180-watchdog-$STAMP"
SH_BIN="/opt/bin/sh"
[ -x "$SH_BIN" ] || SH_BIN="/bin/sh"

echo 'STEP=apply_zash_agent_watchdog_v1.2.180'
echo 'RELEASE_VERSION=v1.2.180'
echo 'TARGET_AGENT_VERSION=0.6.37'
echo "RELEASE_DIR=$RELEASE_DIR"
[ -f "$INSTALL_WATCHDOG" ] || { echo 'APPLY_STATUS=FAIL_INSTALL_WATCHDOG_MISSING'; exit 1; }

mkdir -p "$BACKUP_DIR/zash-agent" "$BACKUP_DIR/cron" 2>/dev/null || true
[ -f "$AGENT_DIR/restart-agent.sh" ] && cp -p "$AGENT_DIR/restart-agent.sh" "$BACKUP_DIR/zash-agent/restart-agent.sh" 2>/dev/null || true
[ -f "$AGENT_DIR/watchdog.sh" ] && cp -p "$AGENT_DIR/watchdog.sh" "$BACKUP_DIR/zash-agent/watchdog.sh" 2>/dev/null || true
for f in /opt/etc/crontabs/root /opt/var/spool/cron/crontabs/root /etc/crontabs/root /var/spool/cron/crontabs/root; do
  [ -f "$f" ] && cp -p "$f" "$BACKUP_DIR/cron/$(echo "$f" | sed 's#[/ ]#_#g')" 2>/dev/null || true
done
echo "BACKUP_DIR=$BACKUP_DIR"
echo "ROLLBACK_HINT=$SH_BIN $RELEASE_DIR/scripts/rollback-zash-agent-watchdog-v1.2.180.sh $BACKUP_DIR"

$SH_BIN "$INSTALL_WATCHDOG" || { echo 'APPLY_STATUS=FAIL_INSTALL_WATCHDOG'; exit 1; }
$SH_BIN "$RELEASE_DIR/scripts/check-zash-agent-watchdog-v1.2.180.sh" || true
echo 'APPLY_STATUS=OK'
