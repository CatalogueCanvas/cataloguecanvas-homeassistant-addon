#!/usr/bin/env bash
set -euo pipefail

OWNER="${OWNER:-CatalogueCanvas}"
REPO="${REPO:-cataloguecanvas-homeassistant-addon}"

# Only the production add-on is tracked. cataloguecanvas_test is deliberately
# left out: its pull counts are test noise, not usage.
SLUG="cataloguecanvas"
PACKAGES=(
    "amd64-cataloguecanvas-homeassistant"
    "aarch64-cataloguecanvas-homeassistant"
)

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
OUT="${1:-$REPO_ROOT/.github/stats/downloads.csv}"
GENERATED="${GENERATED:-$(date -u +%Y-%m-%d)}"

mkdir -p "$(dirname "$OUT")"

# GitHub renders the count in an <h3 title="N"> some tags after the "Total
# downloads" label, so the label and the number are not adjacent. Newlines are
# stripped first and the gap matched non-greedily. perl, not grep -P: BSD grep
# on macOS has no -P, and this script is run locally as well as in CI.
scrape_one() {
    local pkg="$1" page count
    page=$(curl -sL "https://github.com/$OWNER/$REPO/pkgs/container/$pkg" | tr -d '\n')
    count=$(perl -ne 'print "$1\n" if m{Total downloads</span>.*?<h3 title="([0-9,]+)"}' <<< "$page" \
        | head -1 | tr -d ',') || true
    [ -n "$count" ] || return 1
    echo "$count"
}

total=0
for pkg in "${PACKAGES[@]}"; do
    if ! count=$(scrape_one "$pkg"); then
        # Fail loudly. Writing a 0 here would put a false dip in the history
        # line that no later run can distinguish from a real one.
        echo "::error::$pkg: could not read download count" >&2
        exit 1
    fi
    echo "$pkg: $count"
    total=$(( total + count ))
done

if [ "$total" -eq 0 ]; then
    echo "::error::total download count is 0, refusing to write" >&2
    exit 1
fi

[ -f "$OUT" ] || echo "date,slug,downloads" > "$OUT"

# Re-runs on the same day (workflow_dispatch, a retried job) replace that day's
# row instead of appending a duplicate.
tmp="$(mktemp)"
grep -v "^${GENERATED},${SLUG}," "$OUT" > "$tmp" || true
echo "${GENERATED},${SLUG},${total}" >> "$tmp"

# Header first, then rows sorted by date, so the CSV reads chronologically.
{
    head -1 "$tmp"
    tail -n +2 "$tmp" | sort -t, -k1,1
} > "$OUT"
rm -f "$tmp"

echo "wrote ${GENERATED},${SLUG},${total} to $OUT"
