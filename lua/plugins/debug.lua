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
      { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
      { "<leader>de", function() require("dap.ui.widgets").hover() end, mode = { "n", "v" }, desc = "Evaluate" },
      { "<leader>du",
        function()
          local widgets = require("dap.ui.widgets")
          widgets.centered_float(widgets.scopes)
        end,
        desc = "Show Scopes" },
      { "<leader>df",
        function()
          local widgets = require("dap.ui.widgets")
          widgets.centered_float(widgets.frames)
        end,
        desc = "Call Stack" },
      { "<leader>ds",
        function()
          local dap = require("dap")
          local ft = vim.bo.filetype
          local configs = dap.configurations[ft] or {}
          if #configs == 0 then
            vim.notify("No DAP configurations for filetype: " .. ft, vim.log.levels.WARN)
            return
          end
          vim.ui.select(configs, {
            prompt = "Select DAP configuration:",
            format_item = function(c) return c.name end,
          }, function(choice)
            if choice then dap.run(choice) end
          end)
        end,
        desc = "Debug Configurations" },
      { "<leader>dS", function() require("dap").list_breakpoints() end, desc = "List Breakpoints" },
    },
    config = function()
      local dap = require("dap")

      require("mason").setup()
      require("mason-nvim-dap").setup({
        ensure_installed = dap_adapters,
        automatic_installation = false,
        handlers = {},
      })

      vim.fn.sign_define("DapBreakpoint", { text = "B", texthl = "DiagnosticSignError" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "C", texthl = "DiagnosticSignWarn" })
      vim.fn.sign_define("DapLogPoint", { text = "L", texthl = "DiagnosticSignInfo" })
      vim.fn.sign_define("DapStopped", { text = ">", texthl = "DiagnosticSignWarn", linehl = "Visual" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "R", texthl = "DiagnosticSignError" })

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
    end,
  },
}
