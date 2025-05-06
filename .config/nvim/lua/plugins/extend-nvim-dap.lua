return {
  "mfussenegger/nvim-dap",
  opts = function(_, opts)
    local dap = require("dap")

    dap.configurations["typescript"] = {
      {
        type = "pwa-node",
        request = "launch",
        name = "Launch Typescript",
        program = "${file}",
        cwd = "${workspaceFolder}",
        runTimeExecutable = "node",
        runtimeArgs = { "--import", "tsx" },
        sourceMaps = true,
        protocol = "inspector",
        console = "integratedTerminal",
        skipFiles = { "<node_internals>/**" },
      },
      {
        type = "pwa-node",
        request = "launch",
        name = "Launch Typescript 2",
        program = "${file}",
        cwd = "${workspaceFolder}",
        runTimeExecutable = "tsx",
        skipFiles = { "<node_internals>/**" },
      },
    }
  end,
}
