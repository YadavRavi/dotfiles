# tmux + sesh — Workman-DHK Setup

Terminal multiplexer config with `yneo` navigation, Catppuccin Mocha theme, and sesh session management.

## Quick Start

```bash
# Start your main workspace
ops                        # alias for: sesh connect LCARS

# Or connect to any context
sesh connect DPP
sesh connect Astrometrics
sesh connect Engineering
```

If tmux isn't running, sesh starts it automatically. If the session exists, it reattaches.

## Contexts

| Name | Layout | Directory |
|------|--------|-----------|
| **LCARS** | 3 panes: vault `ll` + daily-logs + Claude | SecondBrain vault |
| **DPP** | 2 panes: shell + Claude | `SecondBrain/kb/dpp` |
| **Astrometrics** | 1 pane: shell | SecondBrain vault |
| **Engineering** | 2 panes: shell + Claude | `HomeLab/rani-homelab-v2` |

## Navigation (yneo)

Two layers, matching former Zellij bindings:

**Prefix-free (instant):**

| Key | Action |
|-----|--------|
| `Alt+y/n/e/o` | Focus pane up/down/left/right |
| `Alt+w` | New vertical split |
| `Alt+f` | Toggle popup window |
| `Alt+=` / `Alt+-` | Resize |
| `Alt+,` / `Alt+.` | Swap window left/right |

**Prefix (`Ctrl+Space`, then):**

| Key | Action |
|-----|--------|
| `%` / `"` | Split right / down |
| `c` | New window |
| `x` | Close pane |
| `z` | Zoom/fullscreen |
| `Tab` / `p` | Next / prev window |
| `1`-`9` | Go to window N |
| `T` | Session picker (sesh + fzf) |
| `L` | Last session |
| `d` | Detach |
| `Ctrl+S` | Save session (resurrect) |
| `Ctrl+R` | Restore session (resurrect) |
| `I` | Install plugins (TPM) |

**Copy mode (`Ctrl+Space` then `[`):**

`y`/`n`/`e`/`o` for cursor movement, `u`/`d` half-page, `/`/`?` search, `v` select, `Enter` copy.

## Session Picker

`Ctrl+Space` then `T` opens a fuzzy finder popup:

| Key | Filter |
|-----|--------|
| `Ctrl+A` | All sources |
| `Ctrl+T` | Active tmux sessions |
| `Ctrl+X` | Configured sessions (sesh.toml) |
| `Ctrl+Z` | Zoxide directories |
| `Ctrl+F` | Find directories in ~ |
| `Ctrl+D` | Kill selected session |

## Files

```
~/dotfiles/tmux/
├── tmux.conf              # Main config (symlinked)
├── scripts/
│   ├── lcars.sh           # LCARS 3-pane layout
│   ├── dpp.sh             # DPP 2-pane layout
│   └── engineering.sh     # Engineering 2-pane layout
└── README.md              # This file

~/.config/tmux/tmux.conf   # → ~/dotfiles/tmux/tmux.conf
~/.config/sesh/sesh.toml   # Session declarations
~/.claude/keybindings.json # Alt+O unbound (use /fast)
```

## Dependencies

| Tool | Install | Purpose |
|------|---------|---------|
| tmux | `brew install tmux` | Multiplexer |
| sesh | `brew install sesh` | Session manager |
| zoxide | `brew install zoxide` | Directory frecency |
| fzf | `brew install fzf` | Fuzzy finder |
| TPM | `~/.tmux/plugins/tpm` | Plugin manager |

**Plugins (via TPM):** tmux-sensible, catppuccin/tmux, tmux-resurrect, tmux-continuum

## Ghostty Requirement

`~/.config/ghostty/config` must include:

```
macos-option-as-alt = left
```

Left-Option sends Alt (tmux bindings). Right-Option stays as special chars.

## Cheatsheet

Printable reference with all keybindings across tmux, sesh, Claude Code, NeoVim, and zsh:

```bash
open ~/Documents/ObsidianSyncedVaults/SecondBrain/notes/reference/terminal-keybindings-cheatsheet.html
```

## Session Persistence

Sessions auto-save every 15 minutes (tmux-continuum) and auto-restore on tmux server start. Manual save/restore: `Ctrl+Space` then `Ctrl+S` / `Ctrl+R`.

## Troubleshooting

| Problem | Fix |
|---------|-----|
| Alt keys produce special chars | Check `macos-option-as-alt = left` in Ghostty config, restart Ghostty |
| Plugins not loaded | Run `Ctrl+Space` then `I` to install, or `~/.tmux/plugins/tpm/bin/install_plugins` |
| Theme not showing | `tmux source-file ~/.config/tmux/tmux.conf` to reload |
| sesh can't find sessions | Check `~/.config/sesh/sesh.toml` paths exist |
| Shift+Enter not working in CC | Check `extended-keys always` and `terminal-features` in tmux.conf |
