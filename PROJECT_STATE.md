# EncryptedGuru current project state

Updated: 2026-09-05

## Goal

Build EncryptedGuru as an independent research system for sovereign capital:
identity, control, liquidity, settlement rails, allocation, and lifelong learning.
Maintain a small, inspectable public boundary with source-linked claims and
clear separation from private operational control.

## 2026-09-05 release

- Home now leads with Sovereign Capital Intelligence, two primary actions,
  a Tether / Plasma / USDT0 research map, four recommendation shortcuts, and
  the learning / verification / allocation / audit loop.
- `/thesis/` publishes the enduring framework with five anchored chapters,
  desktop contents navigation, and linked primary sources. The three project
  layer labels are explicitly an editorial interpretation. Documentation
  review dates are scoped to the actual summaries reviewed.
- Recommendations stays first in all 15 page navigation bars. Thesis is second;
  supplementary pages move into More. On phones, research links also live in
  More so the header uses two compact rows.
- Recommendation cards have stable deep links, aligned primary actions,
  readable codes, clipboard controls, and visible referral disclosures.
  The Aave clipboard action copies the complete referral URL.
- The original red portrait remains the brand mark. The new 1200-by-630 social
  preview is generated from source-managed SVG and matches the homepage copy.
- Decorative canvases were removed from public pages together with the dead
  animation code and CSS. More supports native opening, Escape, outside-click
  dismissal, and focus departure; below 861px the menu anchors to the
  navigation bar's right edge so it never leaves the viewport. Main script
  loading opts out of Rocket Loader with `data-cfasync="false"` placed before
  `src`, as Cloudflare requires.
- Decorative arrows are hidden from assistive technology, action groups carry
  `role="group"`, the thesis mantras are plain paragraphs rather than
  quotations, and the copy control keeps keyboard focus.
- Cache-busting values were chosen fresh at release time (`sovereign-v2`,
  `og-home.png?v=20260905b`) because the edge caches any versioned URL that was
  probed before the deploy.
- Local checks pass for source hygiene, all internal destinations and fragment
  links, landmarks, referral integrity, and existing route/boundary tests.
- Production acceptance for this release is pending until the pushed version
  passes the strict live gate and rendered checks.

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
  long-form reading measures; Recommendations puts four referral entries in
  the first desktop row, two per row on tablets, and one per row on phones.
- The mobile page-title override keeps long headings inside the content
  measure; the 390px acceptance pass showed zero horizontal overflow on the
  homepage, Recommendations, Monero, Plasma, and Aave routes.
- Recommendations is the first primary-navigation item and the homepage's
  first action; Monero, Plasma, and Aave are the primary research routes, and
  four referral entries appear in the first desktop row while the adjacent
  provider-term disclosures remain visible.
- The 2026-09-03 audit first found a conditional Cloudflare Insights beacon in
  browser-shaped production HTML. The account-level `encryptedguru.com` RUM
  site was then changed to `Disable`; the final browser-shaped response and
  Chrome DOM checks returned no beacon, and the strict live gate passed.
  Cloudflare documents the automatic Pages injection in its [Web Analytics
  setup guide](https://developers.cloudflare.com/pages/how-to/web-analytics/)
  and the RUM control boundary in its [RUM beacon
  guide](https://developers.cloudflare.com/speed/observatory/rum-beacon/).

## Verification gates

Run these before a production release:

```sh
./scripts/audit-source.sh
./scripts/build-site.sh
./tests/test-plasma-redirect.sh
./tests/test-projects.sh
./tests/test-public-boundary.sh
./tests/test-reproducible-package.sh
python3 tests/test-site-structure.py
./scripts/verify-live.sh --strict-post-deploy
```

## Open risks

- Cloudflare Rocket Loader is still enabled at the edge. `data-cfasync="false"`
  exempts `/main.js` from rewriting, but Cloudflare still injects
  `rocket-loader.min.js` into browser-shaped responses and the strict gate
  still warns. Disable Rocket Loader in the zone speed settings if a
  source-matching response is wanted.
- DMARC remains monitoring-only with `p=none`; change only after sender
  alignment is understood.
- A real-device pass (iPhone and Android) for the More menu and the copy
  controls is still pending; only emulated viewports have been checked.
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
