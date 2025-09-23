-- Optimize LSP diagnostic display for better performance
-- Part of CEP-003 implementation
return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    -- Configure diagnostic display
    vim.diagnostic.config({
      virtual_text = {
        source = false, -- Don't show source in virtual text (cleaner)
        spacing = 2, -- Less spacing for compact display
        prefix = "●", -- Use a simple prefix
      },
      float = {
        source = true, -- Show source in float window
        border = "rounded", -- Better visibility
        header = "",
        prefix = "",
      },
      signs = true,
      underline = true,
      update_in_insert = false, -- Don't update in insert mode (performance)
      severity_sort = true, -- Sort by severity
    })

    return opts
  end,
}