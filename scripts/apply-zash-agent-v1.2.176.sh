#!/opt/bin/sh
# UI Mihomo Ultra v1.2.176 — scoped zash-agent patch installer.
# Run from an unpacked release directory. It patches /opt/zash-agent directly.
set -u

SCRIPT_PATH="$0"
SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$SCRIPT_PATH")" 2>/dev/null && pwd)"
RELEASE_DIR="$(CDPATH= cd -- "$SCRIPT_DIR/.." 2>/dev/null && pwd)"
INSTALLER="$RELEASE_DIR/router-agent/install.sh"
CHECK_SCRIPT="$RELEASE_DIR/scripts/check-zash-agent-v1.2.176.sh"
AGENT_DIR="/opt/zash-agent"
PID_FILE="$AGENT_DIR/var/httpd.pid"
STAMP="$(date +%Y%m%d-%H%M%S 2>/dev/null || echo now)"
BACKUP="/opt/zash-agent.backup-v1.2.176-$STAMP.tar.gz"
SH_BIN="/opt/bin/sh"
[ -x "$SH_BIN" ] || SH_BIN="/bin/sh"

fail() {
  echo "[zash-agent-patch] ERROR: $*" >&2
  exit 1
}

[ -f "$INSTALLER" ] || fail "installer not found: $INSTALLER"
[ -d /opt ] || fail "/opt is missing"
mkdir -p "$AGENT_DIR/var" 2>/dev/null || true

echo "[zash-agent-patch] release=v1.2.176"
echo "[zash-agent-patch] release_dir=$RELEASE_DIR"
echo "[zash-agent-patch] agent_dir=$AGENT_DIR"

if [ -d "$AGENT_DIR" ]; then
  echo "[zash-agent-patch] backup=$BACKUP"
  tar -czf "$BACKUP" -C /opt zash-agent 2>/dev/null || echo "[zash-agent-patch] backup_warning=tar_failed_continuing"
else
  echo "[zash-agent-patch] backup=skipped_no_existing_agent_dir"
fi

echo "[zash-agent-patch] scoped_stop=begin"
if [ -f "$PID_FILE" ]; then
  pid="$(cat "$PID_FILE" 2>/dev/null || true)"
  if [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null; then
    kill "$pid" 2>/dev/null || true
    sleep 1
    kill -0 "$pid" 2>/dev/null && kill -9 "$pid" 2>/dev/null || true
  fi
  rm -f "$PID_FILE" 2>/dev/null || true
fi

ps w | grep '[u]httpd' | grep '/opt/zash-agent/www' | awk '{print $1}' | while read p; do
  kill "$p" 2>/dev/null || true
done
sleep 1
ps w | grep '[u]httpd' | grep '/opt/zash-agent/www' | awk '{print $1}' | while read p; do
  kill -9 "$p" 2>/dev/null || true
done
ps w | grep '/opt/zash-agent/www/cgi-bin/api.sh' | grep -v grep | awk '{print $1}' | while read p; do
  kill "$p" 2>/dev/null || true
done
sleep 1
ps w | grep '/opt/zash-agent/www/cgi-bin/api.sh' | grep -v grep | awk '{print $1}' | while read p; do
  kill -9 "$p" 2>/dev/null || true
done
echo "[zash-agent-patch] scoped_stop=done"

echo "[zash-agent-patch] install=begin"
chmod +x "$INSTALLER" 2>/dev/null || true
"$SH_BIN" "$INSTALLER" || fail "installer failed"
echo "[zash-agent-patch] install=done"

sleep 3

echo
echo "[zash-agent-patch] concise_check=begin"
if [ -x "$CHECK_SCRIPT" ]; then
  "$SH_BIN" "$CHECK_SCRIPT"
elif [ -f "$CHECK_SCRIPT" ]; then
  "$SH_BIN" "$CHECK_SCRIPT"
else
  echo "[zash-agent-patch] check_script=missing:$CHECK_SCRIPT"
  /opt/bin/wget -S -O- -T 10 'http://192.168.0.1:9099/cgi-bin/api.sh?cmd=status' 2>&1 | sed -n '1,80p' || true
fi

echo
echo "[zash-agent-patch] done"
