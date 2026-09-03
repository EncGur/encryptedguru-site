# EncryptedGuru current project state

Updated: 2026-09-03

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
- The public source build is static and contains no forms, database, analytics,
  pixels, advertising network, or public admin surface. This is a source-level
  property; the production edge still needs the browser-shaped no-analytics
  check below to pass.
- `_headers`, `_redirects`, `_routes.json`, `security.txt`, the build script,
  and the live verification script are source-managed.
- Source-only Markdown, scripts, private runbook paths, credentials-like
  artifacts, and deployment internals are blocked from the public edge.
- Personal referral links for Plasma One, Bitfinex, Binance, and Aave App are
  disclosed on the recommendation page; relevant research pages carry separate
  context where applicable. They are not product guarantees or financial advice.
- Aave has a dedicated source-separated research page at `/aave/`, using the
  supplied purple portrait as its page visual and keeping the Aave App referral
  entry separate from protocol, market, token, and risk claims.
- The shared visual system uses a quieter three-level green field: deep base,
  content surface, and focused action surface. Split sections use a stable
  editorial axis on desktop; ordinary tiles carry less radius, shadow, and
  visual weight than recommendation entries.
- On wide screens, the editorial frame expands to 1440px without widening
  long-form reading measures; Recommendations uses a tighter action-first
  opening so the four referral entries appear in the first desktop row.
- The mobile page-title override keeps long headings inside the content
  measure; the 390px acceptance pass showed zero horizontal overflow on the
  homepage, Recommendations, Monero, Plasma, and Aave routes.
- Recommendations is the first primary-navigation item and the homepage's
  first action; Monero, Plasma, and Aave are the primary research routes, and
  four referral entries appear in the first desktop row while the adjacent
  provider-term disclosures remain visible.
- The 2026-09-03 production browser-shaped probe found a conditional Cloudflare
  Insights beacon in the returned HTML. The strict live gate therefore remains
  intentionally red until the edge setting is removed and rechecked. Cloudflare
  documents the automatic Pages injection in its [Web Analytics setup
  guide](https://developers.cloudflare.com/pages/how-to/web-analytics/) and
  the RUM control boundary in its [RUM beacon
  guide](https://developers.cloudflare.com/speed/observatory/rum-beacon/).

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

- Production control-plane blocker: Cloudflare conditionally injects an
  Insights beacon for browser-shaped navigations despite the source-level
  zero-analytics policy. Disable Web Analytics/Insights at the Cloudflare
  account or zone edge, then rerun the strict live gate and browser DOM check.
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
  public/private edge behavior, and browser-shaped no-analytics probe pass
  strict live verification.
- The red portrait is intentional for the global brand mark, favicon, and
  browser/app icon; the homepage hero and generic social preview remain free
  of a large personal photo.
- Current-state documentation points to this file rather than a stale snapshot.
