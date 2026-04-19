# UI Mihomo / Ultra — transfer note v1.2.136

19.04.2026 UI Mihomo / Ultra — сообщение для нового чата

Проект: UI Mihomo / Ultra
Репозиторий: NightShadowDevOPs/UltraUIXkeen
Локальная папка проекта: Y:\Мой диск\Git\UltraUIXkeen
Путь на роутере/сервере: /opt/UltraUIXkeen
Стек: Vue 3 + TypeScript + router-agent (shell/cgi на роутере)

Текущие версии:
- UI: v1.2.136
- router-agent: 0.6.27

Что вошло в v1.2.136:
- поднят UI до 1.2.136
- поднят router-agent до 0.6.27
- добавлены команды HA export-контура: `ha_contract_meta`, `ha_status`, `ha_traffic`, `ha_users`, `ha_qos`
- добавлен короткий on-router cache для HA snapshot payloads: `ha_status=30s`, `ha_traffic=15s`, `ha_users=60s`, `ha_qos=60s`
- cache cleanup status-контура теперь чистит и HA cache
- обновлены docs, changelog, release-plan, текущая записка переноса и HA handoff/json examples

Что важно по текущему состоянию:
- HA export остаётся REST-first; MQTT/discovery пока не входят в обязательный runtime scope
- Home Assistant должен читать готовые JSON snapshot-ответы, а не UI и не тяжёлые shell-потоки напрямую
- namespace для HA: `sensor.smartlife_router_*`, `binary_sensor.smartlife_router_*`
- текущий contract marker: `zash.ha.snapshot.v1`
- тяжёлый Mihomo config workspace по-прежнему не возвращаем в hot path
- proxy-provider SSL checks трогать нельзя

Какие команды сейчас важны:
- `cmd=ha_contract_meta`
- `cmd=ha_status`
- `cmd=ha_traffic`
- `cmd=ha_users`
- `cmd=ha_qos`

Что важно не потерять:
- если меняется `router-agent`, синхронизировать версии в `api.sh`, `router-agent/install.sh` и handoff docs
- в каждый кодовый архив класть и обновлять `docs/chat-transfer.md`
- обновление UI на роутере делается через сам интерфейс UI / release-архив, а не через `git pull` на роутере
- HA-пакет должен содержать не только docs, но и sample/example JSON под актуальную схему

Что смотреть дальше:
- прогнать новые `ha_*` команды на живом роутере XKeen и проверить реальную нагрузку/корректность counters
- собрать HA-side шаблон REST sensors + binary_sensors + dashboard cards поверх текущего контракта
- только потом решать, нужен ли MQTT/discovery как второй этап
