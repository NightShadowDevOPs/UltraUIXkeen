UI Mihomo / Ultra — transfer update v1.2.73

Что изменилось в этом релизе:
- users DB conflict UI для IP labels теперь показывает не только label, но и scope
- в winner/result по labels видно, какая область действия правила реально победила и уйдёт на роутер
- в smart merge для labels router/local значения теперь показываются вместе со scope по backend'ам
- в режиме custom для labels явно видно, что меняется только label, а scope остаётся локальным
- details и exported conflict preview теперь тоже scope-aware по labels
- router-agent в этом релизе не менялся

Текущие версии:
- UI: v1.2.73
- router-agent: 0.6.19

Следующий логичный шаг:
- отдельным безопасным патчем дочистить остаточный host-traffic / Broken pipe log noise, уже не трогая рабочий CGI/status путь агента
