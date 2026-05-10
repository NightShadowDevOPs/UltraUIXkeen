# AI session bootstrap

Continue from v1.2.182.

The restart helper should prefer `/opt/etc/init.d/S99zash-agent restart` and validate both `status` and `ha_snapshot`. UI updater does not deploy router-agent scripts; use raw/manual commands for runtime agent files.
