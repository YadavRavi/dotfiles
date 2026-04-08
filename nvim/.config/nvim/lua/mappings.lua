require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- Window navigation: yneo (Workman home row)
-- Override NVChad's C-h/j/k/l with C-y/n/e/o
map("n", "<C-y>", "<C-w>k", { desc = "Window up" })
map("n", "<C-n>", "<C-w>j", { desc = "Window down" })
map("n", "<C-e>", "<C-w>h", { desc = "Window left" })
map("n", "<C-o>", "<C-w>l", { desc = "Window right" })

-- Remove NVChad's QWERTY window nav defaults
vim.keymap.del("n", "<C-h>")
vim.keymap.del("n", "<C-j>")
vim.keymap.del("n", "<C-k>")
vim.keymap.del("n", "<C-l>")

-- C-w prefix yneo (redundant but ergonomic)
map("n", "<C-w>y", "<C-w>k", { desc = "Window up" })
map("n", "<C-w>n", "<C-w>j", { desc = "Window down" })
map("n", "<C-w>e", "<C-w>h", { desc = "Window left" })
map("n", "<C-w>o", "<C-w>l", { desc = "Window right" })
map("n", "<C-w>O", "<cmd>only<cr>", { desc = "Close other windows" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
