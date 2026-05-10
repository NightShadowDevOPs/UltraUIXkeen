#!/bin/sh
set +e
API_FILE="${API_FILE:-/opt/zash-agent/www/cgi-bin/api.sh}"
BACKUP_FILE="$1"
if [ -z "$BACKUP_FILE" ] || [ ! -f "$BACKUP_FILE" ]; then
  echo "ROLLBACK_CACHE_FIRST_STATUS=FAIL"
  echo "USAGE=/opt/bin/sh rollback-zash-agent-cache-first-v1.2.186.sh /path/to/backup"
  exit 1
fi
cp "$API_FILE" "$API_FILE.before-rollback-v1.2.186.$(date '+%Y%m%d-%H%M%S' 2>/dev/null || echo now)" 2>/dev/null || true
cp "$BACKUP_FILE" "$API_FILE" && chmod +x "$API_FILE" 2>/dev/null
RC=$?
echo "ROLLBACK_CACHE_FIRST_STATUS=$([ $RC -eq 0 ] && echo OK || echo FAIL)"
exit "$RC"
