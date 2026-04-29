# Request ledger

## 2026-04-29 — v1.2.174

User reported:

```text
GET /cgi-bin/api.sh?cmd=ha_snapshot
HTTP/1.1 502 Bad Gateway
```

Decision:

- prepare router-agent patch;
- keep HA contract shape stable;
- avoid increasing `uhttpd` timeout as the primary fix;
- make `ha_snapshot` fast by using cache/stale-cache and background refresh.

Implemented:

- agent `0.6.34`;
- `ha_snapshot` stale-while-refresh mode;
- component-level cache miss stubs;
- background refresh lock;
- updated project documentation and transfer notes.

## 2026-04-29 — v1.2.173

User reported agent startup instability after previous changes.

Implemented:

- startup self-call removed from `start.sh`;
- cron SSL refresh moved to direct CGI shell execution;
- init stop cleanup hardened.
