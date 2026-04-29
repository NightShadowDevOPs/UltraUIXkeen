# Current state — UI Mihomo / Ultra

- Date: **2026-04-29**
- Release: **v1.2.174**
- Agent: **0.6.34**
- Router IP: **192.168.0.1**
- Agent endpoint: `http://192.168.0.1:9099/cgi-bin/api.sh`
- Project path on router: usually `/opt/UltraUIXkeen`
- Runtime agent path: `/opt/zash-agent`

## Last confirmed problem

After v1.2.173 restored the agent startup path, `cmd=status` worked, but HA bundled snapshot smoke test failed:

```text
GET http://192.168.0.1:9099/cgi-bin/api.sh?cmd=ha_snapshot
HTTP/1.1 502 Bad Gateway
```

This means `uhttpd` accepted the connection but the CGI did not return valid headers in time, or failed before headers. In this case the most likely cause was synchronous bundled snapshot assembly: `ha_snapshot` called several heavier HA-export builders before writing its own response.

## v1.2.174 runtime behavior

`cmd=ha_snapshot` now returns quickly:

- takes fresh component data from cache when available;
- falls back to stale component data when fresh cache expired;
- returns component-level cache-miss stubs when no cache exists yet;
- schedules background refresh instead of blocking the HTTP response;
- exposes `cache_mode:"stale-while-refresh"`;
- exposes `refresh_scheduled:true|false`.

## What did not change

- Mihomo core configuration.
- TUN mode.
- Proxy provider SSL checks as a feature.
- Provider list parsing.
- QoS/shaper logic.
- Existing component endpoints: `ha_status`, `ha_traffic`, `ha_users`, `ha_qos`.
- HA contract shape: `status`, `traffic`, `users`, `qos` remain separate nested blocks.

## Expected verification after deploy

1. `cmd=status` returns `200 OK`.
2. `cmd=ha_snapshot` returns `200 OK` instead of `502`.
3. First `ha_snapshot` may contain cache-miss stubs and `refresh_scheduled:true`.
4. Repeating `ha_snapshot` after 5–20 seconds should show more real component data from cache.
5. HA cards should check nested block `ok` flags separately and not treat one stale block as total failure.
