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

- **File Manager**: Oil.nvim opens with `-` key
- **Navigation**: Lightspeed.nvim for fast cursor movement
- **Formatting**: Conform.nvim with format-on-save enabled
  - Lua: Stylua
  - JS/TS/JSX/TSX/JSON/CSS/HTML: Prettier
  - Python: Ruff
- **LSP**: Lua, HTML, CSS, TypeScript, Python (Pyright)
- **Key Mappings**: `;` → `:`, `jk` → `<ESC>`, `<Space>` is leader key
- **Options**: Relative line numbers, 2-space tabs, no line wrap, system clipboard

## Common Development Tasks

### Adding a New Plugin
1. Add plugin specification to `lua/plugins/init.lua`
2. If configuration needed, create file in `lua/configs/`
3. Run `:Lazy sync` in Neovim to install

### Adding LSP Support for a New Language
1. Add server configuration to `lua/configs/lspconfig.lua`
2. Add server to Mason ensure_installed list
3. Restart Neovim and run `:MasonInstall <server-name>`

### Adding a Code Formatter
1. Add formatter configuration to `lua/configs/conform.lua`
2. Add formatter to Mason ensure_installed list
3. Restart Neovim

### Changing Theme
1. Install theme plugin in `lua/plugins/init.lua`
2. Update theme name in `lua/chadrc.lua`

## Plugin Management Commands

- `:Lazy` - Open lazy.nvim UI
- `:Lazy sync` - Update/install plugins
- `:Mason` - Open Mason UI for LSP/formatter management
- `:ConformInfo` - Check formatting setup

## Important Notes

- This config extends NvChad v2.5, so NvChad documentation applies
- Plugin versions are locked in `lazy-lock.json` for consistency
- Many built-in Neovim plugins are disabled for performance in `lua/configs/lazy.lua`
- NvChad base46 theming caches to `~/.local/share/nvim/nvchad/base46/`