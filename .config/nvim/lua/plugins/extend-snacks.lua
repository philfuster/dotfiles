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

    -- Configure gh to open URLs in Windows browser from WSL2
    opts.gh = opts.gh or {}
    opts.gh.browser = function(url)
      vim.fn.system({ "bash", "-c", "cd /mnt/c && cmd.exe /c start '' " .. vim.fn.shellescape(url) })
    end
  end,
}
