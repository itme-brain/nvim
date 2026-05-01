local M = {}

M.install_parsers = {
  "bash",
  "cpp",
  "css",
  "git_config",
  "git_rebase",
  "gitattributes",
  "gitcommit",
  "gitignore",
  "html",
  "javascript",
  "json",
  "nix",
  "python",
  "rust",
  "toml",
  "yaml",
}

M.filetypes = {
  "lua",
  "c",
  "cpp",
  "python",
  "nix",
  "rust",
  "bash",
  "markdown",
  "html",
  "javascript",
  "javascriptreact",
  "css",
  "json",
  "toml",
  "yaml",
  "vim",
  "gitconfig",
  "gitrebase",
  "gitattributes",
  "gitcommit",
  "gitignore",
}

M.language_by_filetype = {
  gitconfig = "git_config",
  gitrebase = "git_rebase",
  javascriptreact = "javascript",
}

return M
