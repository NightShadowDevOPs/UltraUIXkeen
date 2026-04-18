# Аудит навигации — v1.2.123

## Что уже разнесено по рабочим зонам
- `Router → Обзор` — короткая живая сводка по состоянию роутера
- `Router → Резервные копии` — отдельный maintenance/workspace для backup create/list/restore/delete/check/schedule
- `Traffic` — отдельная рабочая зона, внутри которой уже разделены режимы `Devices` и `Users`
- `Router → Сеть` собирается корректно после hotfix v1.2.123

## Что сделано в v1.2.123
- устранён второй build-break: удалён импорт несуществующего `@/composables/useUISettings`
- `RouterPage.vue` теперь использует `showIPAndConnectionInfo` из `@/store/settings`
- hotfix с `ConnectionInfoCard.vue`, добавленный в v1.2.122, сохранён

## Что ещё остаётся сделать
1. Полировать сам backup workspace: явные построчные действия, меньше пустоты, понятнее статус архива
2. Довести `Router → Сеть` до самостоятельного полезного экрана
3. Продолжать аудит верхнего меню и не сваливать operational и maintenance-сценарии в один маршрут
