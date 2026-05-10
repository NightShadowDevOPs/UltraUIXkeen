#!/bin/sh
set +e
API_FILE="${API_FILE:-/opt/zash-agent/www/cgi-bin/api.sh}"
BACKUP_DIR="${BACKUP_DIR:-/opt/zash-agent/var/backups}"
TS="$(date '+%Y%m%d-%H%M%S' 2>/dev/null || echo now)"
mkdir -p "$BACKUP_DIR" 2>/dev/null || true
if [ ! -f "$API_FILE" ]; then echo "BACKUP_STRICT_STATUS=FAIL REASON=API_FILE_NOT_FOUND"; exit 1; fi
OUT="$BACKUP_DIR/api.sh.manual-before-strict-v1.2.186.$TS"
cp "$API_FILE" "$OUT" && echo "BACKUP_STRICT_STATUS=OK" && echo "BACKUP_FILE=$OUT" || echo "BACKUP_STRICT_STATUS=FAIL"
