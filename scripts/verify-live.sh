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
tmp_home="$(mktemp)"
tmp_monero="$(mktemp)"
tmp_recommendations="$(mktemp)"
tmp_plasma_page="$(mktemp)"
tmp_aave="$(mktemp)"
tmp_aave_route="$(mktemp)"
tmp_plasma="$(mktemp)"
tmp_plasma_invite_page="$(mktemp)"
tmp_plasma_invite="$(mktemp)"
tmp_apex_plasma="$(mktemp)"
tmp_legacy_logo="$(mktemp)"
tmp_boundary_headers="$(mktemp)"
tmp_edge_runtime="$(mktemp)"
tmp_thesis="$(mktemp)"
trap 'rm -f "$tmp_headers" "$tmp_security" "$tmp_sitemap" "$tmp_home" "$tmp_monero" "$tmp_recommendations" "$tmp_plasma_page" "$tmp_aave" "$tmp_aave_route" "$tmp_plasma" "$tmp_plasma_invite_page" "$tmp_plasma_invite" "$tmp_apex_plasma" "$tmp_legacy_logo" "$tmp_boundary_headers" "$tmp_edge_runtime" "$tmp_thesis"' EXIT

echo "== HTTP =="
curl -sS -I -L --max-time 20 "https://$domain/" | tee "$tmp_headers" | sed -n '1,80p'

echo
echo "== security.txt =="
curl -sS --max-time 20 "https://$www/.well-known/security.txt" | tee "$tmp_security"

echo
echo "== sitemap =="
curl -sS --max-time 20 "https://$www/sitemap.xml" | tee "$tmp_sitemap" | sed -n '1,80p'

echo
echo "== Homepage metadata =="
curl -sS --max-time 20 "https://$www/" | tee "$tmp_home" | sed -n '1,24p'

echo
echo "== Monero knowledge page =="
curl -sS --max-time 20 "https://$www/monero/" | tee "$tmp_monero" | sed -n '1,20p'

echo
echo "== Recommendations page =="
recommendations_status="$(curl -sS -o "$tmp_recommendations" -w '%{http_code}' --max-time 20 "https://$www/recommendations/")"
printf 'www/recommendations/ status: %s\n' "$recommendations_status"
sed -n '1,20p' "$tmp_recommendations"

echo
echo "== Plasma knowledge page =="
plasma_page_status="$(curl -sS -o "$tmp_plasma_page" -w '%{http_code}' --max-time 20 "https://$www/plasma/")"
printf 'www/plasma/ status: %s\n' "$plasma_page_status"
sed -n '1,20p' "$tmp_plasma_page"

echo
echo "== Aave knowledge page =="
aave_status="$(curl -sS -o "$tmp_aave" -w '%{http_code}' --max-time 20 "https://$www/aave/")"
printf 'www/aave/ status: %s\n' "$aave_status"
sed -n '1,20p' "$tmp_aave"

