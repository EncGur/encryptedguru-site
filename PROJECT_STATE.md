# EncryptedGuru current project state

Updated: 2026-09-08

## Goal

Build EncryptedGuru as an independent research system for sovereign capital:
identity, control, liquidity, settlement rails, allocation, and lifelong learning.
Maintain a small, inspectable public boundary with source-linked claims and
clear separation from private operational control.

## 2026-09-08 density and responsive navigation

- Introduced one shared `--meta-size` token at 0.75rem so secondary metadata
  stays at or above the 12px readability floor across the map, page labels,
  referral values, decision frames, and footer groups.
- Raised compact navigation text to the 14px floor and moved the three topic
  links into the native More menu at widths up to 1120px. The research routes
  remain directly available, but the persistent navigation now presents only
  the primary action, thesis, and library decision points.
- Reduced first-screen and section spacing, and shortened the research title
  image measure so the actual note and decision frame arrive sooner without
  removing the supplied topic imagery.
- Added source regressions for the type floor, responsive navigation contract,
  and shorter research title measure. Bumped every public HTML page to the
  `20260908-minimal-v9` CSS asset. No content claims, referral URLs, provider
  terms, analytics, DNS, or external settings changed.

## 2026-09-08 visual acceptance and mobile overflow correction

- Real viewport review at approximately 964px found that the Monero, Plasma,
  and Aave research titles were bottom-aligned against tall portraits, leaving
  an avoidable blank zone before the primary reading content. A bounded
  861–1120px rule now centers those title blocks and shortens the portrait
  measure; the local Monero, Plasma, and Aave renders returned their subjects
  to the first reading zone.
- A separate 390px viewport review exposed horizontal overflow that was hidden
  rather than solved: intrinsic grid children, long research copy, referral
  cards, and the two homepage hero controls could exceed the frame. Grid items
  now have an explicit zero minimum, and narrow homepage actions stack at full
  width. This preserves the desktop hierarchy while making the mobile layout
  fit the viewport.
- Local visual rechecks covered the homepage, Recommendations, and Aave after
  the responsive correction. Added source regressions for the tablet title rule,
  shrinkable mobile grid items, and stacked mobile hero actions. Bumped every
  public HTML page to the `20260908-minimal-v11` CSS asset. No content claims,
  referral URLs, provider terms, analytics, DNS, or external settings changed.

## 2026-09-08 cascade debt reduction

- Removed pre-minimal declarations that were unconditionally superseded by the
  final flat interface contract: obsolete header and control sizing, duplicate
  page-title spacing, image compositing, visual shadows, tile hover lifts, and
  retired desktop/mobile breakpoint overrides.
- Retained the rules that still carry structure or meaning, including the
  responsive research-image stack, compact tile minimum, content measures,
  focus behavior, and topic-specific Aave treatment. This is a stylesheet
  simplification, not a visual-content rewrite.
- Added no new public claims or external actions. Referral URLs, provider
  disclosures, research copy, brand assets, routes, and external settings are
  unchanged. Bumped every public HTML page to the
  `20260908-minimal-v9` CSS asset so edge caches cannot mix the cascade before
  and after cleanup.

## 2026-09-08 responsive control sizing

- Consolidated the Recommendations desktop breakpoint into one rule so the
  four-column entry layout has a single source of truth from 861px upward.
- Removed the legacy 861–1000px button shrink that reduced recommendation
  actions to 0.8rem text and overly narrow horizontal padding. The shared
  control sizing now remains readable while the cards continue to collapse at
  the existing mobile breakpoints.
- Bumped every public HTML page to the `20260908-minimal-v5` CSS asset and
  added a regression assertion for the retired fit-to-four-cards override.
  No content, route, referral URL, provider term, or external setting changed.

## 2026-09-08 compositing reduction

- Removed the last effective drop shadow from the More menu and disabled the
  top-level backdrop blur in the final interface layer. The header and menu
  now use opaque flat surfaces with borders as their separation mechanism.
- Added local and strict-live assertions for the flat header/menu contract.
  This reduces visual noise and browser compositing work without changing
  navigation, content, referrals, or the red portrait brand mark.
