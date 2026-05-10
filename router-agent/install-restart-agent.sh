#!/opt/bin/sh
# UI Mihomo Ultra v1.2.182 — install zash-agent restart helper.
set -u
SCRIPT_PATH="$0"
SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$SCRIPT_PATH")" 2>/dev/null && pwd)"
AGENT_DIR="/opt/zash-agent"
SRC="$SCRIPT_DIR/restart-agent.sh"
DST="$AGENT_DIR/restart-agent.sh"
TS="$(date +%Y%m%d-%H%M%S 2>/dev/null || echo manual)"
[ -f "$SRC" ] || { echo 'INSTALL_RESTART_STATUS=FAIL_SOURCE_MISSING'; exit 1; }
mkdir -p "$AGENT_DIR/var/backups" 2>/dev/null || true
if [ -f "$DST" ]; then
  cp -p "$DST" "$AGENT_DIR/var/backups/restart-agent.sh.bak.v1.2.182.$TS" 2>/dev/null || true
fi
cp -p "$SRC" "$DST" 2>/dev/null || { echo 'INSTALL_RESTART_STATUS=FAIL_COPY'; exit 1; }
chmod +x "$DST" 2>/dev/null || true
echo 'INSTALL_RESTART_STATUS=OK'
echo "RESTART_FILE=$DST"
grep -q '/opt/etc/init.d/S99zash-agent' "$DST" 2>/dev/null && echo 'HAS_SERVICE_RESTART_PATH=yes' || echo 'HAS_SERVICE_RESTART_PATH=no'
grep -q 'SERVICE_RESTART=BEGIN' "$DST" 2>/dev/null && echo 'SERVICE_RESTART_MARKER=yes' || echo 'SERVICE_RESTART_MARKER=no'
