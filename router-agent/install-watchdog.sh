#!/opt/bin/sh
# UI Mihomo Ultra v1.2.180 — install zash-agent watchdog from release source directory.
# Usage: /opt/bin/sh router-agent/install-watchdog.sh
set -u

SCRIPT_PATH="$0"
SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$SCRIPT_PATH")" 2>/dev/null && pwd)"
AGENT_DIR="/opt/zash-agent"
LOG_DIR="/opt/var/log/zash-agent"
CRON_TAG="zash-agent-watchdog"
SCHEDULE="${ZASH_AGENT_WATCHDOG_CRON:-*/2 * * * *}"
SH_BIN="/opt/bin/sh"
[ -x "$SH_BIN" ] || SH_BIN="/bin/sh"

mkdir -p "$AGENT_DIR/var" "$LOG_DIR" 2>/dev/null || true
[ -f "$SCRIPT_DIR/restart-agent.sh" ] || { echo 'INSTALL_WATCHDOG_STATUS=FAIL_RESTART_SOURCE_MISSING'; exit 1; }
[ -f "$SCRIPT_DIR/watchdog.sh" ] || { echo 'INSTALL_WATCHDOG_STATUS=FAIL_WATCHDOG_SOURCE_MISSING'; exit 1; }
cp -p "$SCRIPT_DIR/restart-agent.sh" "$AGENT_DIR/restart-agent.sh" 2>/dev/null || { echo 'INSTALL_WATCHDOG_STATUS=FAIL_COPY_RESTART'; exit 1; }
cp -p "$SCRIPT_DIR/watchdog.sh" "$AGENT_DIR/watchdog.sh" 2>/dev/null || { echo 'INSTALL_WATCHDOG_STATUS=FAIL_COPY_WATCHDOG'; exit 1; }
chmod +x "$AGENT_DIR/restart-agent.sh" "$AGENT_DIR/watchdog.sh" 2>/dev/null || true

cron_tab=""
for f in /opt/etc/crontabs/root /opt/var/spool/cron/crontabs/root /etc/crontabs/root /var/spool/cron/crontabs/root; do
  d="$(dirname "$f")"
  if [ -d "$d" ] || [ -f "$f" ]; then cron_tab="$f"; break; fi
done
if [ -z "$cron_tab" ]; then
  cron_tab="/opt/var/spool/cron/crontabs/root"
fi
mkdir -p "$(dirname "$cron_tab")" 2>/dev/null || true
touch "$cron_tab" 2>/dev/null || true
tmp_cron="${cron_tab}.tmp.$$"
grep -v "$CRON_TAG" "$cron_tab" 2>/dev/null > "$tmp_cron" || true
printf '%s %s /opt/zash-agent/watchdog.sh >/dev/null 2>&1 # %s\n' "$SCHEDULE" "$SH_BIN" "$CRON_TAG" >> "$tmp_cron"
mv "$tmp_cron" "$cron_tab" 2>/dev/null || { echo 'INSTALL_WATCHDOG_STATUS=FAIL_CRON_WRITE'; exit 1; }
if command -v crontab >/dev/null 2>&1; then crontab "$cron_tab" >/dev/null 2>&1 || true; fi
for init in /opt/etc/init.d/S10cron /opt/etc/init.d/S10crond /etc/init.d/cron /etc/init.d/crond; do
  [ -x "$init" ] || continue
  "$init" restart >/dev/null 2>&1 || "$init" start >/dev/null 2>&1 || true
  break
done

$SH_BIN "$AGENT_DIR/watchdog.sh"
echo 'INSTALL_WATCHDOG_STATUS=OK'
echo "WATCHDOG_CRON=$SCHEDULE"
echo "WATCHDOG_CRON_FILE=$cron_tab"
echo 'WATCHDOG_FILES=/opt/zash-agent/restart-agent.sh /opt/zash-agent/watchdog.sh'
