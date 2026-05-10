# Release v1.2.187 — HA Snapshot CPU/Load Fresh Metrics Hotfix

## Причина

Home Assistant Router Contract был восстановлен и зелёный, но `sensor.smartlife_router_cpu` стабильно показывал `50%`. Диагностика показала, что проблема не в HA и не в Lovelace: `cmd=status` отдавал живой CPU, а `cmd=ha_snapshot` возвращал stale/fallback `status.system.cpu_pct=50`.

## Изменения

- Добавлен helper `ha_snapshot_status_live_system_overlay()` в router-agent API.
- `ha_snapshot_json()` перед финальной сборкой snapshot обновляет `status.system.cpu_pct` из свежего `cmd=status` cache или локального CPU sample.
- Добавлено поле `status.system.load` с `load1/load5/load15`.
- Обновлён `ha_status` cache после overlay, чтобы stale значение не возвращалось повторно.
- Добавлены installer/check/backup/rollback scripts для v1.2.187.

## Безопасность

- Без перезапуска роутера.
- Без изменений Mihomo core, TUN, QoS/routing и provider SSL.
- Без изменений Home Assistant, HA DB, штатной Home Assistant Energy и SmartLife boiler.
- Runtime marker: `v1.2.187 ha_snapshot live CPU/load overlay`.

## Проверка

Команда проверки должна выводить компактный отчёт: marker, 5 samples `status_cpu`/`snapshot_cpu`/`load`, watchdog state. Успех: `snapshot_cpu` не зафиксирован постоянно на `50` и близок к `status_cpu`.