- Bumped every public HTML page to the `20260908-minimal-v6` CSS asset.

## 2026-09-08 interaction type floor

- Raised recurring action text to the 14px readability floor: copy controls,
  thesis navigation, research-card links, the homepage recommendation entry,
  the Playbook entry links, and research context links.
- Shortened the visible copy action to `Copy` while retaining its specific
  accessible label, reducing referral-card width pressure without removing
  context for assistive technology.
- Added a source regression for the interactive type floor and bumped every
  public HTML page to the `20260908-minimal-v7` CSS asset.

## 2026-09-08 minimalist interface pass

- Applied a reduction-first visual system across all public pages: one deep
  background, one green action accent, a shared 1280px editorial frame,
  hairline boundaries, restrained corner radii, flat surfaces, and no
  decorative shadows or hero dot fields.
- Preserved the deliberate exceptions that carry meaning: the red portrait
  brand mark, the supplied research-page imagery, the purple Aave accent, and
  the filled Recommendations action when it is the current route.
- Reduced competing visual hierarchy in the header, buttons, cards, home
  capital map, recommendation entries, research frames, public-boundary blocks,
  and footer. Raised ordinary tile and research-frame copy to a readable 1rem
  while keeping only secondary metadata compact.
- Removed unreferenced legacy hero, signal, status-panel, and recommendation-
  highlight rule trees from the stylesheet so the reduction is a durable
  component constraint rather than a visual override over dormant layouts.
- Fixed a page-title cascade issue where the final editorial review note could
  inherit the large hero-deck size. Review notes now stay explicitly scoped as
  metadata on Recommendations and the Playbook.
- Bumped every public HTML page to the new `20260908-minimal-v2` CSS asset so
  the visual system is consistent and edge caches cannot mix old and new
  layout rules. No content claims, referral URLs, analytics, forms, or external
  provider settings were changed.
- Consolidated the final palette and canvas background into the root token
  source, removing duplicate late-stage token/body definitions. The stylesheet
  now has one background field and one shared frame contract rather than a
  historical cascade that only happened to resolve correctly.
- Local source, build, structure, public-boundary, reproducible-package, and
  syntax gates pass. The site-content release is committed as `54f75ec`; the
  follow-up token and stylesheet consolidation is committed as `f89087e` and
  pushed to `main`. Strict production verification passed after propagation on
  2026-09-08 with the expanded whole-surface checks in
  `scripts/verify-live.sh --strict-post-deploy`.
- Automated proof covers the returned HTML/CSS, routes, headers, boundaries,
  and asset version. Device-level visual acceptance remains a separate
  follow-up surface because it cannot be established from a source or HTTP
  check alone.
- A CI portability regression was found after this release: the GitHub-hosted
  runner does not provide `rg`, while the cache-version assertion in
  `tests/test-projects.sh` had started using it. The assertion now iterates the
  declared page set with POSIX `grep`; the full local suite passes without that
  dependency. GitHub Actions is the final independent confirmation after push.

## 2026-09-08 dead-state cleanup

- Audited the CSS class inventory against every current public HTML page. The
  only exact CSS class with no HTML consumer was the historical `.grid.five`
  variant; its base, tablet, and mobile rules were removed.
- Added a regression assertion so the stylesheet cannot quietly regain that
  dormant five-column state, and bumped all public pages to the
  `20260908-minimal-v3` asset after the CSS changed.
- This is a structural reduction only. No content, route, referral URL,
  provider term, or external setting changed.

## 2026-09-08 cascade consolidation

- Removed visual declarations that were already overridden by the final flat
  interface layer: legacy panel/shadow tokens, surface gradients, and hidden
  lift effects on tiles, path cards, referral surfaces, the capital map, and
  the homepage entry feature.
- Kept only gradients that serve a real reading function over research images;
  the current source now expresses the same flat-surface rule directly rather
  than relying on a late override to cancel ornamental depth.
- Added a regression assertion for the retired panel/shadow token family and
  bumped all public pages to the `20260908-minimal-v4` asset. No content,
  route, referral URL, provider term, or external setting changed.

## 2026-09-08 browser canvas alignment

