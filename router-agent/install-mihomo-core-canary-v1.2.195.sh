#!/opt/bin/sh
# UI Mihomo Ultra v1.2.195 — install Mihomo core canary helper.
set -u
SRC="${1:-/tmp/zash-mihomo-core-195/mihomo-core-canary-v1.2.195.sh}"
DST_DIR="/opt/etc/mihomo/core-updates"
DST="$DST_DIR/mihomo-core-canary-v1.2.195.sh"
mkdir -p "$DST_DIR" 2>/dev/null || true
if [ ! -f "$SRC" ]; then
  echo "INSTALL_CORE_CANARY_STATUS=NO_SOURCE src=$SRC"
  exit 2
fi
cp "$SRC" "$DST" || { echo "INSTALL_CORE_CANARY_STATUS=COPY_FAILED"; exit 3; }
chmod +x "$DST"
echo "INSTALL_CORE_CANARY_STATUS=OK"
echo "CANARY_FILE=$DST"
/opt/bin/sh "$DST" check 2>/dev/null || /bin/sh "$DST" check 2>/dev/null || true
