# HA export bridge — UI Mihomo / Ultra

Дата: **2026-04-29**
Текущая версия UI: **v1.2.173**
Текущая версия router-agent: **0.6.33**

## Изменения v1.2.173
- Контракт Home Assistant не менялся.
- Runtime shape `ha_snapshot`, `status`, `traffic`, `users`, `qos` остаётся совместимым с предыдущими v1.2.169–v1.2.172.
- Изменение касается только устойчивости router-agent: startup `rehydrate` и cron `ssl_cache_refresh` теперь запускаются напрямую через CGI, без HTTP self-call в собственный `uhttpd`.

## Что проверять в соседнем HA/SmartLife проекте
- `snapshot.ok` отдельно от вложенных `status.ok`, `traffic.ok`, `users.ok`, `qos.ok`.
- `*_bps` в контракте — это bytes/sec, не bits/sec.
- `counts.qos_enabled` — счётчик, не boolean.
- Для HA источником должен быть нормализованный `ha_snapshot`, а не случайный UI-only response.

## Минимальный endpoint
`http://192.168.0.1:9099/cgi-bin/api.sh?cmd=ha_snapshot`

## Ожидаемый эффект hotfix
HA export не должен измениться по данным. Должна уменьшиться вероятность, что agent HTTP endpoint зависает после старта/cron и HA получает timeout вместо JSON.
