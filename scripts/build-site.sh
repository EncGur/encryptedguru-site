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
  logo.png \
  monero-hero.png \
  plasma-hero.jpg \
  favicon.ico \
  favicon-32x32.png \
  apple-touch-icon.png \
  site.webmanifest \
  robots.txt \
  sitemap.xml \
  _headers \
  _redirects \
  _routes.json
do
  cp "$file" "$output/"
done

for directory in .well-known contact docs infrastructure labs monero plasma projects; do
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
test -f "$output/projects/index.html"
test -f "$output/projects/gmcp/index.html"
test -f "$output/.well-known/security.txt"
test -f "$output/_routes.json"

printf 'public build ready: %s files in %s/\n' "$(find "$output" -type f | wc -l | tr -d ' ')" "$output"
