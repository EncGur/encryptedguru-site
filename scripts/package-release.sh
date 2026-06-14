#!/usr/bin/env sh
set -eu

cd "$(dirname "$0")/.."

./scripts/audit-source.sh

rm -f encryptedguru-v0.1-site.zip
zip -qr encryptedguru-v0.1-site.zip . \
  -x '.git/*' \
  -x 'encryptedguru-v0.1-site.zip'

unzip -t encryptedguru-v0.1-site.zip >/dev/null
shasum -a 256 encryptedguru-v0.1-site.zip
