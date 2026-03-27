UI Mihomo / Ultra — transfer update v1.2.71

Что изменилось в этом релизе:
- router-agent переиздан как 0.6.18
- install.sh теперь генерирует `/opt/zash-agent/www/cgi-bin/api.sh` с shebang `#!/opt/bin/sh`, а не `#!/bin/sh`
- это фиксирует реальную проблему на роутере: CGI под `uhttpd` запускал `api.sh` через несовместимый `/bin/sh`, из-за чего agent падал с `syntax error: unexpected "{" (expecting "then")`
- подтверждено на роутере пользователя: ручная замена shebang на `#!/opt/bin/sh` сразу оживила `cmd=status`
- сохранены безопасные агентные фиксы из рабочей линии 0.6.17: `read_conntrack_table()`, неблокирующий `rehydrate`, более жёсткая зачистка stale `uhttpd` при restart
- host-traffic temp-file шум в логах (`/tmp/zash_host_traffic_hosts.*`, `Broken pipe`) пока сознательно не менялся в этом релизе

Текущие версии:
- UI: v1.2.71
- router-agent: 0.6.18

27.03.2026 UI Mihomo / Ultra — сообщение для нового чата (вставь целиком)

Проект: UI Mihomo / Ultra
Репозиторий: NightShadowDevOPs/UltraUIXkeen
Локальная папка: Y:\Мой диск\Git\UltraUIXkeen
Путь на роутере/сервере: /opt/UltraUIXkeen
Стек: Vue 3 + TypeScript + router-agent (shell/cgi на роутере)

Текущие версии:
- UI: v1.2.71
- router-agent: 0.6.18

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
- корень агентной аварии после 0.6.12 найден: CGI `uhttpd` запускал `api.sh` через `/bin/sh`, который на роутере не переваривал payload
- рабочий фикс подтверждён вручную: `api.sh` должен использовать `#!/opt/bin/sh`
- safe fixes линии агента сохранены: `read_conntrack_table()`, неблокирующий `rehydrate`, более жёсткий cleanup stale `uhttpd` на restart
- остаточный host-traffic log noise (`/tmp/zash_host_traffic_hosts.*`, `Broken pipe`) ещё не исправлен и должен идти отдельным безопасным шагом от уже рабочей базы

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
- аккуратно и отдельно добить остаточный host-traffic temp-file/log noise, уже не трогая рабочий CGI/shebang путь агента
