-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Better escape
vim.api.nvim_set_keymap("i", "jj", "<Esc>", { noremap = true, silent = true })

-- Better indenting
vim.keymap.set("v", "<", "<gv", { desc = "Indent left and keep selection" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and keep selection" })

-- Move text up and down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Better page navigation
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up and center" })

-- Search and center
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result and center" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result and center" })

-- Clear search highlighting
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlighting" })

-- Quick save
vim.keymap.set("n", "<C-s>", "<cmd>w<cr>", { desc = "Save file" })
vim.keymap.set("i", "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file and exit insert" })
