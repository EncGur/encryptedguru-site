# EncryptedGuru design audit — 2026-08-24

## Goal

Make the public site feel like a deliberate research product: visitors should
understand what EncryptedGuru is, choose a clear entry path, and see how claims
are verified without exposing private operational material.

## Current verified state

- The site is a static, source-managed public surface with no forms, analytics,
  tracking, database, or public admin surface.
- `./scripts/audit-source.sh` passes and `./scripts/build-site.sh` produces the
  26-file public build.
- `https://www.encryptedguru.com/` currently returns `200` with the expected
  security headers and serves the same homepage structure as this checkout.
- The apex domain is redirected to the canonical `www` host through
  `_redirects`.

## First-principles findings

### What the site must do

1. Explain the identity in one sentence.
2. Route visitors into a small number of meaningful reading paths.
3. Separate facts, research, and operational boundaries.
4. Prove that the public surface is intentionally constrained.
5. Stay fast, accessible, portable, and easy to verify.

### Friction found

- The previous homepage repeated the same thesis across many sections without a
  strong “start here” choice.
- Seven top-level links were presented with equal weight, even though the
  content naturally forms three paths: money, rails, and systems.
- “Last verified” appeared as a hard-coded status value but was not explained
  as a verification scope.
- The home page had no share image metadata after its photo was removed.
- The public proof model was present, but visually buried below several generic
  text blocks.
- Inner pages share a visual language, but their page introductions do not yet
  give visitors a compact sense of category, state, and next action.

## Design direction

- **Plasma:** lead with a concrete outcome, then use compact proof modules and
  a clear next action.
- **Linear:** use a quiet product surface, strong typography, and a sequential
  story instead of a wall of navigation.
- **Stripe:** state the proposition first, then show the capabilities and the
  evidence that makes the proposition credible.
- **Vercel:** group the information architecture into a few understandable
  families instead of treating every destination as an equal primary action.

## Implemented in this pass

- Reframed the homepage around “Private systems. Public proof.”
- Added three explicit entry paths: understand money, evaluate rails, and build
  systems.
- Turned verification into a first-class proof strip rather than a buried
  paragraph.
- Added structured Open Graph/Twitter title and description metadata without
  reusing a personal photo for the homepage.
- Replaced the visible brand avatar with a CSS-only system mark; the homepage
  no longer displays a personal photo.
- Added a restrained status/signal panel using CSS only, keeping the site static
  and avoiding new external assets or tracking.
- Improved responsive navigation, card focus states, spacing rhythm, and
  contrast without changing the security headers or public/private boundary.

## Done when

- Source audit and build pass.
- Every published page remains in the allowlisted build.
- The homepage has a clear first viewport, three reading paths, a visible proof
  model, and no homepage personal photo.
- Canonical, Open Graph, and Twitter metadata are present for the homepage.
- No credentials, private runbooks, or new external runtime dependencies are
  introduced.

## Second pass — inner-page continuity

- Preserved the existing type system and homepage hierarchy.
- Added a consistent page context line to every inner route: section code,
  category, and a return path to the overview or parent index.
- Removed the obsolete `v0.3` footer label in favor of a durable site identity.
- Removed the personal `logo.png` share image from generic inner pages; Monero
  and Plasma retain only their topic-specific images.
- Aligned inner-page theme colors with the homepage and added large-image
  Twitter metadata for the two image-led research pages.
