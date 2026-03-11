return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
    opts = {
      spec = {
        { "<leader>l", ":Lazy<CR>", desc = "Lazy" },
        { "<leader>t",
          function()
            vim.cmd("botright new | setlocal nonumber norelativenumber | resize 10 | terminal")
            vim.cmd("startinsert")
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
            local function is_neotree()
              return vim.bo.filetype == "neo-tree"
            end
            -- Skip if in neo-tree
            if is_neotree() then
              vim.notify("Cannot delete buffer from neo-tree", vim.log.levels.WARN)
              return
            end
            local buflisted = vim.fn.getbufinfo({ buflisted = 1 })
            -- Prevent deleting last buffer
            if #buflisted <= 1 then
              vim.notify("Cannot delete last buffer", vim.log.levels.WARN)
              return
            end
            local buf_to_delete = vim.api.nvim_get_current_buf()
            vim.cmd('bprevious')
            vim.cmd('bdelete ' .. buf_to_delete)
            -- If we ended up in neo-tree, move back to a regular window
            if is_neotree() then
              vim.cmd('wincmd l')
            end
          end, desc = "Delete Buffer" },
        { "<leader>bD", "execute 'close'<CR> | <cmd>execute 'bd!'", desc = "Delete Window & Buffer" },

        { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action" },
        { "<leader>cr", vim.lsp.buf.rename, desc = "Rename Variable" },
        { "<leader>ch", vim.lsp.buf.hover, desc = "Hover Info" },
        { "<leader>ce", vim.diagnostic.open_float, desc = "Show Diagnostic" },
        { "]d", vim.diagnostic.goto_next, desc = "Next Diagnostic" },
        { "[d", vim.diagnostic.goto_prev, desc = "Prev Diagnostic" },

        { "<leader>G", group = "Git"},
        { "<leader>f", group = "Files"},
        { "<leader>c", group = "Code"},
        { "<leader>g", group = "Goto"},
      },
    },
	}
}
