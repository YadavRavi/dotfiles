#!/bin/bash
# Engineering — 2 panes:
#   Top:    shell in rani-homelab-v2
#   Bottom: Claude Code in rani-homelab-v2

SESSION="Engineering"
ENG="${HOMELAB_PATH:-$HOME/HomeLab/rani-homelab-v2}"

tmux split-window -v -t "$SESSION" -c "$ENG" -l 60%
command -v claude >/dev/null && tmux send-keys -t "$SESSION:1.2" "claude" Enter

tmux select-pane -t "$SESSION:1.1"
