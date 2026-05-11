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
