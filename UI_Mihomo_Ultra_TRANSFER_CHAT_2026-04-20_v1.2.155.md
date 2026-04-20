\
# UI Mihomo / Ultra — transfer note for next chat

Дата: **2026-04-20**
Текущая версия UI: **v1.2.155**
Текущая версия router-agent: **0.6.32**
Репозиторий: `NightShadowDevOPs/UltraUIXkeen`
Локальная папка: `Y:\Мой диск\Git\UltraUIXkeen`
Путь на роутере: `/opt/UltraUIXkeen`

## Что вошло в v1.2.155
- UI поднят до `1.2.155`
- router-agent оставлен на `0.6.32`, backend telemetry/runtime path не менялся
- основной live polling в Overview → Traffic теперь не всегда крутится на полном темпе: если карточка трафика ушла вне viewport, частота live-refresh снижается с 4 секунд до 8 секунд
- когда карточка снова попадает в viewport, UI делает немедленный live-refresh и возвращается к обычному 4-секундному ритму
- вторичный host-details polling из `v1.2.154` сохранён: off-screen host details / Host QoS / remote targets по-прежнему не долбят background-запросы впустую

## Что важно помнить дальше
- нельзя ломать автоматическую проверку SSL-сертификатов провайдеров
- обновление UI на роутере идёт через встроенный updater интерфейса, а не через `git pull`
- если меняется router-agent, нужно синхронизировать версию в `router-agent/install.sh`, status API, docs и HA handoff bundle
- любые следующие доработки раздела Трафик делать осторожно: сначала runtime-безопасность, потом украшательства

## Что проверить после обновления
1. В Обзоре диаграмма весов трафика остаётся живой и при видимой карточке обновляется без ощущения «задумчивости».
2. Если карточка Overview → Traffic ушла вне экрана, основной live polling становится реже, а secondary host-details polling практически затихает.
3. После возврата к карточке графики и live-данные подхватываются сразу, без ручного refresh.
4. Реальный трафик через роутер и QoS runtime не деградировали после обновления.

## Следующий логичный шаг
- `v1.2.156`: после живой проверки можно смотреть либо ещё один дешёвый off-screen contour в Overview/Traffic, либо аккуратный safe cherry-pick из upstream, но только без роста постоянного polling и без риска для packet-forwarding path.
