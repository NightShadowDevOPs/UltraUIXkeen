# UI Mihomo / Ultra — перенос в новый чат

## Текущее состояние
- Текущая версия UI: **v1.2.130**
- Router-agent: **0.6.26**
- Основной репозиторий: `NightShadowDevOPs/UltraUIXkeen`
- Локальная папка: `Y:\Мой диск\Git\UltraUIXkeen`
- Путь на роутере: `/opt/UltraUIXkeen`

## Что сделано в v1.2.130
- исправлена template-ошибка `Element is missing end tag` в `src/components/router/AgentCard.vue`: возвращён пропущенный закрывающий контейнер внутри unified backup history
- backup workspace из предыдущих релизов сохранён: inspection panel и список архивов остаются внутри корректной области элемента
- `router-agent` в этом релизе не менялся и остаётся `0.6.26`

## Что проверять после выкладки
1. production build снова проходит без ошибки по `AgentCard.vue`
2. `Router → Резервные копии → Загрузить` по-прежнему реально поднимает backup workspace со списками и действиями
3. `Проверить` раскрывает inspection panel внутри строки архива и не ломает весь блок

## Следующий зафиксированный шаг
- **v1.2.131** — Router network workspace hardening: дочистить сетевой рабочий экран и убрать остаточную перегруженность
