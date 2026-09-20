return {
  {
    "ludovicchabant/vim-gutentags",
    lazy = false,
    init = function()
      vim.g.gutentags_modules = { "ctags" }
      vim.g.gutentags_file_list_command = "rg --files --hidden -g !.git -g !.jj"
      vim.g.gutentags_ctags_extra_args = { "--fields=+n" }
      vim.keymap.set("n", "<leader>gp", function()
        vim.cmd.ptag(vim.fn.expand("<cword>"))
      end, { desc = "Preview Definition" })
      vim.keymap.set("n", "<leader>gu", "<cmd>GutentagsUpdate!<CR>", { desc = "Refresh Tags" })
      vim.keymap.set("n", "[q", "<cmd>cprevious<CR>", { desc = "Previous Quickfix" })
      vim.keymap.set("n", "]q", "<cmd>cnext<CR>", { desc = "Next Quickfix" })
    end,
  },
}
