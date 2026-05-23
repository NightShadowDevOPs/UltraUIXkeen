#!/opt/bin/sh
# Compact read-only Mihomo core check for UI Mihomo Ultra v1.2.195.
set -u
API='http://192.168.0.1:9099/cgi-bin/api.sh'
BIN="$(command -v mihomo 2>/dev/null || true)"
[ -n "$BIN" ] || BIN="/opt/bin/mihomo"
echo "CHECK_MIHOMO_CORE_VERSION=v1.2.195"
echo "BIN=$BIN"
echo "CORE_VERSION=$($BIN -v 2>&1 | head -n 1)"
echo "PROCESS=$(ps w | grep '[m]ihomo -d /opt/etc/mihomo' | head -n 1)"
echo "AGENT_STATUS=$(curl -sS -m 8 "$API?cmd=status" 2>/dev/null | grep -o '"version":"[^"]*"\|"cpuPct":[0-9]*' | head -n 2 | tr '\n' ' ')"
echo "CANARY_SCRIPT=$([ -x /opt/etc/mihomo/core-updates/v1.19.25/mihomo ] && echo staged || echo not_staged)"
echo "WATCHDOG=$(cat /opt/zash-agent/var/watchdog.state 2>/dev/null | tr '\n' ';')"