- Aligned the browser and PWA shell colors with the single site canvas value:
  ordinary pages, the 404 surface, and the manifest now use `#0b100d`.
- Kept Aave's `#100c19` theme color as the one topic-specific purple
  exception, matching its research-image treatment.
- Added regression checks for ordinary-page metadata and PWA colors. This
  changes no page content, route, referral URL, provider term, or external
  setting.

## 2026-09-08 research-frame expansion

- Applied one shared six-question decision frame to the Monero, Plasma, and
  Aave research pages: problem, layer, verified evidence, dependencies,
  control, and exit/review.
- The frame is deliberately page-specific. Monero maps private-money control;
  Plasma separates network, product, token, and community signal; Aave follows
  a position from market mechanics through health and exit conditions.
- Cross-linked each frame to the Playbook decision record so the thesis,
  practice layer, research notes, and Recommendations now form a readable
  evidence path rather than isolated pages.
- Added a calm editorial grid with mobile collapse and a new cache-busted CSS
  version. No live rates, provider promises, transaction flows, analytics,
  forms, or external dashboard settings were added or changed.
- Local source, build, structure, public-boundary, reproducible-package, and
  syntax gates passed. The expansion was committed as `74468db` and pushed to
  `main`; strict production verification passed after propagation on
  2026-09-08 (Asia/Singapore), including all three decision-frame anchors and
  the new CSS asset. No Cloudflare dashboard setting, DNS record, or external
  provider terms were changed.

## 2026-09-07 Capital Operating System expansion

- Added `/playbook/` as the missing practice layer between the public thesis,
  research notes, and Recommendations. It turns the existing principles into a
  repeatable path: protect, define, verify, allocate, authorize, monitor, and
  audit/reallocate.
- The new field guide unifies six control boundaries—identity, custody,
  liquidity, rails, productivity, and exit—without presenting them as a
  prescribed portfolio, product guarantee, or personalized financial plan.
- Added a compact decision-record model covering objective, evidence, control,
  dependencies, exit, and review trigger. It is intentionally a static reading
  surface: no form, account, analytics, or persistent user data was added.
- Connected the field guide from the homepage proof section, Thesis, Docs,
  global More navigation, footer navigation, sitemap, build allowlist, and
  release tests. Recommendations remains the first primary navigation entry.
- The expansion was committed as `5c5c645` and pushed to `main`. The public
  build, route structure, and strict live verification passed after propagation
  on 2026-09-07 (Asia/Singapore). No Cloudflare dashboard setting, DNS record,
  or external provider terms were changed by this content expansion.

## 2026-09-06 first-principles audit follow-up

- Secondary routes now declare their active section inside the `More` menu at
  first paint; the runtime also normalizes nested paths such as
  `/projects/gmcp/` and `/labs/dsx-air/` before applying the state.
- Recommendation and research surfaces now carry scoped review dates. The
  dates identify an editorial or documentation review, not a promise that
  provider terms, rates, eligibility, or live parameters remain unchanged.
- Fluid is labeled `stablecoin lending` rather than `stablecoin yield`, because
  the interface is an allocation route and its output is variable.
- The homepage capital map now states that it is a research framework, not a
  prescribed stack. The Projects page no longer claims that GMCP is the
  implementation controlling this website.
- The Plasma invitation explains the app-store fallback, and Contact contains
  a no-JavaScript email path for the Cloudflare Email Obfuscation edge case.
- First-party privacy wording is scoped to EncryptedGuru's own analytics and
  profiling rather than making a claim about external providers.
- The web manifest declares `/` as both its start URL and scope.
- Site-content changes were committed as `2eff4c9` and pushed to `main`.
  Strict live verification passed after propagation on 2026-09-06, including
  the new homepage boundary, review markers, Contact fallback, and Plasma
  app-store fallback. No Cloudflare dashboard setting, DNS record, deployment
  setting, or external provider terms were changed.

## 2026-09-06 Fluid capital-productivity release

- Added Fluid Lend as a distinct `Capital productivity / stablecoin lending`
  subject. The site does not equate a stablecoin with stable yield: the
  position depends on the selected asset and network, contracts, liquidity,
  rate model, withdrawal conditions, and provider controls.
