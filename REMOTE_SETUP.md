# Remote Repository Setup

Purpose: attach this local Git source to a private remote repository and make commits the deployment identity.

Current local state:

- Branch: `main`
- Initial commit: `91292dc Initialize EncryptedGuru static site`
- Latest build-process commit: `ad2a4d3 Add repeatable release verification scripts`
- Release zip is generated locally and ignored by Git.

## Required Remote

Create a private repository named one of:

- `encryptedguru-site`
- `encryptedguru.com`
- `encryptedguru`

Recommended: `encryptedguru-site`, because it describes the artifact without claiming to contain every future system.

## Attach Remote

After creating the private repository, run from this folder:

```sh
git remote add origin git@github.com:cbdtaeff/encryptedguru-site.git
git push -u origin main
```

If HTTPS is preferred:

```sh
git remote add origin https://github.com/cbdtaeff/encryptedguru-site.git
git push -u origin main
```

## Cloudflare Pages

Connect Cloudflare Pages to the private repository.

Settings:

- Production branch: `main`
- Build command: empty
- Output directory: `/`
- Custom domains:
  - `encryptedguru.com`
  - `www.encryptedguru.com`

Source-controlled Cloudflare files:

- `_headers`
- `_redirects`

## Verification

Before push:

```sh
./scripts/audit-source.sh
```

After deployment:

```sh
./scripts/verify-live.sh
```

Expected post-deploy difference:

- Live `/.well-known/security.txt` should include `Expires: 2027-06-14T00:00:00Z`.

## Rollback

Use Cloudflare Pages deployment rollback to return to the prior known-good commit. Verify with:

```sh
./scripts/verify-live.sh
```
