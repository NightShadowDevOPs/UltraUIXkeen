# Chat transfer workflow — UI Mihomo / Ultra

1. Start from the latest release package and documentation set, currently `v1.2.173`.
2. Re-read `docs/current-state.md`, `docs/release-plan.md`, `docs/project-memory.md`, `docs/model-memory-snapshot.md`, `docs/ha-export-bridge.md` and `docs/chat-transfer.md` before making the next change.
3. Preserve the current guardrails: no `git pull` as the primary router update path, keep provider SSL checks intact, keep TUN disabled unless a real scenario explicitly demands it, and do not change the router-agent → HA contract unless explicitly requested.
4. If `router-agent` changes in a later release, sync the version in `router-agent/install.sh`, the status API, docs and HA handoff files in the same release.
5. After `v1.2.173`, keep using low-risk upstream review and only cherry-pick changes that harden the UI or reduce operator confusion without changing polling/runtime shape.