- Home now shows a four-function capital map—Tether / Plasma / USDT0 / Fluid
  Lend—and a featured Fluid entry in the current recommendations action area.
- Recommendations now contains five disclosed personal referral entries. Fluid
  is the featured stablecoin-lending entry in the first desktop row; the four
  existing entries retain their deep links and provider disclosures.
- `/thesis/#capital-productivity` documents Fluid as an allocation/productivity
  layer and links to Fluid's technical documentation. The page explicitly
  separates variable lending output from cash, bank deposits, fixed-rate, or
  guaranteed-return claims.
- Local source, build, structure, public-boundary, reproducible-package, and
  syntax gates passed. The 390px acceptance pass showed the Fluid entry and
  expanded More navigation inside the viewport without horizontal overflow.
- Pushed as commit `d70ea8f`. Production HTML contains the exact
  `https://fluid.io/9745/lending` path, the `#fluid` target, and the
  `#capital-productivity` research layer; strict live verification passed on
  2026-09-06. External Fluid market rates, limits, terms, and eligibility
  remain time-sensitive and were not represented as fixed promises.

## 2026-09-06 Rabby control-surface release

- Added Rabby as the control-surface / execution layer around the capital
  stack. Rabby is an official infrastructure entry for Ethereum and EVM wallet
  connection and signing; it is not a personal referral and is not counted as
  one of the five referral entries.
- Home now shows the five-function map: Tether / Plasma / USDT0 / Fluid Lend /
  Rabby. The homepage systems list also points to the Rabby signing-surface
  note so the path from capital productivity back to authorized execution is
  visible.
- Recommendations adds a separate `Infrastructure / control surface` block
  with the official `https://rabby.io/` entry. It states that transaction
  simulation can improve reviewability but cannot remove self-custody, device,
  phishing, contract, chain, bridge, protocol, or signature risk.
- `/infrastructure/#wallet-control` and `/thesis/#control-surface` document the
  same boundary from architecture and capital-framework perspectives. The
  official integration documentation is linked as primary material.
- Local source, build, structure, public-boundary, reproducible-package, and
  syntax gates passed. Rendered local checks showed the five-row capital map,
  the four referral cards in the first desktop row, and the Rabby control block
  without layout breakage.
- Pushed as commit `c5b5937`. Production content contains the homepage control
  link, Recommendations Rabby block, Infrastructure wallet boundary, and
  Thesis control-surface layer; strict live verification passed on 2026-09-06.

## 2026-09-06 follow-up hardening

- Corrected the navigation truth model: Recommendations remains the most
  visible entry, but it is outlined on other pages and filled only when it is
  the current route. The direct desktop research link owns the single static
  `aria-current` state; on phones, the visible research copies inside More
  mirror that state at runtime.
- Removed the first-paint blank interval caused by the entrance animation.
  Primary content remains visible before motion starts, including when the
  browser has not yet run the deferred script.
- Added accessible labels to the More navigation group and its links, and
  made the built-site structure gate enforce document language, image alt
  attributes, one More group, and no duplicate primary current-page states.
- Made CI build `dist/` explicitly before the built-site and public-boundary
  tests, so structure assertions cannot silently depend on a stale local
  artifact. Cache-busting now points all pages at the `20260906` CSS/JS
  resources.
- Pushed as commit `0ea7619`. Production HTML references both new asset
  versions, the strict live gate passed on 2026-09-06, and a live browser-shaped
  Thesis readback exposed the five anchored chapters and the corrected primary
  navigation. A physical iPhone/Android pass remains open.

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
- Production acceptance passed on 2026-09-05 for commit `f72ff84`: the
  strict live gate passed; `styles.css`, `main.js`, and `og-home.png` served
  under their new version strings match the local build byte for byte; the
  browser-shaped probe returned no analytics beacon and no Rocket Loader
  rewrite; and Chrome DOM checks at 390, 600, 768, 1024, 1440, and 2560 px
  showed no horizontal overflow, the More menu inside the viewport, four
  referral cards in the first desktop row, and no console errors.
