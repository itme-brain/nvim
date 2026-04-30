local dap_adapters = {
  "python",
  "codelldb",
  "bash",
  "js",
}

return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "williamboman/mason.nvim",
      "jay-babu/mason-nvim-dap.nvim",
      "nvim-neotest/nvim-nio",
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-telescope/telescope-dap.nvim",
    },
    cmd = {
      "DapContinue",
      "DapDisconnect",
      "DapInstall",
      "DapLoadLaunchJSON",
      "DapNew",
      "DapRestartFrame",
      "DapSetLogLevel",
      "DapShowLog",
      "DapStepInto",
      "DapStepOut",
      "DapStepOver",
      "DapTerminate",
      "DapToggleBreakpoint",
      "DapUninstall",
    },
    keys = {
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "Conditional Breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
      { "<leader>do", function() require("dap").step_over() end, desc = "Step Over" },
      { "<leader>dO", function() require("dap").step_out() end, desc = "Step Out" },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
      { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle Debug UI" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
      { "<leader>de", function() require("dapui").eval() end, mode = { "n", "v" }, desc = "Evaluate" },
      { "<leader>ds", function() require("telescope").extensions.dap.configurations() end, desc = "Debug Configurations" },
      { "<leader>dS", function() require("telescope").extensions.dap.list_breakpoints() end, desc = "Debug Breakpoints" },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      require("mason").setup()
      require("mason-nvim-dap").setup({
        ensure_installed = dap_adapters,
        automatic_installation = false,
        handlers = {},
      })

      require("nvim-dap-virtual-text").setup({
        commented = true,
      })

      dapui.setup({
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.45 },
              { id = "breakpoints", size = 0.15 },
              { id = "stacks", size = 0.25 },
              { id = "watches", size = 0.15 },
            },
            position = "right",
            size = 50,
          },
          {
            elements = {
              { id = "repl", size = 0.5 },
              { id = "console", size = 0.5 },
            },
            position = "bottom",
            size = 10,
          },
        },
      })

      vim.fn.sign_define("DapBreakpoint", { text = "B", texthl = "DiagnosticSignError" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "C", texthl = "DiagnosticSignWarn" })
      vim.fn.sign_define("DapLogPoint", { text = "L", texthl = "DiagnosticSignInfo" })
      vim.fn.sign_define("DapStopped", { text = ">", texthl = "DiagnosticSignWarn", linehl = "Visual" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "R", texthl = "DiagnosticSignError" })

      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end

      dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = vim.fn.stdpath("data") .. "/mason/bin/js-debug-adapter",
          args = { "${port}" },
        },
      }

      local js_configurations = {
        {
          type = "pwa-node",
          request = "launch",
          name = "Node: Launch file",
          program = "${file}",
          cwd = "${workspaceFolder}",
          console = "integratedTerminal",
        },
        {
          type = "pwa-node",
          request = "attach",
          name = "Node: Attach process",
          processId = require("dap.utils").pick_process,
          cwd = "${workspaceFolder}",
        },
      }

      dap.configurations.javascript = js_configurations
      dap.configurations.typescript = js_configurations
      dap.configurations.javascriptreact = js_configurations
      dap.configurations.typescriptreact = js_configurations

      pcall(function()
        require("telescope").load_extension("dap")
      end)
    end,
  },
}
