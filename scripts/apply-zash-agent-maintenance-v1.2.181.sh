#!/opt/bin/sh
# UI Mihomo Ultra v1.2.181 — apply zash-agent reliability maintenance scripts.
set -u
SCRIPT_PATH="$0"
SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$SCRIPT_PATH")" 2>/dev/null && pwd)"
ROOT_DIR="$(CDPATH= cd -- "$SCRIPT_DIR/.." 2>/dev/null && pwd)"
SH_BIN="/opt/bin/sh"; [ -x "$SH_BIN" ] || SH_BIN="/bin/sh"

echo 'APPLY_RELEASE=v1.2.181'
echo 'APPLY_SCOPE=zash_agent_maintenance_only'
[ -f "$ROOT_DIR/router-agent/maintenance.sh" ] || { echo 'APPLY_STATUS=FAIL_MAINTENANCE_SOURCE_MISSING'; exit 1; }
[ -f "$ROOT_DIR/router-agent/install-maintenance.sh" ] || { echo 'APPLY_STATUS=FAIL_INSTALLER_SOURCE_MISSING'; exit 1; }
$SH_BIN "$ROOT_DIR/router-agent/install-maintenance.sh"
echo 'APPLY_STATUS=OK'
