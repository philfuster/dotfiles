return {
  "neovim/nvim-lspconfig",
  opts = {
    -- Show notifications when formatting (useful for debugging)
    format_notify = true,

    -- Custom diagnostic display settings
    diagnostics = {
      virtual_text = {
        spacing = 2, -- Tighter spacing than LazyVim default (4)
        source = false, -- Don't show source in virtual text
      },
      float = {
        border = "rounded",
        source = true, -- Show source in float window
        header = "",
        prefix = "",
      },
    },
  },
}
