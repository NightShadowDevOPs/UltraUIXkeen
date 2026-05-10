#!/opt/bin/sh
# UI Mihomo Ultra v1.2.186 — zash-agent HA direct endpoints cache-first hotfix installer.
# Patches only /opt/zash-agent/www/cgi-bin/api.sh direct HA endpoint cache behavior.
# Does not touch Mihomo core, TUN, QoS/routing, provider SSL, users-db, shapers.db or router reboot.
set -u

API_FILE="${API_FILE:-/opt/zash-agent/www/cgi-bin/api.sh}"
BACKUP_DIR="${BACKUP_DIR:-/opt/zash-agent/var/backups}"
TS="$(date '+%Y%m%d-%H%M%S' 2>/dev/null || echo now)"
MARKER="v1.2.186 direct HA cache-first stale fallback"

mkdir -p "$BACKUP_DIR" /opt/zash-agent/var 2>/dev/null || true

if [ ! -f "$API_FILE" ]; then
  echo "INSTALL_CACHE_FIRST_STATUS=FAIL"
  echo "REASON=API_FILE_NOT_FOUND"
  exit 1
fi

if grep -q "$MARKER" "$API_FILE" 2>/dev/null; then
  echo "INSTALL_CACHE_FIRST_STATUS=OK_ALREADY_PATCHED"
  echo "API_FILE=$API_FILE"
  echo "MARKER_PRESENT=yes"
  exit 0
fi

for need in 'ha_cache_get_any()' 'ha_status_json()' 'ha_users_json()' 'ha_qos_json()' 'ha_snapshot_refresh_bg()'; do
  if ! grep -q "$need" "$API_FILE" 2>/dev/null; then
    echo "INSTALL_CACHE_FIRST_STATUS=FAIL"
    echo "REASON=MISSING_PATTERN_$need"
    exit 1
  fi
done

BACKUP_FILE="$BACKUP_DIR/api.sh.before-cache-first-v1.2.186.$TS"
cp "$API_FILE" "$BACKUP_FILE" || {
  echo "INSTALL_CACHE_FIRST_STATUS=FAIL"
  echo "REASON=BACKUP_FAILED"
  exit 1
}

TMP_FILE="/tmp/zash-api-cache-first.$$"
awk '
BEGIN {
  inserted_helper=0;
  in_fn=""; cache_seen=0; ret_seen=0;
  patched_status=0; patched_traffic=0; patched_users=0; patched_qos=0;
  in_snapshot_refresh=0; patched_snapshot=0;
}
function patch_for(fn, cname,    marker) {
  marker="  # v1.2.186 direct HA cache-first stale fallback for " cname ": return stale cache immediately and refresh in background."
  print ""
  print marker
  print "  if [ \"${HA_DIRECT_REFRESH:-0}\" != \"1\" ]; then"
  print "    cached_payload=\"$(ha_cache_get_any " cname " 2>/dev/null || true)\""
  print "    if [ -n \"$cached_payload\" ]; then"
  print "      ha_direct_refresh_bg " cname
  print "      reply_ok \"$cached_payload\""
  print "      return"
  print "    fi"
  print "  fi"
  if (cname=="ha_status") patched_status=1;
  if (cname=="ha_traffic") patched_traffic=1;
  if (cname=="ha_users") patched_users=1;
  if (cname=="ha_qos") patched_qos=1;
}
{
  if (inserted_helper==0 && $0 ~ /^ha_snapshot_stub_json\(\) \{/) {
    print "ha_direct_refresh_bg() {"
    print "  name=\"$1\""
    print "  case \"$name\" in ha_status|ha_traffic|ha_users|ha_qos) ;; *) return 0 ;; esac"
    print "  lock_dir=\"/tmp/zash-ha-direct-refresh-$name.lock\""
    print "  ("
    print "    mkdir \"$lock_dir\" >/dev/null 2>&1 || exit 0"
    print "    trap '\''rmdir \"$lock_dir\" >/dev/null 2>&1 || true'\'' EXIT INT TERM"
    print "    HA_DIRECT_REFRESH=1 REQUEST_METHOD=GET QUERY_STRING=\"cmd=$name\" /opt/bin/sh /opt/zash-agent/www/cgi-bin/api.sh >/dev/null 2>&1 || HA_DIRECT_REFRESH=1 REQUEST_METHOD=GET QUERY_STRING=\"cmd=$name\" /bin/sh /opt/zash-agent/www/cgi-bin/api.sh >/dev/null 2>&1 || true"
    print "  ) >/dev/null 2>&1 &"
    print "  return 0"
    print "}"
    print ""
    inserted_helper=1
  }

  if ($0 ~ /^ha_status_json\(\) \{/) { in_fn="ha_status"; cache_seen=0; ret_seen=0 }
  else if ($0 ~ /^ha_traffic_json\(\) \{/) { in_fn="ha_traffic"; cache_seen=0; ret_seen=0 }
  else if ($0 ~ /^ha_users_json\(\) \{/) { in_fn="ha_users"; cache_seen=0; ret_seen=0 }
  else if ($0 ~ /^ha_qos_json\(\) \{/) { in_fn="ha_qos"; cache_seen=0; ret_seen=0 }

  print

  if (in_fn != "" && $0 ~ "cached_payload=\\\"\\$\\(ha_cache_get " in_fn " ") cache_seen=1
  if (in_fn != "" && cache_seen==1 && $0 ~ /^[[:space:]]*return[[:space:]]*$/) ret_seen=1
  if (in_fn != "" && cache_seen==1 && ret_seen==1 && $0 ~ /^[[:space:]]*fi[[:space:]]*$/) {
    patch_for(in_fn "_json", in_fn)
    in_fn=""; cache_seen=0; ret_seen=0
  }

  if ($0 ~ /^ha_snapshot_refresh_bg\(\) \{/) in_snapshot_refresh=1
  else if (in_snapshot_refresh==1 && patched_snapshot==0 && $0 ~ /^[[:space:]]*\([[:space:]]*$/) {
    print "    HA_DIRECT_REFRESH=1"
    patched_snapshot=1
  }
}
END {
  if (inserted_helper != 1 || patched_status != 1 || patched_traffic != 1 || patched_users != 1 || patched_qos != 1 || patched_snapshot != 1) exit 2
}
' "$API_FILE" > "$TMP_FILE"
AWK_RC=$?
if [ "$AWK_RC" -ne 0 ]; then
  rm -f "$TMP_FILE" 2>/dev/null || true
  echo "INSTALL_CACHE_FIRST_STATUS=FAIL"
  echo "REASON=PATCH_INSERT_FAILED"
  echo "AWK_RC=$AWK_RC"
  echo "BACKUP_FILE=$BACKUP_FILE"
  exit 1
fi

chmod 755 "$TMP_FILE" 2>/dev/null || true
mv "$TMP_FILE" "$API_FILE" || {
  echo "INSTALL_CACHE_FIRST_STATUS=FAIL"
  echo "REASON=INSTALL_MOVE_FAILED"
  echo "BACKUP_FILE=$BACKUP_FILE"
  exit 1
}
chmod +x "$API_FILE" 2>/dev/null || true
HAS_MARKER="no"
grep -q "$MARKER" "$API_FILE" 2>/dev/null && HAS_MARKER="yes"

echo "INSTALL_CACHE_FIRST_STATUS=OK"
echo "API_FILE=$API_FILE"
echo "BACKUP_FILE=$BACKUP_FILE"
echo "MARKER_PRESENT=$HAS_MARKER"
echo "RESTART_REQUIRED=no"
