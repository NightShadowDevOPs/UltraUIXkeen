# Project spec

Project: UI Mihomo Ultra / zash-agent
Release: v1.2.181
Title: Agent Maintenance: backup retention and log rotation

Router project:
- Router: Netcraze-5955 / Netcraze NC-1812.
- zash-agent runtime dir: `/opt/zash-agent`.
- zash-agent endpoint: `http://192.168.0.1:9099/cgi-bin/api.sh`.
- Agent version: `0.6.37`.
- UI updater limitation: frontend bundle only, not runtime scripts.

Maintenance policy:
- Keep last 7 zash-agent daily backups.
- Rotate agent.log above 10 MiB.
- Keep 3 compressed agent.log archives.
- Use `/opt/var/spool/cron/crontabs/root` for cron checks.
