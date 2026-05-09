# Bugs and issues

Project: UI Mihomo Ultra / zash-agent
Release: v1.2.181
Title: Agent Maintenance: backup retention and log rotation

Known/closed:
- UI updater updates the frontend bundle only; it does not deploy files from `scripts/` or `router-agent/` to the router runtime. Router-agent scripts must be installed via raw/apply flow.
- Old check command looked at `/etc/crontabs/root`; confirmed correct active cron path is `/opt/var/spool/cron/crontabs/root`.
- `/opt/zash-agent/var/backups` can grow without retention; v1.2.181 adds retention tooling.

Open:
- Add UI visibility for watchdog/maintenance state in a later release.
- Consider agent-side backup script retention integration so daily backup job cannot accumulate indefinitely.
