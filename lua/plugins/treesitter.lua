local treesitter_languages = require("config.treesitter_languages")

local function tree_sitter_cli_works()
  if vim.fn.executable("tree-sitter") == 0 then
    return false
  end

  local result = vim.system({ "tree-sitter", "--version" }, { text = true }):wait()
  return result.code == 0
end

local function ensure_tree_sitter_cli(callback)
  if tree_sitter_cli_works() then
    callback()
    return
  end

  if #vim.api.nvim_list_uis() == 0 then
    return
  end

  local mason_ok, mason = pcall(require, "mason")
  local registry_ok, registry = pcall(require, "mason-registry")
  if not mason_ok or not registry_ok then
    vim.notify_once("tree-sitter CLI is required to install Treesitter parsers", vim.log.levels.WARN)
    return
  end

  mason.setup()
  registry.refresh(function()
    local package_ok, package = pcall(registry.get_package, "tree-sitter-cli")
    if not package_ok then
      vim.notify_once("Mason registry does not include tree-sitter-cli", vim.log.levels.WARN)
      return
    end

    if package:is_installed() then
      if tree_sitter_cli_works() then
        callback()
      else
        vim.notify_once("tree-sitter CLI is installed but cannot run", vim.log.levels.WARN)
      end
      return
    end

    if package:is_installing() then
      return
    end

    package:install({}, function(success, error)
      if success and tree_sitter_cli_works() then
        callback()
      else
        vim.notify("Failed to install tree-sitter-cli with Mason: " .. tostring(error), vim.log.levels.WARN)
      end
    end)
  end)
end

return {
  {
    "neovim-treesitter/nvim-treesitter",
    name = "neovim-treesitter",
    dependencies = {
      "neovim-treesitter/treesitter-parser-registry",
      "williamboman/mason.nvim",
    },
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local treesitter = require("nvim-treesitter")
      treesitter.setup()

      local installed = treesitter.get_installed("parsers")
      local missing = vim.iter(treesitter_languages.install_parsers)
          :filter(function(parser)
            return not vim.tbl_contains(installed, parser)
          end)
          :totable()

      if #missing == 0 then
        return
      end

      ensure_tree_sitter_cli(function()
        treesitter.install(missing)
      end)
    end,
  },
}
