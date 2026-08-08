# Security Policy

## Reporting a Vulnerability

EncryptedGuru takes security reports seriously. This repository is public;
please do not include credentials, private keys, or recovery material in any
report or commit.

Report vulnerabilities to:

- Email: `security@encryptedguru.com`
- Public policy page: https://www.encryptedguru.com/contact/
- security.txt: https://www.encryptedguru.com/.well-known/security.txt

## Scope

- The live site: `https://www.encryptedguru.com/` and its subpaths.
- This source repository and its build pipeline.
- Source-controlled Cloudflare configuration (`_headers`, `_redirects`,
  `_routes.json`, Pages Functions).

## Out of Scope

- Any operational runbooks or private operational infrastructure; these are
  not part of this public repository.
- Deliberately public documentation content.

## Expectations

- Reports are acknowledged within a reasonable time.
- Confirmed issues are fixed in the public repository and verified before
  deployment.
- No bug bounty is offered.

## Safe Harbor

Researchers are welcome to test the public surface without authorization
beyond these conditions:

- Do not access, store, or transmit user or personal data.
- Do not perform denial-of-service or destructive testing.
- Do not modify production state.
- Stop at the first confirmed sign of a real incident and report it.
