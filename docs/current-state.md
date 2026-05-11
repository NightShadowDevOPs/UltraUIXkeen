# Current state after v1.2.189

- UI version: 1.2.189.
- Router-agent runtime marker remains 0.6.37.
- Provider links model:
  - `url` / subscription URL: active provider URL and SSL-check source.
  - `panelUrl`: public Internet panel URL.
  - `panelSshUrl` / `providerPanelSshUrls`: manually filled local SSH tunnel panel URL.
- Latest confirmed router-agent hotfixes before this release:
  - v1.2.186 cache-first HA endpoints.
  - v1.2.187 live CPU/load mapping in ha_snapshot.
  - v1.2.188 provider link fields and sslSource=subscription.
- HA Router Contract is green after CPU hotfix; do not touch HA/DB/boiler for provider link work.
