# UltraUIXkeen

Рабочий пакет UI Mihomo / Ultra для Netcraze + `zash-agent`.

## Текущий релиз

- UI release: **v1.2.174**
- router-agent: **v0.6.34**
- Дата: **2026-04-29**
- Тип релиза: **router-agent hotfix**
- Главная цель: убрать `502 Bad Gateway` на `cmd=ha_snapshot`, когда bundled snapshot пытается синхронно собрать тяжёлые блоки `status`, `traffic`, `users`, `qos` и упирается в CGI timeout `uhttpd`.

## Что изменено в v1.2.174

`ha_snapshot` переведён в режим **stale-while-refresh**:

- быстрый ответ отдаётся из свежего cache;
- если свежего cache нет, используется stale-cache;
- если cache ещё не создан, компонент возвращается как понятный stub `ok:false`, `stale:true`, `cache_miss:true`;
- тяжёлое обновление cache запускается в фоне под lock `/tmp/zash-ha-snapshot-refresh.lock`;
- прямые endpoint-ы `ha_status`, `ha_traffic`, `ha_users`, `ha_qos` не менялись по контракту;
- live traffic, provider SSL checks, Mihomo core, TUN, QoS и правила маршрутизации не трогались.

## Почему это нужно

Проверка показала:

```text
GET /cgi-bin/api.sh?cmd=ha_snapshot
HTTP/1.1 502 Bad Gateway
```

Причина: bundled snapshot формировался после последовательного вызова нескольких HA-export builders и мог не успеть вернуть HTTP headers до timeout `uhttpd`. Это классический случай “агент задумался, веб-сервер решил, что он умер”. Роутер не философский клуб, поэтому snapshot теперь отвечает быстро.

## Основной smoke test

```sh
/opt/bin/wget -S -O- -T 15 'http://192.168.0.1:9099/cgi-bin/api.sh?cmd=ha_snapshot'
```

Ожидаемо:

- HTTP `200 OK`;
- JSON содержит `ok:true`;
- JSON содержит `cache_mode:"stale-while-refresh"`;
- при первом cache miss допустимо `refresh_scheduled:true`;
- второй/следующий вызов должен получить больше реальных данных из cache.

## Документация

Обновлены:

- `README.md`
- `CHANGELOG.md`
- `docs/current-state.md`
- `docs/release-plan.md`
- `docs/model-memory-snapshot.md`
- `docs/project-memory.md`
- `docs/chat-transfer.md`
- `docs/ha-export-bridge.md`
- `docs/request-ledger.md`

## Важно

`ha_snapshot.ok` означает, что bundle собран и endpoint живой. Состояние блоков надо проверять отдельно:

- `status.ok`
- `traffic.ok`
- `users.ok`
- `qos.ok`

Это важно для Home Assistant / SmartLife, чтобы один временно stale-блок не ломал всю карточку.
