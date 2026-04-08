return {
  {
    "stevearc/conform.nvim",
    event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  {
    "neovim/nvim-lspconfig",
    lazy = false,
    priority = 900,
  },

  {
   "williamboman/mason.nvim",
   opts = {
    ensure_installed = {
      "lua-language-server",
      "typescript-language-server",
      "stylua",
      "html-lsp",
      "css-lsp",
      "prettier",
      "pyright",
      "ruff",
      "gopls",
      "goimports",
      "yaml-language-server",
      "dockerfile-language-server",
    },
   },
  },

  {
   "nvim-treesitter/nvim-treesitter",
   branch = "main",
   lazy = false,
   build = ":TSUpdate",
   config = function()
     require("nvim-treesitter").install({
       "vim", "lua", "vimdoc", "html", "css",
       "javascript", "typescript", "tsx", "python",
       "go", "gomod", "gosum", "gowork",
       "yaml", "dockerfile", "markdown", "markdown_inline",
       "toml", "bash",
     })
   end,
  },
 {
  url = "https://codeberg.org/andyg/leap.nvim",
  event = 'VimEnter',
  config = function()
    vim.keymap.set({ 'n', 'x', 'o' }, 's', '<Plug>(leap)')
    vim.keymap.set('n', 'S', '<Plug>(leap-from-window)')
  end,
 },

{
  'stevearc/oil.nvim',
  opts = {},
  config = function()
    require("oil").setup()
    vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
  end,
  -- Optional dependencies
  dependencies = { { "echasnovski/mini.icons", opts = {} } },
  -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
},
}
