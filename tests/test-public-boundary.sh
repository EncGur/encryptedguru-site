#!/usr/bin/env sh
set -eu

cd "$(dirname "$0")/.."

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

failures=0

check_fails() {
  desc="$1"
  shift
  if "$@" >/dev/null 2>&1; then
    echo "FAIL: audit did not reject: $desc" >&2
    failures=$((failures + 1))
  else
    echo "ok: audit rejected $desc"
  fi
}

check_passes() {
  desc="$1"
  shift
  if "$@" >/dev/null 2>&1; then
    echo "ok: audit accepted $desc"
  else
    echo "FAIL: audit rejected clean input: $desc" >&2
    failures=$((failures + 1))
  fi
}

run_audit_with() {
  path="$1"
  content="$2"
  mkdir -p "$(dirname "$tmp/$path")"
  printf '%s\n' "$content" >"$tmp/$path"
  (
    cd "$tmp"
    git init -q . 2>/dev/null
    ./scripts/audit-source.sh
  )
}

mkdir -p "$tmp/scripts" "$tmp/.well-known" "$tmp/functions" "$tmp/monero" "$tmp/projects/gmcp"
cp scripts/audit-source.sh scripts/build-site.sh "$tmp/scripts/"
cp .well-known/security.txt "$tmp/.well-known/security.txt"
cp sitemap.xml "$tmp/sitemap.xml"
cp monero/index.html "$tmp/monero/index.html"
cp projects/index.html "$tmp/projects/index.html"
cp projects/gmcp/index.html "$tmp/projects/gmcp/index.html"
cp _routes.json _redirects index.html 404.html styles.css main.js _headers robots.txt README.md DEPLOYMENT.md RELEASE_CHECKLIST.md FIRST_PRINCIPLES_BUILD.md SECURITY_AUDIT_2026-06-14.md MONERO_SOURCE_AUDIT_2026-07-29.md "$tmp/"
cp 'functions/[[path]].js' "$tmp/functions/[[path]].js"

check_passes "clean tree" run_audit_with README.md "clean"

check_fails "GitHub PAT ghp_" run_audit_with README.md "token ghp_abcdefghijklmnopqrstuvwxyz1234567890"
check_fails "github_pat_ token" run_audit_with README.md "token github_pat_1234567890abcdefghijklmnopqrstuvwxyz"
check_fails "absolute /Users path" run_audit_with README.md "path /Users/someuser/Documents/secret"
check_fails "id_ed25519 key filename" run_audit_with README.md "key id_ed25519_github_custom"
check_fails "id_rsa key filename" run_audit_with README.md "key id_rsa_backup"
check_fails ".env mention" run_audit_with README.md "cp .env.example .env"
check_fails "RSA private key block" run_audit_with README.md "-----BEGIN RSA PRIVATE KEY-----"
check_fails "OPENSSH private key block" run_audit_with README.md "-----BEGIN OPENSSH PRIVATE KEY-----"
check_fails "bearer token" run_audit_with README.md "Authorization: bearer abcdef12345"

# Public repo hygiene: runbooks must not exist in the tree at all.
if [ -d runbooks ]; then
  echo "FAIL: runbooks/ directory is present in the public tree" >&2
  failures=$((failures + 1))
else
  echo "ok: runbooks/ absent from public tree"
fi

# _routes.json must cover source-only patterns including .env and archives.
if grep -q '"/\.env\*"' _routes.json && grep -q '"/\*\.zip"' _routes.json; then
  echo "ok: _routes.json covers .env and archives"
else
  echo "FAIL: _routes.json missing .env or archive guards" >&2
  failures=$((failures + 1))
fi

# No tracked file may carry machine-specific identity patterns. The test file
# itself is excluded because it deliberately contains payload strings.
leaks="$(git grep -nE '/Users/[A-Za-z0-9_.-]+/|id_ed25519|id_rsa|github-cbdtaeff' -- ':!scripts/audit-source.sh' ':!runbooks' ':!tests/' 2>/dev/null || true)"
if [ -n "$leaks" ]; then
  echo "FAIL: machine-specific patterns found in tracked files:" >&2
  echo "$leaks" >&2
  failures=$((failures + 1))
else
  echo "ok: no machine-specific patterns in tracked files"
fi

if [ "$failures" -gt 0 ]; then
  echo "boundary tests failed: $failures" >&2
  exit 1
fi
echo "boundary tests passed"
