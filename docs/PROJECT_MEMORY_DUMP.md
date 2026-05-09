# Project memory dump

Project: UI Mihomo Ultra / zash-agent
Release: v1.2.181
Title: Agent Maintenance: backup retention and log rotation

v1.2.180 watchdog was installed via GitHub raw download. It installed `/opt/zash-agent/restart-agent.sh` and `/opt/zash-agent/watchdog.sh`; cron line is every 2 minutes in `/opt/var/spool/cron/crontabs/root`. Manual cleanup later reduced `/opt/zash-agent` from about 837.9M to 154.7M by deleting old backups and rotating agent.log. v1.2.181 formalizes this as maintenance tooling.
