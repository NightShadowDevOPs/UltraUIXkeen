UI Mihomo / Ultra — обновление переноса v1.2.99

Что изменилось в этом релизе:
- structured editor `proxy-groups` стал заметно более form-driven: добавлен type-aware профиль группы для `select / url-test / fallback / load-balance / relay`, быстрые пресеты и короткие подсказки по тому, какие поля реально важны
- состав группы (`proxies`, `use`, `providers`) теперь можно редактировать не только руками в textarea, но и через чипы добавления/удаления из уже существующих proxies/groups/providers
- structured editor `rules` получил быстрые чипы-подсказки для `payload`, `target` и common params вроде `no-resolve`, чтобы типовые правки меньше требовали ручного набора
- raw YAML не убирался: он остаётся fallback-режимом для редких и vendor-specific ключей
- `router-agent` в этом релизе не менялся; линия остаётся `0.6.22`

Текущие версии:
- UI: v1.2.99
- v1.2.99: structured editor `proxy-groups` стал заметно более формовым — появились type-aware профиль группы, быстрые пресеты и чипы для состава `proxies/use/providers`; `rules` получили быстрые подсказки по payload/target/params; router-agent не менялся
- router-agent: 0.6.22

Что важно по интерфейсу:
- `Mihomo` остаётся отдельным рабочим разделом
- `Settings` держит только интерфейс, поведение и связанные настройки отображения
- safe managed-config flow сохранён: `draft / validate / apply / rollback / baseline / history`
- raw YAML-редактор не убирался: structured-блоки работают поверх текущего черновика и не ломают безопасный pipeline
- вкладка `Роутер` по-прежнему разбита на `Обзор / Трафик / Сеть`

Следующий логичный шаг:
- после v1.2.99 логично сделать ещё более явные form-сценарии для `rule-providers / proxy-providers` (включая type-aware поведение и подбор полей по типу), а затем добивать шаблоны создания новых сущностей с готовыми пресетами
