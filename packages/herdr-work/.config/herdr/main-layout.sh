#!/bin/sh
# main-layout.sh (work) — recreate the zellij-work main.kdl 3-context layout as herdr workspaces.
# Stations: LCARS / DPP / AI-Natives — no Counselor or Engineering on the work machine.
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

# LCARS — single tab with the daily-log auto-open trick (as in zellij-work main.kdl,
# no Ops/Lab/Shell sub-tabs — those are personal-profile only).
top=$(herdr workspace create --cwd "$VAULT" --label LCARS --no-focus | jq -r .result.root_pane.pane_id)
bottom=$(herdr pane split "$top" --direction down --ratio 0.5 | jq -r .result.pane.pane_id)
right=$(herdr pane split "$top" --direction right --ratio 0.5 | jq -r .result.pane.pane_id)
herdr pane rename "$top" shell >/dev/null
herdr pane rename "$right" daily-log >/dev/null
sleep 0.3
herdr pane run "$right" 'nvim $(ls -t ~/Documents/ObsidianSyncedVaults/SecondBrain/daily-logs/$(date +%Y)/*.md 2>/dev/null | head -1)' >/dev/null
herdr pane run "$bottom" 'claude' >/dev/null
echo "created LCARS ($VAULT)"

mk DPP        "$VAULT/kb/dpp"             nvim
mk AI-Natives "$HOME/Projects/AI-Natives" nvim
