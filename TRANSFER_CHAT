UI Mihomo / Ultra — transfer update v1.2.50

What changed in this rebuild:
- added a global stale-build banner under the page title bar, so update-ready / stale-cache state is visible even without the desktop sidebar
- the banner shows both the currently loaded bundle and the router-served bundle, and gives direct hard-refresh + close actions
- banner dismissal is remembered for the current browser session and tied to the router bundle tag, so it stays quiet until a different build appears
- router-agent code not changed in this release

Current versions:
- UI: v1.2.50
- router-agent: 0.6.12

13.03.2026 UI Mihomo / Ultra — сообщение для нового чата (вставь целиком)

Проект: UI Mihomo / Ultra
Новый основной репозиторий: https://github.com/NightShadowDevOPs/UltraUIXkeen
Локальная папка проекта: Y:\Мой диск\Git\UltraUIXkeen
Путь на роутере/сервере: /opt/UltraUIXkeen
Стек: Vue 3 + TypeScript + router-agent (shell/cgi на роутере)

Текущие версии:
- UI: v1.2.50
- router-agent: 0.6.12

Правила по проекту:
- всегда давать архив релиза, commit message и отдельный блок команд для роутера
- пользователь пушит через GitHub Desktop
- обновление на роутере идёт через UI, а не через git pull
- если меняется router-agent, синхронизировать версию в install.sh и status API
- в каждом релизе обновлять docs/chat-transfer.md и корневой TRANSFER_CHAT

Что важно по текущему состоянию:
- в v1.2.50 под PageTitleBar добавлен глобальный баннер новой сборки UI: он виден и на мобильных экранах, где desktop sidebar недоступен
- в v1.2.50 баннер показывает loaded bundle и bundle на роутере, а также даёт быстрые действия «Жёстко обновить UI» и «Закрыть»
- в v1.2.50 закрытие баннера запоминается только на текущую сессию и сбрасывается автоматически, когда на роутере появляется уже другой bundle
- в v1.2.49 строка версии внизу левого меню превратилась в живой индикатор свежести UI: новая сборка видна прямо в sidebar, без захода в Settings
- в v1.2.49 в раскрытом sidebar добавлена кнопка жёсткого обновления UI, а в свернутом режиме появился компактный статус/кнопка для быстрого сброса залипшего кэша
- в v1.2.49 `useUiBuild()` больше не плодит лишние visibility listeners и повторные проверки, если статус сборки используется сразу в нескольких местах UI
- в v1.2.48 в Settings добавлена проверка кэша UI: видно текущий загруженный bundle, bundle из актуального HTML на роутере и статус совпадения/рассинхрона
- в v1.2.48 кнопка жёсткого обновления UI теперь не ограничивается обычным reload: UI снимает service worker registrations, очищает CacheStorage и только потом форсирует reload с cache-bust query
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
- либо добавить ещё более явный mobile/dock-индикатор новой сборки
- либо возвращаться к точечному CIDR helper для Source IP mapping после завершения UI-cache polish
