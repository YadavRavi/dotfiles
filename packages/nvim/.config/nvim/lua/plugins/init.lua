return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- uncomment for format on save
    opts = require "configs.conform",
  },

  {
    "neovim/nvim-lspconfig",
    -- loaded via scheduled `require "configs.lspconfig"` in init.lua (single entry point)
  },

  {
    "mason-org/mason.nvim", -- NvChad's spec name → opts merge
    lazy = false, -- load at startup so the bootstrap runs
    config = function(_, opts)
      require("mason").setup(opts) -- NvChad's mason opts
      require "configs.mason" -- registry bootstrap: install the tool list
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    -- list on opts.ensure_installed so NvChad's :TSInstallAll / build step find it too
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
        "go",
        "gomod",
        "gosum",
        "gowork",
        "yaml",
        "dockerfile",
        "markdown",
        "markdown_inline",
        "toml",
        "bash",
      },
    },
    config = function(_, opts)
      require("nvim-treesitter").install(opts.ensure_installed)
      -- highlighting auto-starts via NvChad's FileType→vim.treesitter.start autocmd
    end,
  },

  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = {},
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
      { "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix (Trouble)" },
      { "<leader>xl", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
    },
  },

  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      opts.completion = opts.completion or {}
      opts.completion.completeopt = "menu,menuone,noselect"
      return opts
    end,
  },

  {
    url = "https://codeberg.org/andyg/leap.nvim",
    event = "VimEnter",
    config = function()
      vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap)")
      vim.keymap.set("n", "S", "<Plug>(leap-from-window)")
    end,
  },

  {
    "echasnovski/mini.files",
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
    config = function()
      require("mini.files").setup {
        mappings = {
          go_in = "o", -- right / open
          go_in_plus = "O", -- right / open and close explorer
          go_out = "e", -- left / parent
          go_out_plus = "E", -- left / parent and trim right columns
        },
      }
      vim.keymap.set("n", "-", function()
        require("mini.files").open(vim.api.nvim_buf_get_name(0))
      end, { desc = "Open file browser at current file" })
    end,
  },
}
