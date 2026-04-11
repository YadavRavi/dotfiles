-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "catppuccin",

  hl_override = {
    NvDashAscii = { fg = "#FF9900", bold = true },
    NvDashButtons = { fg = "#99CCFF" },
    NvDashFooter = { fg = "#CC99CC", italic = true },
  },
}

M.nvdash = {
  load_on_startup = true,

  header = {
    "",
    "  ██╗      ██████╗ █████╗ ██████╗ ███████╗  ",
    "  ██║     ██╔════╝██╔══██╗██╔══██╗██╔════╝  ",
    "  ██║     ██║     ███████║██████╔╝███████╗  ",
    "  ██║     ██║     ██╔══██║██╔══██╗╚════██║  ",
    "  ███████╗╚██████╗██║  ██║██║  ██║███████║  ",
    "  ╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝  ",
    "",
    "    ╔══════════════════════════════════╗    ",
    "    ║   Ad astra per aspera            ║    ",
    "    ╚══════════════════════════════════╝    ",
    "",
    "",
  },

  buttons = {
    { txt = "  Find File", keys = "ff", cmd = "Telescope find_files" },
    { txt = "  Recent Files", keys = "fo", cmd = "Telescope oldfiles" },
    { txt = "󰈭  Find Word", keys = "fw", cmd = "Telescope live_grep" },
    { txt = "  File Browser", keys = "fb", cmd = ":lua require('mini.files').open()" },
    { txt = "󱥚  Themes", keys = "th", cmd = ":lua require('nvchad.themes').open()" },
    { txt = "  Mappings", keys = "ch", cmd = "NvCheatsheet" },

    { txt = "─", hl = "NvDashFooter", no_gap = true, rep = true },

    {
      txt = function()
        local stats = require("lazy").stats()
        local ms = math.floor(stats.startuptime * 100 + 0.5) / 100
        return "  Loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms"
      end,
      hl = "NvDashFooter",
      no_gap = true,
      content = "fit",
    },
  },
}

return M
