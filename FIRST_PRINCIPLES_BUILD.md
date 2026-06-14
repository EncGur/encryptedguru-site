# EncryptedGuru First-Principles Build Plan

Generated: 2026-06-14

## Core Thesis

EncryptedGuru should be a small, inspectable public boundary for a personal sovereign systems lab.

The site is not a marketing funnel. It is a namespace, trust surface, operating notebook, and recovery anchor for infrastructure, cloud, network simulation, and AI workflow work.

## First Principles

1. Own the namespace.
   - The domain is the root of identity, email, future service names, and public trust.
   - DNS, email authentication, security contact, and recovery ownership matter before visual polish.

2. Keep the public surface static by default.
   - Static pages reduce attack surface, operational cost, and recovery complexity.
   - Dynamic systems should be added only when they have a clear operational purpose and a rollback path.

3. Separate public proof from private control.
   - Public pages may describe principles, notes, and contact paths.
   - Admin surfaces, consoles, credentials, billing, and private lab controls must not be exposed by default.

4. Make every system explainable under pressure.
   - Each service needs a purpose, owner, dependency list, recovery path, and verifier.
   - If it cannot be rebuilt or explained, it is not production-worthy.

5. Prefer durable records over memory.
   - Decisions, DNS changes, deployment notes, runbooks, and incident lessons should live in files.
   - Chats can steer work, but artifacts should carry state forward.

## Current Verified State

- `https://encryptedguru.com` redirects to `https://www.encryptedguru.com/`.
- `https://www.encryptedguru.com/` serves the static v0.1 site through Cloudflare.
- `https://www.encryptedguru.com/.well-known/security.txt` is published.
- Public DNS via `1.1.1.1` and `8.8.8.8` resolves the site to Cloudflare IPs:
  - `104.21.95.110`
  - `172.67.144.164`
- MX points to Google Workspace:
  - `1 smtp.google.com.`
- SPF is present:
  - `v=spf1 include:_spf.google.com ~all`
- DMARC is present:
  - `v=DMARC1; p=none; rua=mailto:eg@encryptedguru.com; fo=1`
- Google Workspace DKIM is present at `google._domainkey.encryptedguru.com`.
- Local resolver returned `198.18.0.91` for the apex during audit. Public resolvers did not. Treat this as local proxy, gateway, or DNS interception behavior unless reproduced externally.
- Local project folder is not currently a Git repository.

## Main Gaps

1. No repository-backed deployment workflow is visible locally.
2. DMARC is currently monitoring-only with `p=none`; this is fine for observation, but it is not enforcement.
3. Public docs exist, but operational runbooks are still thin.
4. Planned subdomains are documented but not yet backed by clear activation criteria.
5. Live `security.txt` still needs the local `Expires` update deployed.

## V0.2 Build Order

### Phase 1: Trust Baseline

Goal: make the namespace and contact surface verifiable.

Actions:
- Confirm Google Workspace aliases exist:
  - `contact@encryptedguru.com`
  - `security@encryptedguru.com`
  - `ops@encryptedguru.com`
  - `alerts@encryptedguru.com`
- Confirm DKIM TXT record is enabled and passing.
- Add DMARC TXT record if missing.
- Keep SPF aligned with Google Workspace.
- Keep `security.txt` valid and renew `Expires` before 2027-06-14.

Verifier:
- DNS query shows MX, SPF, DKIM, and DMARC.
- Test email reaches `security@encryptedguru.com`.
- `security.txt` includes `Contact`, `Expires`, `Canonical`, and `Policy`.

### Phase 2: Deployment Discipline

Goal: make the static site reproducible.

Actions:
- Put the site folder in a private Git repository.
- Connect repository to Cloudflare Pages.
- Record deployment owner, build settings, and rollback steps.
- Preserve a zip release artifact only as a secondary handoff, not the source of truth.

Verifier:
- A clean clone can deploy the same site.
- Cloudflare Pages shows the connected commit for the live deployment.
- Rollback path is documented and tested once.

### Phase 3: Runbook Layer

Goal: turn principles into operating documents.

Actions:
- Add internal runbooks for:
  - DNS changes
  - Google Workspace recovery
  - Cloudflare Pages deploy and rollback
  - Lost-device and emergency access
  - Lab teardown and cost control
- Publish only non-sensitive summaries publicly.

Verifier:
- Each runbook has purpose, prerequisites, steps, rollback, and verifier.
- No secrets, account recovery details, or private URLs are published.

### Phase 4: Lab Output

Goal: make labs useful without becoming a public control plane.

Actions:
- Keep `/labs/` as a public index of completed or sanitized lab notes.
- Keep raw configs, credentials, and unreduced screenshots private.
- For DSX Air work, publish topology lessons, failure modes, and rollback patterns.

Verifier:
- Every public lab note has a clear learning objective and no sensitive material.
- Every private lab has a stop condition and cost/resource note.

### Phase 5: Future Services

Goal: activate subdomains only when they have real jobs.

Activation rules:
- `docs.encryptedguru.com`: only if docs outgrow the current static `/docs/` path.
- `lab.encryptedguru.com`: only if lab logs need a dedicated static archive.
- `status.encryptedguru.com`: only when at least one real service needs public status.
- `console.encryptedguru.com`: private access only; never public by default.

Verifier:
- Each subdomain has an owner, access model, DNS record, TLS state, and rollback path before launch.

## Immediate Next Checklist

- [x] Confirm live site resolves and serves through Cloudflare.
- [x] Confirm `security.txt` exists.
- [x] Add `Expires` to local `security.txt`.
- [x] Add a deployment release checklist.
- [x] Add source-controlled Cloudflare `_headers` and `_redirects`.
- [x] Add audit report and first private runbooks.
- [x] Initialize local Git source repository.
- [x] Add repeatable audit, package, and live-verification scripts.
- [x] Refresh `encryptedguru-v0.1-site.zip` with current local files.
- [x] Confirm DKIM and DMARC.
- [ ] Confirm live `security.txt` after next deployment.
- [ ] Create or attach private Git remote source of truth.
