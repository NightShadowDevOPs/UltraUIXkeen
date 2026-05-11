## v1.2.194
Provider hosting payment dates now show users-db save status and can be pushed immediately with Save now.

# UI Mihomo Ultra / router-agent v1.2.192

UI-only release for the provider/server table in the Tasks/Providers area.

## Что изменено

- Выровнены столбцы таблицы провайдеров: `Провайдер`, `Ссылки доступа`, `Оплата хостинга`, `Порог SSL, дни`, `SSL истекает`.
- Исправлен структурный перекос таблицы: теперь `colgroup` содержит 5 колонок под 5 реальных столбцов.
- Имя провайдера вынесено в отдельную видимую плашку рядом с иконкой/страной.
- Поля URL для `Панель · Internet` и `Панель · SSH` сделаны короче и одинаковыми по ширине.
- Кнопки перехода по ссылкам сохранены: `Подписка`, `Панель · Internet`, `Панель · SSH`.

## Что не менялось

- router-agent runtime не менялся.
- Проверка SSL по подписке не менялась.
- Mihomo core, TUN, QoS, routing, provider cache, users-db, shapers.db не менялись.
- Home Assistant, HA DB, SmartLife boiler и штатная HA Energy не трогались.

## Проверка

Компактный source-check: `scripts/check-provider-table-layout-v1.2.192.sh`.


## v1.2.193 — Provider Hosting Recurring Payments UI

- Added provider hosting payment period metadata: once / 1 / 3 / 6 / 12 months.
- Added `Оплатил` action to move next hosting due date by the selected period.
- Added colored `Осталось ... дней` hosting payment badge.
- Added users-db sync field `providerHostingPeriodMonths`.
- No router runtime, Mihomo, TUN, QoS/routing, Home Assistant, HA DB or SmartLife changes.
