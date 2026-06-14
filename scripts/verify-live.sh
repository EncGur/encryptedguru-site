#!/usr/bin/env sh
set -eu

domain="encryptedguru.com"
www="www.encryptedguru.com"

echo "== HTTP =="
curl -sS -I -L --max-time 20 "https://$domain/" | sed -n '1,80p'

echo
echo "== security.txt =="
curl -sS --max-time 20 "https://$www/.well-known/security.txt"

echo
echo "== sitemap =="
curl -sS --max-time 20 "https://$www/sitemap.xml" | sed -n '1,80p'

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
