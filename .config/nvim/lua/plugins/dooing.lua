return {
  {
    "atiladefreitas/dooing",
    event = "VeryLazy",
    init = function()
      -- dooing ships plugin/dooing.vim, which lazy.nvim sources during packadd BEFORE it
      -- applies opts. That file calls require("dooing").bootstrap(), running setup() with
      -- plugin defaults -- mapping <leader>td over LazyVim's "Debug Nearest" and scheduling
      -- a second due-notification timer. setup() has no re-entry guard, so tripping the
      -- plugin's own guard here makes the opts below the only setup() that ever runs.
      vim.g.loaded_dooing = 1
    end,
    opts = {
      -- One global list, shared across every project. Kept in the .config so it survives an
      -- ~/.local/share/nvim wipe and syncs with the rest of the notes. Per-project lists
      -- (below) are what give per-repo separation.
      save_path = vim.fn.expand("~/.config/dooing_todos.json"),
      pretty_print_json = true, -- readable line-level diffs in the vault repo
      timestamp = {
        enabled = true, -- Show relative timestamps (e.g., @5m ago, @2h ago)
      },

      ui = {
        style = "modern",
      },

      window = {
        dimensions = function()
          return {
            width = math.max(40, math.floor(vim.o.columns * 0.4)),
            height = math.max(10, math.floor(vim.o.columns * 0.6)),
          }
        end,
      },

      due_notifications = {
        enabled = true,
        on_startup = true, -- only fires because of the VeryLazy load above
        on_open = true,
      },
      per_project = {
        enabled = true,
        default_filename = "dooing.json",
        auto_gitignore = false, -- never append to a repo's tracked .gitignore
        on_missing = "prompt", -- never create dooing.json without confirming
        auto_open_project_todos = false,
      },
      keymaps = {
        -- Owned by the keys block below so which-key gets real descriptions and the
        -- <leader>t defaults never shadow LazyVim's test group.
        toggle_window = false,
        open_project_todo = false,
        show_due_notification = false,
        create_nested_task = "<leader>kn",
        open_todo_scratchpad = "<leader>kp",
        remove_duplicates = "<leader>kD",
      },
    },
    keys = {
      { "<leader>kk", "<cmd>Dooing<cr>", desc = "Global todo list" },
      { "<leader>kp", "<cmd>DooingLocal<cr>", desc = "Project todo list" },
      { "<leader>kd", "<cmd>DooingDue<cr>", desc = "Due and overdue items" },
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>k", group = "todo (dooing)" },
      },
    },
  },
}
