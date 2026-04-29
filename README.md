# UltraUIXkeen

Рабочий пакет UI Mihomo / Ultra для Netcraze Ultra.

- UI: `v1.2.173`
- router-agent: `0.6.33`
- Репозиторий: `NightShadowDevOPs/UltraUIXkeen`
- Путь на роутере: `/opt/UltraUIXkeen`

## Что важно в v1.2.173
- Hotfix для `zash-agent`: стартовый `rehydrate` больше не вызывается через HTTP-запрос в собственный `uhttpd`, а запускается напрямую как CGI shell-команда.
- Cron `ssl-refresh.sh` также больше не ходит в локальный HTTP endpoint агента, а вызывает CGI напрямую. Это снижает риск self-deadlock, когда `uhttpd` занят тяжёлым запросом, а UI уже ждёт `/status` или providers API.
- `start.sh` чистит зависшие CGI-процессы перед свежим стартом, но не трогает живой уже запущенный агент при обычном `start`.
- `S99zash-agent stop` стал жёстче: graceful stop, пауза, затем force-kill для зависших `uhttpd`/`api.sh`.
- Installer теперь автодетектит `MIHOMO_CONFIG` для уже существующего `agent.env`, если переменная отсутствует или указывает на несуществующий файл.
- UI-логика, polling, HA/export контракт, provider SSL checks как функция и TUN-режим не менялись.

## Операционные правила
- не ломать автоматическую проверку SSL-сертификатов провайдеров
- не предлагать `git pull` как основной путь обновления UI на роутере
- если меняется `router-agent`, синхронизировать версию в `install.sh`, status API и документации
- блоки команд для роутера всегда начинать с `clear`
- TUN не включать без отдельного реального сценария и отдельной проверки
