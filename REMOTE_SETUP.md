# Remote Repository Setup

Purpose: attach this local Git source to a private remote repository and make commits the deployment identity.

Current local state:

- Branch: `main`
- Initial commit: `91292dc Initialize EncryptedGuru static site`
- Latest build-process commit: `ad2a4d3 Add repeatable release verification scripts`
- Latest remote-setup commit: `125c8b8 Document remote repository setup`
- Release zip is generated locally and ignored by Git.

## Current Remote Blockers

- No existing `encryptedguru` or `encryptedguru-site` repository was found through the GitHub connector.
- The local `gh` CLI is not installed.
- The GitHub connector available in this session can operate on installed repositories but does not expose repository creation.
- SSH host verification for `github.com` has been fixed in `~/.ssh/known_hosts`.
- SSH authentication currently fails with `Permission denied (publickey)`.
- A dedicated GitHub SSH key has been generated outside the repository:
  - Private key: `~/.ssh/id_ed25519_github_cbdtaeff`
  - Public key export: `/Users/esmp/Documents/Codex/2026-05-20/encryptedguru-github-cbdtaeff-public-key.txt`
- SSH alias `github-cbdtaeff` has been added to `~/.ssh/config`.
- Local `origin` is already set to:
  - `git@github-cbdtaeff:cbdtaeff/encryptedguru-site.git`

Do not commit private keys or SSH setup files into this repository.

## Required Remote

Create a private repository named one of:

- `encryptedguru-site`
- `encryptedguru.com`
- `encryptedguru`

Recommended: `encryptedguru-site`, because it describes the artifact without claiming to contain every future system.

## Attach Remote

After creating the private repository, run from this folder:

```sh
git push -u origin main
```

If HTTPS is preferred:

```sh
git remote add origin https://github.com/cbdtaeff/encryptedguru-site.git
git push -u origin main
```

## SSH Key Setup

If using SSH, add the public key from:

```text
/Users/esmp/Documents/Codex/2026-05-20/encryptedguru-github-cbdtaeff-public-key.txt
```

to GitHub account SSH keys, then verify:

```sh
ssh -T github-cbdtaeff
```

Expected result should greet the `cbdtaeff` GitHub account or another intended account.

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
./scripts/check-remote-ready.sh
```

After deployment:

```sh
./scripts/verify-live.sh --strict-post-deploy
```

Expected post-deploy difference:

- Live `/.well-known/security.txt` should include `Expires: 2027-06-14T00:00:00Z`.

Current expected failures before remote setup:

- `./scripts/check-remote-ready.sh` fails with `Permission denied (publickey)` until the dedicated public key is added to GitHub.
- `./scripts/verify-live.sh --strict-post-deploy` fails until the current local source is deployed and live `security.txt` includes `Expires`.

## Rollback

Use Cloudflare Pages deployment rollback to return to the prior known-good commit. Verify with:

```sh
./scripts/verify-live.sh
```
