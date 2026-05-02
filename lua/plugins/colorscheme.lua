return {
  {
    dir = vim.fn.stdpath("config"),
    name = "local-colorscheme",
    lazy = false,
    config = function()
      local color_group = vim.api.nvim_create_augroup("config_colorscheme", { clear = true })

      vim.cmd.colorscheme("anticuus")

      local highlights = {
        Normal      = { bg = "NONE" },
        NormalNC    = { bg = "NONE" },
        EndOfBuffer = { bg = "NONE" },

        Comment    = { fg = "#5a5a5a", italic = true },
        ["@comment"] = { fg = "#5a5a5a", italic = true },

        Function              = { fg = "#88ddcc" },
        ["@function"]         = { fg = "#88ddcc" },
        ["@function.builtin"] = { fg = "#88ddcc" },
        ["@function.method"]  = { fg = "#88ddcc" },

        Type              = { fg = "#e8a060" },
        Typedef           = { fg = "#e8a060" },
        ["@type"]         = { fg = "#e8a060" },
        ["@type.builtin"] = { fg = "#e8a060" },

        Number   = { fg = "#c490d0" },
        Boolean  = { fg = "#c490d0" },
        Float    = { fg = "#c490d0" },
        Constant = { fg = "#c490d0" },
        ["@number"]           = { fg = "#c490d0" },
        ["@number.float"]     = { fg = "#c490d0" },
        ["@boolean"]          = { fg = "#c490d0" },
        ["@constant"]         = { fg = "#c490d0" },
        ["@constant.builtin"] = { fg = "#c490d0" },

        ["@tag"]               = { fg = "#ff6b6b" },
        ["@tag.delimiter"]     = { fg = "#ff6b6b" },
        ["@keyword.return"]    = { fg = "#ff6b6b" },
        ["@keyword.exception"] = { fg = "#ff6b6b" },

        MatchParen = { fg = "#c490d0", bold = true, underline = true },

        IncSearch = { fg = "#000000", bg = "#88ddcc" },
        CurSearch = { fg = "#000000", bg = "#c490d0" },

        DiffAdd    = { fg = "#a5d6a7", bg = "#0a2010" },
        DiffChange = { fg = "#e8a060", bg = "#201a0a" },
        DiffDelete = { fg = "#ff6b6b", bg = "#200a0a" },
        DiffText   = { fg = "#ffcc00", bg = "#3a2000", bold = true },

        WinBar   = { fg = "#dadada", bold = true },
        WinBarNC = { fg = "#888888" },

        ConflictMarker = { link = "DiagnosticError" },
        YankHighlight  = { link = "Search" },

        OilCreate = { link = "DiagnosticOk" },
        OilDelete = { link = "DiagnosticError" },
        OilMove   = { link = "DiagnosticWarn" },
        OilCopy   = { link = "DiagnosticInfo" },

        BlinkCmpLabelMatch    = { link = "Search" },
        BlinkCmpMenuSelection = { link = "PmenuSel" },

        FzfLuaTitle        = { link = "Title" },
        FzfLuaPreviewTitle = { link = "Title" },
        FzfLuaHeaderBind   = { link = "Special" },
      }

      local function apply_highlights()
        for group, spec in pairs(highlights) do
          vim.api.nvim_set_hl(0, group, spec)
        end
      end

      local conflict_pattern = [[<<<<<<< HEAD\|=======\|>>>>>>> .\+]]
      local function apply_conflict_match(win)
        if vim.w[win].conflict_marker_match_id then
          pcall(vim.fn.matchdelete, vim.w[win].conflict_marker_match_id, win)
        end
        vim.w[win].conflict_marker_match_id = vim.fn.matchadd("ConflictMarker", conflict_pattern, 10, -1, {
          window = win,
        })
      end

      apply_highlights()

      vim.api.nvim_create_autocmd("ColorScheme", {
        group = color_group,
        callback = apply_highlights,
      })

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
