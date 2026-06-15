# Cloudflare Pages Setup

Purpose: connect the private GitHub repository to Cloudflare Pages and make `main` the production deployment source.

## Current GitHub Source

- Repository: `https://github.com/EncGur/encryptedguru-site`
- Visibility: private
- Production branch: `main`
- Latest synchronized commit at setup time: `6586be4 Record completed GitHub synchronization`

## Current Cloudflare Blocker

Cloudflare dashboard is not logged in in the active Chrome session. The page shows:

- `Sign in to Cloudflare`
- `Verify you are human`

Complete Cloudflare login and human verification manually before continuing.

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
   - empty
8. Build output directory:
   - `/`
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

## Expected Source-Control Behavior

Cloudflare Pages should read:

- `_headers`
- `_redirects`

This should preserve:

- apex-to-www redirect
- security headers
- cache policy
- `security.txt` content type

## Post-Deploy Verification

Run:

```sh
./scripts/verify-live.sh --strict-post-deploy
```

Expected:

- Apex redirects to `https://www.encryptedguru.com/`.
- Final homepage response is `200`.
- Security headers are present.
- Live `/.well-known/security.txt` includes:
  - `Expires: 2027-06-14T00:00:00Z`

## Stop Conditions

- Cloudflare asks for credentials, 2FA, or human verification.
- GitHub authorization asks for broader account permissions than repository access to `EncGur/encryptedguru-site`.
- Build output directory cannot be set to `/`.
- Deployment preview does not include `_headers` or `_redirects`.
- Custom domain setup would overwrite Google Workspace MX, SPF, DKIM, or DMARC records.
