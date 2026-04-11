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
      "bash-language-server",
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
  'echasnovski/mini.files',
  dependencies = { { "echasnovski/mini.icons", opts = {} } },
  config = function()
    require("mini.files").setup({
      mappings = {
        go_in       = 'o',  -- right / open
        go_in_plus  = 'O',  -- right / open and close explorer
        go_out      = 'e',  -- left / parent
        go_out_plus = 'E',  -- left / parent and trim right columns
      },
    })
    vim.keymap.set("n", "-", function()
      require("mini.files").open(vim.api.nvim_buf_get_name(0))
    end, { desc = "Open file browser at current file" })
  end,
},
}
