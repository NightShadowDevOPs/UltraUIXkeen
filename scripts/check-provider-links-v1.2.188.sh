#!/bin/sh
# Compact provider links check for v1.2.188. Output: <=15 lines.
set +e
API="${API:-http://192.168.0.1:9099/cgi-bin/api.sh}"
JSON="$(curl -sS -m 15 "$API?cmd=mihomo_providers" 2>/dev/null || true)"
echo "CHECK_PROVIDER_LINKS_VERSION=v1.2.188"
echo "HTTP_JSON_OK=$(printf '%s' "$JSON" | grep -q '"ok":true' && echo yes || echo no)"
echo "HAS_SSL_SOURCE=$(printf '%s' "$JSON" | grep -q '"sslCheckSource":"subscription"' && echo yes || echo no)"
echo "HAS_PANEL_SSH_FIELD=$(printf '%s' "$JSON" | grep -q '"panelSshUrl"' && echo yes || echo no)"
printf '%s' "$JSON" | grep -o '"name":"[^"]*"\|"url":"[^"]*"\|"panelUrl":"[^"]*"\|"panelSshUrl":"[^"]*"' | awk -F'"' '
function hp(u,x,a){x=u; sub(/^https?:\/\//,"",x); split(x,a,"/"); return a[1]}
function flush(){ if(n=="") return; total++; if(u!="") subc++; if(p!="") panc++; if(s!="") sshc++; if(total<=5) print n " sub=" hp(u) " panel=" (p?hp(p):"none") " ssh=" (s?hp(s):"none") }
$2=="name"{flush(); n=$4; u=""; p=""; s=""}
$2=="url"{u=$4}
$2=="panelUrl"{p=$4}
$2=="panelSshUrl"{s=$4}
END{flush(); print "TOTAL=" total " SUBSCRIPTION=" subc " PANEL_INTERNET=" panc " PANEL_SSH=" sshc}
'
echo "WATCHDOG=$(cat /opt/zash-agent/var/watchdog.state 2>/dev/null | tr '\n' ';')"
