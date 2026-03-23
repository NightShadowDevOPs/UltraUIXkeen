13.03.2026 UI Mihomo / Ultra — сообщение для нового чата (вставь целиком)

Проект: UI Mihomo / Ultra
Новый основной репозиторий: https://github.com/NightShadowDevOPs/UltraUIXkeen
Локальная папка проекта: Y:\Мой диск\Git\UltraUIXkeen
Путь на роутере/сервере: /opt/UltraUIXkeen
Стек: Vue 3 + TypeScript + router-agent (shell/cgi на роутере)

Текущие версии:
- UI: v1.2.28
- router-agent: 0.6.8

Правила по проекту:
- всегда давать архив релиза, commit message и отдельный блок команд для роутера
- пользователь пушит через GitHub Desktop
- в командах для роутера всегда начинать с clear
- если меняется router-agent, синхронизировать версию в install.sh и status API
- в каждом релизе обновлять docs/chat-transfer.md и корневой TRANSFER_CHAT

Что важно по текущему состоянию:
- QoS и лимиты живут в разделе «Трафик»
- подтверждённый корень текущей проблемы: страница «Трафик» не делала полноценный старт router-agent сама; из-за этого на части ПК агент-функции фактически оживали только после открытия раздела «Router»
- в v1.2.28 добавлен ранний probe router-agent из общего HomePage и отдельная проверка/подтягивание agent status + lan_hosts прямо в UserTrafficStats
- кнопка «Применить» в QoS теперь зависит не только от localStorage-флага agentEnabled, а от фактической доступности agent + резолва IP строки
- для строк QoS добавлен fallback по agent lan_hosts, чтобы строка могла получить IP даже без текущего active connection
- после успешного probe агент автоматически включает shared users-db pull, поэтому лимиты/QoS должны подтягиваться без открытия раздела «Router»
- shaper/re-apply и MAC refresh на странице «Трафик» теперь тоже пытаются сначала поднять agent runtime, а не молча зависеть от старого локального флага
- router-agent в этом релизе не менялся
