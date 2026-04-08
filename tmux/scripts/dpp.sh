#!/bin/bash
# DPP — 2 panes:
#   Top:    shell in kb/dpp
#   Bottom: Claude Code in kb/dpp

SESSION="DPP"
DPP="$HOME/Documents/ObsidianSyncedVaults/SecondBrain/kb/dpp"

# Pane 0 (top) is already created in $DPP
tmux split-window -v -t "$SESSION" -c "$DPP" -l 60%
tmux send-keys -t "$SESSION:1.2" "claude" Enter

# Focus the shell pane (top)
tmux select-pane -t "$SESSION:1.1"
