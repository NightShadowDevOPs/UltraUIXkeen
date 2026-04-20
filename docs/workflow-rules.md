# UltraUIXkeen — Workflow rules

## Release output format
For each release, prepare:
1. Main project archive
2. Chat-transfer archive
3. HA handoff archive when HA bridge files are involved
4. Commit message as a **plain text line inside a code block**, without `git commit` command
5. Router commands in a separate code block when router-side actions are needed

## Router-side commands
- Start router command blocks with `clear`.
- Do **not** propose `git pull` on the router as the primary UI update path.
- If `router-agent` changed, provide explicit reinstall / restart / verification commands.
- If router-side actions are not needed, state that directly.

## Language rule
- All explanations and supporting release text for this project should be in Russian.

## Documentation discipline
Every release must refresh, when relevant:
- `CHANGELOG.md`
- `docs/release-plan.md`
- `CURRENT_CHAT_TRANSFER_NOTE.md`
- `docs/chat-transfer.md`
- transfer bundle files
- HA handoff docs when HA bridge files changed
- workflow / memory docs when operational agreements changed

## Checks to include in release messages
Mention what should be checked after deployment or update. Prefer concrete checks such as:
- version visible in UI / status
- router-agent version in `/cgi-bin/api.sh?cmd=status`
- expected HA endpoint response available
- expected UI cards / QoS screens / traffic screens behave correctly

## Commit message style
- One concise release line
- Include version and intent
- Example style: `v1.2.144: add actionable diagnostics cards for Host and Traffic workspaces`

## Handoff rules for a new chat
At the start of a new chat:
- read the transfer note and workflow docs first
- verify actual repo/runtime state
- only then decide the next version and implementation scope
