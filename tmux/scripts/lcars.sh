#!/bin/bash
# LCARS — 3 panes:
#   Top-left:  vault dir listing (ll)
#   Top-right: current daily-logs dir
#   Bottom:    Claude Code

SESSION="LCARS"
VAULT="$HOME/Documents/ObsidianSyncedVaults/SecondBrain"
DAILYDIR="$VAULT/daily-logs"
LATEST="$(find "$DAILYDIR" -type f -name '*.md' | sort -r | head -1)"

# Layout:
#   ┌──────────┬──────────┐
#   │ vault ll │ daily-log│  40%
#   ├──────────┴──────────┤
#   │     Claude Code     │  60%
#   └─────────────────────┘

# Pane 1 (top) is already created in $VAULT
# Pane 1 exists (top). Split bottom for Claude Code → pane 2
tmux split-window -v -t "$SESSION" -c "$VAULT" -l 60%

# Split top pane horizontally for daily-log → pane 2 (inserts between 1 and old 2)
# After this: 1=top-left, 2=top-right, 3=bottom (Claude)
tmux split-window -h -t "$SESSION:1.1" -c "$DAILYDIR"

# Send commands to correct panes
tmux send-keys -t "$SESSION:1.1" "ll" Enter
tmux send-keys -t "$SESSION:1.2" "nvim $LATEST" Enter
tmux send-keys -t "$SESSION:1.3" "claude" Enter

# Focus the Claude pane (bottom)
tmux select-pane -t "$SESSION:1.3"
