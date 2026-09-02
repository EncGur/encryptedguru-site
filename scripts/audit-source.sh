#!/usr/bin/env sh
set -eu

cd "$(dirname "$0")/.."

required_files="
index.html
404.html
monero/index.html
aave/index.html
projects/index.html
projects/gmcp/index.html
go/plasma-one/index.html
recommendations/index.html
styles.css
main.js
robots.txt
sitemap.xml
.well-known/security.txt
_headers
_redirects
_routes.json
README.md
PROJECT_STATE.md
DEPLOYMENT.md
RELEASE_CHECKLIST.md
FIRST_PRINCIPLES_BUILD.md
SECURITY_AUDIT_2026-06-14.md
MONERO_SOURCE_AUDIT_2026-07-29.md
scripts/build-site.sh
functions/[[path]].js
"

for file in $required_files; do
  test -f "$file" || {
    echo "missing required file: $file" >&2
    exit 1
  }
done

grep -q '^Expires: ' .well-known/security.txt || {
  echo "security.txt is missing Expires" >&2
  exit 1
}

grep -q 'https://www.encryptedguru.com/' sitemap.xml || {
  echo "sitemap.xml missing canonical www URL" >&2
  exit 1
}

grep -q 'https://www.encryptedguru.com/monero/' sitemap.xml || {
  echo "sitemap.xml missing Monero page" >&2
  exit 1
}

grep -q 'https://www.encryptedguru.com/aave/' sitemap.xml || {
  echo "sitemap.xml missing Aave page" >&2
  exit 1
}

grep -q 'https://www.encryptedguru.com/projects/</loc>' sitemap.xml || {
  echo "sitemap.xml missing Projects index" >&2
  exit 1
}

grep -q 'https://www.encryptedguru.com/projects/gmcp/</loc>' sitemap.xml || {
  echo "sitemap.xml missing GMCP project page" >&2
  exit 1
}

grep -q 'href="/projects/"' index.html || {
  echo "homepage missing Projects navigation link" >&2
  exit 1
}

grep -q 'Mastering Monero' monero/index.html || {
  echo "Monero page missing primary source attribution" >&2
  exit 1
}

grep -q '"/scripts/\*"' _routes.json || {
  echo "_routes.json missing source-script guard" >&2
  exit 1
}

grep -q 'status: 404' 'functions/[[path]].js' || {
  echo "Pages Function source guard is missing its 404 response" >&2
  exit 1
}

grep -q 'https://www.encryptedguru.com/' _redirects || {
  echo "_redirects missing canonical www target" >&2
  exit 1
}

if find . \
  -path './.git' -prune -o \
  -type f \( \
    -name '*.html' -o \
    -name '*.txt' -o \
    -name '*.xml' -o \
    -name '*.md' -o \
    -name '*.js' -o \
    -name '*.css' -o \
    -name '*.webmanifest' -o \
    -name '_headers' -o \
    -name '_redirects' \
  \) -print0 | xargs -0 grep -nEi 'password[=:]|token[=:]|api[_-]?key[=:]|bearer [a-z0-9._-]+|BEGIN (RSA|OPENSSH|PRIVATE)|ghp_[A-Za-z0-9]{20,}|github_pat_[A-Za-z0-9_]{20,}|/Users/[A-Za-z0-9_.-]+/|id_ed25519|id_rsa|\.env([=:. ]|$)' ; then
  echo "potential secret or machine-specific pattern found" >&2
  exit 1
fi

echo "source audit passed"
