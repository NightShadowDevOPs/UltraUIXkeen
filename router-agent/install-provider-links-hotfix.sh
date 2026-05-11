#!/bin/sh
# UI Mihomo Ultra v1.2.188 — provider links / subscription-first SSL metadata hotfix.
# Scope: router-agent API metadata only. No Mihomo core, TUN, QoS, routing, users rules or router reboot.
set +e
API_FILE="/opt/zash-agent/www/cgi-bin/api.sh"
BACKUP_DIR="/opt/zash-agent/var/backups"
STAMP="$(date +%Y%m%d-%H%M%S 2>/dev/null || echo now)"
BACKUP_FILE="$BACKUP_DIR/api.sh.before-provider-links-v1.2.188.$STAMP"
MARKER="# v1.2.188-provider-links"

mkdir -p "$BACKUP_DIR" 2>/dev/null || true
if [ ! -f "$API_FILE" ]; then
  echo "INSTALL_PROVIDER_LINKS_STATUS=ERROR_NO_API"
  echo "API_FILE=$API_FILE"
  exit 0
fi
if grep -q "v1.2.188-provider-links" "$API_FILE" 2>/dev/null; then
  echo "INSTALL_PROVIDER_LINKS_STATUS=OK_ALREADY"
  echo "API_FILE=$API_FILE"
  echo "RESTART_REQUIRED=no"
  exit 0
fi
cp "$API_FILE" "$BACKUP_FILE" 2>/dev/null
TMP="$API_FILE.tmp.v188.$$"
awk -v marker="$MARKER" '
  /safe_list_proxy_provider_lines\(\)/ && !inserted {
    print "users_db_panel_ssh_urls_lines() {"
    print "  file=\"\""
    print "  for f in \"${USERS_DB_FILE:-}\" \"/opt/zash-agent/var/users-db.json\" \"/opt/zash-agent/var/users_db.json\" \"/opt/zash-agent/var/usersdb.json\"; do"
    print "    if [ -f \"$f\" ]; then file=\"$f\"; break; fi"
    print "  done"
    print "  [ -n \"$file\" ] || return 0"
    print "  data=\"$(head -c 2097152 \"$file\" 2>/dev/null | tr -d '\''\\n\\r'\'')\""
    print "  part=\"$(printf '\''%s'\'' \"$data\" | sed -nE '\''s/.*\"providerPanelSshUrls\"[[:space:]]*:[[:space:]]*\\{([^}]*)\\}.*/\\1/p'\'' | head -n1)\""
    print "  [ -n \"$part\" ] || return 0"
    print "  printf '\''%s'\'' \"$part\" | tr '\'','\'' '\''\\n'\'' | sed -nE '\''s/^[[:space:]]*\"([^\"]+)\"[[:space:]]*:[[:space:]]*\"([^\"]*)\".*/\\1\\t\\2/p'\''"
    print "  return 0"
    print "}"
    print ""
    inserted=1
  }
  {
    line=$0
    if (line ~ /panel_map="\$\(users_db_panel_urls_lines\)"/) {
      print line
      print "  panel_ssh_map=\"$(users_db_panel_ssh_urls_lines)\""
      next
    }
    if (line ~ /panel_url="\$\(panel_url_for_provider/) {
      print line
      print "    panel_ssh_url=\"$(panel_url_for_provider \"$pname\" \"$panel_ssh_map\")\""
      next
    }
    if (line ~ /esc_purl="\$\(printf/) {
      print line
      print "    esc_pssh=\"$(printf '\''%s'\'' \"$panel_ssh_url\" | sed '\''s/\"/\\\\\\\"/g'\'')\""
      next
    }
    if (line ~ /out="\$out\{\\\"name\\\".*panelSslNotAfter/) {
      print "    out=\"$out{\\\"name\\\":\\\"$esc_name\\\",\\\"url\\\":\\\"$esc_url\\\",\\\"host\\\":\\\"$esc_host\\\",\\\"port\\\":\\\"$esc_port\\\",\\\"sslNotAfter\\\":\\\"$esc_na\\\",\\\"sslCheckSource\\\":\\\"subscription\\\",\\\"panelUrl\\\":\\\"$esc_purl\\\",\\\"panelSshUrl\\\":\\\"$esc_pssh\\\",\\\"panelSslNotAfter\\\":\\\"$esc_pna\\\",\\\"panelSslCheckSource\\\":\\\"panel\\\"}\""
      print "    " marker
      next
    }
    print line
  }
' "$API_FILE" > "$TMP"
if [ ! -s "$TMP" ]; then
  echo "INSTALL_PROVIDER_LINKS_STATUS=ERROR_PATCH_EMPTY"
  echo "BACKUP_FILE=$BACKUP_FILE"
  rm -f "$TMP" 2>/dev/null
  exit 0
fi
if ! grep -q "v1.2.188-provider-links" "$TMP" 2>/dev/null; then
  echo "INSTALL_PROVIDER_LINKS_STATUS=ERROR_MARKER_MISSING"
  echo "BACKUP_FILE=$BACKUP_FILE"
  rm -f "$TMP" 2>/dev/null
  exit 0
fi
mv "$TMP" "$API_FILE" 2>/dev/null
chmod +x "$API_FILE" 2>/dev/null
echo "INSTALL_PROVIDER_LINKS_STATUS=OK"
echo "API_FILE=$API_FILE"
echo "BACKUP_FILE=$BACKUP_FILE"
echo "MARKER_PRESENT=yes"
echo "RESTART_REQUIRED=no"
