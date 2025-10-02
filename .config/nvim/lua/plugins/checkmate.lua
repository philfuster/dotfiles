return {
  "bngarren/checkmate.nvim",
  ft = { "markdown" },
  opts = {
    files = {
      "*.md",
      "*.markdown",
      "TODO*",
      "NOTES*",
      "**/CEPs/*.md",
    },
    todo_states = {
      unchecked = { marker = "☐", order = 1 },
      checked = { marker = "☑", order = 2 },
      partial = { marker = "◐", type = "incomplete", markdown = "-", order = 3 },
      cancelled = { marker = "☒", type = "complete", markdown = "~", order = 4 },
      in_progress = { marker = "◯", type = "incomplete", markdown = "o", order = 5 },
      waiting = { marker = "⏳", type = "inactive", markdown = "?", order = 6 },
    },
    smart_toggle = {
      enabled = true,
    },
    archive = {
      heading = {
        title = "Completed",
        level = 2,
      },
    },
  },
}

