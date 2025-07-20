-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.lazyvim_prettier_needs_config = true

-- Performance and UX improvements
vim.opt.updatetime = 200 -- Faster completion and CursorHold
vim.opt.timeoutlen = 500 -- Faster which-key popup
vim.opt.scrolloff = 8 -- Keep 8 lines above/below cursor
vim.opt.sidescrolloff = 8 -- Keep 8 columns left/right of cursor

-- Better search experience
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Undo persistence
vim.opt.undofile = true
vim.opt.undolevels = 10000

-- Better split behavior
vim.opt.splitright = true
vim.opt.splitbelow = true
