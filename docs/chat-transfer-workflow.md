# Chat transfer workflow — UI Mihomo / Ultra

Use this checklist whenever the project is moved into a fresh chat.

1. Start from the latest release package and documentation set, currently `v1.2.165`.
2. Read in order:
   - `docs/project-memory.md`
   - `docs/current-state.md`
   - `docs/release-plan.md`
   - `docs/request-ledger.md`
   - `docs/chat-transfer.md`
   - `docs/ha-export-bridge.md`
3. Preserve fixed workflow rules:
   - explain everything in Russian
   - update docs on every release
   - copy a memory snapshot into docs on every release
   - do not risk the real traffic path for UI cosmetics
   - do not break SSL certificate checks of proxy providers
   - router updates use the built-in UI updater, not `git pull`
   - if `router-agent` changes, sync `install.sh`, status API, docs and handoff bundle
4. Re-confirm with the user what was already verified on the real router before preparing the next step.
5. After `v1.2.165`, keep using low-risk upstream review and only cherry-pick changes that harden the UI or reduce pointless wake-up work without changing runtime shape.
