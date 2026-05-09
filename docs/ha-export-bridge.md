# HA export bridge status — v1.2.180

The release keeps the existing Home Assistant endpoint contract:

- `ha_status`
- `ha_traffic`
- `ha_users`
- `ha_qos`
- `ha_snapshot`
- `ha_contract_meta`

`v1.2.177` strict JSON protection is preserved. Shell helper stdout must not pollute HTTP headers or JSON bodies.

`v1.2.178` lightweight apply fix is preserved. The installer should not hang on a full compressed backup of `/opt/zash-agent`.
