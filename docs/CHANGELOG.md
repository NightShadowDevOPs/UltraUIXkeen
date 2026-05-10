# CHANGELOG — v1.2.187

## Added

- `router-agent/install-ha-snapshot-cpu-hotfix.sh`
- `scripts/check-zash-agent-snapshot-cpu-v1.2.187.sh`
- `scripts/apply-zash-agent-snapshot-cpu-v1.2.187.sh`
- `scripts/backup-zash-agent-snapshot-cpu-v1.2.187.sh`
- `scripts/rollback-zash-agent-snapshot-cpu-v1.2.187.sh`

## Changed

- `router-agent/install.sh`: добавлена логика live overlay для `ha_snapshot.status.system.cpu_pct` и `status.system.load`.
- `package.json`: версия `1.2.187`.

## Not changed

- Mihomo core/TUN/QoS/routing/provider SSL.
- Home Assistant/HA DB/native Energy/SmartLife boiler.
