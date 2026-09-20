return {
  {
    dir = vim.fn.stdpath("config"),
    name = "local-colorscheme",
    lazy = false,
    config = function()
      local color_group = vim.api.nvim_create_augroup("config_colorscheme", { clear = true })

      vim.cmd.colorscheme("anticuus")

      local conflict_pattern = [[<<<<<<< HEAD\|=======\|>>>>>>> .\+]]
      local function apply_conflict_match(win)
        if vim.w[win].conflict_marker_match_id then
          pcall(vim.fn.matchdelete, vim.w[win].conflict_marker_match_id, win)
        end
        vim.w[win].conflict_marker_match_id = vim.fn.matchadd("ConflictMarker", conflict_pattern, 10, -1, {
          window = win,
        })
      end

      vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter" }, {
        group = color_group,
        callback = function()
          apply_conflict_match(vim.api.nvim_get_current_win())
        end,
      })

      vim.api.nvim_create_autocmd("TextYankPost", {
        group = color_group,
        callback = function()
          vim.highlight.on_yank({ higroup = "YankHighlight", timeout = 150 })
        end,
      })
    end,
  },

  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  {
    "fei6409/log-highlight.nvim",
  },
}
