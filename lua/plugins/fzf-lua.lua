local function get_root()
  local result = vim.system({ "git", "rev-parse", "--show-toplevel" }, { text = true }):wait()
  if result.code == 0 and result.stdout then
    local git_dir = vim.trim(result.stdout)
    if git_dir ~= "" then
      return git_dir
    end
  end
  return vim.fn.getcwd()
end

-- Close oil first so picker actions land in a normal window, not oil's float.
local function pick(action)
  return function()
    if vim.bo.filetype == "oil" then
      require("oil").close()
    end
    action()
  end
end

return {
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local fzf = require("fzf-lua")
      local fzf_actions = require("fzf-lua.actions")

      fzf.setup({
        keymap = {
          fzf = {
            ["ctrl-d"] = "preview-half-page-down",
            ["ctrl-u"] = "preview-half-page-up",
          },
        },
        actions = {
          files = {
            ["enter"]  = fzf_actions.file_edit,
            ["ctrl-x"] = fzf_actions.file_split,
            ["ctrl-v"] = fzf_actions.file_vsplit,
            ["ctrl-t"] = fzf_actions.file_tabedit,
            ["alt-q"]  = fzf_actions.file_sel_to_qf,
            ["alt-l"]  = fzf_actions.file_sel_to_ll,
          },
        },
      })
      fzf.register_ui_select()

      require("which-key").add({
        { "<leader>/",  pick(function() fzf.live_grep({ cwd = get_root() }) end), desc = "grep" },
        { "<leader>ff", pick(function() fzf.files({ cwd = get_root() }) end),     desc = "Search for Files" },
        { "<leader>fp", pick(fzf.oldfiles),                                       desc = "Oldfiles" },
        { "<leader>bf",
          pick(function()
            fzf.buffers({ sort_lastused = true, ignore_current_buffer = true })
          end),
          desc = "Find Buffer" },
        { "<leader>?",  pick(fzf.command_history), desc = "Command History" },
        { "<leader>cm", pick(fzf.manpages),        desc = "Manpages" },

        -- Code
        { "gd",
          pick(function()
            local attached = vim.lsp.get_clients({ bufnr = 0 })
            if next(attached) ~= nil then
              fzf.lsp_definitions()
            else
              vim.api.nvim_feedkeys("gd", "n", false)
            end
          end),
          mode = "n",
          desc = "Go to Definition" },
        { "<leader>gd", pick(fzf.lsp_definitions),       desc = "Go to Definition" },
        { "<leader>gr", pick(fzf.lsp_references),        desc = "Goto References" },
        { "<leader>gi", pick(fzf.lsp_implementations),   desc = "Go to Implementations" },
        { "<leader>gt", pick(fzf.lsp_typedefs),          desc = "Go to Type Definition" },
        { "<leader>cv", pick(fzf.lsp_document_symbols),  desc = "Document Symbols" },
        { "<leader>cd", pick(fzf.diagnostics_workspace), desc = "Code Diagnostics" },

        -- Git
        { "<leader>Gt", pick(fzf.git_branches), desc = "Git Branches" },
        { "<leader>Gc", pick(fzf.git_commits),  desc = "Git Commits" },
      })
    end,
  },
}
