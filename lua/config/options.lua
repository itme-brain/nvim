vim.o.clipboard = "unnamedplus"
vim.g.autoformat = false

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
-- Enable true color if terminal supports it (disabled in TTY/headless)
if vim.env.COLORTERM == "truecolor" or vim.env.COLORTERM == "24bit" then
  vim.opt.termguicolors = true
end

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true

vim.opt.guicursor = "n-v-c:block,i:block,r:block"

vim.opt.fillchars = { eob = " " }

vim.opt.laststatus = 3

local mode_names = {
  n = "NORMAL", i = "INSERT", v = "VISUAL", V = "V-LINE",
  ["\22"] = "V-BLOCK", c = "COMMAND", R = "REPLACE", t = "TERM",
}

_G.statusline_mode = function()
  return mode_names[vim.api.nvim_get_mode().mode] or "?"
end

_G.statusline_branch = function()
  local b = vim.b.gitsigns_head
  return b and ("  " .. b) or ""
end

vim.opt.statusline = " %{v:lua.statusline_mode()}  %f%m%r %= %{v:lua.statusline_branch()}  %l:%c "

local options_group = vim.api.nvim_create_augroup("config_options", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = options_group,
  pattern = { "python", "c", "cpp" },
  callback = function()
    local opt = vim.opt_local
    opt.tabstop = 4
    opt.shiftwidth = 4
    opt.softtabstop = 4
  end,
})
