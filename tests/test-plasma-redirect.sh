#!/usr/bin/env sh
set -eu

cd "$(dirname "$0")/.."

research_destination="/plasma/"
invite_destination="/go/plasma-one/"

./scripts/build-site.sh >/dev/null

for route in /plasma /go/plasma-one; do
  if [ "$route" = "/plasma" ]; then
    expected="$route $research_destination 308"
  else
    expected="$route $invite_destination 308"
  fi
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

test -f dist/go/plasma-one/index.html || {
  echo "FAIL: /go/plasma-one/ invitation page is missing from the build" >&2
  exit 1
}

grep -q 'https://plasmaone.onelink.me/P8qq?' dist/go/plasma-one/index.html || {
  echo "FAIL: invitation page is missing the exact Plasma One deep link" >&2
  exit 1
}

grep -q 'href="/go/plasma-one/"' plasma/index.html || {
  echo "FAIL: Plasma research page is missing the explicit invitation route" >&2
  exit 1
}

plasma_line="$(grep -nF '/plasma ' _redirects | head -n 1 | cut -d: -f1)"
apex_line="$(grep -nF 'https://encryptedguru.com/*' _redirects | head -n 1 | cut -d: -f1)"
test "$plasma_line" -lt "$apex_line" || {
  echo "FAIL: Plasma redirect must precede the broader domain redirect" >&2
  exit 1
}

echo "Plasma redirect tests passed"
