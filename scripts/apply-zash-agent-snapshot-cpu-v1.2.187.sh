#!/bin/sh
set +e
SRC="${SRC:-router-agent/install-ha-snapshot-cpu-hotfix.sh}"
if [ ! -f "$SRC" ]; then
  echo "APPLY_SNAPSHOT_CPU_STATUS=FAIL"
  echo "REASON=SOURCE_NOT_FOUND"
  echo "SRC=$SRC"
  exit 1
fi
/opt/bin/sh "$SRC" 2>/dev/null || /bin/sh "$SRC"
RC=$?
echo "APPLY_RC=$RC"
exit "$RC"
