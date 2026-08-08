# Post-Deployment Record: 2026-06-15

Purpose: record the production cutover state for `encryptedguru.com` after the
Cloudflare Pages migration.

> Status note (2026-08-08): this is a historical record. The repository is now
> public and open source; see `README.md` and `SECURITY.md` for the current
> public/private boundary.

## Production State

- Source repository: `https://github.com/EncGur/encryptedguru-site`
- Cloudflare Pages project: `encryptedguru-site`
- Production branch: `main`
- Canonical URL: `https://www.encryptedguru.com/`
- Apex behavior: `https://encryptedguru.com/` redirects to
  `https://www.encryptedguru.com/`
- Pages preview URL: `https://encryptedguru-site.pages.dev/`

## Cutover Finding

The custom-domain setup was initially blocked because Cloudflare DNS showed a
read-only `www` web record. The root cause was not ordinary DNS. The formal
domains were still attached to the old Worker:

- Worker: `sparkling-cake-ec49`
- Old custom domains:
  - `encryptedguru.com`
  - `www.encryptedguru.com`

Cloudflare exposed those Worker custom domains as read-only DNS entries. The
correct fix was to remove the custom domains from the old Worker, then attach
them to the Cloudflare Pages project.

## Verification

Strict live verification passed after the cutover:

```sh
./scripts/verify-live.sh --strict-post-deploy
```

Observed production checks:

- `https://encryptedguru.com/` returns `301` to
  `https://www.encryptedguru.com/`.
- `https://www.encryptedguru.com/` returns `200`.
- `https://www.encryptedguru.com/.well-known/security.txt` includes
  `Expires: 2027-06-14T00:00:00Z`.
- Google Workspace DNS remains present:
  - MX: `1 smtp.google.com.`
  - SPF: `v=spf1 include:_spf.google.com ~all`
  - DMARC at `_dmarc.encryptedguru.com`
  - DKIM at `google._domainkey.encryptedguru.com`

## Future Rule

If Cloudflare says a web DNS record is read-only, do not force-edit DNS first.
Find the owning Cloudflare product:

1. Check Workers & Pages project custom domains.
2. Check Worker custom domains.
3. Check Workers Routes.
4. Only then edit ordinary DNS records.

