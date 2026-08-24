#!/usr/bin/env sh
set -eu

cd "$(dirname "$0")/.."

destination="https://plasmaone.onelink.me/P8qq/rvdp9r4l?code=EGEGEG"

./scripts/build-site.sh >/dev/null

for route in /plasma; do
  expected="$route $destination 301"
  grep -Fqx "$expected" _redirects || {
    echo "FAIL: missing source redirect: $expected" >&2
    exit 1
  }
  grep -Fqx "$expected" dist/_redirects || {
    echo "FAIL: build did not carry redirect: $expected" >&2
    exit 1
  }
done

test -f dist/plasma/index.html || {
  echo "FAIL: /plasma/ research page is missing from the build" >&2
  exit 1
}

plasma_line="$(grep -nF '/plasma ' _redirects | head -n 1 | cut -d: -f1)"
apex_line="$(grep -nF 'https://encryptedguru.com/*' _redirects | head -n 1 | cut -d: -f1)"
test "$plasma_line" -lt "$apex_line" || {
  echo "FAIL: Plasma redirect must precede the broader domain redirect" >&2
  exit 1
}

echo "Plasma redirect tests passed"
