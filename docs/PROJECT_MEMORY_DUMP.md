# PROJECT_MEMORY_DUMP v1.2.192

Router/UI context:

- Router IP: `192.168.0.1`.
- zash-agent endpoint: `/cgi-bin/api.sh` on port `9099`.
- Agent runtime marker remains `0.6.37` for recent hotfixes.
- Provider list currently has subscription URL and Internet panel URL. SSH-local panel URL is a manually entered field.
- SSL expiry data should be based on subscription URL/cert, not panel public URL.
- Hosting payment due dates are manually maintained per provider.

Recent accepted fixes:

- Watchdog/maintenance installed and stable.
- HA cache-first direct endpoints fixed.
- HA snapshot CPU/load fixed.
- Provider links and hosting date UI implemented.
- Current release only aligns visual table layout.
