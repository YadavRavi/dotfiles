#!/bin/sh
# app-spaces.sh (work) — create the LCARS / DPP / AI-Natives spaces in the Herdr desktop app.
# Same shape as the personal app: per space, tabs <station> (claude) | NVIM | Shell.
# No Counselor / Engineering on the work machine. Spaces persist in herdr-core, so run once
# with the app open:  sh ~/.config/herdr/app-spaces.sh   (re-runs skip spaces that exist)
# ponytail: TUI equivalent is main-layout.sh next to this; delete it once the TUI is retired.
set -e

VAULT="$HOME/Documents/ObsidianSyncedVaults/SecondBrain"
LATEST_LOG='nvim "$(ls -t "$HOME"/Documents/ObsidianSyncedVaults/SecondBrain/daily-logs/$(date +%Y)/*.md 2>/dev/null | head -1)"'

mk() { # $1=space $2=folder $3=station-tab argv (JSON) for NVIM tab
    if herdr-app ls | jq -e --arg n "$1" '.spaces[] | select(.name == $n)' >/dev/null; then
        echo "skip $1 (exists)"; return
    fi
    id=$(herdr-app do space.new --name "$1" --folder "$2" --tab "$1" --argv '["claude"]' | jq -r .space)
    herdr-app do tab.new --space "$id" --name NVIM --folder "$2" --argv "$3" >/dev/null
    herdr-app do tab.new --space "$id" --name Shell --folder "$2" >/dev/null
    echo "created $1 ($2)"
}

mk LCARS      "$VAULT"                    "$(jq -nc --arg c "$LATEST_LOG" '["sh","-c",$c]')"
mk DPP        "$VAULT/kb/dpp"             '["nvim"]'
mk AI-Natives "$HOME/Projects/AI-Natives" '["nvim"]'
