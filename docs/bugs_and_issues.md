# BUGS_AND_ISSUES — v1.2.187

## Исправляется в релизе

- `ha_snapshot.status.system.cpu_pct` мог оставаться `50`, хотя `cmd=status` отдавал живой CPU.
- `ha_snapshot.status.system.load` отсутствовал, хотя `cmd=status` уже отдаёт `load1/load5/load15`.

## Остаётся наблюдать

- Проверить 3–5 последовательных samples после установки: `status_cpu` и `snapshot_cpu` должны быть близкими, без постоянного `50`.
- Если endpoint снова начнёт залипать, использовать установленный watchdog/restart helper, не трогая Mihomo core.
