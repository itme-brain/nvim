# Neovim Configuration

Portable Neovim configuration using lazy.nvim and native LSP (Neovim 0.11+).

## Installation

### Standalone (any system)
```bash
git clone git@github.com:itme-brain/nvim.git ~/.config/nvim
```

### As part of NixOS config
```bash
git clone --recurse-submodules git@github.com:itme-brain/nixos.git
```

## Features

- **Native LSP** (`vim.lsp.config`) - no manual server list needed
- **Smart LSP picker** (`<leader>css`) - auto-detects installed servers for current filetype
- **Portable** - works on NixOS (LSPs via extraPackages) or any system (LSPs via Mason)
- **Mason** - auto-disabled on NixOS, auto-installs essentials elsewhere

## LSP Setup

On NixOS, LSPs come from:
- `neovim.extraPackages` (global essentials)
- Project `devShell` (project-specific)

On other systems, Mason auto-installs:
- `lua_ls` - Lua/Neovim
- `nil_ls` - Nix
- `bashls` - Bash/Shell
- `jsonls` - JSON
- `html` - HTML
- `cssls` - CSS
- `marksman` - Markdown
- `taplo` - TOML
- `yamlls` - YAML

The smart picker (`<leader>css`) scans all lspconfig servers and shows only those with binaries installed.

## Key Bindings

| Key | Action |
|-----|--------|
| `<leader>css` | Start LSP (smart picker) |
| `<leader>csx` | Stop LSP |
| `<leader>csr` | Restart LSP |
| `<leader>cf` | Format code |
| `<leader>ca` | Code action |
| `<leader>cr` | Rename symbol |
| `gd` | Go to definition |
| `<leader>gr` | Find references |
| `<leader>e` | Toggle file explorer |
| `<leader>bd` | Delete buffer |
| `<leader>/` | Live grep |
| `<leader>ff` | Find files |

## Plugins

- **lazy.nvim** - plugin manager
- **nvim-lspconfig** - LSP configurations
- **nvim-cmp** - completion
- **telescope.nvim** - fuzzy finder
- **nvim-treesitter** - syntax highlighting
- **neo-tree.nvim** - file explorer
- **gitsigns.nvim** - git integration
- **lualine.nvim** - statusline
- **bufferline.nvim** - buffer tabs
- **which-key.nvim** - keybinding hints
