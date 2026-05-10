# Rules digest

- Use release prefix artifacts only: `release-*`.
- No checkpoint artifact names.
- Do not deploy/restart/mutate runtime without explicit decision.
- No secrets/tokens/full URLs in docs/archives.
- Router terminal output must stay compact, 10–15 lines.
- UI updater does not deploy `router-agent/*` scripts; agent runtime uses raw/manual install path.
