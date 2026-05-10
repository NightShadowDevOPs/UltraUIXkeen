# UI Mihomo Ultra v1.2.187 — HA Snapshot CPU/Load Fresh Metrics Hotfix

## Что исправлено

`ha_snapshot.status.system.cpu_pct` больше не должен зависать на старом/fallback значении `50`, когда `cmd=status` уже отдаёт живой CPU. Перед сборкой `ha_snapshot` статусный компонент получает overlay свежих системных метрик из свежего `cmd=status` cache или, если cache недоступен, из локального `/proc/stat`.

Дополнительно рядом добавлен `ha_snapshot.status.system.load` с `load1`, `load5`, `load15`, потому что в обычном `cmd=status` эти значения уже есть, а в snapshot-ветке они раньше не попадали.

## Область изменения

Изменяется только runtime-файл router-agent API:

- `/opt/zash-agent/www/cgi-bin/api.sh`

Не трогаются: Home Assistant, HA DB, штатная Home Assistant Energy, SmartLife boiler, Mihomo core, TUN, QoS/routing, provider SSL, `users-db`, `shapers.db`, reboot роутера.

## Установка на роутере

Основной raw/manual installer:

- `router-agent/install-ha-snapshot-cpu-hotfix.sh`

Проверка:

- `scripts/check-zash-agent-snapshot-cpu-v1.2.187.sh`

Ожидаемый результат: 3–5 последовательных samples показывают, что `status_cpu` и `snapshot_cpu` не расходятся постоянно и `snapshot_cpu` больше не залипает на `50`.
