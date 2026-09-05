# Deployment Notes

## Recommended path: Cloudflare Pages

1. Keep the source in the public GitHub repository `EncGur/encryptedguru-site`.
2. Connect the repository to Cloudflare Pages.
3. Set the build command to `sh scripts/build-site.sh`.
4. Set the output directory to `dist`.
5. Add custom domains:
   - `encryptedguru.com`
   - `www.encryptedguru.com`
6. Redirect the apex domain to `www`.
7. Enable HTTPS.
8. Keep analytics disabled unless there is a clear operational reason.

Note: the current canonical public URL is `https://www.encryptedguru.com/`, with
the apex redirecting to `www`. If this changes, update canonical tags,
`sitemap.xml`, `security.txt`, `_redirects`, and this file in the same release.

Cloudflare Pages source-control files:

- `scripts/build-site.sh`: copies only approved public assets into `dist/`.
- `_headers`: security headers and cache policy.
- `_redirects`: apex and HTTP redirect policy.
- `_routes.json` and `functions/[[path]].js`: return a non-cacheable `404` for
  source-only paths without invoking Functions for normal static routes.
- `404.html`: disables Pages' implicit single-page-app fallback and restores real
  not-found responses.

Before release, run the verification gates listed in `PROJECT_STATE.md`:

```sh
./scripts/audit-source.sh
./scripts/build-site.sh
./tests/test-plasma-redirect.sh
./tests/test-projects.sh
./tests/test-public-boundary.sh
./tests/test-reproducible-package.sh
python3 tests/test-site-structure.py
```

After release:

```sh
./scripts/verify-live.sh
```

## DNS baseline

Keep Google Workspace records intact:

- MX records for Gmail
- SPF TXT record
- DKIM TXT record
- DMARC TXT record

Add web hosting records only after confirming the hosting provider's exact target.

## First aliases to create in Google Workspace

- `contact@encryptedguru.com`
- `security@encryptedguru.com`
- `ops@encryptedguru.com`
- `alerts@encryptedguru.com`

## Security posture

- No secrets in the static site.
- No forms in v0.2.
- No tracking scripts.
- Keep `/.well-known/security.txt` published.
- The source repository is public; operational runbooks and account-recovery
  material stay in a private operational repository.
- Keep `_headers` and `_redirects` reviewed in source control.
- Never deploy the repository root; operational Markdown and scripts are source
  artifacts, not public site assets.
- Keep the source-route Function limited by `_routes.json`; expanding it to
  `/*` would convert normal static requests into metered Function requests.
