Продолжаем UI Mihomo Ultra / router-agent после v1.2.187.

v1.2.187 — router-agent hotfix для залипшего CPU в Home Assistant Router Contract: `cmd=status` отдавал живой CPU, а `cmd=ha_snapshot` мог возвращать stale/fallback `status.system.cpu_pct=50`. Подготовлен installer `router-agent/install-ha-snapshot-cpu-hotfix.sh`, marker `v1.2.187 ha_snapshot live CPU/load overlay`, check script `scripts/check-zash-agent-snapshot-cpu-v1.2.187.sh`.

Не трогать Home Assistant, HA DB, native Energy, SmartLife boiler, Mihomo core, TUN, QoS/routing, provider SSL, users-db, shapers.db. Вывод диагностик держать в 10–15 строк.

## v1.2.190

UI-only provider links layout polish. Provider names are badges, columns are aligned, URL inputs are shorter. Runtime/router-agent logic unchanged.
