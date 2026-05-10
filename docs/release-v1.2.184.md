# Release v1.2.184 — Watchdog false-positive hotfix

Scope: zash-agent watchdog only.

Fixes a false positive where `status` and top-level `ha_snapshot` were OK, but nested bundle diagnostics produced `BUNDLE_OK=false`; the watchdog kept increasing `FAIL_COUNT` and restarted the agent unnecessarily.

New policy: restart only when transport/root health is bad (`status.ok` and top-level `ha_snapshot.ok`). Nested bundle fields remain diagnostic output and are not a restart trigger.

Does not touch Mihomo core, TUN, QoS/routing, provider SSL, users-db, shapers.db, or router reboot.
