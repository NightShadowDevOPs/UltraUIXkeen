# UI Mihomo / Ultra — transfer note for next chat

Дата: **2026-04-29**

## Текущий релиз

- UI release: **v1.2.174**
- router-agent: **0.6.34**
- Роутер: **192.168.0.1**
- Agent endpoint: `http://192.168.0.1:9099/cgi-bin/api.sh`
- Runtime path: `/opt/zash-agent`
- Project path on router: usually `/opt/UltraUIXkeen`

## Что было перед v1.2.174

В v1.2.173 был исправлен startup self-call: агент больше не должен зависать на старте из-за HTTP-запроса в самого себя (`cmd=rehydrate`). После этого `cmd=status` заработал, но `cmd=ha_snapshot` упал на smoke test:

```text
HTTP/1.1 502 Bad Gateway
```

## Что вошло в v1.2.174

`ha_snapshot` переведён на safe bundle сборку:

- не собирает `status`, `traffic`, `users`, `qos` синхронно перед отправкой headers;
- отдаёт свежий cache;
- если свежий cache истёк — отдаёт stale-cache;
- если cache ещё отсутствует — отдаёт stub компонента:
  - `ok:false`
  - `stale:true`
  - `cache_miss:true`
  - `component:"ha_status|ha_traffic|ha_users|ha_qos"`
- планирует фоновый refresh под lock `/tmp/zash-ha-snapshot-refresh.lock`;
- добавляет поля верхнего уровня:
  - `cache_mode:"stale-while-refresh"`
  - `refresh_scheduled:true|false`

## Что не трогать без явной задачи

- TUN
- Mihomo core
- Proxy provider SSL checks
- QoS/shaper
- live traffic path
- HA entity naming
- SmartLife/Home Assistant package YAML

## Что проверять после заливки

```sh
/opt/bin/wget -S -O- -T 15 'http://192.168.0.1:9099/cgi-bin/api.sh?cmd=status'
/opt/bin/wget -S -O- -T 15 'http://192.168.0.1:9099/cgi-bin/api.sh?cmd=ha_snapshot'
sleep 10
/opt/bin/wget -S -O- -T 15 'http://192.168.0.1:9099/cgi-bin/api.sh?cmd=ha_snapshot'
```

Ожидаемый результат:

- status: `200 OK`, `ok:true`;
- ha_snapshot: `200 OK`, `ok:true`;
- первый snapshot может быть cache-miss/stale по вложенным блокам;
- второй snapshot должен подтянуть больше данных;
- не должно быть `502`.

## Контракт для HA

Home Assistant должен проверять не только `snapshot.ok`, но и вложенные флаги:

- `snapshot.status.ok`
- `snapshot.traffic.ok`
- `snapshot.users.ok`
- `snapshot.qos.ok`

Один временно stale/cache-miss блок не означает, что агент полностью недоступен.
