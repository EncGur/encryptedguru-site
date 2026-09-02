# EncryptedGuru current project state

Updated: 2026-09-02

## Goal

Maintain a small, inspectable public boundary for EncryptedGuru's financial
privacy, network, infrastructure, and AI workflow notes. Public claims should
be source-linked, clearly scoped, reproducible where practical, and separated
from private operational control.

## Current verified state

- Production source is the public `EncGur/encryptedguru-site` repository on the
  `main` branch.
- The current release identity for this change is the Git commit recorded at
  release time; production is served at `https://www.encryptedguru.com/`.
- The apex redirects to the canonical `www` host.
- The public site is static and has no forms, database, analytics, pixels,
  advertising network, or public admin surface.
- `_headers`, `_redirects`, `_routes.json`, `security.txt`, the build script,
  and the live verification script are source-managed.
- Source-only Markdown, scripts, private runbook paths, credentials-like
  artifacts, and deployment internals are blocked from the public edge.
- Personal referral links for Plasma One, Bitfinex, Binance, and Aave App are
  disclosed on the recommendation page; relevant research pages carry separate
  context where applicable. They are not product guarantees or financial advice.
- Recommendations are a first-class public route in the primary navigation;
  visual prominence does not remove the adjacent provider-term disclosures.

## Verification gates

Run these before a production release:

```sh
./scripts/audit-source.sh
./scripts/build-site.sh
./tests/test-plasma-redirect.sh
./tests/test-projects.sh
./tests/test-public-boundary.sh
./scripts/verify-live.sh --strict-post-deploy
```

## Open risks

- DMARC remains monitoring-only with `p=none`; change only after sender
  alignment is understood.
- Mobile animation performance still needs a real-device measurement pass.
- Provider eligibility, fees, geography, KYC, custody, withdrawals, rewards,
  and supported products are time-sensitive external facts.
- Research pages need periodic review when their status dates or external
  sources become stale.

## Done when

- The source build and boundary tests pass.
- The production route, headers, sitemap, security.txt, recommendation entry,
  and public/private edge behavior pass strict live verification.
- The red portrait is intentional for the global brand mark, favicon, and
  browser/app icon; the homepage hero and generic social preview remain free
  of a large personal photo.
- Current-state documentation points to this file rather than a stale snapshot.
