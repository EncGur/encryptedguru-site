#!/usr/bin/env sh
set -eu

cd "$(dirname "$0")/.."

./scripts/build-site.sh

archive="encryptedguru-v0.2-site.zip"
rm -f "$archive"
(cd dist && zip -qr "../$archive" .)

unzip -t "$archive" >/dev/null
shasum -a 256 "$archive"
