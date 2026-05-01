local treesitter_filetypes = {
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
  "vim",
  "gitconfig",
  "gitrebase",
  "gitattributes",
  "gitcommit",
  "gitignore",
}

local language_by_filetype = {
  gitconfig = "git_config",
  gitrebase = "git_rebase",
  javascriptreact = "javascript",
}

for filetype, language in pairs(language_by_filetype) do
  vim.treesitter.language.register(language, filetype)
end

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("config_treesitter", { clear = true }),
  pattern = treesitter_filetypes,
  callback = function(event)
    local language = vim.treesitter.language.get_lang(vim.bo[event.buf].filetype)
    if not language then
      return
    end

    local ok, has_parser = pcall(vim.treesitter.language.add, language)
    if ok and has_parser then
      pcall(vim.treesitter.start, event.buf, language)
    end
  end,
})
