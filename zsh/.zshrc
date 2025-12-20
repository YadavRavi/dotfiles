# Initialize Homebrew if it exists
if [[ -f "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f "/usr/local/bin/brew" ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

# 1Password SSH agent
export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock

# Set the directory where to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it doesn’t exist
if [ ! -d "$ZINIT_HOME" ]; then
	mkdir -p "$(dirname $ZINIT_HOME)"
	git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Plugins go here:

# Syntax Highlighting
zinit light zsh-users/zsh-syntax-highlighting
# ZSH Completion
zinit light zsh-users/zsh-completions
# Load Completions
autoload -U compinit && compinit
zinit cdreplay -q

# zoxide will be initialized later with cd override

# ZSH Autosuggestions
zinit light zsh-users/zsh-autosuggestions

# fzf will be initialized later

# FZF Tab
zinit light Aloxaf/fzf-tab

# EZA replacement for ls
zinit light z-shell/zsh-eza

# Add in snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/raviyadav/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/raviyadav/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/raviyadav/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/raviyadav/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
# Keybindings

bindkey '^y' autosuggest-accept
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward


# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -la --icons --git --color=always --group-directories-first $realpath 2>/dev/null || ls -la --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -la --icons --git --color=always --group-directories-first $realpath 2>/dev/null || ls -la --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_zi:*' fzf-preview 'eza -la --icons --git --color=always --group-directories-first $realpath 2>/dev/null || ls -la --color $realpath'

# Aliases
alias ff='ls | fzf'
command -v bat >/dev/null && alias cat='bat'
alias ls='eza --group-directories-first --icons'
alias l='eza --git-ignore --group-directories-first --icons'
alias ll='eza --all --header --long --group-directories-first --icons'
alias llm='eza --all --header --long --sort=modified --group-directories-first --icons'
alias la='eza -lbhHigUmuSa'
alias lx='eza -lbhHigUmuSa@'
alias lt='eza --tree --group-directories-first --icons'
alias tree='eza --tree --group-directories-first --icons'
alias oo='cd $HOME/Documents/ObsidianSyncedVaults/SecondBrain/'
alias bup='brew update && brew upgrade && exec zsh'
command -v nvim >/dev/null && alias nfz='nvim $(fzf -m --preview="bat --color=always {}")'

# yazi wrapper function
if command -v yazi >/dev/null; then
    function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
    }
fi

# Initialize fzf
command -v fzf >/dev/null && eval "$(fzf --zsh)"

# iTerm2 shell integration
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# Zellij auto-start and helper functions
if command -v zellij >/dev/null; then
    eval "$(zellij setup --generate-auto-start zsh)"
    function zr () { zellij run --name "$*" -- zsh -ic "$*";}
    function zrf () { zellij run --name "$*" --floating -- zsh -ic "$*";}
    function zri () { zellij run --name "$*" --in-place -- zsh -ic "$*";}
    function ze () { zellij edit "$*";}
    function zef () { zellij edit --floating "$*";}
    function zei () { zellij edit --in-place "$*";}
    function zpipe () {
      if [ -z "$1" ]; then
        zellij pipe;
      else
        zellij pipe -p $1;
      fi
    }
fi

export PATH="/opt/homebrew/opt/curl/bin:$PATH"

# Initialize zoxide with cd override
command -v zoxide >/dev/null && eval "$(zoxide init --cmd cd zsh)"

# Zoxide aliases
alias z="cd"    # Short alias for zoxide-powered cd
alias zi="cdi"  # Short alias for interactive directory selection
alias zs="zoxide query -s"  # Show zoxide statistics

# Zoxide environment variables
export _ZO_MAXAGE=10000      # Keep more entries in the database
export _ZO_RESOLVE_SYMLINKS=1 # Resolve symlinks before adding to database

# Set default editor
if command -v nvim >/dev/null; then
    export EDITOR=nvim
else
    export EDITOR=vim
fi

# Initialize thefuck
command -v thefuck >/dev/null && eval $(thefuck --alias)

# Created by `pipx` on 2025-06-13 14:30:17
export PATH="$PATH:/Users/raviyadav/.local/bin"

# Task Master aliases added on 6/30/2025
alias tm='task-master'
alias taskmaster='task-master'
