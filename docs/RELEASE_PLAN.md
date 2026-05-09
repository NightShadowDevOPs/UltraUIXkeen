# Release plan

Project: UI Mihomo Ultra / zash-agent
Release: v1.2.181
Title: Agent Maintenance: backup retention and log rotation

Scope:
1. Add `/opt/zash-agent/maintenance.sh` support.
2. Keep only last 7 daily `zash-backup-*.tar.gz` files.
3. Rotate `/opt/zash-agent/var/agent.log` when it exceeds 10 MiB.
4. Keep 3 compressed `agent.log.*.gz` copies.
5. Add install/check/apply/rollback scripts for maintenance.
6. Update docs and transfer notes that UI updater does not deliver router-agent scripts.

Out of scope:
- Mihomo core.
- TUN.
- QoS/routing.
- Provider SSL checks.
- users-db, shapers.db, provider cache deletion.
