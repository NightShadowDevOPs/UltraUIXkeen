#!/opt/bin/sh
# Compact provider links check for v1.2.189. Output target: <= 15 lines.
set +e
API="${ZASH_AGENT_API:-http://192.168.0.1:9099/cgi-bin/api.sh}"
echo "CHECK_PROVIDER_LINKS_VERSION=v1.2.189"
json="$(curl -sS -m 15 "$API?cmd=mihomo_providers" 2>/dev/null || true)"
echo "$json" | grep -q '"providers"\|"name"' && echo "HTTP_JSON_OK=yes" || echo "HTTP_JSON_OK=no"
echo "$json" | grep -q '"sslSource":"subscription"' && echo "SSL_SOURCE_SUBSCRIPTION=yes" || echo "SSL_SOURCE_SUBSCRIPTION=unknown"
echo "$json" | grep -q '"panelSshUrl"' && echo "HAS_PANEL_SSH_FIELD=yes" || echo "HAS_PANEL_SSH_FIELD=no"
echo "$json" | grep -o '"name":"[^"]*"\|"url":"[^"]*"\|"panelUrl":"[^"]*"\|"panelSshUrl":"[^"]*"' \
| awk -F'"' '
function hp(u,x,a){x=u; sub(/^https?:\/\//,"",x); split(x,a,"/"); return a[1]}
function flush(){if(n=="")return; total++; if(u!="")subc++; if(p!="")panelc++; if(s!="")sshc++; if(total<=6)print n " sub=" hp(u) " panel=" (hp(p)?hp(p):"none") " ssh=" (hp(s)?hp(s):"none")}
$2=="name"{flush(); n=$4; u=""; p=""; s=""}
$2=="url"{u=$4}
$2=="panelUrl"{p=$4}
$2=="panelSshUrl"{s=$4}
END{flush(); print "TOTAL=" total " SUBSCRIPTION=" subc " PANEL_INTERNET=" panelc " PANEL_SSH=" sshc}
'
echo "WATCHDOG=$(cat /opt/zash-agent/var/watchdog.state 2>/dev/null | tr '\n' ';')"
