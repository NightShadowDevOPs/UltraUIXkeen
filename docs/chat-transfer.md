UI Mihomo / Ultra — transfer update v1.2.77

Что изменилось в этом релизе:
- редактор конфига Mihomo вынесен из Settings в отдельный верхнеуровневый раздел `Mihomo`
- левое меню разбито на логические группы: Monitor / Network & Mihomo / Management
- страница Settings разгружена и собрана в подблоки с быстрыми переходами: Interface / Backends / Traffic & labels / Pages & cards
- новый раздел Mihomo стал точкой входа для config workflow и быстрых переходов к runtime/providers/rules
- safe managed config flow из v1.2.75 сохранён без изменения router-agent версии
- Router → Agent status теперь перепроверяется автоматически, поэтому единичный сбой первого запроса не должен надолго оставлять карточку в offline

Текущие версии:
- UI: v1.2.77
- router-agent: 0.6.20

Что важно по новой навигации:
- `Mihomo` теперь отдельный рабочий раздел, а не карточка внутри Settings
- Settings теперь держит только UI/поведение и связанные display-настройки
- sidebar уже разбит на смысловые группы, но это только первый этап audit/refactor

Следующий логичный шаг:
- после hotfix статуса продолжить аудит навигации: решить, делать ли внутри Mihomo полноценные подразделы Runtime / Config / Providers / Rules и отдельно переработать мобильную навигацию
