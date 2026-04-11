#!/bin/bash
# check-secrets.sh — scan stdin for patterns that must not land in the shared repo.
# Exit 0 if clean, 1 if any pattern matches.
set -euo pipefail

BLOCKLIST=(
    'rani-team\.berlin'
    '/Users/raviyadav/Documents/ObsidianSyncedVaults'
    '/HomeLab/rani-homelab-v2'
    'op://[^[:space:]]+/[Ss]ecret'
)

input=$(cat)
fail=0
for pattern in "${BLOCKLIST[@]}"; do
    if echo "$input" | grep -E "$pattern" >/dev/null 2>&1; then
        echo "check-secrets: match for pattern '$pattern'" >&2
        fail=1
    fi
done

if [[ "$fail" -eq 1 ]]; then
    echo "check-secrets: blocked. Move content to overlay (gitignored) or scrub." >&2
    exit 1
fi
exit 0
