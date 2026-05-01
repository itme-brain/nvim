return {
  {
    "pablopunk/pi.nvim",
    config = function()
      require("pi").setup({
        log_path = vim.fn.stdpath("state") .. "/pi-nvim.log",
      })

      require("which-key").add({
        { "<leader>a",  group = "AI" },
        { "<leader>aa", "<cmd>PiAsk<cr>",          desc = "Ask Pi" },
        { "<leader>al", "<cmd>PiLog<cr>",          desc = "Pi Log" },
        { "<leader>ax", "<cmd>PiCancel<cr>",       desc = "Cancel Pi" },
        { "<leader>aa", "<cmd>PiAskSelection<cr>", mode = "v", desc = "Ask Pi" },
      })
    end,
  },
}
