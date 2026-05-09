# Release documentation

Project: UI Mihomo Ultra / zash-agent
Release: v1.2.181
Title: Agent Maintenance: backup retention and log rotation

This documentation package follows universal release rules v9.10.2.

Artifacts expected:
- `release-ui-mihomo-ultra-v1.2.181.zip`
- `release-docs-ui-mihomo-ultra-v1.2.181.zip`
- `release-transfer-ui-mihomo-ultra-v1.2.181.zip`

Release focus: make zash-agent runtime maintenance repeatable: backup retention, agent.log rotation, correct cron-path checks, and raw/apply installer flow for router-agent scripts.

# Changelog

Project: UI Mihomo Ultra / zash-agent
Release: v1.2.181
Title: Agent Maintenance: backup retention and log rotation

## v1.2.181

Added:
- `router-agent/maintenance.sh`
- `router-agent/install-maintenance.sh`
- `scripts/apply-zash-agent-maintenance-v1.2.181.sh`
- `scripts/check-zash-agent-maintenance-v1.2.181.sh`
- `scripts/backup-zash-agent-maintenance-v1.2.181.sh`
- `scripts/rollback-zash-agent-maintenance-v1.2.181.sh`

Changed:
- Package version bumped to `1.2.181`.
- Watchdog state can now include `LAST_CHECK_ISO` and `LAST_STATUS`.
- Maintenance checks use `/opt/var/spool/cron/crontabs/root` as the confirmed router cron path.

Not changed:
- zash-agent runtime marker remains `0.6.37`.
- Mihomo core/TUN/QoS/routing/provider SSL unchanged.
