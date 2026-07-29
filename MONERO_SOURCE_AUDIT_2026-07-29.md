# Monero Source Audit: 2026-07-29

Purpose: record the source, copyright boundary, durable concepts, stale material,
and current official verification links used for the public `/monero/` page.

## Primary Source

- Title: `Mastering Monero: The Future of Private Transactions`
- Attribution: SerHack and the Monero Community
- Edition: First edition, December 2018
- Free PDF release: April 18, 2019
- Local review copy: `Mastering Monero First Edition by SerHack and Monero Community.pdf`
- Pages: 214
- SHA-256:
  `78cc26396519514201f96968cd4b2235b55376797264e0117ff5bbbe4f8f6cea`
- Canonical public PDF:
  `https://masteringmonero.com/book/Mastering%20Monero%20First%20Edition%20by%20SerHack%20and%20Monero%20Community.pdf`

## Copyright Boundary

The PDF states:

- text: CC BY-NC-SA 4.0
- cover: CC BY-NC-ND 4.0
- images: CC BY-NC-ND 4.0

The public page uses original summaries and attribution. It does not reproduce
the cover, illustrations, screenshots, long passages, or code examples.

## Durable Concepts Used

- privacy by default
- financial privacy as control over disclosed metadata
- fungibility as interchangeability without public coin histories
- self-custody and recovery as part of the security model
- sender privacy through ring signatures
- recipient privacy through one-time stealth addresses
- amount privacy through Ring Confidential Transactions
- local versus remote node trust boundaries
- open-source verification and independently checked software

## First-Edition Material Not Treated As Current Instructions

- Kovri is described as an upcoming network privacy component. The official
  repository is archived, and current documentation describes Dandelion++ plus
  optional Tor/I2P paths.
- GUI and CLI screenshots and workflows are version-specific.
- RPC examples, integrations, dependencies, flags, and build commands may be
  stale.
- Exact ring parameters, wallet conventions, transaction sizes, fees, storage
  estimates, version numbers, and service recommendations change over time.
- The book's historical security caveats remain useful, but current operational
  decisions must be checked against current official documentation.

## Current Official Verification Sources

- What is Monero:
  `https://www.getmonero.org/get-started/what-is-monero/`
- Technical specification:
  `https://docs.getmonero.org/technical-specs/`
- Running a node:
  `https://docs.getmonero.org/running-node/`
- `monerod` reference and remote-node tradeoffs:
  `https://docs.getmonero.org/interacting/monerod-reference/`
- Mainnet, stagenet, and testnet:
  `https://docs.getmonero.org/infrastructure/networks/`
- Verify Monero binaries:
  `https://docs.getmonero.org/interacting/verify-monero-binaries/`
- Subaddresses:
  `https://docs.getmonero.org/public-address/subaddress/`
- Kovri repository archive:
  `https://github.com/monero-project/kovri`

## Publishing Rule

The public site may explain stable privacy and custody principles. It must not
publish wallet secrets, recovery material, transaction identifiers, private
view keys, private infrastructure details, or version-specific commands unless
they are freshly verified and necessary.
