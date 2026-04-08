#!/bin/bash
# LCARS — 3 panes:
#   Top-left:  vault dir listing (ll)
#   Top-right: current daily-logs dir
#   Bottom:    Claude Code

SESSION="LCARS"
VAULT="${OSTRICH_VAULT:-$HOME/Documents/ObsidianSyncedVaults/SecondBrain}"
DAILYDIR="$VAULT/daily-logs"
LATEST="$(find "$DAILYDIR" -type f -name '*.md' 2>/dev/null | sort -r | head -1)"

tmux split-window -v -t "$SESSION" -c "$VAULT" -l 60%
tmux split-window -h -t "$SESSION:1.1" -c "$DAILYDIR"

tmux send-keys -t "$SESSION:1.1" "ll" Enter
[ -n "$LATEST" ] && tmux send-keys -t "$SESSION:1.2" "nvim $LATEST" Enter
command -v claude >/dev/null && tmux send-keys -t "$SESSION:1.3" "claude" Enter

tmux select-pane -t "$SESSION:1.3"
