#!/opt/bin/sh
# UI Mihomo Ultra v1.2.195 — Mihomo core v1.19.25 staged canary helper.
# Default is read-only check. Core replacement requires explicit token: APPLY_MIHOMO_1_19_25.
# Scope: Mihomo binary only. Does not edit config.yaml, TUN, sniffing, QUIC, QoS, routing, router-agent or Home Assistant.
set -u

TARGET_VERSION="v1.19.25"
TARGET_ASSET="mihomo-linux-arm64-v1.19.25.gz"
TARGET_URL="https://github.com/MetaCubeX/mihomo/releases/download/${TARGET_VERSION}/${TARGET_ASSET}"
WORK_DIR="/opt/etc/mihomo"
STAGE_DIR="$WORK_DIR/core-updates/$TARGET_VERSION"
BACKUP_DIR="$WORK_DIR/core-updates/backups"
STAGED_GZ="$STAGE_DIR/$TARGET_ASSET"
STAGED_BIN="$STAGE_DIR/mihomo"
LOG_FILE="$WORK_DIR/core-updates/mihomo-core-canary-v1.2.195.log"
CMD="${1:-check}"
TOKEN="${2:-}"

mkdir -p "$STAGE_DIR" "$BACKUP_DIR" "$(dirname "$LOG_FILE")" 2>/dev/null || true
now(){ date '+%Y-%m-%d %H:%M:%S' 2>/dev/null || date 2>/dev/null || echo now; }
log(){ echo "$(now) $*" >> "$LOG_FILE" 2>/dev/null || true; }
out(){ echo "$*"; log "$*"; }

find_bin(){
  b="$(command -v mihomo 2>/dev/null || true)"
  [ -n "$b" ] && { echo "$b"; return 0; }
  [ -x /opt/bin/mihomo ] && { echo /opt/bin/mihomo; return 0; }
  [ -x /opt/sbin/mihomo ] && { echo /opt/sbin/mihomo; return 0; }
  [ -x "$WORK_DIR/mihomo" ] && { echo "$WORK_DIR/mihomo"; return 0; }
  echo ""
}

core_ver(){
  b="$1"
  [ -n "$b" ] && [ -x "$b" ] || { echo "missing"; return 0; }
  "$b" -v 2>&1 | head -n 1 | sed 's/[[:space:]][[:space:]]*/ /g'
}

restart_mihomo(){
  for s in /opt/etc/init.d/S99mihomo /opt/etc/init.d/S99mihomo-core /opt/etc/init.d/mihomo; do
    if [ -x "$s" ]; then
      out "RESTART_METHOD=$s restart"
      "$s" restart >/tmp/mihomo-restart-v195.out 2>&1
      rc=$?
      out "RESTART_RC=$rc"
      return "$rc"
    fi
  done
  out "RESTART_METHOD=not_found_manual_required"
  return 9
}

cmd_check(){
  bin="$(find_bin)"
  echo "CHECK_MIHOMO_CORE_CANARY_VERSION=v1.2.195"
  echo "CURRENT_BIN=${bin:-NOT_FOUND}"
  echo "CURRENT_VERSION=$(core_ver "$bin")"
  echo "STAGED_BIN_EXISTS=$([ -x "$STAGED_BIN" ] && echo yes || echo no)"
  echo "STAGED_VERSION=$(core_ver "$STAGED_BIN")"
  echo "TARGET_VERSION=$TARGET_VERSION"
  echo "WORK_DIR=$WORK_DIR"
}

cmd_stage(){
  arch="$(uname -m 2>/dev/null || echo unknown)"
  case "$arch" in aarch64|arm64) : ;; *) echo "STAGE_STATUS=REFUSED_UNSUPPORTED_ARCH arch=$arch expected=arm64"; return 2;; esac
  echo "STAGE_TARGET=$TARGET_URL"
  if command -v curl >/dev/null 2>&1; then
    curl -fL --connect-timeout 15 -m 180 "$TARGET_URL" -o "$STAGED_GZ"
  else
    wget -O "$STAGED_GZ" -T 180 "$TARGET_URL"
  fi
  rc=$?
  [ "$rc" -eq 0 ] || { echo "STAGE_DOWNLOAD_RC=$rc"; return "$rc"; }
  gzip -dc "$STAGED_GZ" > "$STAGED_BIN.tmp"
  rc=$?
  [ "$rc" -eq 0 ] || { rm -f "$STAGED_BIN.tmp"; echo "STAGE_GZIP_RC=$rc"; return "$rc"; }
  chmod +x "$STAGED_BIN.tmp"
  mv "$STAGED_BIN.tmp" "$STAGED_BIN"
  echo "STAGE_STATUS=OK"
  echo "STAGED_VERSION=$(core_ver "$STAGED_BIN")"
}

