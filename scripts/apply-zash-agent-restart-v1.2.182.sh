#!/opt/bin/sh
# UI Mihomo Ultra v1.2.182 — apply zash-agent restart service hotfix from release tree.
set -u
SCRIPT_PATH="$0"
SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$SCRIPT_PATH")" 2>/dev/null && pwd)"
ROOT_DIR="$(CDPATH= cd -- "$SCRIPT_DIR/.." 2>/dev/null && pwd)"
AGENT_SRC="$ROOT_DIR/router-agent/restart-agent.sh"
INSTALL_SRC="$ROOT_DIR/router-agent/install-restart-agent.sh"
SH_BIN="/opt/bin/sh"; [ -x "$SH_BIN" ] || SH_BIN="/bin/sh"
[ -f "$AGENT_SRC" ] || { echo 'APPLY_STATUS=FAIL_RESTART_SOURCE_MISSING'; exit 1; }
[ -f "$INSTALL_SRC" ] || { echo 'APPLY_STATUS=FAIL_INSTALL_SOURCE_MISSING'; exit 1; }
$SH_BIN "$INSTALL_SRC" || { echo 'APPLY_STATUS=FAIL_INSTALL'; exit 1; }
echo 'APPLY_STATUS=OK'
