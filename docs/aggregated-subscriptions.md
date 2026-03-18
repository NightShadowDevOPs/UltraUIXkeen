# Aggregated subscriptions

UI Mihomo/Ultra can now build one client-facing subscription from multiple proxy providers.

Important:
- the router **only serves the subscription URL**;
- the client app connects **directly to provider servers**;
- router-agent must be enabled and reachable from the client device.

## Supported outputs

### 1) Mihomo / Clash YAML

Endpoint:

```text
http://<router-ip>:9099/cgi-bin/api.sh?cmd=subscription&format=mihomo
```

What it does:
- generates `proxy-providers` from current Mihomo `proxy-providers` in `config.yaml`;
- adds ready-made groups:
  - `Manual`
  - `Auto`
  - `Failover`
  - `Balance`
- final `MATCH` rule points to the generated top-level group.

Good for:
- Mihomo
- Clash family clients
- clients that understand remote YAML configs with provider URLs

### 2) Universal V2Ray / Xray subscription

Endpoint:

```text
http://<router-ip>:9099/cgi-bin/api.sh?cmd=subscription&format=b64
```

What it does:
- downloads provider subscription payloads;
- tries to normalize Base64 / plain text share-link payloads;
- merges and deduplicates links;
- returns a Base64 subscription body.

Plain text variant:

```text
http://<router-ip>:9099/cgi-bin/api.sh?cmd=subscription&format=plain
```

Good for:
- V2rayTun
- v2rayNG
- Hiddify
- other apps that import a subscription URL or share-link list

## Provider filtering

You can limit the exported bundle to specific providers:

```text
&providers=AdminVPS,Play2GoFI,CloudRU
```

Example:

```text
http://<router-ip>:9099/cgi-bin/api.sh?cmd=subscription&format=mihomo&providers=AdminVPS,CloudRU
```

## Custom bundle name

Optional query parameter:

```text
&name=My Bundle
```

Example:

```text
http://<router-ip>:9099/cgi-bin/api.sh?cmd=subscription&format=mihomo&name=Family Bundle
```

## If router-agent token is enabled

Add the token into the subscription URL:

```text
&token=<agent-token>
```

Example:

```text
http://<router-ip>:9099/cgi-bin/api.sh?cmd=subscription&format=b64&token=YOUR_TOKEN
```

## Notes / limitations

- `format=mihomo` does not proxy traffic through the router; it only builds a YAML config that points to provider URLs.
- `format=b64` works best when upstream provider URLs return normal V2Ray/Xray subscription payloads (Base64 or plain share links).
- if an upstream provider returns only a panel page or another non-subscription format, its links may not appear in `format=b64`.
- if `subscription` returns `{"ok":false,"error":"no-providers"}`, router-agent could not parse `proxy-providers` from the current Mihomo config.


## Deep link notes

- `Mihomo / Clash`: `clash://install-config?url=<encoded-subscription-url>`
- `v2rayNG`: `v2rayng://install-config?url=<encoded-subscription-url>&name=<encoded-name>`
- `V2rayTun`: `v2raytun://import-sub?url=<encoded-plain-subscription-url>`
- `Hiddify`: `hiddify://import/<encoded-subscription-url>#<encoded-name>`

The UI now URL-encodes subscription links before building deep links, because raw `http://...?...&...` values inside custom schemes can break import on some clients. For V2rayTun specifically, the UI uses the plain-text subscription endpoint plus the `v2raytun://import-sub?url=...` form for better compatibility, while the QR mode shows the direct plain subscription URL.


## V2RayTun compatibility

For V2RayTun, use the dedicated `format=v2raytun` subscription endpoint. It returns the same raw node list as `plain`, but adds V2RayTun-supported HTTP headers such as `profile-title`, `profile-update-interval`, and `update-always`. The UI uses the official deep link form `v2raytun://import/{subscription_link}` for buttons and QR-codes, while the copy action keeps a normal subscription URL for clipboard import.
