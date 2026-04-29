# HA export bridge — UI Mihomo / Ultra

Дата: **2026-04-29**
Релиз: **v1.2.174**
Agent: **0.6.34**

## Endpoint

```text
http://192.168.0.1:9099/cgi-bin/api.sh?cmd=ha_snapshot
```

## Bundle contract

Top-level shape remains:

```json
{
  "ok": true,
  "format_version": 1,
  "timestamp": "...",
  "contract": "zash.ha.snapshot.bundle.v1",
  "agent_version": "0.6.34",
  "cache_mode": "stale-while-refresh",
  "refresh_scheduled": true,
  "status": { "...": "..." },
  "traffic": { "...": "..." },
  "users": { "...": "..." },
  "qos": { "...": "..." }
}
```

## New behavior in v1.2.174

`ha_snapshot` is now timeout-safe:

- it does not synchronously rebuild every nested block before sending headers;
- it reads fresh cache first;
- stale cache is allowed for the bundled response;
- missing cache produces a structured nested stub;
- background refresh is scheduled when stale or missing data was used.

Example nested cache miss:

```json
{
  "ok": false,
  "format_version": 1,
  "timestamp": "...",
  "stale": true,
  "cache_miss": true,
  "component": "ha_traffic",
  "error": "cache-miss"
}
```

## HA integration rule

HA must treat top-level and nested status separately:

- `snapshot.ok` — endpoint returned a valid bundle.
- `snapshot.status.ok` — router/agent status block is valid.
- `snapshot.traffic.ok` — traffic block is valid.
- `snapshot.users.ok` — users block is valid.
- `snapshot.qos.ok` — QoS block is valid.

## Units and semantics

- `*_bps` means **bytes/sec**, not bits/sec.
- `counts.qos_enabled` is a **counter**, not a boolean.
- Router IP for this project: **192.168.0.1**.
