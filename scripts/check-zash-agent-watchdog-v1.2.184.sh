#!/opt/bin/sh
set +e
echo '== zash-agent watchdog v1.2.184 check =='
grep -n 'v1.2.184\|POLICY=transport_ok' /opt/zash-agent/watchdog.sh 2>/dev/null | head -n 4
/opt/bin/sh /opt/zash-agent/watchdog.sh 2>/dev/null || /bin/sh /opt/zash-agent/watchdog.sh 2>/dev/null
echo "STATE=$(cat /opt/zash-agent/var/watchdog.state 2>/dev/null | tr '
' ';')"
echo "CRON_WD=$(grep -c 'zash-agent/watchdog.sh' /opt/var/spool/cron/crontabs/root 2>/dev/null)"
