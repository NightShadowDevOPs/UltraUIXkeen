# Session summary — v1.2.191

Current confirmed baseline before this release:
- router-agent runtime version: 0.6.37.
- Router endpoint: `http://192.168.0.1:9099/cgi-bin/api.sh`.
- Watchdog state was OK after v1.2.184–v1.2.186 fixes.
- v1.2.187 fixed `ha_snapshot.status.system.cpu_pct` mapping from live `status.cpuPct` and added load values.
- v1.2.188 moved SSL source semantics toward subscription URL and added panel SSH URL fields.
- v1.2.190 improved provider name visibility and provider URL table layout.

This release adds manual hosting payment date tracking for providers. Dates are not auto-discovered from hosters; they are entered manually.
