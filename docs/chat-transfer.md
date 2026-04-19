# UI Mihomo / Ultra — chat transfer

## Текущее состояние
- Текущая версия UI: **v1.2.140**
- Router-agent: **0.6.31**
- Последний подтверждённый пользователем релиз до этого шага: **v1.2.138**
- Репозиторий: `NightShadowDevOPs/UltraUIXkeen`
- Локальная папка: `Y:\Мой диск\Git\UltraUIXkeen`
- Путь на роутере: `/opt/UltraUIXkeen`

## Что вошло в v1.2.140

- поднят UI до `1.2.140`
- поднят `router-agent` до `0.6.31`
- исправлен `router-agent/install.sh`: embedded CGI внутри инсталлятора синхронизирован с `api.sh`, команда `ha_snapshot` теперь реально доезжает до роутера после установки
- single-resource HA package на `ha_snapshot` сохранён

## Что вошло в v1.2.138

- поднят UI до `1.2.138`
- поднят `router-agent` до `0.6.29`
- исправлен оставшийся рассинхрон версии в `ha_status`: `agent.serverVersion` больше не должен показывать старое cached-значение
- документация и transfer-файлы обновлены по факту live-проверки

## Live-наблюдение
- роутер отвечает по `http://192.168.0.1:9099/cgi-bin/api.sh?cmd=status`
- `ha_contract_meta` тоже уже отвечает корректно
- на этом стенде для проверки agent лучше использовать `192.168.0.1`, а не `127.0.0.1`

## Что важно проверить после обновления
1. `wget -qO- "http://192.168.0.1:9099/cgi-bin/api.sh?cmd=ha_contract_meta"` показывает `agent_version: 0.6.31` и `preferred_resource: ha_snapshot`.
2. `wget -qO- "http://192.168.0.1:9099/cgi-bin/api.sh?cmd=ha_snapshot"` отдаёт один валидный JSON c вложенными секциями `status`, `traffic`, `users`, `qos`.
3. В Home Assistant после замены `smartlife_router_rest.yaml` пропадают или заметно редеют эпизоды `Empty reply found when expecting JSON data`.

## Что важно помнить дальше
- если меняется `router-agent`, нужно отдельно дать команду обновления агента на роутере
- в релизах всегда нужны: архив релиза, commit message отдельно, команды для роутера отдельно
- в docs обязательно поддерживать файл переноса в новый чат и HA handoff-пакет в актуальном состоянии
