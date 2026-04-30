return {
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
    config = function()
      local oil = require("oil")

      oil.setup({
        default_file_explorer = true,
        skip_confirm_for_simple_edits = true,
        view_options = {
          show_hidden = true,
        },
        float = {
          padding = 4,
          max_width = 100,
          max_height = 30,
          border = "rounded",
        },
      })

      require("which-key").add({
        { "-",         "<cmd>Oil<cr>",        desc = "Open Parent Dir" },
        { "<leader>e", oil.toggle_float,      desc = "File Explorer" },
      })
    end,
  },
}
