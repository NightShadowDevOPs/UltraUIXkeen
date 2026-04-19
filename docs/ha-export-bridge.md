# HA export bridge

### v1.2.140

- router-agent installer hotfix: `router-agent/install.sh` now contains the same HA export CGI logic as `api.sh`
- `ha_snapshot` is delivered by the installer and available right after a normal router-agent upgrade
- docs, handoff packs and sample JSON aligned to agent `0.6.31`

### v1.2.139

- introduced aggregated `ha_snapshot` endpoint in the repo runtime code
- switched the main Home Assistant package to a single-resource polling model
