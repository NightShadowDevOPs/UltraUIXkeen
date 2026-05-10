# Project spec

Project: UI Mihomo Ultra / zash-agent

Router runtime:

- Router IP: `192.168.0.1`.
- zash-agent endpoint: `http://192.168.0.1:9099/cgi-bin/api.sh`.
- Agent init service: `/opt/etc/init.d/S99zash-agent`.
- Agent process: `/opt/sbin/uhttpd` serving `/opt/zash-agent/www`.

Release v1.2.182 changes restart helper only.
