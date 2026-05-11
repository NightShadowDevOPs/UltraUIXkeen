# Chat transfer — v1.2.191

Continue UI Mihomo Ultra / router-agent from this state:

- Router IP: `192.168.0.1`.
- Agent endpoint: `http://192.168.0.1:9099/cgi-bin/api.sh`.
- Runtime agent version: `0.6.37`.
- Stable releases already applied: watchdog/maintenance/restart/strict/cache-first and snapshot CPU fixes up to v1.2.187.
- Provider links work from v1.2.188+: subscription URL, public panel URL, optional SSH panel URL.
- v1.2.190 improved provider name display and aligned provider URL columns.
- v1.2.191 adds manual hosting payment due-date tracking per provider; dates are saved through users-db sync.

Next likely task: after panels are closed to Internet, verify browser access through PC-side SSH tunnels and update each provider `panel SSH` URL to `https://127.0.0.1:<local_port>/...`.
