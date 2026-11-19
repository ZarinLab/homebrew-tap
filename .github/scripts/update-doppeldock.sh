#!/bin/bash
# Point Formula/doppeldock.rb at the latest DoppelDock release.
#
#   .github/scripts/update-doppeldock.sh [VERSION]
#
# Without VERSION it asks GitHub for the latest release. Prints the new version
# when the formula was changed, nothing when it was already up to date.
# Runs on macOS and Linux (uses perl for in-place edits).

set -euo pipefail

FORMULA="Formula/doppeldock.rb"
REPO="ZarinLab/doppeldock"

if [[ $# -ge 1 ]]; then
  version="${1#v}"
else
  version="$(curl -fsSL -H "Accept: application/vnd.github+json" "https://api.github.com/repos/$REPO/releases/latest" \
    | perl -ne 'print $1 if /"tag_name"\s*:\s*"v?([^"]+)"/')"
fi
[[ "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || { echo "update-doppeldock: bad version '$version'" >&2; exit 1; }

current="$(perl -ne 'print $1 if m{^  url "[^"]*/v([0-9]+\.[0-9]+\.[0-9]+)/doppeldock-[^"]*\.tar\.gz"} || m{^  url "[^"]*/archive/refs/tags/v([^"/]+)\.tar\.gz"}' "$FORMULA")"
if [[ "$version" == "$current" ]]; then
  echo "doppeldock is up to date ($current)" >&2
  exit 0
fi

# Prefer the release's own source archive (signed build provenance), and check
# it against the release's SHA256SUMS. Only releases that don't have one (a 404,
# not any other error) fall back to GitHub's automatic archive.
asset="doppeldock-$version.tar.gz"
url="https://github.com/$REPO/releases/download/v$version/$asset"
code="$(curl -sIL -o /dev/null -w '%{http_code}' "$url")"
if [[ "$code" == 200 ]]; then
  sha="$(curl -fsSL "$url" | shasum -a 256 | cut -d' ' -f1)"
  sums="$(curl -fsSL "https://github.com/$REPO/releases/download/v$version/SHA256SUMS")" \
    || { echo "update-doppeldock: release v$version has no SHA256SUMS" >&2; exit 1; }
  grep -qx "$sha  $asset" <<<"$sums" \
    || { echo "update-doppeldock: $asset does not match the release's SHA256SUMS" >&2; exit 1; }
elif [[ "$code" == 404 ]]; then
  url="https://github.com/$REPO/archive/refs/tags/v$version.tar.gz"
  sha="$(curl -fsSL "$url" | shasum -a 256 | cut -d' ' -f1)"
else
  echo "update-doppeldock: could not reach $url (HTTP $code); try again later" >&2
  exit 1
fi
[[ "$sha" =~ ^[0-9a-f]{64}$ ]] || { echo "update-doppeldock: could not checksum $url" >&2; exit 1; }

URL="$url" SHA="$sha" perl -pi -e 's{^  url ".*"$}{  url "$ENV{URL}"}; s{^  sha256 ".*"$}{  sha256 "$ENV{SHA}"}' "$FORMULA"
if ! grep -q "  url \"$url\"" "$FORMULA" || ! grep -q "  sha256 \"$sha\"" "$FORMULA"; then
  echo "update-doppeldock: editing $FORMULA failed" >&2
  exit 1
fi

echo "doppeldock $current -> $version" >&2
echo "$version"
