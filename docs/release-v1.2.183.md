# Release v1.2.184 — UI Version Bundle Sync Hotfix

Дата: 2026-05-10

## Цель

Синхронизировать отображаемую версию UI после агентского hotfix v1.2.182.
На роутере было подтверждено: `restart-agent.sh` уже v1.2.182, `RELEASE_META` уже v1.2.182, но frontend assets всё ещё содержали `1.2.181` в CSS-bundle (`messire`, `zash`, `ultraui`).

## Изменения

- `package.json` обновлён до `1.2.184`.
- Добавлена документация по UI bundle sync.
- Добавлены компактные router-check scripts для проверки, где в установленном UI осталась старая версия.
- `zash-agent` runtime marker не менялся: актуальная runtime-версия агента остаётся `0.6.37`.
- `restart-agent.sh`, watchdog и maintenance не менялись функционально в этом релизе.

## Не менялось

- Mihomo core.
- TUN.
- QoS/routing.
- Provider SSL checks/cache.
- `users-db.json`, `shapers.db`, provider traffic/cache.
- `/opt/etc/init.d/S99zash-agent`.

## Проверка на роутере после обновления UI

Запустить компактный check script из релиза или выполнить эквивалентную проверку:

```sh
/opt/bin/sh scripts/check-ui-version-v1.2.184.sh
```

Ожидаемо:

```text
OLD_181_FILES=0
NEW_183_FILES>0
PACKAGE_VERSION=1.2.184
```

Если `OLD_181_FILES=0`, но в браузере всё ещё видна старая версия — причина в PWA/browser cache, а не в файлах роутера.
