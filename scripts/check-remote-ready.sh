#!/usr/bin/env sh
set -eu

cd "$(dirname "$0")/.."

expected_suffix="EncGur/encryptedguru-site.git"

actual_remote="$(git remote get-url origin 2>/dev/null || true)"
case "${actual_remote:-}" in
  *"$expected_suffix") ;;
  *)
    echo "origin is not set to the EncryptedGuru public repository" >&2
    echo "expected any URL ending in: $expected_suffix" >&2
    echo "actual:   ${actual_remote:-<missing>}" >&2
    exit 1
    ;;
esac

if ! git ls-remote origin >/tmp/encryptedguru-ls-remote.out 2>&1; then
  cat /tmp/encryptedguru-ls-remote.out >&2
  echo "Remote repository is not reachable. Check network access or GitHub authentication." >&2
  exit 1
fi

echo "remote is ready"
