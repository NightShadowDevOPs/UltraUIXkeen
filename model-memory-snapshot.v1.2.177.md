# model memory snapshot v1.2.177

Router project paths: project `/opt/etc/mihomo`, installed agent `/opt/zash-agent`, init `/opt/etc/init.d/S99zash-agent`, base URL `http://192.168.0.1:9099/cgi-bin/api.sh`.

v1.2.177 fixes HA invalid-header failures by removing BusyBox `sort -o` stdout leak risk and wrapping HA endpoints with strict JSON response guard. Do not touch TUN, live routing, Mihomo core, provider SSL checks, QoS/shaper semantics, or HA contract shape unless explicitly requested.
