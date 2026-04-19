# UI Mihomo / Ultra — chat transfer

## Текущее состояние
- Текущая версия UI: **v1.2.138**
- Router-agent: **0.6.29**
- Репозиторий: `NightShadowDevOPs/UltraUIXkeen`
- Локальная папка: `Y:\Мой диск\Git\UltraUIXkeen`
- Путь на роутере: `/opt/UltraUIXkeen`

## Что вошло в v1.2.138

- поднят UI до `1.2.138`
- поднят `router-agent` до `0.6.29`
- исправлен оставшийся рассинхрон версии в `ha_status`: `agent.serverVersion` больше не должен показывать старое cached-значение
- документация и transfer-файлы обновлены по факту live-проверки

## Что вошло в v1.2.137
- поднят UI до `1.2.137`
- поднят `router-agent` до `0.6.28`
- добавлен готовый комплект файлов для Home Assistant в `docs/ha-export/homeassistant/`
- добавлены:
  - `configuration-snippet.example.yaml`
  - `smartlife_router_rest.yaml`
  - `smartlife_router_templates.yaml`
  - `smartlife_router_dashboard.yaml`
  - `README.md` с шагами подключения
- исправлена синхронизация `serverVersion` после обновления агента
- обновлены handoff/docs/release-plan/changelog

## Live-наблюдение
- роутер отвечает по `http://192.168.0.1:9099/cgi-bin/api.sh?cmd=status`
- `ha_contract_meta` тоже уже отвечает корректно
- на этом стенде для проверки agent лучше использовать `192.168.0.1`, а не `127.0.0.1`

## Что важно помнить дальше
- если меняется `router-agent`, нужно отдельно дать команду обновления агента на роутере
- в релизах всегда нужны: архив релиза, commit message отдельно, команды для роутера отдельно
- в docs обязательно поддерживать файл переноса в новый чат и HA handoff-пакет в актуальном состоянии
