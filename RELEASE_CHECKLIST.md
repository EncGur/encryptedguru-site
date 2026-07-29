# EncryptedGuru Release Checklist

Use this before publishing a new static-site release.

## Preflight

- [ ] Run `./scripts/audit-source.sh`.
- [ ] Run `./scripts/build-site.sh` and confirm only public assets exist in `dist/`.
- [ ] Run `./scripts/check-remote-ready.sh` after the GitHub repo and SSH key are configured.
- [ ] Confirm no secrets, tokens, private URLs, billing data, recovery codes, or unreduced screenshots are present.
- [ ] Confirm all public email addresses are intentional and active.
- [ ] Confirm `/.well-known/security.txt` is valid and `Expires` is in the future.
- [ ] Confirm `robots.txt` and `sitemap.xml` match the intended public surface.
- [ ] Confirm canonical URLs use `https://www.encryptedguru.com/`.
- [ ] Confirm `_headers` and `_redirects` match the intended Cloudflare behavior.
- [ ] Confirm Cloudflare uses build command `sh scripts/build-site.sh` and output directory `dist`.

## Local Verification

- [ ] Start local preview with `python3 -m http.server 4173 --directory dist`.
- [ ] Open `http://127.0.0.1:4173/`.
- [ ] Check homepage, Monero, docs, labs, infrastructure, contact, and `security.txt`.
- [ ] Check mobile width for navigation and text fit.
- [ ] Check that external-facing links and mail links are correct.
- [ ] Check an unknown route returns `404` rather than the homepage.

## DNS and Security Verification

- [ ] Confirm apex redirects to `www`.
- [ ] Confirm Cloudflare serves HTTPS.
- [ ] Confirm MX points to Google Workspace.
- [ ] Confirm SPF, DKIM, and DMARC are present.
- [ ] Confirm security headers remain enabled:
  - `x-content-type-options: nosniff`
  - `x-frame-options: DENY`
  - `referrer-policy: strict-origin-when-cross-origin`
  - `permissions-policy`

## Release

- [ ] Commit changes to the private source repository.
- [ ] Run `./scripts/package-release.sh` if a handoff zip is needed.
- [ ] Deploy through Cloudflare Pages or the current static host.
- [ ] Record the deployed commit or package hash.
- [ ] Keep `encryptedguru-v0.2-site.zip` only as a handoff artifact.
- [ ] If using Cloudflare Pages, confirm settings match `CLOUDFLARE_PAGES_SETUP.md`.

## Post-Release

- [ ] Run `./scripts/verify-live.sh --strict-post-deploy`.
- [ ] Confirm source Markdown, runbooks, and shell scripts return `404`.
- [ ] Record any DNS or deployment changes in the project notes.
