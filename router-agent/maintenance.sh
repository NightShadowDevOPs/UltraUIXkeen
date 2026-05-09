#!/opt/bin/sh
# UI Mihomo Ultra v1.2.181 — zash-agent maintenance.
# Safe scope: backup retention + agent.log rotation only.
# Does NOT touch Mihomo core, TUN, QoS/routing, users-db, shapers.db, provider SSL cache.
set -u

MODE="${1:-dry-run}"
AGENT_DIR="/opt/zash-agent"
VAR_DIR="$AGENT_DIR/var"
BACKUP_DIR="$VAR_DIR/backups"
LOG_FILE="$VAR_DIR/agent.log"
STATE_FILE="$VAR_DIR/maintenance.state"
KEEP_BACKUPS="${ZASH_AGENT_BACKUP_KEEP_COUNT:-7}"
LOG_MAX_BYTES="${ZASH_AGENT_LOG_MAX_BYTES:-10485760}"
LOG_KEEP_GZ="${ZASH_AGENT_LOG_KEEP_GZ:-3}"
TMP_ALL="/tmp/zash-maint-all.$$"
TMP_DEL="/tmp/zash-maint-delete.$$"

case "$MODE" in
  dry-run|apply|status) ;;
  *) echo 'MAINTENANCE_STATUS=ERROR_BAD_MODE'; echo 'USAGE=maintenance.sh [dry-run|apply|status]'; exit 2 ;;
esac

mkdir -p "$VAR_DIR" "$BACKUP_DIR" 2>/dev/null || true
now_epoch() { date +%s 2>/dev/null || echo 0; }
now_iso() { date '+%Y-%m-%dT%H:%M:%S%z' 2>/dev/null || date 2>/dev/null || echo now; }
size_file() { [ -f "$1" ] && wc -c < "$1" 2>/dev/null || echo 0; }
size_list_kb() { s=0; while IFS= read -r f; do [ -f "$f" ] || continue; k=$(du -k "$f" 2>/dev/null | awk '{print $1}'); s=$((s + ${k:-0})); done < "$1"; echo "$s"; }
cleanup_tmp() { rm -f "$TMP_ALL" "$TMP_DEL" 2>/dev/null || true; }
trap cleanup_tmp EXIT INT TERM

ls -1t "$BACKUP_DIR"/zash-backup-*.tar.gz 2>/dev/null > "$TMP_ALL" || true
sed -n "$((KEEP_BACKUPS + 1)),99999p" "$TMP_ALL" > "$TMP_DEL" 2>/dev/null || true
BACKUPS_COUNT=$(wc -l < "$TMP_ALL" 2>/dev/null || echo 0)
DELETE_COUNT=$(wc -l < "$TMP_DEL" 2>/dev/null || echo 0)
DELETE_KB=$(size_list_kb "$TMP_DEL")
DELETE_MB=$((DELETE_KB / 1024))
AGENT_LOG_BYTES=$(size_file "$LOG_FILE")
ROTATE_NEEDED=no
[ "$AGENT_LOG_BYTES" -gt "$LOG_MAX_BYTES" ] 2>/dev/null && ROTATE_NEEDED=yes
VAR_KB=$(du -sk "$VAR_DIR" 2>/dev/null | awk '{print $1}')
BACKUPS_KB=$(du -sk "$BACKUP_DIR" 2>/dev/null | awk '{print $1}')

if [ "$MODE" = "status" ] || [ "$MODE" = "dry-run" ]; then
  echo "MAINTENANCE_MODE=$MODE"
  echo "VAR_SIZE_KB=${VAR_KB:-0}"
  echo "BACKUPS_SIZE_KB=${BACKUPS_KB:-0}"
  echo "BACKUPS_COUNT=$BACKUPS_COUNT"
  echo "KEEP_BACKUPS=$KEEP_BACKUPS"
  echo "DELETE_CANDIDATES=$DELETE_COUNT"
  echo "WOULD_FREE_KB=$DELETE_KB"
  echo "WOULD_FREE_MB=$DELETE_MB"
  echo "AGENT_LOG_BYTES=$AGENT_LOG_BYTES"
  echo "LOG_MAX_BYTES=$LOG_MAX_BYTES"
  echo "ROTATE_NEEDED=$ROTATE_NEEDED"
  if [ "$MODE" = "dry-run" ]; then
    echo 'DELETE_PREVIEW_BEGIN'
    sed -n '1,20p' "$TMP_DEL" 2>/dev/null
    echo 'DELETE_PREVIEW_END'
  fi
fi

[ "$MODE" = "dry-run" ] && { echo 'MAINTENANCE_STATUS=DRY_RUN_ONLY'; exit 0; }
[ "$MODE" = "status" ] && { echo 'MAINTENANCE_STATUS=STATUS_ONLY'; exit 0; }

DELETED=0
while IFS= read -r f; do
  [ -f "$f" ] || continue
  case "$f" in
    "$BACKUP_DIR"/zash-backup-*.tar.gz) rm -f "$f" 2>/dev/null && DELETED=$((DELETED + 1)) ;;
    *) echo "SKIP_UNSAFE_DELETE=$f" ;;
  esac
done < "$TMP_DEL"

ROTATED_LOG=no
if [ -f "$LOG_FILE" ] && [ "$AGENT_LOG_BYTES" -gt "$LOG_MAX_BYTES" ] 2>/dev/null; then
  TS=$(date +%Y%m%d-%H%M%S 2>/dev/null || echo manual)
  LOG_BAK="$LOG_FILE.$TS"
  cp "$LOG_FILE" "$LOG_BAK" 2>/dev/null && gzip -f "$LOG_BAK" 2>/dev/null && : > "$LOG_FILE" && ROTATED_LOG=yes
fi

# Keep only newest compressed agent.log copies.
ls -1t "$LOG_FILE".*.gz 2>/dev/null | sed -n "$((LOG_KEEP_GZ + 1)),99999p" | while IFS= read -r oldlog; do
  case "$oldlog" in
    "$LOG_FILE".*.gz) rm -f "$oldlog" 2>/dev/null || true ;;
  esac
done

{
  echo "LAST_MAINTENANCE=$(now_epoch)"
  echo "LAST_MAINTENANCE_ISO=$(now_iso)"
  echo "MODE=apply"
  echo "DELETED_BACKUPS=$DELETED"
  echo "FREED_KB_ESTIMATE=$DELETE_KB"
  echo "ROTATED_LOG=$ROTATED_LOG"
  echo "KEEP_BACKUPS=$KEEP_BACKUPS"
  echo "LOG_MAX_BYTES=$LOG_MAX_BYTES"
} > "$STATE_FILE" 2>/dev/null || true

VAR_KB_AFTER=$(du -sk "$VAR_DIR" 2>/dev/null | awk '{print $1}')
BACKUPS_COUNT_AFTER=$(ls -1 "$BACKUP_DIR"/zash-backup-*.tar.gz 2>/dev/null | wc -l)
AGENT_LOG_BYTES_AFTER=$(size_file "$LOG_FILE")
echo "MAINTENANCE_MODE=apply"
echo "DELETED_BACKUPS=$DELETED"
echo "FREED_KB_ESTIMATE=$DELETE_KB"
echo "ROTATED_LOG=$ROTATED_LOG"
echo "VAR_SIZE_KB_AFTER=${VAR_KB_AFTER:-0}"
echo "BACKUPS_COUNT_AFTER=$BACKUPS_COUNT_AFTER"
echo "AGENT_LOG_BYTES_AFTER=$AGENT_LOG_BYTES_AFTER"
echo 'MAINTENANCE_STATUS=OK'
