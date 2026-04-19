# UltraUIXkeen — Current state

## Release target
- UI package target for this release: **v1.2.142**
- Router-agent line confirmed on router: **0.6.31**
- Home Assistant bridge contract: **frozen / do not change payload shape**
- Current stable HA pull model: **single `ha_snapshot` poll + attribute split inside HA**
- Current HA UX addition: **freshness / stale helper sensors are computed inside HA only**

## What is confirmed right now
- Router and Home Assistant are already delivering `ha_snapshot` correctly after router-agent `0.6.31`.
- The user sees router data in HA, but some cards periodically show **«Нет данных»**.
- The agreed safe next step was: do **not** expand the router-agent JSON; instead, show data age / stale-state inside Home Assistant.
- Heavy extra polling should be avoided so the router is not hammered for the sake of prettier cards.

## Release intent for v1.2.142
- Не менять структуру данных, которые Ultra / router-agent передают в Home Assistant.
- Добавить в Home Assistant слой индикации свежести `snapshot` / `traffic` / `users` / `qos` без дополнительной нагрузки на роутер.
- Обновить handoff-документы, release-plan и карту сущностей под новые helper-сенсоры.

## Previous release intent for v1.2.141
- Не менять структуру данных, которые Ultra / router-agent передают в Home Assistant.
- Выгрузить накопленную проектную память и рабочие договорённости в файлы внутри проекта.
- Обновить все handoff-документы, чтобы следующий чат можно было начать без потери контекста.

## Important guardrails
- Не ломать автоматическую проверку SSL-сертификатов прокси-провайдеров.
- Не возвращаться к `git pull` как к основному сценарию обновления UI на роутере.
- В docs и handoff-файлах каждый релиз должен фиксировать и сам шаг, и запрос пользователя, а не только итог.
