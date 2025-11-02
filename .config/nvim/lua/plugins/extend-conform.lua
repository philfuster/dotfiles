-- Formatter setup with auto-detection:
-- - Prettier: used when config file exists (controlled by lazyvim_prettier_needs_config in options.lua)
-- - Biome: fallback when no prettier config found
return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      javascript = { "prettier", "biome", stop_after_first = true },
      javascriptreact = { "prettier", "biome", stop_after_first = true },
      typescript = { "prettier", "biome", stop_after_first = true },
      typescriptreact = { "prettier", "biome", stop_after_first = true },
      json = { "prettier", "biome", stop_after_first = true },
      jsonc = { "prettier", "biome", stop_after_first = true },
      css = { "prettier", "biome", stop_after_first = true },
    },
  },
}
