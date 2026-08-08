# Post-Deployment Record: 2026-07-29

Purpose: record the EncryptedGuru v0.2 release, its Monero source boundary, and
the production checks completed after deployment.

> Status note (2026-08-08): the repository is now public and open source. The
> public/private boundary described in this record has been redesigned; see
> `README.md` and `SECURITY.md`.

## Released State

- Source repository: `https://github.com/EncGur/encryptedguru-site`
- Cloudflare Pages project: `encryptedguru-site`
- Production branch: `main`
- Canonical URL: `https://www.encryptedguru.com/`
- Monero knowledge page: `https://www.encryptedguru.com/monero/`
- Content release commit: `6136be3`
- Source-route guard commit: `61dcfc6`

Cloudflare Pages was observed with:

- Build command: `sh scripts/build-site.sh`
- Build output directory: `dist`

The build script uses an allowlist and produced 21 public files. Repository
Markdown, shell scripts, runbooks, release archives, and logs are not copied to
the public build.

## Monero Source Boundary

The new page is an original first-principles synthesis of *Mastering Monero,
First Edition*. It separates durable privacy and custody concepts from commands,
parameters, interfaces, and network guidance that can become stale.

- Reviewed PDF: 214 pages
- Edition: first edition, December 2018
- PDF SHA-256:
  `78cc26396519514201f96968cd4b2235b55376797264e0117ff5bbbe4f8f6cea`
- Detailed evidence: `MONERO_SOURCE_AUDIT_2026-07-29.md`
- Copyright boundary: original summary and attribution only; no book cover,
  illustrations, screenshots, long passages, or code examples were republished.

## Production Verification

The strict network verifier passed:

```sh
./scripts/verify-live.sh --strict-post-deploy
```

Observed results:

- Apex returns `301` to `https://www.encryptedguru.com/`.
- Canonical homepage and `/monero/` return `200`.
- Required security headers are present.
- `security.txt` has the expected expiry.
- The sitemap contains both the canonical homepage and `/monero/`.
- Unknown routes, source Markdown, private runbooks, and source scripts return
  `404`.
- Source-route responses include `Cache-Control: no-store` and
  `X-Robots-Tag: noindex`.
- Google Workspace MX, SPF, DMARC, and DKIM records remain present.

Production browser verification also passed in headless Chrome:

- `/monero/` at `1440x1000` and `390x844`
- homepage at `390x844`
- a real `404` page at `1440x900`
- no horizontal overflow, broken images, JavaScript page errors, failed
  subresources, or unexpected HTTP error responses
- five primary navigation links at every tested viewport

The `404` top-level response is expected and was tested separately from broken
subresource detection.

## Cache Remediation

Old repository-source URLs remained available from the custom-domain cache after
the allowlisted build first deployed. Cloudflare's zone cache and the known old
source URLs were purged. A narrowly routed Pages Function now returns a
non-cacheable, non-indexable `404` for source-only patterns while ordinary static
pages remain outside Function invocation.

## Release Rule

Future releases must preserve all four gates:

1. Source audit passes.
2. Only the allowlisted `dist/` tree is published.
3. Strict live verification passes after Cloudflare reports deployment success.
4. Changed pages receive desktop and mobile browser checks against the canonical
   domain.
