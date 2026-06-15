#!/usr/bin/env sh
set -eu

cd "$(dirname "$0")/.."

expected_remote="git@github-cbdtaeff:cbdtaeff/encryptedguru-site.git"

actual_remote="$(git remote get-url origin 2>/dev/null || true)"
if [ "$actual_remote" != "$expected_remote" ]; then
  echo "origin is not set to expected remote" >&2
  echo "expected: $expected_remote" >&2
  echo "actual:   ${actual_remote:-<missing>}" >&2
  exit 1
fi

if ! ssh -T github-cbdtaeff >/tmp/encryptedguru-ssh-check.out 2>&1; then
  cat /tmp/encryptedguru-ssh-check.out >&2
  echo "GitHub SSH authentication is not ready. Add the exported public key to GitHub first." >&2
  exit 1
fi

if ! git ls-remote origin >/tmp/encryptedguru-ls-remote.out 2>&1; then
  cat /tmp/encryptedguru-ls-remote.out >&2
  echo "Remote repository is not reachable. Create cbdtaeff/encryptedguru-site or check permissions." >&2
  exit 1
fi

echo "remote is ready"
