#!/opt/bin/sh
# UI Mihomo Ultra v1.2.182 — backup current restart helper before hotfix.
set -u
AGENT_DIR="/opt/zash-agent"
BACKUP_DIR="$AGENT_DIR/var/backups"
TS="$(date +%Y%m%d-%H%M%S 2>/dev/null || echo manual)"
mkdir -p "$BACKUP_DIR" 2>/dev/null || true
if [ -f "$AGENT_DIR/restart-agent.sh" ]; then
  cp -p "$AGENT_DIR/restart-agent.sh" "$BACKUP_DIR/restart-agent.sh.bak.v1.2.182.$TS" 2>/dev/null || { echo 'BACKUP_STATUS=FAIL_COPY'; exit 1; }
  echo 'BACKUP_STATUS=OK'
  echo "BACKUP_FILE=$BACKUP_DIR/restart-agent.sh.bak.v1.2.182.$TS"
else
  echo 'BACKUP_STATUS=NOTHING_TO_BACKUP'
fi
