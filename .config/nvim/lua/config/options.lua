-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Require prettier config file for formatting (falls back to biome if not found)
vim.g.lazyvim_prettier_needs_config = true

vim.opt.updatetime = 200  -- Faster completion and CursorHold
vim.opt.timeoutlen = 500  -- Faster which-key popup
vim.opt.scrolloff = 8     -- Keep 8 lines above/below cursor
vim.opt.sidescrolloff = 8 -- Keep 8 columns left/right of cursor

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.undofile = true
vim.opt.undolevels = 10000

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.shada = "!,'300,<50,s10,h" -- Smaller shada file
vim.opt.backup = false             -- No backup files
vim.opt.writebackup = false        -- No write backup
vim.opt.swapfile = false           -- No swap (we have undofile)

-- Set LSP log level to reduce overhead
vim.lsp.set_log_level("ERROR")
