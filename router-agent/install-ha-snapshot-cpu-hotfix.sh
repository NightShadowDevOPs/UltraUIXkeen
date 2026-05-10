#!/opt/bin/sh
# UI Mihomo Ultra v1.2.187 — zash-agent ha_snapshot CPU/load hotfix installer.
# Patches only /opt/zash-agent/www/cgi-bin/api.sh HA snapshot status system metrics.
# Does not touch Mihomo core, TUN, QoS/routing, provider SSL, users-db, shapers.db, Home Assistant or router reboot.
set -u

API_FILE="${API_FILE:-/opt/zash-agent/www/cgi-bin/api.sh}"
BACKUP_DIR="${BACKUP_DIR:-/opt/zash-agent/var/backups}"
TS="$(date '+%Y%m%d-%H%M%S' 2>/dev/null || echo now)"
MARKER="v1.2.187 ha_snapshot live CPU/load overlay"

mkdir -p "$BACKUP_DIR" /opt/zash-agent/var 2>/dev/null || true

if [ ! -f "$API_FILE" ]; then
  echo "INSTALL_SNAPSHOT_CPU_STATUS=FAIL"
  echo "REASON=API_FILE_NOT_FOUND"
  echo "API_FILE=$API_FILE"
  exit 1
fi

if grep -q "$MARKER" "$API_FILE" 2>/dev/null; then
  echo "INSTALL_SNAPSHOT_CPU_STATUS=OK_ALREADY_PATCHED"
  echo "API_FILE=$API_FILE"
  echo "MARKER_PRESENT=yes"
  echo "RESTART_REQUIRED=no"
  exit 0
fi

for need in 'ha_snapshot_json()' 'ha_snapshot_component_json()' 'status_cache_get()' 'status_cpu_pct_sample()' 'ha_cache_put()'; do
  if ! grep -q "$need" "$API_FILE" 2>/dev/null; then
    echo "INSTALL_SNAPSHOT_CPU_STATUS=FAIL"
    echo "REASON=MISSING_PATTERN_$need"
    exit 1
  fi
done

BACKUP_FILE="$BACKUP_DIR/api.sh.before-snapshot-cpu-v1.2.187.$TS"
cp "$API_FILE" "$BACKUP_FILE" || {
  echo "INSTALL_SNAPSHOT_CPU_STATUS=FAIL"
  echo "REASON=BACKUP_FAILED"
  exit 1
}

