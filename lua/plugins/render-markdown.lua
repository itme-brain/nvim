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
  {
    "selimacerbas/markdown-preview.nvim",
    ft = { "markdown" },
    dependencies = {
      "selimacerbas/live-server.nvim",
    },
    config = function()
      require("markdown_preview").setup()
    end,
    keys = {
      { "<leader>mp", "<cmd>MarkdownPreview<cr>", desc = "Preview Markdown" },
    },
  },
}
