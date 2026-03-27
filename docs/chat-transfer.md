UI Mihomo / Ultra — transfer update v1.2.72

Что изменилось в этом релизе:
- router-agent переиздан как 0.6.19
- install.sh теперь сохраняет в generated `api.sh` уже подтверждённый рабочий shebang `#!/opt/bin/sh`
- `status` больше не делает внешний запрос версии через `remote_agent_version()`; `serverVersion` берётся локально из `AGENT_VERSION`, что убирает зависание CGI на роутере
- в generated payload добавлен helper `version_cmp_sh()`, чтобы убрать ошибки `version_cmp_sh: not found` и `sh: bad number`
- подтверждённый корень проблемы: прямой запуск `api.sh` через `/opt/bin/sh` работал, а CGI-path подвисал из-за сочетания несовместимого `/bin/sh` и внешней проверки версии
- остаточный host-traffic / `Broken pipe` шум в логах пока не менялся и должен идти отдельным безопасным шагом

Текущие версии:
- UI: v1.2.72
- router-agent: 0.6.19

27.03.2026 UI Mihomo / Ultra — сообщение для нового чата (вставь целиком)

Проект: UI Mihomo / Ultra
Репозиторий: NightShadowDevOPs/UltraUIXkeen
Локальная папка: Y:\Мой диск\Git\UltraUIXkeen
Путь на роутере/сервере: /opt/UltraUIXkeen
Стек: Vue 3 + TypeScript + router-agent (shell/cgi на роутере)

Текущие версии:
- UI: v1.2.72
- router-agent: 0.6.19

Правила по проекту:
- всегда отдавать архив релиза
- commit message давать отдельно
- команды для роутера давать отдельно
- в командах для роутера добавлять clear
- UI на роутере обновляется через встроенный механизм интерфейса, не через git pull
- если меняется router-agent, нужно синхронизировать версию в install.sh и status API
- в каждом релизе обновлять docs/chat-transfer.md и корневой TRANSFER_CHAT

Что важно по текущему состоянию:
- users DB conflict cockpit уже показывает winner/result/reason по tunnels, panel URLs, icons, SSL warn settings, labels и user limits; есть apply-preview и copy/export conflict preview
- корень агентной аварии подтверждён: CGI `uhttpd` должен запускать `api.sh` через `#!/opt/bin/sh`, а не через проблемный `/bin/sh`
- второй подтверждённый хвост: `status` нельзя вешать на внешний `remote_agent_version()` запрос; локальный `serverVersion` работает стабильно
- helper `version_cmp_sh()` теперь обязан быть в payload, чтобы не было хвоста `version_cmp_sh: not found` / `bad number`
- остаточный host-traffic / `Broken pipe` log noise ещё не исправлен и должен идти отдельным безопасным шагом от уже рабочей базы

Порядок работы по проекту:
1. Собираем релиз архивом
2. Пользователь обновляет локальный репозиторий через GitHub Desktop
3. UI на роутере обновляется через встроенный механизм интерфейса
4. Если меняется router-agent — обновляем его отдельно через install.sh
5. Для нового чата используем docs/chat-transfer.md и корневой TRANSFER_CHAT как точку переноса

Команды для установки/проверки router-agent на роутере:
```sh
clear
/opt/bin/wget -O- "https://raw.githubusercontent.com/NightShadowDevOPs/UltraUIXkeen/main/router-agent/install.sh" | /opt/bin/sh
wget -T 5 -qO- "http://192.168.0.1:9099/cgi-bin/api.sh?cmd=status"
wget -T 5 -qO- "http://192.168.0.1:9099/cgi-bin/api.sh?cmd=qos_status"
wget -T 5 -qO- "http://192.168.0.1:9099/cgi-bin/api.sh?cmd=traffic_live"
```

Следующий логичный шаг:
- отдельным безопасным патчем дочистить остаточный host-traffic / Broken pipe log noise, уже не трогая рабочий CGI/status путь агента