echo
echo "== Plasma routes =="
curl -sS -D "$tmp_plasma" -o /dev/null -w 'www/plasma status: %{http_code}\n' --max-time 20 "https://$www/plasma"
curl -sS -D "$tmp_aave_route" -o /dev/null -w 'www/aave status: %{http_code}\n' --max-time 20 "https://$www/aave"
plasma_invite_page_status="$(curl -sS -o "$tmp_plasma_invite_page" -w '%{http_code}' --max-time 20 "https://$www/go/plasma-one/")"
printf 'www/go/plasma-one/ status: %s\n' "$plasma_invite_page_status"
sed -n '1,20p' "$tmp_plasma_invite_page"
curl -sS -D "$tmp_plasma_invite" -o /dev/null -w 'www/go/plasma-one status: %{http_code}\n' --max-time 20 "https://$www/go/plasma-one"
curl -sS -D "$tmp_apex_plasma" -o /dev/null -w 'apex/plasma status: %{http_code}\n' --max-time 20 "https://$domain/plasma"
curl -sS -D "$tmp_legacy_logo" -o /dev/null -w 'legacy/logo.png status: %{http_code}\n' --max-time 20 "https://$www/logo.png"

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

  curl --fail -sS --max-time 20 "https://$www/thesis/" > "$tmp_thesis" || {
    echo "live Thesis page is not returning 200" >&2
    exit 1
  }
  grep -q 'https://www.encryptedguru.com/thesis/</loc>' "$tmp_sitemap" || {
    echo "live sitemap missing Thesis page" >&2
    exit 1
  }
  grep -q 'Sovereign Capital Intelligence' "$tmp_home" || {
    echo "live homepage missing the Sovereign Capital Intelligence title" >&2
    exit 1
  }
  grep -q 'id="capital-stack"' "$tmp_thesis" || {
    echo "live Thesis page missing capital-stack anchor" >&2
    exit 1
  }
  grep -q 'id="method"' "$tmp_thesis" || {
    echo "live Thesis page missing method anchor" >&2
    exit 1
  }
  for referral in plasma-one bitfinex binance aave; do
    grep -q "id=\"$referral\"" "$tmp_recommendations" || {
      echo "live Recommendations page missing deep-link target $referral" >&2
      exit 1
    }
  done
  grep -q '<script data-cfasync="false" defer src="/main.js' "$tmp_home" || {
    echo "live homepage script tag lost its Rocket Loader opt-out ordering" >&2
    exit 1
  }

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

  # A default curl request does not reproduce a browser navigation closely
  # enough to catch Cloudflare's conditional HTML injections. Use a browser-
  # shaped request so the zero-analytics promise is tested at the edge.
  curl -sS --compressed \
    -A 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36' \
    -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8' \
    -H 'Accept-Language: en-US,en;q=0.9' \
    -H 'Sec-Fetch-Dest: document' \
    -H 'Sec-Fetch-Mode: navigate' \
    -H 'Sec-Fetch-Site: none' \
    --max-time 20 "https://$www/?eg-runtime-probe=1" > "$tmp_edge_runtime"

  if grep -qiE 'static\.cloudflareinsights\.com|data-cf-beacon' "$tmp_edge_runtime"; then
    echo "live browser-shaped HTML contains an analytics beacon despite the zero-analytics policy" >&2
    exit 1
  fi

  if grep -qi 'rocket-loader\.min\.js' "$tmp_edge_runtime"; then
    echo "warning: live browser-shaped HTML is being rewritten by Cloudflare Rocket Loader" >&2
  fi

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

  grep -q 'https://www.encryptedguru.com/aave/' "$tmp_sitemap" || {
    echo "live sitemap missing Aave page" >&2
    exit 1
  }

  grep -q 'https://www.encryptedguru.com/recommendations/' "$tmp_sitemap" || {
    echo "live sitemap missing Recommendations page" >&2
    exit 1
  }

  grep -q 'og-home.png' "$tmp_home" || {
    echo "live homepage is missing the branded social preview image" >&2
    exit 1
  }

  grep -qi '^HTTP/2 302' "$tmp_legacy_logo" || {
    echo "legacy /logo.png is still served without the replacement boundary" >&2
    exit 1
  }

  grep -qi 'location: /eg-mark.png' "$tmp_legacy_logo" || {
    echo "legacy /logo.png is not redirected to the current EG brand asset" >&2
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

  test "$aave_status" = "200" || {
    echo "live Aave page is not returning 200" >&2
    exit 1
  }

  grep -q '<h1>Aave</h1>' "$tmp_aave" || {
    echo "live Aave page missing expected heading" >&2
    exit 1
  }

  grep -q 'src="/aave-hero.png' "$tmp_aave" || {
    echo "live Aave page is missing its PNG fallback hero asset" >&2
    exit 1
  }

  grep -q 'aave-hero-720.webp' "$tmp_aave" || {
    echo "live Aave page is missing its responsive WebP source" >&2
    exit 1
  }

  grep -q 'monero-hero-720.webp' "$tmp_monero" || {
    echo "live Monero page is missing its responsive WebP source" >&2
    exit 1
  }

  for asset in aave-hero.webp aave-hero-720.webp monero-hero.webp monero-hero-720.webp; do
    asset_status="$(curl -sS -o /dev/null -w '%{http_code}' --max-time 20 "https://$www/$asset?v=20260903")"
    test "$asset_status" = "200" || {
      echo "live responsive hero asset is not returning 200: $asset_status $asset" >&2
      exit 1
    }
  done

  grep -q 'https://aave.com/app/r/999F66' "$tmp_aave" || {
    echo "live Aave page is missing the exact referral entry" >&2
    exit 1
  }

  grep -q 'https://aave.com/docs/resources/risks' "$tmp_aave" || {
    echo "live Aave page is missing official risk documentation" >&2
    exit 1
  }

  test "$recommendations_status" = "200" || {
    echo "live Recommendations page is not returning 200" >&2
    exit 1
  }

  grep -q '<h1>Recommendations</h1>' "$tmp_recommendations" || {
    echo "live Recommendations page missing expected heading" >&2
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

  grep -qi '^HTTP/2 308' "$tmp_plasma" || {
    echo "www/plasma is not returning a 308 redirect to the research page" >&2
    exit 1
  }

  grep -qi '^HTTP/2 308' "$tmp_aave_route" || {
    echo "www/aave is not returning a 308 redirect to the research page" >&2
    exit 1
  }

  grep -qiE '^location: .*\/aave/' "$tmp_aave_route" || {
    echo "www/aave is not pointing at the canonical Aave research page" >&2
    exit 1
  }

  grep -qiE '^location: .*\/plasma/' "$tmp_plasma" || {
    echo "www/plasma is not pointing at the canonical research page" >&2
    exit 1
  }

  grep -qi '^HTTP/2 308' "$tmp_plasma_invite" || {
    echo "www/go/plasma-one is not returning a 308 redirect to the invitation page" >&2
    exit 1
  }

  grep -qiE '^location: .*\/go/plasma-one/' "$tmp_plasma_invite" || {
    echo "www/go/plasma-one is not pointing at the invitation page" >&2
    exit 1
  }

  test "$plasma_invite_page_status" = "200" || {
    echo "live Plasma invitation page is not returning 200" >&2
    exit 1
  }

  grep -q 'https://plasmaone.onelink.me/P8qq?' "$tmp_plasma_invite_page" || {
    echo "live Plasma invitation page is missing the exact provider deep link" >&2
    exit 1
  }

  grep -qi '^HTTP/2 301' "$tmp_apex_plasma" || {
    echo "apex/plasma is not returning a 301 redirect" >&2
    exit 1
  }

  if grep -qiF 'location: https://www.encryptedguru.com/plasma' "$tmp_apex_plasma"; then
    echo "apex/plasma reaches the canonical www research route"
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
