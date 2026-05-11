# New chat transfer — UI Mihomo Ultra v1.2.189

Continue UI Mihomo Ultra / router-agent from release v1.2.189.

Important context:

- User wants to close public 3x-ui panels from Internet later. Panels should be accessed from PC via SSH tunnels to `127.0.0.1:port`, not by adding SSH tunnel load on the router.
- SSL checks must continue to use subscription URLs, not panel URLs.
- Provider table now has three separate link types: subscription, panel Internet, panel SSH.
- Manual SSH panel URLs are stored as `providerPanelSshUrls` in users-db sync.
- Existing `providerPanelUrls` remain Internet panel URLs.
- Do not break current provider SSL checks, provider list, router-agent HA endpoints, watchdog, maintenance, or users-db.

Current validated router-agent baseline before this release:

- Agent endpoint: `http://192.168.0.1:9099/cgi-bin/api.sh`.
- Runtime marker: `0.6.37`.
- `cmd=status`, `ha_status`, `ha_traffic`, `ha_users`, `ha_qos`, `ha_snapshot` return HTTP 200 JSON OK.
- Watchdog state OK, maintenance cron installed, zash-agent size reduced to about 153 MB.
- v1.2.187 fixed `ha_snapshot.status.system.cpu_pct` from stuck 50 to live status CPU.

Rules:

- Router command output must stay compact: 10–15 lines max.
- For router commands use `cd /opt/etc/mihomo` and `set +e`.
- Do not touch Mihomo core, TUN, QoS/routing, provider SSL logic, users-db limits, shapers.db, or reboot router unless explicitly required.
- Do not touch Home Assistant, HA DB, native HA Energy, SmartLife boiler for router-agent work.
- UI updater deploys frontend bundle only; router-agent runtime scripts/hotfixes require raw installer path.