AWK_FILE="/tmp/zash-snapshot-cpu-hotfix.$$.awk"
TMP_FILE="/tmp/zash-api-snapshot-cpu.$$"
cat > "$AWK_FILE" <<'AWK'
BEGIN { inserted_fn=0; patched_overlay=0 }
{
  if (inserted_fn==0 && $0 ~ /^ha_snapshot_json\(\) \{/) {
    print "ha_snapshot_status_live_system_overlay() {"
    print "  payload=\"$1\""
    print "  # v1.2.187 ha_snapshot live CPU/load overlay: HA snapshot status must not keep stale fallback CPU=50."
    print "  printf '%s' \"$payload\" | grep -q '\"system\":{' || { printf '%s' \"$payload\"; return 0; }"
    print "  live_status=\"$(status_cache_get 5 2>/dev/null || true)\""
    print "  cpu_pct=\"$(printf '%s' \"$live_status\" | sed -n 's/.*\"cpuPct\":\\([0-9][0-9.]*\\).*/\\1/p' | head -n 1)\""
    print "  load1=\"$(printf '%s' \"$live_status\" | sed -n 's/.*\"load1\":\"\\([^\"]*\\)\".*/\\1/p' | head -n 1)\""
    print "  load5=\"$(printf '%s' \"$live_status\" | sed -n 's/.*\"load5\":\"\\([^\"]*\\)\".*/\\1/p' | head -n 1)\""
    print "  load15=\"$(printf '%s' \"$live_status\" | sed -n 's/.*\"load15\":\"\\([^\"]*\\)\".*/\\1/p' | head -n 1)\""
    print "  if ! echo \"$cpu_pct\" | grep -qE '^[0-9]+(\\.[0-9]+)?$'; then"
    print "    cpu_pct=\"$(status_cpu_pct_sample 2>/dev/null || echo 0)\""
    print "  fi"
    print "  if [ -r /proc/loadavg ]; then"
    print "    [ -n \"$load1\" ] || load1=\"$(awk '{print $1}' /proc/loadavg 2>/dev/null)\""
    print "    [ -n \"$load5\" ] || load5=\"$(awk '{print $2}' /proc/loadavg 2>/dev/null)\""
    print "    [ -n \"$load15\" ] || load15=\"$(awk '{print $3}' /proc/loadavg 2>/dev/null)\""
    print "  fi"
    print "  echo \"$cpu_pct\" | grep -qE '^[0-9]+(\\.[0-9]+)?$' || cpu_pct=0"
    print "  echo \"$load1\" | grep -qE '^[0-9]+(\\.[0-9]+)?$' || load1=0"
    print "  echo \"$load5\" | grep -qE '^[0-9]+(\\.[0-9]+)?$' || load5=0"
    print "  echo \"$load15\" | grep -qE '^[0-9]+(\\.[0-9]+)?$' || load15=0"
    print "  overlaid=\"$(printf '%s' \"$payload\" | sed -e 's/\"load\":{[^}]*},//g' -e \"s/\\\"cpu_pct\\\":[0-9][0-9.]*/\\\"cpu_pct\\\":$cpu_pct,\\\"load\\\":{\\\"load1\\\":$load1,\\\"load5\\\":$load5,\\\"load15\\\":$load15}/\")\""
    print "  printf '%s' \"$overlaid\" | grep -q '\"load\":{' || overlaid=\"$payload\""
    print "  printf '%s' \"$overlaid\""
    print "}"
    print ""
    inserted_fn=1
  }
  print
  if (patched_overlay==0 && $0 ~ /^[[:space:]]*\[ -n "\$status_payload" \] \|\| status_payload=/) {
    print "  # v1.2.187: keep HA snapshot system CPU/load fresh even when ha_status component cache is stale."
    print "  status_payload=\"$(ha_snapshot_status_live_system_overlay \"$status_payload\")\""
    print "  ha_cache_put ha_status \"$status_payload\" >/dev/null 2>&1 || true"
    patched_overlay=1
  }
}
END { if (inserted_fn != 1 || patched_overlay != 1) exit 2 }
AWK

awk -f "$AWK_FILE" "$API_FILE" > "$TMP_FILE"
AWK_RC=$?
rm -f "$AWK_FILE" 2>/dev/null || true
if [ "$AWK_RC" -ne 0 ]; then
  rm -f "$TMP_FILE" 2>/dev/null || true
  echo "INSTALL_SNAPSHOT_CPU_STATUS=FAIL"
  echo "REASON=PATCH_INSERT_FAILED"
  echo "AWK_RC=$AWK_RC"
  echo "BACKUP_FILE=$BACKUP_FILE"
  exit 1
fi

chmod 755 "$TMP_FILE" 2>/dev/null || true
mv "$TMP_FILE" "$API_FILE" || {
  echo "INSTALL_SNAPSHOT_CPU_STATUS=FAIL"
  echo "REASON=INSTALL_MOVE_FAILED"
  echo "BACKUP_FILE=$BACKUP_FILE"
  exit 1
}
chmod +x "$API_FILE" 2>/dev/null || true
HAS_MARKER="no"
grep -q "$MARKER" "$API_FILE" 2>/dev/null && HAS_MARKER="yes"

echo "INSTALL_SNAPSHOT_CPU_STATUS=OK"
echo "API_FILE=$API_FILE"
echo "BACKUP_FILE=$BACKUP_FILE"
echo "MARKER_PRESENT=$HAS_MARKER"
echo "RESTART_REQUIRED=no"