cmd_test(){
  [ -x "$STAGED_BIN" ] || { echo "TEST_STATUS=NO_STAGED_BIN_RUN_STAGE_FIRST"; return 2; }
  echo "TEST_STAGED_VERSION=$(core_ver "$STAGED_BIN")"
  "$STAGED_BIN" -t -d "$WORK_DIR" >/tmp/mihomo-config-test-v195.out 2>&1
  rc=$?
  echo "CONFIG_TEST_RC=$rc"
  tail -n 4 /tmp/mihomo-config-test-v195.out 2>/dev/null | sed 's/^/CONFIG_TEST_TAIL=/'
  [ "$rc" -eq 0 ] && echo "TEST_STATUS=OK" || echo "TEST_STATUS=FAILED"
  return "$rc"
}

cmd_apply(){
  [ "$TOKEN" = "APPLY_MIHOMO_1_19_25" ] || { echo "APPLY_STATUS=REFUSED_TOKEN_REQUIRED"; return 2; }
  [ -x "$STAGED_BIN" ] || { echo "APPLY_STATUS=NO_STAGED_BIN_RUN_STAGE_FIRST"; return 2; }
  bin="$(find_bin)"
  [ -n "$bin" ] && [ -x "$bin" ] || { echo "APPLY_STATUS=CURRENT_BIN_NOT_FOUND"; return 2; }
  "$STAGED_BIN" -t -d "$WORK_DIR" >/tmp/mihomo-config-test-v195.out 2>&1
  rc=$?
  [ "$rc" -eq 0 ] || { echo "APPLY_STATUS=REFUSED_CONFIG_TEST_FAILED rc=$rc"; tail -n 4 /tmp/mihomo-config-test-v195.out; return "$rc"; }
  ts="$(date '+%Y%m%d-%H%M%S' 2>/dev/null || echo now)"
  backup="$BACKUP_DIR/mihomo.before-${TARGET_VERSION}.$ts"
  cp -p "$bin" "$backup" || { echo "APPLY_STATUS=BACKUP_FAILED"; return 3; }
  cp "$STAGED_BIN" "$bin" || { cp "$backup" "$bin" 2>/dev/null || true; echo "APPLY_STATUS=COPY_FAILED_ROLLBACK_ATTEMPTED"; return 4; }
  chmod +x "$bin"
  restart_mihomo
  rrc=$?
  echo "APPLY_BACKUP=$backup"
  echo "APPLY_STATUS=$([ "$rrc" -eq 0 ] && echo OK || echo COPIED_RESTART_MANUAL_CHECK_REQUIRED)"
  echo "CURRENT_VERSION=$(core_ver "$bin")"
  return 0
}

cmd_rollback(){
  [ "$TOKEN" = "ROLLBACK_MIHOMO" ] || { echo "ROLLBACK_STATUS=REFUSED_TOKEN_REQUIRED"; return 2; }
  bin="$(find_bin)"
  last="$(ls -1t "$BACKUP_DIR"/mihomo.before-* 2>/dev/null | head -n 1)"
  [ -n "$bin" ] && [ -n "$last" ] || { echo "ROLLBACK_STATUS=NO_BACKUP_OR_BIN"; return 2; }
  cp "$last" "$bin" && chmod +x "$bin"
  rc=$?
  [ "$rc" -eq 0 ] || { echo "ROLLBACK_STATUS=COPY_FAILED"; return "$rc"; }
  restart_mihomo
  echo "ROLLBACK_FROM=$last"
  echo "ROLLBACK_STATUS=OK"
  echo "CURRENT_VERSION=$(core_ver "$bin")"
}

case "$CMD" in
  check|status) cmd_check ;;
  stage|download) cmd_stage ;;
  test|canary) cmd_test ;;
  apply) cmd_apply ;;
  rollback) cmd_rollback ;;
  *) echo "Usage: $0 {check|stage|test|apply APPLY_MIHOMO_1_19_25|rollback ROLLBACK_MIHOMO}"; exit 1 ;;
esac
