# Project memory — UI Mihomo / Ultra

## Current baseline

- Latest prepared release: **v1.2.174**
- Agent: **0.6.34**
- Router: Netcraze / XKeen class device
- Router IP: **192.168.0.1**
- Agent bind: `192.168.0.1:9099`

## Recent chain

- `v1.2.169`: full router-to-HA contract stabilized.
- `v1.2.170`: HA export bridge docs and transfer package.
- `v1.2.171`: traffic page readability and grouping improvements.
- `v1.2.172`: calmer traffic service state and empty states.
- `v1.2.173`: startup self-call hotfix for `zash-agent`.
- `v1.2.174`: `ha_snapshot` anti-timeout hotfix after smoke test returned `502 Bad Gateway`.

## Key rules for future work

- Keep router IP as `192.168.0.1`.
- Prefer direct CGI shell calls for local maintenance jobs over self-HTTP into the same `uhttpd`.
- Avoid synchronous heavy work in bundle endpoints before HTTP headers.
- Keep HA contract stable.
- Do not conflate bytes/sec with bits/sec.
- Do not represent `counts.qos_enabled` as boolean.
