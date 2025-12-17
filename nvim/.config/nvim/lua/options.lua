require "nvchad.options"

-- add yours here!

local opt = vim.opt
opt.cursorlineopt ='both' -- to enable cursorline!

-- line numbers
opt.relativenumber = true
opt.number = true

-- tabs & indentation
opt.tabstop = 2 -- 2 spces for tabs
opt.shiftwidth = 2 -- spces for indent width
opt.expandtab = true -- expand tabs to spaces
opt.autoindent = true -- copy indent from current line when starting new one

-- line wrapping
opt.wrap = false -- disable line wrapping

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- when mixed case in search, assumes you want case-sensitive

-- cursor line
opt.cursorline = true -- highlight the current cursorline


-- appearance
-- turn on termguicolo
-- requires iTerm or true color terminal
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn ="yes"

-- backspace
opt.backspace = "indent,eol,start"

-- clipboard
opt.clipboard:append("unnamedplus")

-- split windows
opt.splitright = true
opt.splitbelow = true

-- turn off swapfile
opt.swapfile = false
