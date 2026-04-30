return {
  {
    "saghen/blink.cmp",
    version = "*",
    event = "InsertEnter",
    opts = {
      keymap = {
        preset = "none",
        ["<C-y>"] = { "select_and_accept" },
        ["<C-e>"] = { "cancel" },
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
        ["<C-d>"] = { "scroll_documentation_up", "fallback" },
      },
      completion = {
        list = {
          selection = { preselect = false, auto_insert = false },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
      },
      sources = {
        default = { "lsp", "buffer", "path" },
      },
    },
  },
}
