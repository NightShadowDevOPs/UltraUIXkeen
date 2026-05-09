#!/opt/bin/sh
# UI Mihomo Ultra v1.2.181 — install zash-agent maintenance script and daily cron.
set -u

SCRIPT_PATH="$0"
SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$SCRIPT_PATH")" 2>/dev/null && pwd)"
AGENT_DIR="/opt/zash-agent"
CRON_TAG="zash-agent-maintenance"
SCHEDULE="${ZASH_AGENT_MAINTENANCE_CRON:-17 4 * * *}"
SH_BIN="/opt/bin/sh"
[ -x "$SH_BIN" ] || SH_BIN="/bin/sh"

mkdir -p "$AGENT_DIR/var" 2>/dev/null || true
[ -f "$SCRIPT_DIR/maintenance.sh" ] || { echo 'INSTALL_MAINTENANCE_STATUS=FAIL_SOURCE_MISSING'; exit 1; }
cp -p "$SCRIPT_DIR/maintenance.sh" "$AGENT_DIR/maintenance.sh" 2>/dev/null || { echo 'INSTALL_MAINTENANCE_STATUS=FAIL_COPY'; exit 1; }
chmod +x "$AGENT_DIR/maintenance.sh" 2>/dev/null || true

cron_tab=""
for f in /opt/var/spool/cron/crontabs/root /opt/etc/crontabs/root /etc/crontabs/root /var/spool/cron/crontabs/root; do
  d="$(dirname "$f")"
  if [ -d "$d" ] || [ -f "$f" ]; then cron_tab="$f"; break; fi
done
[ -n "$cron_tab" ] || cron_tab="/opt/var/spool/cron/crontabs/root"
mkdir -p "$(dirname "$cron_tab")" 2>/dev/null || true
touch "$cron_tab" 2>/dev/null || true
tmp_cron="${cron_tab}.tmp.$$"
grep -v "$CRON_TAG" "$cron_tab" 2>/dev/null > "$tmp_cron" || true
printf '%s %s /opt/zash-agent/maintenance.sh apply >/dev/null 2>&1 # %s\n' "$SCHEDULE" "$SH_BIN" "$CRON_TAG" >> "$tmp_cron"
mv "$tmp_cron" "$cron_tab" 2>/dev/null || { echo 'INSTALL_MAINTENANCE_STATUS=FAIL_CRON_WRITE'; exit 1; }
if command -v crontab >/dev/null 2>&1; then crontab "$cron_tab" >/dev/null 2>&1 || true; fi
for init in /opt/etc/init.d/S10cron /opt/etc/init.d/S10crond /etc/init.d/cron /etc/init.d/crond; do
  [ -x "$init" ] || continue
  "$init" restart >/dev/null 2>&1 || "$init" start >/dev/null 2>&1 || true
  break
done

$SH_BIN "$AGENT_DIR/maintenance.sh" dry-run
echo 'INSTALL_MAINTENANCE_STATUS=OK'
echo "MAINTENANCE_CRON=$SCHEDULE"
echo "MAINTENANCE_CRON_FILE=$cron_tab"
echo 'MAINTENANCE_FILE=/opt/zash-agent/maintenance.sh'
