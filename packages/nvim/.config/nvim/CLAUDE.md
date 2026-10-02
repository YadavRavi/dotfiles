# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Neovim configuration based on NvChad v2.5, using lazy.nvim as the plugin manager. The configuration is part of a larger dotfiles repository managed with GNU Stow.

## Architecture

The configuration follows a modular structure:
- `init.lua`: Entry point that bootstraps lazy.nvim and loads NvChad
- `lua/chadrc.lua`: NvChad UI configuration (theme: catppuccin)
- `lua/options.lua`: Core Vim settings
- `lua/mappings.lua`: Custom key mappings
- `lua/configs/`: Plugin-specific configurations
- `lua/plugins/init.lua`: Plugin declarations

## Key Customizations

- **File Manager**: mini.files opens at the current file with `-` (nav keys: `o`/`O` in, `e`/`E` out — Workman layout)
- **Motion**: leap.nvim (from codeberg) — `s` leap, `S` leap from other window
- **Formatting**: Conform.nvim with format-on-save enabled
  - Lua: Stylua
  - JS/TS/JSX/TSX/JSON/CSS/HTML/YAML/Markdown: Prettier
  - Python: Ruff
  - Go: goimports + gofmt
- **LSP**: Lua, HTML, CSS, TypeScript (ts_ls), Python (Pyright), Go (gopls), YAML, Dockerfile, Bash — native `vim.lsp.config`/`vim.lsp.enable` (nvim 0.11+)
- **Window nav**: Workman home row — `<C-y>`/`<C-n>`/`<C-e>`/`<C-o>` = up/down/left/right (NvChad's QWERTY `<C-hjkl>` deleted)
- **Diagnostics**: trouble.nvim under `<leader>x` (`xx` all, `xX` buffer, `xq` quickfix, `xl` loclist)
- **Key Mappings**: `;` → `:`, `jk` → `<ESC>`, `<Space>` is leader
- **Options**: relative numbers, 2-space tabs, no wrap, system clipboard, undofile, smartcase, splitright/below

## Common Development Tasks

### Adding a New Plugin
1. Add plugin specification to `lua/plugins/init.lua`
2. If configuration needed, create file in `lua/configs/`
3. Run `:Lazy sync` in Neovim to install

### Adding LSP Support for a New Language
1. Add `vim.lsp.config(...)` + add the server to the `vim.lsp.enable({...})` list in `lua/configs/lspconfig.lua`
2. Add the Mason package name to `ensure_installed` on the `mason-org/mason.nvim` spec in `lua/plugins/init.lua`
3. Restart Neovim — mason loads at startup (`lazy = false`) and installs the list automatically. `:MasonInstall <name>` as fallback.

### Adding a Code Formatter
1. Add formatter to `lua/configs/conform.lua`
2. Add its Mason package name to `ensure_installed` (as above)
3. Restart Neovim

### Changing Theme
1. Install theme plugin in `lua/plugins/init.lua`
2. Update theme name in `lua/chadrc.lua`

## Plugin Management Commands

- `:Lazy` - Open lazy.nvim UI
- `:Lazy sync` - Update/install plugins
- `:Mason` - Open Mason UI for LSP/formatter management
- `:TSInstallAll` - Compile all treesitter parsers (needs `tree-sitter` CLI on PATH)
- `:ConformInfo` - Check formatting setup

## Important Notes

- This config extends NvChad v2.5, so NvChad documentation applies
- Plugin versions are locked in `lazy-lock.json` for consistency
- Many built-in Neovim plugins are disabled for performance in `lua/configs/lazy.lua`
- NvChad base46 theming caches to `~/.local/share/nvim/nvchad/base46/`
- **Treesitter is on the `main` branch** (NvChad v2.5 requires it). Parser compilation needs the `tree-sitter` CLI 0.26.1+ on PATH. Note: Homebrew's `tree-sitter` ships only the library — the CLI comes from `npm i -g tree-sitter-cli` symlinked into `~/.local/bin`. Highlighting auto-starts via NvChad's `FileType → vim.treesitter.start` autocmd (do not add your own).
- **Mason auto-install** relies on `lazy = false` forcing `setup()` at startup; mason v2's `ensure_installed` only fires on `setup()`. Do NOT add `mason-tool-installer` (incompatible with mason v2).
