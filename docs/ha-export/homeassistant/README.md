# Home Assistant package bundle

Начиная с **v1.2.137** в проекте лежит не только контракт JSON, но и готовый набор YAML-файлов для быстрого подключения роутера в Home Assistant.

## Что внутри
- `configuration-snippet.example.yaml` — пример включения `packages`
- `smartlife_router_rest.yaml` — готовые REST sensors / binary sensors через единый `ha_snapshot` resource
- `smartlife_router_templates.yaml` — производные helper sensors
- `smartlife_router_dashboard.yaml` — пример Lovelace dashboard

## Быстрое подключение
1. Убедись, что router-agent на роутере обновлён минимум до **0.6.30**.
2. В Home Assistant включи `packages`, если они ещё не включены.
3. Скопируй `smartlife_router_rest.yaml` и `smartlife_router_templates.yaml` в `/config/packages/`.
4. При желании импортируй `smartlife_router_dashboard.yaml` как raw Lovelace config.
5. Перезапусти Home Assistant или перечитай YAML-конфигурацию.

## Важно
- в примерах используется live-адрес этого стенда: `http://192.168.0.1:9099/cgi-bin/api.sh`
- если IP роутера другой, просто замени его во всех `resource:`
- для первых тестов достаточно проверить `status`, `ha_contract_meta` и новый агрегированный `ha_snapshot` через браузер/wget
