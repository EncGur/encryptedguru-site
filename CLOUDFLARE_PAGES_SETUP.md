# Cloudflare Pages Setup

Purpose: connect the private GitHub repository to Cloudflare Pages and make `main` the production deployment source.

## Current GitHub Source

- Repository: `https://github.com/EncGur/encryptedguru-site`
- Visibility: private
- Production branch: `main`
- Latest synchronized commit at setup time: `6586be4 Record completed GitHub synchronization`

## Current Cloudflare State

Cloudflare Pages is connected and serving production from the private GitHub
repository.

Production state:

- Pages project: `encryptedguru-site`
- Pages preview: `https://encryptedguru-site.pages.dev/`
- Canonical production URL: `https://www.encryptedguru.com/`
- Apex redirect: `https://encryptedguru.com/` to
  `https://www.encryptedguru.com/`

Historical blocker:

- `www.encryptedguru.com` initially could not be attached because an old Worker
  custom domain created a read-only DNS record.
- Old Worker: `sparkling-cake-ec49`
- Fix: remove `encryptedguru.com` and `www.encryptedguru.com` from that Worker's
  `Domains` tab, then attach them to the Pages project.

## Create Pages Project

Open:

```text
https://dash.cloudflare.com/?to=/:account/pages/new/provider/github
```

Expected path:

1. Choose GitHub as provider.
2. Authorize Cloudflare Pages to access `EncGur/encryptedguru-site`.
3. Select repository:
   - `EncGur/encryptedguru-site`
4. Project name:
   - `encryptedguru-site`
5. Production branch:
   - `main`
6. Framework preset:
   - None
7. Build command:
   - `sh scripts/build-site.sh`
8. Build output directory:
   - `dist`
9. Environment variables:
   - none
10. Deploy.

## Custom Domains

Attach:

- `www.encryptedguru.com`
- `encryptedguru.com`

Canonical direction:

- `https://encryptedguru.com/*` redirects to `https://www.encryptedguru.com/:splat`

The source-controlled `_redirects` file already represents this policy.

If Cloudflare shows `Unable to edit this record as this has been configured as
read only`, inspect Workers & Pages before changing DNS. A Worker custom domain
or another managed Cloudflare product may own the record.

## Expected Source-Control Behavior

Cloudflare Pages should read:

- `_headers`
- `_redirects`
- `_routes.json`
- `404.html`

This should preserve:

- apex-to-www redirect
- security headers
- cache policy
- `security.txt` content type
- real `404` responses for unpublished routes
- exclusion of source Markdown, runbooks, scripts, and Git metadata
- a non-cacheable `404` guard for source-only routes, including stale CDN objects

## Post-Deploy Verification

Run:

```sh
./scripts/verify-live.sh --strict-post-deploy
```

Expected:

- Apex redirects to `https://www.encryptedguru.com/`.
- Final homepage response is `200`.
- Security headers are present.
- `/monero/` returns `200` with the expected heading.
- unpublished source paths and unknown routes return `404`.
- Live `/.well-known/security.txt` includes:
  - `Expires: 2027-06-14T00:00:00Z`

Last known strict verification:

- Date: 2026-06-15
- Result: passed
- Record: `POST_DEPLOYMENT_RECORD_2026-06-15.md`

## Stop Conditions

- Cloudflare asks for credentials, 2FA, or human verification.
- GitHub authorization asks for broader account permissions than repository access to `EncGur/encryptedguru-site`.
- Build command cannot run `sh scripts/build-site.sh` or the output directory
  cannot be set to `dist`.
- Deployment preview does not include `_headers` or `_redirects`.
- `_routes.json` expands Function execution beyond source-only paths.
- Custom domain setup would overwrite Google Workspace MX, SPF, DKIM, or DMARC records.
