# Model memory snapshot — UI Mihomo / Ultra

- Current release prepared: **v1.2.174**
- Current agent version: **0.6.34**
- Router IP: **192.168.0.1**
- Runtime agent: `/opt/zash-agent`
- HTTP endpoint: `http://192.168.0.1:9099/cgi-bin/api.sh`
- Important current issue fixed: `cmd=ha_snapshot` returned `502 Bad Gateway` because the bundled snapshot could exceed CGI timeout before emitting headers.
- Fix strategy: stale-while-refresh cache bundle, background refresh lock, component-level cache-miss stubs.
- Do not enable TUN for the current routing model unless requirements change.
- Do not touch live traffic, provider SSL checks, QoS or Mihomo core when making HA snapshot hotfixes.
- HA/SmartLife must use `ha_snapshot` as normalized source and check nested `status.ok`, `traffic.ok`, `users.ok`, `qos.ok` separately.
- `*_bps` means bytes/sec.
- `counts.qos_enabled` is a counter, not boolean.
