#!/bin/sh
# main-layout.sh — recreate the Zellij main.kdl 5-context layout as herdr workspaces.
# Per workspace: top-left shell | top-right nvim | bottom claude (same as main.kdl).
# Run once per fresh herdr session: sh ~/.config/herdr/main-layout.sh
set -e

VAULT="$HOME/Documents/ObsidianSyncedVaults/SecondBrain"

mk() { # $1=label $2=cwd $3=command for top-right pane
    top=$(herdr workspace create --cwd "$2" --label "$1" --no-focus | jq -r .result.root_pane.pane_id)
    bottom=$(herdr pane split "$top" --direction down --ratio 0.5 | jq -r .result.pane.pane_id)
    right=$(herdr pane split "$top" --direction right --ratio 0.5 | jq -r .result.pane.pane_id)
    # name shell/nvim panes; claude stays unnamed so the agent status label shows
    herdr pane rename "$top" shell >/dev/null
    herdr pane rename "$right" nvim >/dev/null
    sleep 0.3 # let the pane shells start before typing into them
    herdr pane run "$right" "$3" >/dev/null
    herdr pane run "$bottom" "claude" >/dev/null
    echo "created $1 ($2)"
}

# LCARS — 3 sub-tabs Ops/Lab/Shell (from lcars.kdl).
# Ops: vault listing + today's daily log on top (40%), claude bottom (60%).
top=$(herdr workspace create --cwd "$VAULT" --label LCARS --no-focus | jq -r .result.root_pane.pane_id)
ws=${top%%:*}
herdr tab rename "${ws}:t1" Ops >/dev/null
bottom=$(herdr pane split "$top" --direction down --ratio 0.6 | jq -r .result.pane.pane_id)
right=$(herdr pane split "$top" --direction right --ratio 0.5 | jq -r .result.pane.pane_id)
herdr pane rename "$top" vault >/dev/null   # pane names as in lcars.kdl
herdr pane rename "$right" trace >/dev/null # claude pane unnamed -> agent label
sleep 0.3
herdr pane run "$top" 'ls -al' >/dev/null
herdr pane run "$right" 'nvim $(ls -t ~/Documents/ObsidianSyncedVaults/SecondBrain/daily-logs/$(date +%Y)/*.md 2>/dev/null | head -1)' >/dev/null
herdr pane run "$bottom" 'claude' >/dev/null
herdr tab create --workspace "$ws" --cwd "$VAULT" --label Lab --no-focus >/dev/null
herdr tab create --workspace "$ws" --cwd "$VAULT" --label Shell --no-focus >/dev/null
echo "created LCARS ($VAULT) with Ops/Lab/Shell tabs"
mk DPP         "$VAULT/kb/dpp"             nvim
mk AI-Natives  "$HOME/Projects/AI-Natives" nvim
mk Counselor   "$VAULT/kb"                 nvim
mk Engineering "$HOME/HomeLab/rani-homelab-v2" nvim
