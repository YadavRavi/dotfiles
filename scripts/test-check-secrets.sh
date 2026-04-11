#!/bin/bash
# Tests for scripts/check-secrets.sh. Exit 0 = all pass.
set -euo pipefail

SCRIPT="$(cd "$(dirname "$0")" && pwd)/check-secrets.sh"
PASS=0
FAIL=0

assert() {
    local name="$1" expected_exit="$2" input="$3"
    local actual_exit=0
    echo "$input" | "$SCRIPT" >/dev/null 2>&1 || actual_exit=$?
    if [[ "$actual_exit" -eq "$expected_exit" ]]; then
        echo "  PASS: $name"
        PASS=$((PASS+1))
    else
        echo "  FAIL: $name (expected exit $expected_exit, got $actual_exit)"
        FAIL=$((FAIL+1))
    fi
}

echo "--- check-secrets.sh tests ---"
assert "clean input passes"            0 "+some regular code change"
assert "rani-team.berlin triggers"     1 "+traefik.http.routers.foo.rule=Host(\`foo.rani-team.berlin\`)"
assert "obsidian vault path triggers"  1 "+/Users/raviyadav/Documents/ObsidianSyncedVaults/foo"
assert "homelab path triggers"         1 "+cd /HomeLab/rani-homelab-v2/stacks"
assert "op secret reference triggers"  1 "+token: op://Private/secret/credential"

echo
echo "  passed: $PASS"
echo "  failed: $FAIL"
[[ "$FAIL" -eq 0 ]]
