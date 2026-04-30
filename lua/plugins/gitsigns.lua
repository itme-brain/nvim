return {
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        signcolumn = false,
        numhl = true,
      })
      require("which-key").add({
        { "<leader>Gb", ":Gitsigns toggle_current_line_blame<CR>", desc = "Git blame" },
      })
    end,
  },
}
