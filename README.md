# EncryptedGuru

Static site for encryptedguru.com.

Purpose:

- Public identity for EncryptedGuru.
- Documentation entry point for Monero, infrastructure, cloud, network, AI workflow notes, and engineering projects.
- Minimal public surface: no forms, no analytics, no newsletter, no database.

The source repository is public and open source:

- Repository: `https://github.com/EncGur/encryptedguru-site`
- Production branch: `main`
- Live site: `https://www.encryptedguru.com/`
- Security contact: `https://www.encryptedguru.com/.well-known/security.txt`

## Public / Private Boundary

This repository is intentionally public. It contains the site source, the
build pipeline, and public-facing documentation only.

The following material is NOT public and must never be committed here:

- Operational runbooks (DNS change, mail auth, emergency access, deploy
  procedures). These live in a private operational repository.
- Local machine paths, usernames, device names, SSH aliases, SSH key
  filenames, or account-recovery topology.
- Credentials, tokens, keys, recovery codes, or private URLs of any kind.

Public pages may describe principles, notes, and contact paths. Admin
surfaces, consoles, credentials, billing, and private lab controls must not be
exposed by default.

## Local preview

```sh
./scripts/build-site.sh
python3 -m http.server 4173 --directory dist
```

Open:

```text
http://127.0.0.1:4173/
```

## Deploy targets

- Cloudflare Pages (production)
- Firebase Hosting
- GitHub Pages
- Any static web host

## Operational documents

- `FIRST_PRINCIPLES_BUILD.md`: historical first-principles build plan and v0.2 order.
- `PROJECT_STATE.md`: current source, production, public-boundary, and open-risk state.
- `aave/index.html`: source-backed Aave protocol, market, risk, and referral research note.
- `recommendations/index.html`: public referral and editorial-disclosure policy.
- `SECURITY_AUDIT_2026-06-14.md`: historical public-surface audit.
- `RELEASE_CHECKLIST.md`: pre-release and post-release checks.
- `REMOTE_SETUP.md`: public repository and Cloudflare Pages setup steps.
- `CLOUDFLARE_PAGES_SETUP.md`: exact Cloudflare Pages connection and verification path.
- `POST_DEPLOYMENT_RECORD_2026-06-15.md`: production cutover and verification record.
- `POST_DEPLOYMENT_RECORD_2026-07-29.md`: v0.2 Monero release, public-boundary remediation, and live verification record.
- `MONERO_SOURCE_AUDIT_2026-07-29.md`: source, license, stale-content, and current-doc audit for `/monero/`.
- `SECURITY.md`: responsible-disclosure policy for this repository.

Operational runbooks are intentionally not part of the public repository; they
are maintained in a private operational repository.

## Release artifacts

- `dist/` is the allowlisted public build and is not tracked by Git.
- `functions/[[path]].js` returns `404` only for source-only routes selected by
  `_routes.json`; normal static pages do not invoke the Function.
- `encryptedguru-v0.3-site.zip` is a local handoff artifact and is not tracked by Git.

## Local commands

```sh
./scripts/audit-source.sh
./scripts/build-site.sh
./scripts/package-release.sh
./scripts/verify-live.sh
./scripts/verify-live.sh --strict-post-deploy
./scripts/check-remote-ready.sh
```
