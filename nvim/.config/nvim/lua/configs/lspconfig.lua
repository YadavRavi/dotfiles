-- Neovim 0.11+ native LSP configuration
-- See :help lspconfig-nvim-0.11

require("nvchad.configs.lspconfig").defaults()

-- Servers with default config
vim.lsp.config("html", {})
vim.lsp.config("cssls", {})

-- TypeScript (renamed from tsserver to ts_ls)
vim.lsp.config("ts_ls", {})

-- Lua
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = {
          vim.fn.expand "$VIMRUNTIME/lua",
          vim.fn.expand "$VIMRUNTIME/lua/vim/lsp",
          vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy",
        },
        maxPreload = 100000,
        preloadFileSize = 10000,
      },
    },
  },
})

-- Python
vim.lsp.config("pyright", {
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "workspace",
        useLibraryCodeForTypes = true,
      },
    },
  },
})

-- Go
vim.lsp.config("gopls", {
  settings = {
    gopls = {
      analyses = { unusedparams = true },
      staticcheck = true,
    },
  },
})

-- YAML
vim.lsp.config("yamlls", {})

-- Dockerfile
vim.lsp.config("dockerls", {})

-- Enable all configured servers
vim.lsp.enable({ "html", "cssls", "ts_ls", "lua_ls", "pyright", "gopls", "yamlls", "dockerls" })
