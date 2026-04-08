#!/bin/bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
TEMPLATES="$DOTFILES_DIR/local-templates"

echo "=== Dotfiles Setup ==="
echo "Dotfiles dir: $DOTFILES_DIR"
echo ""

# --- Helper ---
install_overlay() {
    local template="$1"
    local target="$2"
    local name="$3"

    if [ -f "$target" ]; then
        echo "  [skip] $name already exists at $target"
    else
        mkdir -p "$(dirname "$target")"
        cp "$template" "$target"
        echo "  [created] $name → $target (edit for this machine)"
    fi
}

# --- Step 1: Stow packages ---
echo "--- Stowing packages ---"
cd "$DOTFILES_DIR"
for pkg in zsh tmux nvim ghostty git gh ripgrep; do
    if [ -d "$pkg" ]; then
        stow --restow "$pkg" 2>/dev/null && echo "  [stowed] $pkg" || echo "  [warn] $pkg stow failed (may need --adopt)"
    fi
done
echo ""

# --- Step 2: Install overlay files ---
echo "--- Installing overlay templates ---"
install_overlay "$TEMPLATES/zshrc.local.example"       "$HOME/.zshrc.local"                    "zsh local"
install_overlay "$TEMPLATES/tmux-local.conf.example"   "$HOME/.config/tmux/local.conf"         "tmux local"
install_overlay "$TEMPLATES/ghostty-local.example"     "$HOME/.config/ghostty/local"            "ghostty local"
install_overlay "$TEMPLATES/nvim-local.lua.example"    "$HOME/.config/nvim/lua/configs/local.lua" "nvim local"
install_overlay "$TEMPLATES/gitconfig.local.example"   "$HOME/.gitconfig.local"                "git local"
install_overlay "$TEMPLATES/sesh.toml.example"         "$HOME/.config/sesh/sesh.toml"          "sesh config"
echo ""

# --- Step 3: Install TPM if missing ---
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    echo "--- Installing TPM ---"
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    echo "  [installed] TPM — run prefix+I in tmux to install plugins"
else
    echo "--- TPM already installed ---"
fi
echo ""

# --- Step 4: Claude Code keybindings ---
CLAUDE_KB="$HOME/.claude/keybindings.json"
if [ ! -f "$CLAUDE_KB" ]; then
    echo "--- Creating Claude Code keybindings ---"
    mkdir -p "$HOME/.claude"
    cat > "$CLAUDE_KB" << 'KEYBINDINGS'
{
  "bindings": [
    {
      "context": "Chat",
      "bindings": {
        "alt+o": null
      }
    }
  ]
}
KEYBINDINGS
    echo "  [created] $CLAUDE_KB (Alt+O unbound for tmux)"
else
    echo "--- Claude Code keybindings already exist ---"
fi
echo ""

# --- Done ---
echo "=== Setup complete ==="
echo ""
echo "Next steps:"
echo "  1. Edit overlay files for this machine:"
echo "     - ~/.zshrc.local           (SSH agent, conda, paths)"
echo "     - ~/.gitconfig.local       (name, email, signing key)"
echo "     - ~/.config/tmux/local.conf (terminal, clipboard)"
echo "     - ~/.config/sesh/sesh.toml  (session paths)"
echo "     - ~/.config/ghostty/local   (opacity, display prefs)"
echo "  2. Restart your shell:  exec zsh"
echo "  3. Open tmux and install plugins:  prefix + I"
echo "  4. Open nvim and let Mason install LSPs"
