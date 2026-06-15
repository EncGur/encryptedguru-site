#!/usr/bin/env sh
set -eu

domain="encryptedguru.com"
www="www.encryptedguru.com"
strict=0

if [ "${1:-}" = "--strict-post-deploy" ]; then
  strict=1
fi

tmp_headers="$(mktemp)"
tmp_security="$(mktemp)"
tmp_sitemap="$(mktemp)"
trap 'rm -f "$tmp_headers" "$tmp_security" "$tmp_sitemap"' EXIT

echo "== HTTP =="
curl -sS -I -L --max-time 20 "https://$domain/" | tee "$tmp_headers" | sed -n '1,80p'

echo
echo "== security.txt =="
curl -sS --max-time 20 "https://$www/.well-known/security.txt" | tee "$tmp_security"

echo
echo "== sitemap =="
curl -sS --max-time 20 "https://$www/sitemap.xml" | tee "$tmp_sitemap" | sed -n '1,80p'

echo
echo "== DNS =="
printf 'A apex: '
dig @1.1.1.1 +short "$domain" A | tr '\n' ' '
printf '\nA www: '
dig @1.1.1.1 +short "$www" A | tr '\n' ' '
printf '\nMX: '
dig @1.1.1.1 +short "$domain" MX | tr '\n' ' '
printf '\nSPF: '
dig @1.1.1.1 +short "$domain" TXT | tr '\n' ' '
printf '\nDMARC: '
dig @1.1.1.1 +short "_dmarc.$domain" TXT | tr '\n' ' '
printf '\nDKIM: '
dig @1.1.1.1 +short "google._domainkey.$domain" TXT | sed 's/ .*$/ .../'

if [ "$strict" -eq 1 ]; then
  echo
  echo "== strict checks =="

  grep -qi '^HTTP/2 301' "$tmp_headers" || {
    echo "missing apex redirect response" >&2
    exit 1
  }

  grep -qi 'location: https://www.encryptedguru.com/' "$tmp_headers" || {
    echo "missing apex-to-www location" >&2
    exit 1
  }

  grep -qi '^HTTP/2 200' "$tmp_headers" || {
    echo "missing final 200 response" >&2
    exit 1
  }

  grep -qi '^x-content-type-options: nosniff' "$tmp_headers" || {
    echo "missing x-content-type-options header" >&2
    exit 1
  }

  grep -qi '^x-frame-options: DENY' "$tmp_headers" || {
    echo "missing x-frame-options header" >&2
    exit 1
  }

  grep -qi '^referrer-policy: strict-origin-when-cross-origin' "$tmp_headers" || {
    echo "missing referrer-policy header" >&2
    exit 1
  }

  grep -q '^Expires: 2027-06-14T00:00:00Z' "$tmp_security" || {
    echo "live security.txt is missing expected Expires" >&2
    exit 1
  }

  grep -q 'https://www.encryptedguru.com/' "$tmp_sitemap" || {
    echo "live sitemap missing canonical homepage" >&2
    exit 1
  }

  echo "strict live verification passed"
fi
