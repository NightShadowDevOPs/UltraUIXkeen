# zash-agent

Current packaged agent version: `0.6.37`

## v1.2.179 packaging note

`v1.2.179` is a packaging/documentation/static-cleanup release built from:

- UI/source baseline `v1.2.177`;
- zash-agent lightweight apply hotfix `v1.2.178`;
- universal release rules `v9.10.2`.

Runtime behavior is intentionally kept narrow:

- strict JSON HA endpoints from `v1.2.177` are preserved;
- lightweight file backup apply path from `v1.2.178` is preserved;
- installed agent marker remains `0.6.37`;
- literal NUL bytes in `install.sh` around `tr -d` were replaced with textual `\000` escaping;
- Mihomo core, TUN, QoS semantics, routing rules and provider SSL checks are not changed.

Important paths:

- project directory on router: `/opt/etc/mihomo`;
- installed agent directory: `/opt/zash-agent`;
- agent endpoint: `http://192.168.0.1:9099/cgi-bin/api.sh`.
