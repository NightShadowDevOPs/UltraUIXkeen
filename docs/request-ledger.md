# UltraUIXkeen — Request ledger

## Long-lived user requirements
- Each release should contain archives, a separate commit message, updated docs and transfer files.
- Keep a transfer file in `docs` for moving the project into a new chat.
- If `router-agent` changes, sync its version in `install.sh` and in the status API.
- Router command blocks should start with `clear`.
- Do not treat `git pull` on the router as the main UI update path.
- Do not break automatic SSL certificate checks of proxy providers.
- Do not change the HA JSON contract unless there is a strong reason and it is explicitly agreed.

## Special request for v1.2.143
- Prepare the current release.
- Prepare clean transfer information for a new chat.
- Prepare a memory snapshot with an explanation of how this memory should be used during work.
- Document the working order: command blocks, commit messages, checks, release packaging.

## Special request for v1.2.144
- Host QoS and Traffic / Users should get **normal diagnostics cards**, not just compact counters.
- Diagnostics cards should be actionable and help navigate to the problematic slice quickly.
- Do **not** change the Home Assistant data structure / payload contract while doing this UI step.
- Refresh the transfer pack, memory snapshot and workflow notes again in the same release.

## Special request for v1.2.146
- Inside diagnostics slices, rows should be easier to read: sort the most important/problematic entries first.
- Show a short visible explanation near each row so the operator understands why it landed in the current slice.
- Keep the Home Assistant bridge contract unchanged.
