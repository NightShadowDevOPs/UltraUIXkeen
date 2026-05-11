#!/bin/sh
set +e
API="${API:-http://192.168.0.1:9099/cgi-bin/api.sh}"
DB="/opt/zash-agent/var/users-db.json"
echo "CHECK_PROVIDER_HOSTING_PERSISTENCE_VERSION=v1.2.194"
[ -f "$DB" ] && echo "USERS_DB_EXISTS=yes" || echo "USERS_DB_EXISTS=no"
json="$(cat "$DB" 2>/dev/null || true)"
case "$json" in *providerHostingDueDates*) echo "HAS_DUE_DATES_FIELD=yes";; *) echo "HAS_DUE_DATES_FIELD=no";; esac
case "$json" in *providerHostingPeriodMonths*) echo "HAS_PERIOD_FIELD=yes";; *) echo "HAS_PERIOD_FIELD=no";; esac
due_block="$(printf '%s' "$json" | grep -o '"providerHostingDueDates":{[^}]*}' 2>/dev/null | head -n 1)"
period_block="$(printf '%s' "$json" | grep -o '"providerHostingPeriodMonths":{[^}]*}' 2>/dev/null | head -n 1)"
due_count=0; period_count=0
[ -n "$due_block" ] && due_count=$(printf '%s' "$due_block" | grep -o '"[^"]*":"[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]"' | wc -l | tr -d ' ')
[ -n "$period_block" ] && period_count=$(printf '%s' "$period_block" | grep -o '"[^"]*":[0-9][0-9]*' | wc -l | tr -d ' ')
echo "HOSTING_DUE_RECORDS=$due_count"
echo "HOSTING_PERIOD_RECORDS=$period_count"
api_ok="$(curl -sS -m 8 "$API?cmd=users_db_get" 2>/dev/null | grep -o '"ok":true' | head -n 1)"
[ -n "$api_ok" ] && echo "USERS_DB_API_OK=yes" || echo "USERS_DB_API_OK=no"
state="$(cat /opt/zash-agent/var/watchdog.state 2>/dev/null | tr '\n' ';')"
echo "WATCHDOG=$state"
