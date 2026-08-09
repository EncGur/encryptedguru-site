#!/usr/bin/env sh
set -eu

cd "$(dirname "$0")/.."

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

failures=0

sha_a="$(./scripts/package-release.sh | tail -1 | awk '{print $1}')"
cp encryptedguru-v0.3-site.zip "$tmp/a.zip"

sha_b="$(./scripts/package-release.sh | tail -1 | awk '{print $1}')"
cp encryptedguru-v0.3-site.zip "$tmp/b.zip"

if [ "$sha_a" != "$sha_b" ]; then
  echo "FAIL: package is not reproducible" >&2
  echo "  sha_a=$sha_a" >&2
  echo "  sha_b=$sha_b" >&2
  failures=$((failures + 1))
else
  echo "ok: package reproducible ($sha_a)"
fi

if cmp -s "$tmp/a.zip" "$tmp/b.zip"; then
  echo "ok: packages byte-identical"
else
  echo "FAIL: packages differ despite equal SHA" >&2
  failures=$((failures + 1))
fi

# Both archives must unpack to the same allowlisted public tree.
mkdir -p "$tmp/ua" "$tmp/ub"
(cd "$tmp/ua" && unzip -q "$tmp/a.zip")
(cd "$tmp/ub" && unzip -q "$tmp/b.zip")

if diff -r "$tmp/ua" "$tmp/ub" >/dev/null 2>&1; then
  echo "ok: unpacked trees identical"
else
  echo "FAIL: unpacked trees differ" >&2
  failures=$((failures + 1))
fi

# The unpacked tree must contain only public allowlist content.
leaks="$(cd "$tmp/ua" && find . -type f \( -name '*.md' -o -name '*.sh' -o -name '*.zip' -o -name '*.log' -o -name '.env*' -o -name '*.key' -o -name '*.pem' \) )"
if [ -n "$leaks" ]; then
  echo "FAIL: source-only artifacts in release archive:" >&2
  echo "$leaks" >&2
  failures=$((failures + 1))
else
  echo "ok: no source-only artifacts in archive"
fi

if [ "$failures" -gt 0 ]; then
  echo "reproducible-package test failed: $failures" >&2
  exit 1
fi
echo "reproducible-package test passed"
