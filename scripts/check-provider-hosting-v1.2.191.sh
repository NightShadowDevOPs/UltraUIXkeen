#!/bin/sh
set +e
cd /opt/etc/mihomo 2>/dev/null || cd .
echo "CHECK_PROVIDER_HOSTING_VERSION=v1.2.191"
VER="$(grep '"version"' package.json 2>/dev/null | head -n 1 | sed 's/.*"version"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')"
echo "PACKAGE_VERSION=${VER:-unknown}"
echo "HAS_HOSTING_DUE_UI=$(grep -Rsl 'hostingPaymentDue' src 2>/dev/null | wc -l)"
echo "HAS_HOSTING_DUE_STORE=$(grep -Rsl 'providerHostingDueDates\|proxyProviderHostingDueDateMap' src 2>/dev/null | wc -l)"
echo "HAS_PANEL_SSH=$(grep -Rsl 'proxyProviderPanelSshUrlMap' src 2>/dev/null | wc -l)"
echo "RUNTIME_AGENT_TOUCH=no"
echo "DECISION=OK_IF_VERSION_1.2.191_AND_UI_STORE_NONZERO"
