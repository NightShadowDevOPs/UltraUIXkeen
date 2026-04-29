# Audit deploy decision — v1.2.176

## Input

Strict audit for the previous line reported documentation completeness as good, but highlighted an ambiguous risk around the old `ha_snapshot` CGI timeout.

## Decision

Create `v1.2.176` before deploy.

## Reason

The runtime issue was already confirmed fixed by smoke test in `v1.2.174`, but docs still allowed the audit to interpret the timeout as a current known issue. For deployment discipline, `v1.2.176` makes the status explicit and adds rollback/check tooling.

## Deploy stance

Deploy can proceed after uploading `v1.2.176`, because this release does not change live traffic, Mihomo core, provider checks, TUN, QoS or HA contract.

## Verification gate

After applying, these markers must be present:

```text
STATUS_HTTP=200
STATUS_OK=true
HA_SNAPSHOT_HTTP=200
HA_SNAPSHOT_OK=true
MIHOMO_PROVIDERS_HTTP=200
```
