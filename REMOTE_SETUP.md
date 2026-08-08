# Remote Repository Setup

Purpose: attach a local Git source to the public EncryptedGuru repository and make commits the deployment identity.

Current local state:

- Branch: `main`
- Initial commit: `91292dc Initialize EncryptedGuru static site`
- Release zip is generated locally and ignored by Git.

## Current Remote State

- The repository is public:
  - `https://github.com/EncGur/encryptedguru-site`
- Local `main` tracks `origin/main`.
- Remote readiness check passes:
  - `./scripts/check-remote-ready.sh`
- The repository is connected to Cloudflare Pages, which deploys the `main`
  branch to `https://www.encryptedguru.com/`.

Do not commit private keys or SSH setup files into this repository. This
repository is public: never commit credentials, local paths, SSH key
filenames, or account-recovery details.

## Attach Remote

If this repository is not yet cloned locally:

```sh
git clone git@github.com:EncGur/encryptedguru-site.git
```

If HTTPS is preferred:

```sh
git clone https://github.com/EncGur/encryptedguru-site.git
```

To push from an existing clone, verify the remote:

```sh
git remote -v
git push -u origin main
```

## Authentication

Use standard GitHub authentication (SSH key or HTTPS token) configured outside
this repository. Do not place key material or token files in the working tree.

## Cloudflare Pages

Connect Cloudflare Pages to the public repository.

Settings:

- Production branch: `main`
- Build command: `sh scripts/build-site.sh`
- Output directory: `dist`
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
./scripts/check-remote-ready.sh
```

After deployment:

```sh
./scripts/verify-live.sh --strict-post-deploy
```

## Rollback

Use Cloudflare Pages deployment rollback to return to the prior known-good commit. Verify with:

```sh
./scripts/verify-live.sh
```
