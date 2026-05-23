# Transfer note — UI Mihomo Ultra / router-agent v1.2.195

Current focus: cautious Mihomo core update rehearsal from v1.19.24 to v1.19.25.

What is included:
- `router-agent/mihomo-core-canary-v1.2.195.sh`
- `router-agent/install-mihomo-core-canary-v1.2.195.sh`
- `scripts/check-mihomo-core-v1.2.195.sh`

Critical constraints:
- Do not edit Home Assistant, HA DB, штатная HA Energy, SmartLife boiler.
- Do not change TUN/sniffing/QUIC automatically.
- Do not replace Mihomo binary without explicit user action and token `APPLY_MIHOMO_1_19_25`.
- Keep outputs compact: 10–15 lines maximum.

Known context:
- Router currently reported Mihomo Meta v1.19.24 linux arm64.
- User had internet access issues previously and fixed them by disabling sniffing and browser QUIC.
- Preferred rollout: stage → config test → optional apply → observe → rollback if needed.
