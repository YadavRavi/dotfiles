# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a macOS dotfiles repository managed with GNU Stow. Each top-level directory is a "stow package" that mirrors the structure of the home directory.

## Stow Management

Each directory represents a stow package. The directory structure inside each package maps to the home directory:
- `zsh/.zshrc` → `~/.zshrc`
- `nvim/.config/nvim/` → `~/.config/nvim/`
- `git/.gitconfig` → `~/.gitconfig`

```bash
# Link a package (from repo root)
stow <package>

# Unlink a package
stow -D <package>

# Restow (unlink then link)
stow -R <package>

# Preview changes without applying
stow -n <package>
```

## Packages

| Package | Contents |
|---------|----------|
| `zsh` | Zsh config with Zinit plugin manager |
| `nvim` | NvChad-based Neovim config |
| `ghostty` | Ghostty terminal config |
| `wezterm` | WezTerm terminal config |
| `git` | Git config with SSH signing via 1Password |
| `bash` | Bash profile with Conda/Rancher Desktop |
| `nix` | Nix-darwin flake for macOS system config |
| `ripgrep` | Ripgrep default options |
| `gh` | GitHub CLI config |
| `gpt4all` | GPT4All settings |

## Key Configurations

### Zsh (`zsh/.zshrc`)
- Plugin manager: Zinit (auto-installed if missing)
- Plugins: zsh-syntax-highlighting, zsh-completions, zsh-autosuggestions, fzf-tab, zsh-eza
- CLI tools: zoxide (replaces cd), fzf, bat, eza, yazi
- Keybindings: `^y` accept suggestion, `^p/^n` history search, `jk` escape in nvim

### Neovim (`nvim/.config/nvim/`)
Based on NvChad v2.5. See `nvim/.config/nvim/CLAUDE.md` for detailed guidance.
- `:Lazy` for plugin management
- `:Mason` for LSP/formatter management

### Nix-Darwin (`nix/.config/nix-darwin/`)
```bash
# Build and apply system configuration
darwin-rebuild build --flake ~/.config/nix-darwin#NCX-101138
darwin-rebuild switch --flake ~/.config/nix-darwin#NCX-101138
```

## Stow Ignore Patterns

The `.stow-local-ignore` file excludes:
- `.DS_Store`, `.git`, `.gitignore`
- README and LICENSE files at package root

## Testing Changes

```bash
# Reload zsh config
source ~/.zshrc
# or
exec zsh
```

For Neovim changes, restart Neovim or run `:source %` on the modified file.
