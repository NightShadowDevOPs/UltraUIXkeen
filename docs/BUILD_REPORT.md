# Build report v1.2.182

SH_SYNTAX_STATUS=OK
STATIC_SAFETY_STATUS=OK_AFTER_REVIEW

Syntax checks:
- router-agent/install-watchdog.sh: RC=0
- router-agent/install.sh: RC=0
- router-agent/restart-agent.sh: RC=0
- router-agent/watchdog.sh: RC=0
- router-agent/maintenance.sh: RC=0
- router-agent/install-maintenance.sh: RC=0
- router-agent/install-restart-agent.sh: RC=0
- scripts/apply-zash-agent-watchdog-v1.2.180.sh: RC=0
- scripts/backup-zash-agent-watchdog-v1.2.180.sh: RC=0
- scripts/check-zash-agent-watchdog-v1.2.180.sh: RC=0
- scripts/rollback-zash-agent-watchdog-v1.2.180.sh: RC=0
- scripts/check-zash-agent-maintenance-v1.2.181.sh: RC=0
- scripts/apply-zash-agent-maintenance-v1.2.181.sh: RC=0
- scripts/backup-zash-agent-maintenance-v1.2.181.sh: RC=0
- scripts/rollback-zash-agent-maintenance-v1.2.181.sh: RC=0
- scripts/backup-zash-agent-restart-v1.2.182.sh: RC=0
- scripts/apply-zash-agent-restart-v1.2.182.sh: RC=0
- scripts/check-zash-agent-restart-v1.2.182.sh: RC=0
- scripts/rollback-zash-agent-restart-v1.2.182.sh: RC=0

Secret scan review:
- False-positive UI/code literals reviewed: password field handling, PRIVATE KEY label text, Bearer header string construction.
- No private keys, tokens, passwords, device IDs, local keys or full subscription URLs are intentionally included in release docs or router-agent scripts.
