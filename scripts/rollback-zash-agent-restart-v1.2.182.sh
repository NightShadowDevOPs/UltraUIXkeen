#!/opt/bin/sh
# UI Mihomo Ultra v1.2.182 — rollback restart helper to latest saved backup.
set -u
AGENT_DIR="/opt/zash-agent"
BACKUP_DIR="$AGENT_DIR/var/backups"
LAST="$(ls -1t "$BACKUP_DIR"/restart-agent.sh.bak.v1.2.182.* 2>/dev/null | head -n 1)"
[ -n "$LAST" ] || { echo 'ROLLBACK_STATUS=FAIL_NO_BACKUP'; exit 1; }
cp -p "$LAST" "$AGENT_DIR/restart-agent.sh" 2>/dev/null || { echo 'ROLLBACK_STATUS=FAIL_COPY'; exit 1; }
chmod +x "$AGENT_DIR/restart-agent.sh" 2>/dev/null || true
echo 'ROLLBACK_STATUS=OK'
echo "RESTORED_FROM=$LAST"
