#!/bin/bash
# setup.sh — profile-aware dotfiles stow orchestrator.
# Usage:
#   ./setup.sh personal      # first run
#   ./setup.sh work          # first run on work laptop
#   ./setup.sh               # subsequent runs (reads ~/.dotfiles-profile)
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# --- Profile resolution ---
PROFILE="${1:-}"
MARKER="$HOME/.dotfiles-profile"
if [[ -z "$PROFILE" && -f "$MARKER" ]]; then
    PROFILE=$(cat "$MARKER")
fi
if [[ -z "$PROFILE" ]]; then
    echo "Usage: $0 <personal|work>  (first run — marker file missing)" >&2
    exit 1
fi

PROFILE_FILE="$DOTFILES_DIR/profiles/$PROFILE.txt"
if [[ ! -f "$PROFILE_FILE" ]]; then
    echo "Unknown profile: $PROFILE (no $PROFILE_FILE)" >&2
    exit 1
fi

echo "$PROFILE" > "$MARKER"

echo "=== Dotfiles setup — profile: $PROFILE ==="
echo "Dotfiles dir: $DOTFILES_DIR"
echo

# --- Stow packages listed in the profile ---
echo "--- Stowing packages ---"
cd "$DOTFILES_DIR/packages"
while IFS= read -r line || [[ -n "$line" ]]; do
    pkg="${line%%#*}"                # strip trailing comment
    pkg="${pkg// /}"                 # strip whitespace
    [[ -z "$pkg" ]] && continue
    if [[ -d "$pkg" ]]; then
        if stow --restow --dir="$DOTFILES_DIR/packages" --target="$HOME" "$pkg" 2>/dev/null; then
            echo "  [stowed] $pkg"
        else
            echo "  [warn] $pkg stow failed — check for conflicts"
        fi
    else
        echo "  [skip] $pkg (directory not found under packages/)"
    fi
done < "$PROFILE_FILE"
echo

# --- Seed overlay templates (machine-specific, gitignored) ---
echo "--- Installing overlay templates ---"
install_overlay() {
    local template="$1" target="$2" name="$3"
    if [[ -f "$target" ]]; then
        echo "  [skip] $name already at $target"
    elif [[ -f "$template" ]]; then
        mkdir -p "$(dirname "$target")"
        cp "$template" "$target"
        echo "  [created] $name → $target (edit for this machine)"
    else
        echo "  [skip] $name (template $template not found)"
    fi
}

TEMPLATES="$DOTFILES_DIR/overlays/templates"
install_overlay "$TEMPLATES/zshrc.local.example"          "$HOME/.zshrc.local"               "zsh local"
install_overlay "$TEMPLATES/ghostty.local.example"        "$HOME/.config/ghostty/local"      "ghostty local"
install_overlay "$TEMPLATES/gitconfig.$PROFILE.example"   "$HOME/.gitconfig-$PROFILE"        "git $PROFILE identity"
install_overlay "$TEMPLATES/sesh.toml.example"            "$HOME/.config/sesh/sesh.toml"     "sesh (legacy)"
echo

echo "=== done. profile=$PROFILE ==="
echo
echo "Next steps:"
echo "  1. Edit ~/.zshrc.local and ~/.gitconfig-$PROFILE for this machine"
echo "  2. exec zsh (or open a new Ghostty window)"
echo "  3. Type 'zj' to land in Zellij"
