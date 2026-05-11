#!/bin/sh
set +e
ROOT="${1:-/opt/etc/mihomo}"
TS="$(date +%Y%m%d-%H%M%S 2>/dev/null || echo now)"
OUT_DIR="$ROOT/backups"
OUT="$OUT_DIR/ui-mihomo-ultra-before-v1.2.192-$TS.tar.gz"
mkdir -p "$OUT_DIR" 2>/dev/null || true
cd "$ROOT" 2>/dev/null || { echo "BACKUP_STATUS=FAIL_NO_ROOT ROOT=$ROOT"; exit 1; }
tar -czf "$OUT" ui zash ultraui messire package.json 2>/dev/null
rc=$?
echo "BACKUP_STATUS=$([ $rc -eq 0 ] && echo OK || echo FAIL)"
echo "BACKUP_FILE=$OUT"
echo "BACKUP_RC=$rc"
exit $rc
