#!/opt/bin/sh
set +e
LAST="$(ls -1dt /opt/zash-agent/var/watchdog-backup-v1.2.184-* 2>/dev/null | head -n 1)"
[ -n "$LAST" ] || { echo 'ROLLBACK_STATUS=FAIL_NO_BACKUP'; exit 1; }
[ -f "$LAST/watchdog.sh" ] || { echo 'ROLLBACK_STATUS=FAIL_NO_WATCHDOG_IN_BACKUP'; exit 1; }
cp -p "$LAST/watchdog.sh" /opt/zash-agent/watchdog.sh || { echo 'ROLLBACK_STATUS=FAIL_COPY'; exit 1; }
chmod +x /opt/zash-agent/watchdog.sh 2>/dev/null || true
echo "ROLLBACK_STATUS=OK SRC=$LAST"
