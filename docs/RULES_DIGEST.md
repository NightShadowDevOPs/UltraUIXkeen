# Rules digest

- Use universal release rules v9.10.2.
- Use artifacts named `release-*`, `release-docs-*`, `release-transfer-*`.
- Do not use checkpoint prefixes.
- Keep release docs and transfer docs separate from main release archive.
- Do not include secrets.
- Do not touch Mihomo core, TUN, QoS/routing, provider SSL, users-db or shapers unless explicitly requested.
- Router terminal dislikes long one-liners; provide short commands.
