#!/usr/bin/env sh
set -eu

cd "$(dirname "$0")/.."

./scripts/build-site.sh

archive="encryptedguru-v0.2-site.zip"
rm -f "$archive"

# Deterministic archive: derive every entry timestamp from the Git commit time
# (UTC) so the same tree always produces byte-identical release archives on any
# machine, in any timezone. Never use wall-clock time. The 12-digit
# CCYYMMDDhhmm form (no seconds; DOS-time granularity is 2s anyway) is accepted
# by both BSD (macOS) and GNU touch.
ts="$(TZ=UTC git show -s --format=%cd --date=format:%Y%m%d%H%M HEAD)"
if [ -z "$ts" ]; then
  echo "cannot derive commit timestamp for deterministic archive" >&2
  exit 1
fi

find dist -exec touch -t "$ts" {} +

# Sorted entry list, no directory entries, no extra attributes (xattrs/ACLs),
# so ordering, timestamps, and metadata are fully deterministic.
(cd dist && find . -type f | LC_ALL=C sort | sed 's|^\./||' | zip -q -X -@ "../$archive")

unzip -t "$archive" >/dev/null
shasum -a 256 "$archive"
