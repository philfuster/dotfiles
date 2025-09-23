return {
  "folke/snacks.nvim",
  opts = {
    explorer = {
      -- Keep explorer functionality but change keybindings
    },
  },
  keys = {
    -- Disable the default LazyVim keybindings for snacks_explorer
    { "<leader>e", false },
    { "<leader>E", false },
    -- Add alternative keybindings for snacks_explorer
    {
      "<leader>se",
      function()
        Snacks.explorer()
      end,
      desc = "Snacks Explorer (root)",
    },
    {
      "<leader>sE",
      function()
        Snacks.explorer.open(vim.uv.cwd())
      end,
      desc = "Snacks Explorer (cwd)",
    },
    -- Keep the original <leader>fe and <leader>fE if you want them
    {
      "<leader>fe",
      function()
        Snacks.explorer()
      end,
      desc = "Explorer Snacks (root)",
    },
    {
      "<leader>fE",
      function()
        Snacks.explorer.open(vim.uv.cwd())
      end,
      desc = "Explorer Snacks (cwd)",
    },
  },
}