#!/bin/bash
session=$(sesh list -t -c -z | fzf \
  --no-sort --ansi --border-label ' sesh ' --prompt '⚡  ' \
  --header '  ^a all ^t tmux ^x config ^z zoxide  ^d kill  ^f find' \
  --bind 'tab:down,btab:up' \
  --bind 'ctrl-a:change-prompt(⚡  )+reload(sesh list -t -c -z)' \
  --bind 'ctrl-t:change-prompt(🪟  )+reload(sesh list -t)' \
  --bind 'ctrl-x:change-prompt(⚙️  )+reload(sesh list -c)' \
  --bind 'ctrl-z:change-prompt(📁  )+reload(sesh list -z)' \
  --bind 'ctrl-f:change-prompt(🔎  )+reload(fd -H -d 2 -t d . ~)' \
  --bind 'ctrl-d:execute(tmux kill-session -t {})+reload(sesh list -t -c -z)')

[ -n "$session" ] && sesh connect "$session"
