# EncryptedGuru Security Audit

Date: 2026-06-14
Scope: public static site, DNS evidence, email-authentication evidence, release hygiene.

## Executive Result

The public site is suitable as a small static trust surface. The main engineering gap is not an exposed vulnerability in the current site; it is operational reproducibility. The source folder is not a Git repository, and Cloudflare behavior was not fully represented as source-controlled deployment files before this audit.

## Evidence Collected

### Public HTTP

- `https://encryptedguru.com/` returns `301` to `https://www.encryptedguru.com/`.
- `https://www.encryptedguru.com/` returns `200`.
- Cloudflare is serving the site.
- Observed response headers include:
  - `x-content-type-options: nosniff`
  - `x-frame-options: DENY`
  - `referrer-policy: strict-origin-when-cross-origin`
  - `permissions-policy: camera=(), microphone=(), geolocation=(), payment=()`

### DNS and Mail

Public resolver checked: `1.1.1.1`.

- Apex A records:
  - `172.67.144.164`
  - `104.21.95.110`
- `www` A records:
  - `104.21.95.110`
  - `172.67.144.164`
- MX:
  - `1 smtp.google.com.`
- SPF:
  - `v=spf1 include:_spf.google.com ~all`
- DMARC:
  - `v=DMARC1; p=none; rua=mailto:eg@encryptedguru.com; fo=1`
- DKIM:
  - Google Workspace selector exists at `google._domainkey.encryptedguru.com`.

### Local Source Hygiene

Text scan across HTML, CSS, JS, XML, TXT, manifest, and Markdown found no apparent secrets. Hits were only policy text mentioning words such as `secret`, `token`, or `private`.

## Findings

### P1: Deployment Source of Truth Is Not Established

The local folder is not a Git repository. That means live deployment state cannot yet be cleanly tied to a commit, reviewed diff, or rollback point from this folder alone.

Action:
- Create or locate the private repository that Cloudflare Pages should deploy from.
- Make Git commit SHA the release identity.
- Keep zip files as handoff artifacts only.

Verifier:
- `git status` works in the source folder.
- Cloudflare Pages shows the deployed commit.
- A clean clone can reproduce the site.

### P2: Cloudflare Runtime Behavior Needed Source Files

Live headers are good, but relying only on dashboard state makes drift harder to detect. This audit added `_headers` and `_redirects` so Cloudflare Pages behavior can be reviewed in source.

Action:
- Deploy `_headers` and `_redirects`.
- Verify headers and apex redirect after deployment.

Verifier:
- `curl -I -L https://encryptedguru.com/` still shows apex-to-www redirect.
- `curl -I https://www.encryptedguru.com/` shows expected security headers.

### P2: DMARC Is Monitoring-Only

DMARC exists with `p=none`, which is correct for early observation but does not enforce rejection or quarantine.

Action:
- Monitor aggregate reports.
- Move to `p=quarantine` only after expected senders are confirmed.
- Move to `p=reject` only after quarantine period is clean.

Verifier:
- No legitimate mail source fails SPF/DKIM alignment before enforcement.

### P3: Operational Runbooks Are Still Thin

Public principles exist, but recovery-grade runbooks need procedure-level detail.

Action:
- Maintain private runbooks for DNS, Cloudflare deployment, Google Workspace mail authentication, and emergency access.

Verifier:
- A trusted operator can follow a runbook without relying on chat memory.

## Executed Changes

- Added `_headers`.
- Added `_redirects`.
- Added `FIRST_PRINCIPLES_BUILD.md`.
- Added `RELEASE_CHECKLIST.md`.
- Added this audit report.
- Updated local `security.txt` with `Expires`.

## Next Gate

Do not expand product surface until the private repository and deployment source of truth are established.

Local source-control initialization was started after this audit. The remote private repository still needs to be created or attached before Cloudflare Pages can use Git commits as the release identity.