- CI (`.github/workflows/static-audit.yml`) now runs the built-site structure
  test alongside the existing source, boundary, projects, and reproducible
  package gates.

## Current verified state

- Production source is the public `EncGur/encryptedguru-site` repository on the
  `main` branch.
- The deployed site-content release is commit `74468db` (feat: align research
  pages with decision framework). Core live HTML, the decision-frame CSS
  version, route boundaries, and security headers passed strict verification on
  2026-09-08 after propagation, while Cloudflare edge transforms remain
  observed on `contact` and `robots.txt`; the hosting deployment identifier has
  not been independently recorded here.
- Production is served at `https://www.encryptedguru.com/`.
- The apex redirects to the canonical `www` host.
- The public source build is static and contains no forms, database, analytics,
  pixels, advertising network, or public admin surface. This is a source-level
  property; the browser-shaped production no-analytics check passed on
  2026-09-06 and remains a release gate.
- `_headers`, `_redirects`, `_routes.json`, `security.txt`, the build script,
  and the live verification script are source-managed.
- Source-only Markdown, scripts, private runbook paths, credentials-like
  artifacts, and deployment internals are blocked from the public edge.
- Personal referral links for Plasma One, Fluid Lend, Bitfinex, Binance, and
  Aave App are disclosed on the recommendation page; relevant research pages
  carry separate context where applicable. They are not product guarantees or
  financial advice.
- Rabby is disclosed separately as an official infrastructure entry and is not
  represented as a personal referral, yield source, custody guarantee, or
  security guarantee.
- Aave has a dedicated source-separated research page at `/aave/`, using the
  supplied purple portrait as its page visual and keeping the Aave App referral
  entry separate from protocol, market, token, and risk claims.
- The shared visual system uses a quieter three-level green field: deep base,
  content surface, and focused action surface. Split sections use a stable
  editorial axis on desktop; ordinary tiles carry less radius, shadow, and
  visual weight than recommendation entries.
- On wide screens, the editorial frame expands to 1440px without widening
  long-form reading measures; Recommendations puts four of the five referral
  entries in the first desktop row, two per row on tablets, and one per row on
  phones.
- The mobile page-title override keeps long headings inside the content
  measure; the 390px acceptance pass showed zero horizontal overflow on the
  homepage, Recommendations, Monero, Plasma, and Aave routes.
- Recommendations is the first primary-navigation item and the homepage's
  first action; Monero, Plasma, and Aave are the primary research routes, and
  five disclosed referral entries—including the featured Fluid Lend entry—are
  available with the adjacent provider-term disclosures kept visible.
- The Capital Operating System field guide is published at `/playbook/`. Its
  public route, canonical tag, current More-navigation state, sitemap entry,
  seven-step flow, six-boundary model, and decision-record anchors passed the
  2026-09-07 strict live verification.
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

- Cloudflare Rocket Loader is still enabled at the zone. With `/main.js`
  opted out via `data-cfasync="false"`, the 2026-09-05 browser-shaped probe
  showed no Rocket Loader injection at all; the strict gate still warns if
  it reappears. Disable it in the zone speed settings if a source-matching
  response must be guaranteed.
- Cloudflare Email Obfuscation rewrites live contact mail links and injects a
  decoder script; the source now includes an explicit no-JavaScript fallback.
  The 2026-09-06 strict live pass confirmed the fallback marker in the default
  live HTML; reopen `/contact/` after future deployments because edge
  variants can differ.
- Cloudflare's managed `robots.txt` currently differs from the source file
  because edge crawler policy is being added at runtime. Decide whether that
  policy belongs in a documented hosting control or in the repository before
  treating the source file as the complete crawler policy.
- DMARC remains monitoring-only with `p=none`; change only after sender
  alignment is understood.
- A real-device pass (iPhone and Android) for the More menu and the copy
  controls is still pending; only emulated viewports have been checked.
- Provider eligibility, fees, geography, KYC, custody, withdrawals, rewards,
  and supported products are time-sensitive external facts.
- Rabby's supported chains, wallet behavior, security warnings, transaction
  simulation coverage, and third-party integrations can change; a simulation
  is a review aid, not proof that a signed transaction is safe.
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
