UI Mihomo / Ultra — обновление переноса v1.2.100

Что изменилось в этом релизе:
- релиз `v1.2.100` — это целевой build-fix после `v1.2.99`: исправлен битый фрагмент `splitFormList / joinFormList` в `MihomoConfigEditor.vue`, из-за которого production build падал на `Unterminated regular expression`
- функциональность `v1.2.99` сохранена: form-driven `proxy-groups`, type-aware профиль группы и быстрые chips-подсказки для `rules` никуда не делись, просто релиз теперь действительно собирается
- `router-agent` в этом релизе не менялся; линия остаётся `0.6.22`

Текущие версии:
- UI: v1.2.100
- v1.2.100: patch-build-fix для `MihomoConfigEditor.vue`; исправлен сломанный regex/строковый литерал в helper-кусочке split/join списков, из-за которого CI/build падал на `Unterminated regular expression`; router-agent не менялся
- router-agent: 0.6.22

Что важно по интерфейсу:
- `Mihomo` остаётся отдельным рабочим разделом
- `Settings` держит только интерфейс, поведение и связанные настройки отображения
- safe managed-config flow сохранён: `draft / validate / apply / rollback / baseline / history`
- raw YAML-редактор не убирался: structured-блоки работают поверх текущего черновика и не ломают безопасный pipeline
- вкладка `Роутер` по-прежнему разбита на `Обзор / Трафик / Сеть`

Следующий логичный шаг:
- после `v1.2.100` логично продолжить form-сценарии для `rule-providers / proxy-providers` (включая type-aware поведение и подбор полей по типу), а затем добивать шаблоны создания новых сущностей с готовыми пресетами
