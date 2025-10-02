return {
  "stevearc/conform.nvim",
  opts = {
    formatters = {
      prettier = {
        prepend_args = { "--config", vim.fn.expand("~/.config/.prettierrc") },
      },
    },
  },
}
