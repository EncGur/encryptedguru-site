# Cloudflare Pages Deploy Runbook

Purpose: publish the static site with a reproducible release path and a tested rollback.

## Preconditions

- Source lives in a private Git repository.
- Cloudflare Pages project is connected to that repository.
- Build command is `sh scripts/build-site.sh`.
- Output directory is `dist`.
- Custom domains are attached:
  - `encryptedguru.com`
  - `www.encryptedguru.com`

## Pre-Deploy

1. Run the release checklist.
2. Run `./scripts/build-site.sh` and inspect the allowlisted `dist/` output.
3. Confirm `security.txt` has a future `Expires` value.
4. Confirm `_headers`, `_redirects`, `_routes.json`, and `404.html` are present in `dist/`.
5. Confirm no secrets are present:

```sh
find . -type f \( -name '*.html' -o -name '*.txt' -o -name '*.xml' -o -name '*.md' -o -name '*.js' -o -name '*.css' -o -name '*.webmanifest' \) -print0 | xargs -0 grep -nEi "secret|token|password|private key|api[_-]?key|bearer|BEGIN (RSA|OPENSSH|PRIVATE)" || true
```

## Deploy

1. Commit the release.
2. Push to the deployment branch.
3. Wait for Cloudflare Pages to finish.
4. Record deployed commit SHA.

## Verify

```sh
curl -I -L https://encryptedguru.com/
curl -I https://www.encryptedguru.com/
curl -sS https://www.encryptedguru.com/.well-known/security.txt
curl -sS https://www.encryptedguru.com/sitemap.xml
```

Expected:
- Apex redirects to `https://www.encryptedguru.com/`.
- Homepage returns `200`.
- Security headers are present.
- `security.txt` includes `Expires`.
- `/monero/` returns `200`.
- unknown routes and source-only files return `404`.
- normal HTML routes remain static and are excluded from Function invocation.

## Rollback

Use Cloudflare Pages deployment rollback to restore the previous known-good commit. Then rerun verification.

## Stop Conditions

- Homepage does not return `200`.
- Apex redirect breaks.
- Security headers disappear.
- `security.txt` is missing or stale.
