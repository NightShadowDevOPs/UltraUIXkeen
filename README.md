# UI Mihomo Ultra v1.2.179

Рабочий пакет UI Mihomo / Ultra для Netcraze + `zash-agent`.

## Текущий релиз

- UI release: **v1.2.179**
- router-agent runtime/package marker: **0.6.37**
- дата: **2026-05-09**
- тип релиза: **release / packaging cleanup / documentation normalization**
- router IP: **192.168.0.1**
- папка проекта на роутере: **`/opt/etc/mihomo`**
- runtime-папка агента: **`/opt/zash-agent`**

## Что сделано

`v1.2.179` собирает в один нормальный пакет состояние `v1.2.177 + v1.2.178` и приводит релиз к universal release rules `v9.10.2`.

Изменения:

- влит agent-only hotfix `v1.2.178` с lightweight backup вместо полного tar backup `/opt/zash-agent`;
- `router-agent/install.sh` и генерируемый `api.sh` сохраняют strict JSON HA endpoints;
- исправлена устаревшая документация про `agent 0.6.35/0.6.36`;
- добавлены текущие apply/check/rollback/backup scripts для `v1.2.179`;
- удалены из release-пакета старые transfer/scratch/root artifacts, которые не нужны для установки;
- literal NUL bytes в `install.sh` заменены текстовым `\000` escaping;
- созданы отдельные release/docs/transfer пакеты по v9.10.2.

## Что не менялось

- Mihomo core.
- TUN mode.
- QoS/shaper semantics.
- Routing rules.
- Provider SSL checks.
- HA contract endpoint names and JSON intent: `ha_status`, `ha_traffic`, `ha_users`, `ha_qos`, `ha_snapshot`.

## Применение на роутере

После загрузки и распаковки release-папки на роутере:

```sh
clear
cd /opt/etc/mihomo
/opt/bin/sh scripts/apply-zash-agent-v1.2.179.sh
```

Проверка без применения:

```sh
clear
cd /opt/etc/mihomo
/opt/bin/sh scripts/check-zash-agent-v1.2.179.sh
```

Rollback после apply:

```sh
clear
cd /opt/etc/mihomo
/opt/bin/sh scripts/rollback-zash-agent-v1.2.179.sh
```

## Ожидаемые признаки успеха

- `STATUS_VERSION=0.6.37`;
- `STATUS_HTTP=200`;
- `HA_STATUS_HTTP=200`;
- `HA_TRAFFIC_HTTP=200`;
- `HA_USERS_HTTP=200`;
- `HA_QOS_HTTP=200`;
- `HA_SNAPSHOT_HTTP=200`;
- `HAS_STATUS=true HAS_TRAFFIC=true HAS_USERS=true HAS_QOS=true` на `HA_SNAPSHOT`.
