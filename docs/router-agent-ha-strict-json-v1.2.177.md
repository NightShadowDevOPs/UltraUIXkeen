# v1.2.177 — router-agent HA strict JSON hotfix

Дата: 2026-04-29

## Что исправлено

- Исправлен риск утечки TSV/stdout строк до HTTP-заголовков в HA endpoints.
- Причина: BusyBox `sort` на роутере может не поддерживать GNU-style `sort -o file file`; в этом случае строки вроде `shape` и `wireguard-route` попадали в stdout CGI до `Content-Type`.
- Добавлен strict wrapper для HA endpoints: `ha_status`, `ha_traffic`, `ha_users`, `ha_qos`, `ha_snapshot`, `ha_contract_meta`.
- Если вспомогательная функция всё же пишет до заголовков, мусор уходит в `/opt/zash-agent/var/ha-strict.log`, а Home Assistant получает валидный JSON response.
- Агент поднят до `0.6.36`.

## Не менялось

- Mihomo core, TUN, live traffic routing, QoS/shaper semantics, provider SSL checks и HA contract shape не менялись.
