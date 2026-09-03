#!/usr/bin/env sh
set -eu

cd "$(dirname "$0")/.."

./scripts/audit-source.sh

output="dist"
rm -rf "$output"
mkdir -p "$output"

for file in \
  index.html \
  404.html \
  styles.css \
  main.js \
  eg-mark.png \
  eg-mark-32.png \
  eg-mark.ico \
  eg-mark-180.png \
  og-home.png \
  monero-hero.png \
  monero-hero.webp \
  monero-hero-720.webp \
  plasma-hero.jpg \
  aave-hero.png \
  aave-hero.webp \
  aave-hero-720.webp \
  site.webmanifest \
  robots.txt \
  sitemap.xml \
  _headers \
  _redirects \
  _routes.json
do
  cp "$file" "$output/"
done

for directory in .well-known aave contact docs go infrastructure labs monero plasma projects recommendations; do
  cp -R "$directory" "$output/"
done

if find "$output" -type f \( \
  -name '*.md' -o \
  -name '*.sh' -o \
  -name '*.zip' -o \
  -name '*.log' \
\) -print | grep -q .; then
  echo "non-public source artifact entered $output" >&2
  exit 1
fi

if find "$output" -type l -print | grep -q .; then
  echo "symbolic link entered $output" >&2
  exit 1
fi

test -f "$output/index.html"
test -f "$output/404.html"
test -f "$output/monero/index.html"
test -f "$output/plasma/index.html"
test -f "$output/aave/index.html"
test -f "$output/go/plasma-one/index.html"
test -f "$output/recommendations/index.html"
test -f "$output/og-home.png"
test -f "$output/aave-hero.png"
test -f "$output/eg-mark.png"
test -f "$output/eg-mark-32.png"
test -f "$output/eg-mark.ico"
test -f "$output/eg-mark-180.png"
test ! -e "$output/logo.png"
test ! -e "$output/favicon-32x32.png"
test ! -e "$output/apple-touch-icon.png"
test -f "$output/projects/index.html"
test -f "$output/projects/gmcp/index.html"
test -f "$output/.well-known/security.txt"
test -f "$output/_routes.json"

printf 'public build ready: %s files in %s/\n' "$(find "$output" -type f | wc -l | tr -d ' ')" "$output"
