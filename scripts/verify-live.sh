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
tmp_monero="$(mktemp)"
tmp_plasma_page="$(mktemp)"
tmp_plasma="$(mktemp)"
tmp_apex_plasma="$(mktemp)"
tmp_boundary_headers="$(mktemp)"
trap 'rm -f "$tmp_headers" "$tmp_security" "$tmp_sitemap" "$tmp_monero" "$tmp_plasma_page" "$tmp_plasma" "$tmp_apex_plasma" "$tmp_boundary_headers"' EXIT

echo "== HTTP =="
curl -sS -I -L --max-time 20 "https://$domain/" | tee "$tmp_headers" | sed -n '1,80p'

echo
echo "== security.txt =="
curl -sS --max-time 20 "https://$www/.well-known/security.txt" | tee "$tmp_security"

echo
echo "== sitemap =="
curl -sS --max-time 20 "https://$www/sitemap.xml" | tee "$tmp_sitemap" | sed -n '1,80p'

echo
echo "== Monero knowledge page =="
curl -sS --max-time 20 "https://$www/monero/" | tee "$tmp_monero" | sed -n '1,20p'

echo
echo "== Plasma knowledge page =="
plasma_page_status="$(curl -sS -o "$tmp_plasma_page" -w '%{http_code}' --max-time 20 "https://$www/plasma/")"
printf 'www/plasma/ status: %s\n' "$plasma_page_status"
sed -n '1,20p' "$tmp_plasma_page"

echo
echo "== Plasma referral =="
curl -sS -D "$tmp_plasma" -o /dev/null -w 'www/plasma status: %{http_code}\n' --max-time 20 "https://$www/plasma"
curl -sS -D "$tmp_apex_plasma" -o /dev/null -w 'apex/plasma status: %{http_code}\n' --max-time 20 "https://$domain/plasma"

echo
echo "== Public surface boundary =="
unknown_status="$(curl -sS -o /dev/null -w '%{http_code}' --max-time 20 "https://$www/__encryptedguru-boundary-check__")"
markdown_status="$(curl -sS -D "$tmp_boundary_headers" -o /dev/null -w '%{http_code}' --max-time 20 "https://$www/REMOTE_SETUP.md")"
runbook_status="$(curl -sS -o /dev/null -w '%{http_code}' --max-time 20 "https://$www/runbooks/CLOUDFLARE_PAGES_DEPLOY_RUNBOOK.md")"
script_status="$(curl -sS -o /dev/null -w '%{http_code}' --max-time 20 "https://$www/scripts/verify-live.sh")"
printf 'Unknown route: %s\n' "$unknown_status"
printf 'Source Markdown: %s\n' "$markdown_status"
printf 'Private runbook: %s\n' "$runbook_status"
printf 'Source script: %s\n' "$script_status"

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

  grep -qi '^strict-transport-security:' "$tmp_headers" || {
    echo "missing strict-transport-security header" >&2
    exit 1
  }

  grep -qi '^content-security-policy:' "$tmp_headers" || {
    echo "missing content-security-policy header" >&2
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

  grep -q 'https://www.encryptedguru.com/monero/' "$tmp_sitemap" || {
    echo "live sitemap missing Monero page" >&2
    exit 1
  }

  grep -q 'https://www.encryptedguru.com/plasma/' "$tmp_sitemap" || {
    echo "live sitemap missing Plasma page" >&2
    exit 1
  }

  grep -q '<h1>Monero</h1>' "$tmp_monero" || {
    echo "live Monero page missing expected heading" >&2
    exit 1
  }

  test "$plasma_page_status" = "200" || {
    echo "live Plasma page is not returning 200" >&2
    exit 1
  }

  grep -q '<h1>Plasma</h1>' "$tmp_plasma_page" || {
    echo "live Plasma page missing expected heading" >&2
    exit 1
  }

  grep -q 'https://docs.plasma.org/docs/get-started/why-build-on-plasma/overview' "$tmp_plasma_page" || {
    echo "live Plasma page missing official developer documentation link" >&2
    exit 1
  }

  grep -q 'https://x.com/e4symp/status/2091829636108026276' "$tmp_plasma_page" || {
    echo "live Plasma page missing the observed community source link" >&2
    exit 1
  }

  grep -qi '^HTTP/2 301' "$tmp_plasma" || {
    echo "www/plasma is not returning a 301 redirect" >&2
    exit 1
  }

  grep -qiF 'location: https://plasmaone.onelink.me/P8qq/rvdp9r4l?code=EGEGEG' "$tmp_plasma" || {
    echo "www/plasma is not pointing at the fixed Plasma One referral URL" >&2
    exit 1
  }

  grep -qi '^HTTP/2 301' "$tmp_apex_plasma" || {
    echo "apex/plasma is not returning a 301 redirect" >&2
    exit 1
  }

  if grep -qiF 'location: https://www.encryptedguru.com/plasma' "$tmp_apex_plasma"; then
    echo "apex/plasma reaches the Pages referral route through the existing apex redirect"
  elif grep -qiF 'location: https://plasmaone.onelink.me/P8qq/rvdp9r4l?code=EGEGEG' "$tmp_apex_plasma"; then
    echo "apex/plasma reaches the Plasma One referral URL directly"
  else
    echo "apex/plasma has an unexpected redirect target" >&2
    exit 1
  fi

  for status in "$unknown_status" "$markdown_status" "$runbook_status" "$script_status"; do
    test "$status" = "404" || {
      echo "live public surface still exposes an unpublished route" >&2
      exit 1
    }
  done

  grep -qi '^cache-control: no-store' "$tmp_boundary_headers" || {
    echo "source-route guard is cacheable" >&2
    exit 1
  }

  grep -qi '^x-robots-tag: noindex' "$tmp_boundary_headers" || {
    echo "source-route guard is missing noindex" >&2
    exit 1
  }

  echo "strict live verification passed"
fi
