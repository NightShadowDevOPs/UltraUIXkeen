# RULES_DIGEST — v1.2.187

- Use universal release rules v9.10.2.
- Required artifacts: release ZIP, docs ZIP, transfer ZIP.
- No checkpoint prefixes.
- No deploy/runtime mutation unless user explicitly runs installer.
- Runtime router-agent scripts must be delivered via raw/manual installer path; UI updater alone is not enough.
- Keep terminal output compact, ideally 10–15 lines.
- Never include tokens, private keys, Bearer strings, full subscription URLs or secrets.
- No Home Assistant / HA DB / native Energy / SmartLife boiler changes for this router-agent hotfix.
