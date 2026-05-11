#!/bin/sh
set +e
ROOT="${1:-.}"
FILE="$ROOT/src/views/TasksPage.vue"
echo "CHECK_PROVIDER_TABLE_LAYOUT_VERSION=v1.2.192"
[ -f "$FILE" ] || { echo "SOURCE_FILE_PRESENT=no"; exit 1; }
echo "SOURCE_FILE_PRESENT=yes"
echo "PACKAGE_VERSION=$(grep -m1 '"version"' "$ROOT/package.json" 2>/dev/null | sed 's/[ ,"]//g')"
echo "COL_COUNT=$(grep -o '<col class=' "$FILE" | wc -l)"
echo "TH_COUNT=$(grep -o '<th class=' "$FILE" | wc -l)"
echo "HAS_PROVIDER_NAME_BADGE=$(grep -q 'max-w-\[170px\].*:title="p.name"' "$FILE" && echo yes || echo no)"
echo "HAS_SHORT_URL_INPUT=$(grep -q 'w-\[220px\]' "$FILE" && echo yes || echo no)"
echo "HAS_TABLE_FIXED=$(grep -q 'min-w-\[1320px\] table-fixed' "$FILE" && echo yes || echo no)"
