# UI Mihomo Ultra v1.2.194 — Provider hosting persistence status

## Scope

UI/docs/scripts-only release for the provider hosting payment table.

## What changed

- Added a visible hosting payment persistence status in the providers table:
  - `Сохранено` / `Ожидает сохранения` / `Сохранение…` / `Ошибка сохранения`.
  - Saved records counter.
  - Last successful save timestamp and users-db revision when available.
- Added explicit `Сохранить сейчас` button for hosting payment fields.
- Kept automatic users-db sync enabled; the button is a verification/control path, not a replacement.
- Improved bootstrap safety: provider hosting payment fields are now counted as real local/remote data during users-db first-time sync decisions.
- Added compact router-side check script: `scripts/check-provider-hosting-persistence-v1.2.194.sh`.

## Safety scope

Not touched:

- Mihomo core.
- TUN.
- QoS/routing rules.
- Provider SSL checks.
- Router reboot.
- Home Assistant.
- HA DB.
- Native Home Assistant Energy.
- SmartLife boiler.

## Expected verification

After editing one hosting payment date and period in UI:

1. Status changes to `Ожидает сохранения` or `Сохранение…`.
2. After sync, status becomes `Сохранено`.
3. `Сохранить сейчас` can be pressed for an immediate users-db push.
4. Router check should show non-zero records after at least one provider has hosting payment data.

```sh
cd /opt/etc/mihomo
set +e
/opt/bin/sh scripts/check-provider-hosting-persistence-v1.2.194.sh
```

Expected compact lines include:

```text
CHECK_PROVIDER_HOSTING_PERSISTENCE_VERSION=v1.2.194
USERS_DB_EXISTS=yes
HAS_DUE_DATES_FIELD=yes
HAS_PERIOD_FIELD=yes
HOSTING_DUE_RECORDS=<number>
HOSTING_PERIOD_RECORDS=<number>
USERS_DB_API_OK=yes
```
