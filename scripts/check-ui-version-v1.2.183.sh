#!/bin/sh
# UI Mihomo Ultra v1.2.184 — compact installed UI version check.
# Read-only. Prints <= 15 lines.
set +e
cd /opt/etc/mihomo 2>/dev/null || cd /opt/etc 2>/dev/null || true
old="1.2.181"
new="1.2.184"
echo "== UI version check v1.2.184 =="
echo "PWD=$(pwd)"
old_files=$(grep -Rsl "$old" ./ui ./messire ./zash ./ultraui 2>/dev/null | wc -l)
new_files=$(grep -Rsl "$new" ./ui ./messire ./zash ./ultraui 2>/dev/null | wc -l)
first_old=$(grep -Rsl "$old" ./ui ./messire ./zash ./ultraui 2>/dev/null | head -n 1)
first_new=$(grep -Rsl "$new" ./ui ./messire ./zash ./ultraui 2>/dev/null | head -n 1)
echo "OLD_181_FILES=$old_files first=${first_old:-none}"
echo "NEW_183_FILES=$new_files first=${first_new:-none}"
for d in ui messire zash ultraui; do
  [ -d "./$d" ] && echo "DIR_$d=yes" || echo "DIR_$d=no"
done
[ "$old_files" -eq 0 ] && echo "DECISION=UI_FILES_OK_OR_BROWSER_CACHE" || echo "DECISION=UI_BUNDLE_STILL_OLD"
