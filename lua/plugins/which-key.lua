return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
    opts = {
      spec = {
        { "<leader>l", ":Lazy<CR>", desc = "Lazy" },
        { "<leader>t",
          function()
            vim.cmd("botright new")
            vim.opt_local.number = false
            vim.opt_local.relativenumber = false
            vim.cmd.resize(10)
            vim.cmd.terminal()
            vim.cmd.startinsert()
          end,
          mode = "n",
          desc = "Open Terminal"
        },

        --{ "<leader>wd", "<cmd>execute 'bd' | execute 'close'<CR>", desc = "Delete window & buffer" },
        -- Window & Buffer Management
        { "<leader>w", group = "Windows"},
        { "<leader>wc", ":close<CR>", desc = "Close Window" },
        { "<leader>ws", ":split<CR>", desc = "Horizontal Window Split" },
        { "<leader>wv", ":vsplit<CR>", desc = "Vertial Window Split" },
        { "<leader>wm", "<C-w>_", desc = "Maximize Window" },

        { "<leader>b", group = "Buffers"},
        { "<leader>bd", function()
            local current_buf = vim.api.nvim_get_current_buf()
            local buflisted = vim.fn.getbufinfo({ buflisted = 1 })
            if #buflisted <= 1 then
              vim.notify("Cannot delete last buffer", vim.log.levels.WARN)
              return
            end
            vim.cmd.bprevious()
            vim.cmd.bdelete({ args = { tostring(current_buf) } })
          end, desc = "Delete Buffer" },
        { "<leader>bD", function()
            local current_buf = vim.api.nvim_get_current_buf()
            local current_win = vim.api.nvim_get_current_win()

            local wins = vim.fn.win_findbuf(current_buf)
            if #wins > 1 then
              vim.api.nvim_win_close(current_win, false)
            end

            if vim.api.nvim_buf_is_valid(current_buf) then
              vim.cmd('bdelete! ' .. current_buf)
            end
          end, desc = "Delete Window & Buffer" },

        { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action" },
        { "<leader>cr", vim.lsp.buf.rename, desc = "Rename Variable" },
        { "<leader>ch", vim.lsp.buf.hover, desc = "Hover Info" },
        { "<leader>ce", vim.diagnostic.open_float, desc = "Show Diagnostic" },
        { "]d", vim.diagnostic.goto_next, desc = "Next Diagnostic" },
        { "[d", vim.diagnostic.goto_prev, desc = "Prev Diagnostic" },

        { "<leader>G", group = "Git"},
        { "<leader>a", group = "AI"},
        { "<leader>f", group = "Files"},
        { "<leader>c", group = "Code"},
        { "<leader>d", group = "Debug"},
        { "<leader>g", group = "Goto"},
      },
    },
	}
}
