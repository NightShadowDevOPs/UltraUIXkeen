# UI Mihomo / Ultra — перенос в новый чат

## Текущее состояние
- Текущая версия UI: **v1.2.130**
- Router-agent: **0.6.26**
- Основной репозиторий: `NightShadowDevOPs/UltraUIXkeen`
- Локальная папка: `Y:\Мой диск\Git\UltraUIXkeen`
- Путь на роутере: `/opt/UltraUIXkeen`

## Что сделано в v1.2.130
- исправлена template-ошибка `Element is missing end tag` в `src/components/router/AgentCard.vue`: в unified history резервных копий возвращён пропущенный закрывающий контейнер
- backup workspace из предыдущих релизов не откатывался: inspection panel и unified history остаются в правильном контексте списка архивов
- router-agent в этом релизе не менялся и остаётся `0.6.26`

## Что проверить после выкладки
- production build снова проходит без ошибки по `AgentCard.vue`
- `Router → Резервные копии → Загрузить` по-прежнему поднимает backup workspace, а не пустой экран
- `Проверить` раскрывает проверку архива внутри списка и не ломает блок

## Следующий релиз
- **v1.2.131** — Router network workspace hardening: дочистить сетевой рабочий экран и убрать остаточную перегруженность
