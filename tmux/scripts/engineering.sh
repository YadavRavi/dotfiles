#!/bin/bash
# Engineering — 2 panes:
#   Top:    shell in rani-homelab-v2
#   Bottom: Claude Code in rani-homelab-v2

SESSION="Engineering"
ENG="$HOME/HomeLab/rani-homelab-v2"

# Pane 0 (top) is already created in $ENG
tmux split-window -v -t "$SESSION" -c "$ENG" -l 60%
tmux send-keys -t "$SESSION:1.2" "claude" Enter

# Focus the shell pane (top)
tmux select-pane -t "$SESSION:1.1"
