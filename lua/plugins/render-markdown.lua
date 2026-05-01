return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      enabled = false,
      completions = { lsp = { enabled = true } },
    },
    keys = {
      { "<leader>mr", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle Markdown Render" },
    },
  },
}
