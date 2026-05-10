#!/opt/bin/sh
# UI Mihomo Ultra v1.2.182 — compact check for zash-agent restart helper.
set -u
AGENT_DIR="/opt/zash-agent"
RESTART="$AGENT_DIR/restart-agent.sh"
INIT="/opt/etc/init.d/S99zash-agent"
BASE="http://192.168.0.1:9099/cgi-bin/api.sh"
echo 'CHECK_RELEASE=v1.2.182'
echo 'CHECK_SCOPE=zash_agent_restart_service_hotfix'
echo "INIT_EXISTS=$([ -x "$INIT" ] && echo yes || echo no)"
echo "RESTART_SCRIPT_EXISTS=$([ -x "$RESTART" ] && echo yes || echo no)"
echo "HAS_SERVICE_RESTART_PATH=$(grep -q '/opt/etc/init.d/S99zash-agent' "$RESTART" 2>/dev/null && echo yes || echo no)"
echo "HAS_SERVICE_RESTART_MARKER=$(grep -q 'SERVICE_RESTART=BEGIN' "$RESTART" 2>/dev/null && echo yes || echo no)"
echo "HAS_FALLBACK_SCOPED=$(grep -q 'FALLBACK_SCOPED' "$RESTART" 2>/dev/null && echo yes || echo no)"
echo "PID_FILE=$(cat $AGENT_DIR/var/httpd.pid 2>/dev/null || echo missing)"
echo "PROCESS=$(ps | grep '[u]httpd' | grep '/opt/zash-agent/www' | head -n 1)"
STATUS_BODY="$(curl -sS -m 8 "$BASE?cmd=status" 2>/dev/null || true)"
SNAP_BODY="$(curl -sS -m 8 "$BASE?cmd=ha_snapshot" 2>/dev/null || true)"
echo "$STATUS_BODY" | grep -q '"ok":true' && echo 'STATUS_OK=true' || echo 'STATUS_OK=false'
echo "$SNAP_BODY" | grep -q '"ok":true' && echo 'SNAPSHOT_OK=true' || echo 'SNAPSHOT_OK=false'
echo "$SNAP_BODY" | grep -q '"qos":{"ok":true' && echo 'SNAPSHOT_BUNDLE_OK=true' || echo 'SNAPSHOT_BUNDLE_OK=false'
echo 'CHECK_STATUS=OK_IF_ALL_TRUE'
