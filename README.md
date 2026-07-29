# EncryptedGuru v0.2

Static site for encryptedguru.com.

Purpose:

- Public identity for EncryptedGuru.
- Documentation entry point for Monero, infrastructure, cloud, network, and AI workflow notes.
- Minimal public surface: no forms, no analytics, no newsletter, no database.

Local preview:

```sh
./scripts/build-site.sh
python3 -m http.server 4173 --directory dist
```

Open:

```text
http://127.0.0.1:4173/
```

Deploy targets:

- Cloudflare Pages
- Firebase Hosting
- GitHub Pages
- Any static web host

Operational documents:

- `FIRST_PRINCIPLES_BUILD.md`: first-principles build plan and v0.2 order.
- `SECURITY_AUDIT_2026-06-14.md`: current public-surface audit.
- `RELEASE_CHECKLIST.md`: pre-release and post-release checks.
- `REMOTE_SETUP.md`: private remote and Cloudflare Pages setup steps.
- `CLOUDFLARE_PAGES_SETUP.md`: exact Cloudflare Pages connection and verification path.
- `POST_DEPLOYMENT_RECORD_2026-06-15.md`: production cutover and verification record.
- `MONERO_SOURCE_AUDIT_2026-07-29.md`: source, license, stale-content, and current-doc audit for `/monero/`.
- `runbooks/`: private-operational runbooks for DNS, deploy, mail auth, and emergency access.
- `runbooks/DSX_AIR_LAB_RUNBOOK.md`: private DSX Air lab execution discipline.

Release artifacts:

- `dist/` is the allowlisted public build and is not tracked by Git.
- `functions/[[path]].js` returns `404` only for source-only routes selected by
  `_routes.json`; normal static pages do not invoke the Function.
- `encryptedguru-v0.2-site.zip` is a local handoff artifact and is not tracked by Git.

Local commands:

```sh
./scripts/audit-source.sh
./scripts/build-site.sh
./scripts/package-release.sh
./scripts/verify-live.sh
./scripts/verify-live.sh --strict-post-deploy
./scripts/check-remote-ready.sh
```
