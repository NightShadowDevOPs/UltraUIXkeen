#!/opt/bin/sh
set -u
SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" 2>/dev/null && pwd)"
ROOT_DIR="$(CDPATH= cd -- "$SCRIPT_DIR/.." 2>/dev/null && pwd)"
SRC_DIR="$ROOT_DIR/router-agent"
[ -f "$SRC_DIR/watchdog.sh" ] || { echo 'APPLY_STATUS=FAIL_SOURCE_MISSING'; exit 1; }
mkdir -p /opt/zash-agent/var /opt/var/log/zash-agent 2>/dev/null || true
cp -p "$SRC_DIR/watchdog.sh" /opt/zash-agent/watchdog.sh || { echo 'APPLY_STATUS=FAIL_COPY_WATCHDOG'; exit 1; }
chmod +x /opt/zash-agent/watchdog.sh 2>/dev/null || true
/opt/bin/sh /opt/zash-agent/watchdog.sh || /bin/sh /opt/zash-agent/watchdog.sh || true
echo 'APPLY_STATUS=OK'
echo 'PATCH=watchdog_transport_policy_v1.2.184'
