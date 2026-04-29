# Request ledger

## 2026-04-29 — v1.2.173
User reported that `zash-agent` recovered after manual stop/kill/start but UI still showed agent unavailable and providers were not visible during the incident. Requested a patch.

Implemented:
- router-agent `0.6.33`
- removed startup HTTP self-call for `cmd=rehydrate`
- removed cron HTTP self-call for `cmd=ssl_cache_refresh`
- hardened stop/start process cleanup
- added `MIHOMO_CONFIG` auto-detect for existing env
- updated documentation and handoff files

Validation deferred by user.

## 2026-04-24 — v1.2.172
Traffic calmer service and empty states for `Трафик -> Устройства` and `Трафик -> Пользователи`.
