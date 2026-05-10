#!/opt/bin/sh
# UI Mihomo Ultra v1.2.186 — zash-agent HA strict endpoint hotfix installer.
# Patches only /opt/zash-agent/www/cgi-bin/api.sh strict wrapper fallback.
# Does not touch Mihomo core, TUN, QoS/routing, provider SSL, users-db, shapers.db or router reboot.
set -u

API_FILE="/opt/zash-agent/www/cgi-bin/api.sh"
BACKUP_DIR="/opt/zash-agent/var/backups"
TS="$(date '+%Y%m%d-%H%M%S' 2>/dev/null || echo now)"
MARKER="v1.2.186 strict endpoint cache fallback"

mkdir -p "$BACKUP_DIR" /opt/zash-agent/var 2>/dev/null || true

if [ ! -f "$API_FILE" ]; then
  echo "INSTALL_STRICT_STATUS=FAIL"
  echo "REASON=API_FILE_NOT_FOUND"
  echo "API_FILE=$API_FILE"
  exit 1
fi

if grep -q "$MARKER" "$API_FILE" 2>/dev/null; then
  echo "INSTALL_STRICT_STATUS=OK_ALREADY_PATCHED"
  echo "API_FILE=$API_FILE"
  echo "MARKER_PRESENT=yes"
  exit 0
fi

if ! grep -q 'strict-output-violation' "$API_FILE" 2>/dev/null; then
  echo "INSTALL_STRICT_STATUS=FAIL"
  echo "REASON=STRICT_WRAPPER_NOT_FOUND"
  echo "API_FILE=$API_FILE"
  exit 1
fi

BACKUP_FILE="$BACKUP_DIR/api.sh.before-strict-hotfix-v1.2.186.$TS"
cp "$API_FILE" "$BACKUP_FILE" || {
  echo "INSTALL_STRICT_STATUS=FAIL"
  echo "REASON=BACKUP_FAILED"
  exit 1
}

TMP_FILE="/tmp/zash-api-strict-hotfix.$$"
awk '
BEGIN { seen=0; inserted=0 }
{
  if ($0 ~ /strict_no_header=true/) seen=1
  if (seen==1 && inserted==0 && $0 ~ /^[[:space:]]*rm -f "\$tmp"/) {
    print "  # v1.2.186 strict endpoint cache fallback: if a heavy HA endpoint generated"
    print "  # a valid cache but did not emit headers through the strict wrapper, return"
    print "  # that cached payload instead of reporting strict-output-violation."
    print "  case \"$cmd\" in"
    print "    ha_status|ha_traffic|ha_users|ha_qos)"
    print "      cached_payload=\"$(ha_cache_get_any \"$cmd\" 2>/dev/null || true)\""
    print "      if [ -n \"$cached_payload\" ]; then"
    print "        printf '\''%s cmd=%s strict_cache_fallback=true fn=%s rc=%s\\n'\'' \"$(date '\''+%Y-%m-%d %H:%M:%S'\'' 2>/dev/null || echo date)\" \"$cmd\" \"$fn\" \"$rc\" >> \"$log_file\" 2>/dev/null || true"
    print "        rm -f \"$tmp\" 2>/dev/null || true"
    print "        reply_ok \"$cached_payload\""
    print "        return 0"
    print "      fi"
    print "      ;;"
    print "  esac"
    print ""
    inserted=1
  }
  print
}
END { if (inserted != 1) exit 2 }
' "$API_FILE" > "$TMP_FILE"
AWK_RC=$?
if [ "$AWK_RC" -ne 0 ]; then
  rm -f "$TMP_FILE" 2>/dev/null || true
  echo "INSTALL_STRICT_STATUS=FAIL"
  echo "REASON=PATCH_INSERT_FAILED"
  echo "AWK_RC=$AWK_RC"
  echo "BACKUP_FILE=$BACKUP_FILE"
  exit 1
fi

chmod 755 "$TMP_FILE" 2>/dev/null || true
mv "$TMP_FILE" "$API_FILE" || {
  echo "INSTALL_STRICT_STATUS=FAIL"
  echo "REASON=INSTALL_MOVE_FAILED"
  echo "BACKUP_FILE=$BACKUP_FILE"
  exit 1
}
chmod +x "$API_FILE" 2>/dev/null || true

HAS_MARKER="no"
grep -q "$MARKER" "$API_FILE" 2>/dev/null && HAS_MARKER="yes"

echo "INSTALL_STRICT_STATUS=OK"
echo "API_FILE=$API_FILE"
echo "BACKUP_FILE=$BACKUP_FILE"
echo "MARKER_PRESENT=$HAS_MARKER"
echo "RESTART_REQUIRED=no"
