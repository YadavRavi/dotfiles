return {
  {
    "stevearc/conform.nvim",
    event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require "configs.lspconfig"
    end,
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
    },
   },
  },

  {
   "nvim-treesitter/nvim-treesitter",
   opts = {
    ensure_installed = {
      "vim",
      "lua",
      "vimdoc",
      "html",
      "css",
      "javascript",
      "typescript",
      "tsx",
      "python",
    },
   },
  },
-- lightspeed.nvim
 {
  'ggandor/lightspeed.nvim',
  event = 'VimEnter',
  config = function()
    require('lightspeed').setup({
      ignore_case = false,
      exit_after_idle_msecs = { unlabeled = nil, labeled = nil },
      -- Avoid conflicts with semicolon mapping
      repeat_ft_with_target_char = false,
    })
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
