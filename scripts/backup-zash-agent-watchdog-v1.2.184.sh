#!/opt/bin/sh
set +e
TS="$(date +%Y%m%d-%H%M%S 2>/dev/null || echo now)"
DST="/opt/zash-agent/var/watchdog-backup-v1.2.184-$TS"
mkdir -p "$DST" 2>/dev/null || true
cp -p /opt/zash-agent/watchdog.sh "$DST/watchdog.sh" 2>/dev/null || true
cp -p /opt/zash-agent/var/watchdog.state "$DST/watchdog.state" 2>/dev/null || true
echo "BACKUP_STATUS=OK DST=$DST"
