#!/bin/bash
# DPP — 2 panes:
#   Top:    shell in kb/dpp
#   Bottom: Claude Code in kb/dpp

SESSION="DPP"
DPP="${OSTRICH_VAULT:-$HOME/Documents/ObsidianSyncedVaults/SecondBrain}/kb/dpp"

tmux split-window -v -t "$SESSION" -c "$DPP" -l 60%
command -v claude >/dev/null && tmux send-keys -t "$SESSION:1.2" "claude" Enter

tmux select-pane -t "$SESSION:1.1"
