#!/usr/bin/env sh
set -eu

cd "$(dirname "$0")/.."

failures=0

ok() {
  desc="$1"
  shift
  if "$@" >/dev/null 2>&1; then
    echo "ok: $desc"
  else
    echo "FAIL: $desc" >&2
    failures=$((failures + 1))
  fi
}

./scripts/build-site.sh >/dev/null

# The Projects section must build into dist/.
ok "dist/projects/index.html exists" test -f dist/projects/index.html
ok "dist/projects/gmcp/index.html exists" test -f dist/projects/gmcp/index.html
ok "dist/plasma/index.html exists" test -f dist/plasma/index.html

# Every internal href on every page that carries the primary navigation must
# resolve to a real file inside dist/.
pages="index.html 404.html monero/index.html plasma/index.html docs/index.html labs/index.html labs/dsx-air/index.html infrastructure/index.html contact/index.html projects/index.html projects/gmcp/index.html recommendations/index.html go/plasma-one/index.html"

for page in $pages; do
  if [ ! -f "$page" ]; then
    echo "FAIL: missing page $page" >&2
    failures=$((failures + 1))
    continue
  fi
done

broken=0
for page in $pages; do
  for href in $(grep -oE 'href="[^"]*"' "$page" | sed -E 's/^href="//; s/"$//' | sort -u); do
    case "$href" in
      \#*) continue ;;
      http:*|https:*|mailto:*|tel:*) continue ;;
      /*)
        target="${href%%#*}"
        target="${target%%\?*}"
        case "$target" in
          */) rel="${target#/}index.html" ;;
          *)  rel="${target#/}" ;;
        esac
        if [ ! -f "dist/$rel" ]; then
          echo "FAIL: $page links to $href (missing dist/$rel)" >&2
          broken=$((broken + 1))
        fi
        ;;
    esac
  done
done
if [ "$broken" -gt 0 ]; then
  echo "FAIL: $broken broken internal links" >&2
  failures=$((failures + 1))
else
  echo "ok: every internal href on the updated pages resolves to a real file"
fi

# The sitemap must carry both new canonical URLs.
ok "sitemap.xml has Projects index URL" grep -q 'https://www.encryptedguru.com/projects/</loc>' sitemap.xml
ok "sitemap.xml has GMCP project URL" grep -q 'https://www.encryptedguru.com/projects/gmcp/</loc>' sitemap.xml
ok "sitemap.xml has Plasma URL" grep -q 'https://www.encryptedguru.com/plasma/</loc>' sitemap.xml
ok "sitemap.xml has Recommendations URL" grep -q 'https://www.encryptedguru.com/recommendations/</loc>' sitemap.xml

# The new pages must carry the canonical tags matching the sitemap.
ok "projects/index.html canonical tag" grep -q 'https://www.encryptedguru.com/projects/' projects/index.html
ok "projects/gmcp/index.html canonical tag" grep -q 'https://www.encryptedguru.com/projects/gmcp/' projects/gmcp/index.html
ok "plasma/index.html canonical tag" grep -q 'https://www.encryptedguru.com/plasma/' plasma/index.html
ok "Plasma page links official network overview" grep -q 'https://www.plasma.org/network' plasma/index.html
ok "Plasma page links official developer docs" grep -q 'https://docs.plasma.org/docs/get-started/why-build-on-plasma/overview' plasma/index.html
ok "Plasma page links the observed X post" grep -q 'https://x.com/e4symp/status/2091829636108026276' plasma/index.html
ok "Plasma page separates community signal" grep -q 'community distribution signal' plasma/index.html
ok "Plasma page uses explicit invitation route" grep -q 'href="/go/plasma-one/"' plasma/index.html
ok "Recommendations page has four referral entries" test "$(grep -c '<article class="tile recommendation-card">' recommendations/index.html)" -eq 4
ok "Recommendations page keeps the exact Aave referral URL" grep -q 'href="https://aave.com/app/r/999F66"' recommendations/index.html
ok "Recommendations desktop grid defines four columns" grep -q 'grid-template-columns: repeat(4, minmax(0, 1fr));' styles.css

# Every page carrying the primary navigation must link to the Projects hub.
for page in $pages; do
  if ! grep -q 'href="/projects/"' "$page"; then
    echo "FAIL: $page missing Projects navigation link" >&2
    failures=$((failures + 1))
  fi
  if ! grep -q 'href="/plasma/"' "$page"; then
    echo "FAIL: $page missing Plasma navigation link" >&2
    failures=$((failures + 1))
  fi
  first_nav_link="$(sed -n '/<nav class="nav"/,/<\/nav>/p' "$page" | grep -m1 -oE 'href="[^"]*"' || true)"
  if [ "$first_nav_link" = 'href="/recommendations/"' ]; then
    echo "ok: $page puts Recommendations first in primary navigation"
  else
    echo "FAIL: $page does not put Recommendations first in primary navigation" >&2
    failures=$((failures + 1))
  fi
done

# Public-boundary leak patterns must stay absent from the new pages.
leaks="$(grep -nE '/Users/[A-Za-z0-9_.-]+/|id_ed25519|id_rsa|ghp_[A-Za-z0-9]{20,}|github_pat_[A-Za-z0-9_]{20,}|BEGIN (RSA|OPENSSH|PRIVATE)|password[=:]|token[=:]|api[_-]?key[=:]|bearer [a-z0-9._-]+|\.env([=:. ]|$)' projects/index.html projects/gmcp/index.html plasma/index.html || true)"
if [ -n "$leaks" ]; then
  echo "FAIL: leak patterns found in new pages:" >&2
  echo "$leaks" >&2
  failures=$((failures + 1))
else
  echo "ok: no public-boundary leak patterns in new pages"
fi

# The GMCP page must describe RED dispatch as at-most-once, never exactly-once.
# Exactly-once may appear only as an explicit disclaimer, never as a guarantee.
if grep -qi 'exactly-once' projects/gmcp/index.html; then
  if grep -qi 'exactly-once semantics are not claimed\|no false exactly-once' projects/gmcp/index.html; then
    echo "ok: GMCP page disclaims exactly-once semantics"
  else
    echo "FAIL: GMCP page claims exactly-once semantics" >&2
    failures=$((failures + 1))
  fi
else
  echo "ok: GMCP page avoids exactly-once mentions"
fi
if grep -qi 'at-most-once' projects/gmcp/index.html; then
  echo "ok: GMCP page states at-most-once dispatch"
else
  echo "FAIL: GMCP page missing at-most-once statement" >&2
  failures=$((failures + 1))
fi

if [ "$failures" -gt 0 ]; then
  echo "projects tests failed: $failures" >&2
  exit 1
fi
echo "projects tests passed"
