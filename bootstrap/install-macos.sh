#!/bin/bash
# install-macos.sh — fresh-machine bootstrap for the dotfiles stack.
# Installs xcode-cli, Homebrew, Brewfile bundle, then runs setup.sh.
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"

PROFILE="${1:-}"
if [[ -z "$PROFILE" ]]; then
    echo "Usage: $0 <personal|work>" >&2
    exit 1
fi

echo "=== macOS bootstrap for profile: $PROFILE ==="
echo "Dotfiles dir: $DOTFILES_DIR"
echo

# --- 1. Xcode CLI tools ---
if ! xcode-select -p &>/dev/null; then
    echo "--- Installing Xcode command line tools ---"
    xcode-select --install
    echo "Re-run this script after the Xcode installer window completes."
    exit 0
fi
echo "[ok] Xcode CLI tools present"

# --- 2. Homebrew ---
if ! command -v brew &>/dev/null; then
    echo "--- Installing Homebrew ---"
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    if [[ -x /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -x /usr/local/bin/brew ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
fi
echo "[ok] Homebrew present: $(brew --version | head -1)"

# --- 3. Brewfile bundle ---
echo "--- Running brew bundle (profile: $PROFILE) ---"
DOTFILES_PROFILE="$PROFILE" brew bundle --file="$DOTFILES_DIR/bootstrap/Brewfile"

# --- 4. Stow packages ---
echo "--- Running setup.sh $PROFILE ---"
"$DOTFILES_DIR/setup.sh" "$PROFILE"

# --- 5. Checklist ---
echo
echo "=== bootstrap complete ==="
echo "Manual steps remaining:"
if [[ "$PROFILE" == "personal" ]]; then
    echo "  1. Sign in to 1Password (eval \$(op signin))"
    echo "  2. Clone personal projects into ~/Projects"
    echo "  3. Verify homelab SSH aliases: ssh docker-vm"
elif [[ "$PROFILE" == "work" ]]; then
    echo "  1. Edit ~/.gitconfig-work with work email + signing method"
    echo "  2. gh auth login (work SSO if required)"
    echo "  3. Edit ~/.zshrc.local for any work-specific env"
fi
echo "  4. Open a new Ghostty window → should auto-land in Zellij"
