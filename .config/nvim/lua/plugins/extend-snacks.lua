return {
  "folke/snacks.nvim",
  opts = function(_, opts)
    table.insert(
      opts.dashboard.preset.keys,
      7,
      { icon = "S", key = "S", desc = "Select session", action = require("persistence").select }
    )
    opts.notifier = opts.notifier or {}
    opts.notifier.style = opts.notifier.style or {}
    opts.notifier.style.wo = opts.notifier.style.wo or {}
    opts.notifier.style.wo.wrap = true
  end,
}
