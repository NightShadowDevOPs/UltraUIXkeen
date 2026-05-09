# Current State — UI Mihomo Ultra / zash-agent v1.2.180

- UI version: `1.2.180`.
- zash-agent runtime target: `0.6.37`.
- Router endpoint: `http://192.168.0.1:9099/cgi-bin/api.sh`.
- Agent listens on router LAN IP, not on `127.0.0.1`.
- HA source of truth: `cmd=ha_snapshot`.
- This release adds watchdog/restart helper scripts for the agent only.
