UI Mihomo / Ultra — transfer update v1.2.56

What changed in this rebuild:
- added explicit owner-resolution diagnostics in Traffic -> Users when the effective limit/QoS owner differs from the display row
- row badges/runtime hints now explain whether owner resolution came from persisted self state, name match, IP match, or MAC match
- Router -> Traffic now supports editable descriptions for OVPN/WG and other tunnel interfaces
- tunnel descriptions are shown both on the live tunnel cards and in routed via/route labels for downstream hosts
- router-agent code not changed in this release

Current versions:
- UI: v1.2.56
- router-agent: 0.6.12

13.03.2026 UI Mihomo / Ultra — сообщение для нового чата (вставь целиком)

Проект: UI Mihomo / Ultra
Репозиторий: NightShadowDevOPs/UltraUIXkeen
Локальная папка: Y:\Мой диск\Git\UltraUIXkeen
Путь на роутере/сервере: /opt/UltraUIXkeen
Стек: Vue 3 + TypeScript + router-agent (shell/cgi на роутере)

Текущие версии:
- UI: v1.2.56
- router-agent: 0.6.12

Правила по проекту:
- всегда отдавать архив релиза
- commit message давать отдельно
- команды для роутера давать отдельно
- в командах для роутера добавлять clear
- UI на роутере обновляется через встроенный механизм интерфейса, не через git pull
- если меняется router-agent, нужно синхронизировать версию в install.sh и status API
- в каждом релизе обновлять docs/chat-transfer.md и корневой TRANSFER_CHAT

Что важно по текущему состоянию:
- в v1.2.56 в Traffic -> Users добавлен явный owner-resolution badge: если limit owner отличается от display user, это теперь видно сразу в строке
- в v1.2.56 runtime tooltip/meta по строке объясняет причину owner-resolution: persisted self / name / IP / MAC match
- в v1.2.56 в Router -> Traffic появились редактируемые описания для OVPN/WG и других tunnel interfaces; они показываются на карточках туннелей и в routed via/route подписях
- в v1.2.55 в Traffic -> Users строки теперь показывают компактные бейджи пути совпадения Source IP прямо рядом с пользователем: exact / CIDR / regex / IPv6 suffix
- в v1.2.55 tooltip у этих бейджей показывает matched rule key(s) и live IPs, а QoS runtime hover тоже включает source-match path
- в v1.2.54 в Users -> Source IP mapping появились компактные бейджи типа правила и live-match counters по каждой строке
- в v1.2.54 Source IP stats теперь тоже показывает CIDR/regex/suffix-метки через общий helper, а не делает вид, что знает только exact IP
- в v1.2.53 добавлен рабочий CIDR helper path для Source IP mapping: CIDR/regex-метки теперь участвуют в Users/Traffic и могут подтягивать живые IP
- в v1.2.53 строки трафика снова собираются по смысловой метке подсети, а не расползаются только по отдельным IP из buckets
- в v1.2.52 найден и исправлен реальный build-breaker: синтаксическая ошибка в `src/i18n/en.ts`; откат глобального баннера из HomePage сохранён как безопасный fallback
- в v1.2.49 строка версии внизу левого меню остаётся живым индикатором свежести UI
- в v1.2.49 в раскрытом sidebar есть кнопка жёсткого обновления UI, а в свернутом режиме — компактный статус/кнопка
- в v1.2.48 в Settings есть проверка кэша UI: loaded bundle, bundle на роутере и статус совпадения/рассинхрона
- в v1.2.48 кнопка жёсткого обновления UI снимает service worker, чистит CacheStorage и делает reload с cache-bust query
- в v1.2.47 в разделе «Трафик» добавлен отдельный блок QoS runtime и расширенные runtime-подсказки по строкам устройств
- router-agent в текущем релизе не менялся

Порядок работы по проекту:
1. Собираем релиз архивом
2. Пользователь обновляет локальный репозиторий через GitHub Desktop
3. UI на роутере обновляется через встроенный механизм интерфейса
4. Если меняется router-agent — обновляем его отдельно через install.sh
5. Для нового чата используем docs/chat-transfer.md и корневой TRANSFER_CHAT как точку переноса

Команды для проверки на роутере:
```sh
clear
wget -qO- "http://192.168.0.1:9099/cgi-bin/api.sh?cmd=status"
wget -qO- "http://192.168.0.1:9099/cgi-bin/api.sh?cmd=qos_status"
wget -qO- "http://192.168.0.1:9099/cgi-bin/api.sh?cmd=traffic_live"
```

Следующий логичный шаг:
- добавить ещё более явную diagnostics-строку для tunnel descriptions в host target details, чтобы описание интерфейса было видно и в раскрытом контексте хоста
- затем можно спокойно возвращать верхний build-banner уже отдельным безопасным компонентом
