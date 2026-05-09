# UltraUIXkeen

Рабочий пакет UI Mihomo / Ultra для Netcraze + `zash-agent`.

## Текущий релиз

- UI release: **v1.2.176**
- router-agent runtime/package: **v0.6.35**
- Дата: **2026-04-29**
- Тип релиза: **release hardening / deploy safety / audit cleanup**
- Router IP: **192.168.0.1**
- Папка проекта на роутере: **`/opt/etc/mihomo`**
- Runtime-папка агента: **`/opt/zash-agent`**

## Что изменено в v1.2.176

Это аккуратный патч после строгого аудита документации и перед деплоем `v1.2.175`-линии. Логика роутинга и контракт HA не меняются — здесь не цирк с исчезающими провайдерами, а ремень безопасности перед установкой.

Добавлено/исправлено:

- добавлен `scripts/check-zash-agent-v1.2.176.sh` с короткими машинно-читаемыми маркерами вместо простыни JSON;
- добавлен `scripts/apply-zash-agent-v1.2.176.sh`, который ставит packaged agent в `/opt/zash-agent` и затем запускает короткий smoke-check;
- добавлен `scripts/rollback-zash-agent-v1.2.176.sh` для восстановления последнего backup `/opt/zash-agent.backup-v1.2.176-*` или `/opt/zash-agent.backup-v1.2.175-*`;
- документация явно фиксирует статус старой проблемы `ha_snapshot -> 502/uhttpd timeout`: **fixed in v1.2.174**, не open issue;
- формализован release-docs ZIP для project-memory-sync/audit: `release-docs-ui-mihomo-ultra-v1.2.176.zip`.

## Что не менялось

- Mihomo core и конфиги прокси.
- TUN mode.
- Провайдеры и provider SSL checks.
- QoS/shaper logic.
- Контракт `ha_snapshot`, `ha_status`, `ha_traffic`, `ha_users`, `ha_qos`.
- Путь живого трафика.
- Runtime-код агента остаётся **v0.6.35**.

## Проверка после применения

Из папки проекта на роутере, после загрузки файлов релиза:

```sh
/opt/bin/sh scripts/check-zash-agent-v1.2.176.sh
```

Критичные признаки успеха:

```text
STATUS_HTTP=200
STATUS_OK=true
HA_SNAPSHOT_HTTP=200
HA_SNAPSHOT_OK=true
MIHOMO_PROVIDERS_HTTP=200
```

Откат:

```sh
/opt/bin/sh scripts/rollback-zash-agent-v1.2.176.sh
```


## v1.2.177 — router-agent HA strict JSON hotfix

Закрыт риск невалидных HTTP responses для Home Assistant: строки `shape`, `wireguard-route` и другой stdout от shell helpers больше не могут попасть перед `Content-Type: application/json`. Добавлены безопасная сортировка без `sort -o` и strict wrapper для HA endpoints. Агент: `0.6.36`.
