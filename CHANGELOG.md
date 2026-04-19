# Changelog

## v1.2.140 — router-agent install hotfix

- raised UI to `1.2.140`
- raised `router-agent` to `0.6.31`
- fixed drift between `api.sh` and the embedded CGI payload inside `router-agent/install.sh`
- `ha_snapshot` is now included in the installer-delivered router CGI, so a router updated from `install.sh` really gets the aggregated HA endpoint
- kept the Home Assistant package on the single-resource `ha_snapshot` model introduced in the previous release

## v1.2.139 — aggregated HA snapshot bundle

- raised UI to `1.2.139`
- raised `router-agent` to `0.6.30`
- added aggregated `ha_snapshot` endpoint in `api.sh`
- switched Home Assistant package to a single REST resource that feeds template sensors from the aggregated bundle
- updated docs, handoff packs and sample JSON for the HA export contour
