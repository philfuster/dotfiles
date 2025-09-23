-- TEMPORARY WORKAROUND for lazydev.nvim compatibility issue
-- TODO: Remove this file when lazydev.nvim is fixed upstream
-- Error: "attempt to call field 'is_enabled' (a nil value)"
-- This provides manual Lua LSP configuration as a fallback
-- See CEP-003 for full context
return {
  {
    "folke/lazydev.nvim",
    enabled = false, -- Disable due to compatibility issues
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- Ensure lua_ls server settings exist
      opts.servers = opts.servers or {}
      opts.servers.lua_ls = opts.servers.lua_ls or {}
      opts.servers.lua_ls.settings = opts.servers.lua_ls.settings or {}

      -- Configure Lua LSP for Neovim development
      opts.servers.lua_ls.settings.Lua = {
        runtime = {
          version = "LuaJIT",
        },
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          checkThirdParty = false,
          library = {
            vim.env.VIMRUNTIME,
            "${3rd}/luv/library",
          },
        },
        completion = {
          callSnippet = "Replace",
        },
        telemetry = {
          enable = false,
        },
      }

      return opts
    end,
  },
}