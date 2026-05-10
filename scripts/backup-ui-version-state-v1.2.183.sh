#!/bin/sh
# UI Mihomo Ultra v1.2.183 — frontend dirs backup helper.
# Safe backup only. Does not modify UI files.
set +e
cd /opt/etc/mihomo 2>/dev/null || cd /opt/etc 2>/dev/null || true
TS="$(date +%Y%m%d-%H%M%S 2>/dev/null || echo now)"
OUT="/tmp/ui-mihomo-frontends-backup-v1.2.183-$TS.tar.gz"
echo "== UI frontend backup v1.2.183 =="
tar -czf "$OUT" ui messire zash ultraui 2>/tmp/ui-backup-v1.2.183.err
rc=$?
echo "BACKUP_RC=$rc"
echo "BACKUP_FILE=$OUT"
[ -f "$OUT" ] && du -sh "$OUT" 2>/dev/null || true
err=$(cat /tmp/ui-backup-v1.2.183.err 2>/dev/null | head -n 1)
echo "ERROR_FIRST=${err:-none}"
