UI Mihomo / Ultra — transfer update v1.2.75

Что изменилось в этом релизе:
- добавлен безопасный контур управления `config.yaml` через router-agent: отдельный черновик на роутере, отдельный эталонный конфиг, история ревизий активного конфига
- в редакторе конфига в Настройках появился managed-режим: Active → Draft, Baseline → Draft, Save draft, Validate draft, Apply draft, Make active baseline, Restore baseline, Restore revision
- применение черновика теперь идёт через pipeline: validate → snapshot current active → write config.yaml → restart Mihomo → rollback на предыдущий active или fallback на baseline при ошибке
- если managed-команды router-agent недоступны, редактор остаётся в старом direct/fallback-режиме и не ломает обычные backend'ы

Текущие версии:
- UI: v1.2.75
- router-agent: 0.6.20

Что важно по новой логике:
- эталонный конфиг хранится отдельно и не перезаписывается обычным сохранением черновика
- baseline меняется только отдельным действием “Make active baseline”
- при неудачном применении сначала идёт откат на предыдущий active, затем fallback на baseline
- первый этап пока без визуального конструктора YAML: основа — безопасное хранение, проверка, применение и восстановление

Следующий логичный шаг:
- добавить diff/sравнение active vs draft vs baseline и аккуратный просмотр причин отката/результата validate прямо в UI
