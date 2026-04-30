treesitter_parsers := "lua c cpp python nix rust bash markdown html html_tags javascript ecma jsx css vim git_config git_rebase gitattributes gitcommit gitignore"

default:
  just --list

check:
  nvim --headless README.md '+checkhealth vim.treesitter' '+qa'

update-treesitter:
  nvim --headless "+lua require('nvim-treesitter').install(vim.split('{{treesitter_parsers}}', ' ')):wait(300000)" '+qa'
