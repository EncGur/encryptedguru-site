# EncryptedGuru v0.1

Static site for encryptedguru.com.

Purpose:

- Public identity for EncryptedGuru.
- Documentation entry point for infrastructure, cloud, network, and AI workflow notes.
- Minimal public surface: no forms, no analytics, no newsletter, no database.

Local preview:

```sh
python3 -m http.server 4173
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
- `runbooks/`: private-operational runbooks for DNS, deploy, mail auth, and emergency access.

Release artifacts:

- `encryptedguru-v0.1-site.zip` is a local handoff artifact and is not tracked by Git.

Local commands:

```sh
./scripts/audit-source.sh
./scripts/package-release.sh
./scripts/verify-live.sh
```
