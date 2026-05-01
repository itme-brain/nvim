# Neovim Configuration

Portable Neovim configuration using lazy.nvim, Mason-managed tooling, native LSP, native Treesitter, Telescope, and DAP (Neovim 0.11+, tested on 0.12.1).

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

- **Native LSP** (`vim.lsp.config` / `vim.lsp.enable`) - no manual server list needed
- **Smart LSP picker** (`<leader>css`) - auto-detects installed servers for current filetype
- **Neovim 0.12 compatible** - uses built-in `:lsp` commands and keeps legacy `:Lsp*` aliases working
- **Portable** - Mason is the source of truth for LSP servers and debug adapters
- **Treesitter** - uses Neovim's native `vim.treesitter.*` APIs without `nvim-treesitter`
- **Debugging** - lazy-loaded `nvim-dap` stack with Mason-managed adapters

## LSP Setup

Mason installs the shared LSP baseline on every system:
- `lua_ls` - Lua/Neovim
- `nil_ls` - Nix
- `bashls` - Bash/Shell
- `jsonls` - JSON
- `html` - HTML
- `cssls` - CSS
- `marksman` - Markdown
- `taplo` - TOML
- `yamlls` - YAML

On NixOS, Mason-installed binaries require `nix-ld` so downloaded tools can execute. The NixOS module should provide `nix-ld`; Neovim itself does not keep a separate Nix-only LSP package list.

The smart picker (`<leader>css`) scans all lspconfig servers and shows only those with binaries installed.
On Neovim 0.12+, start/stop/restart uses the built-in `:lsp` commands under the hood.

## Treesitter

Treesitter uses Neovim's native API:
- Highlighting starts through `vim.treesitter.start`
- Parser/filetype mappings use `vim.treesitter.language.register`
- Parser and query installation is intentionally outside lazy.nvim and Mason

Neovim loads compiled parser libraries from `parser/` directories on `runtimepath` and query files from `queries/<language>/`.
`tree-sitter-cli` is only needed by tools that generate or compile parsers from grammar sources; it is not required at runtime for highlighting.
Prefer providing parsers and queries through Neovim's runtime or a reproducible system/development environment.

## Debugging

Debugging uses `nvim-dap`, `nvim-dap-ui`, `nvim-dap-virtual-text`, `telescope-dap.nvim`, and `mason-nvim-dap.nvim`.

The DAP stack is lazy-loaded. Normal startup does not load DAP; it loads only when a `:Dap...` command runs or a `<leader>d...` mapping is used.

Mason installs:
- `debugpy` - Python
- `codelldb` - C/C++/Rust
- `bash-debug-adapter` - Bash
- `js-debug-adapter` - JavaScript/TypeScript

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
| `<leader>/` | Live grep from git root |
| `<leader>ff` | Find files from git root |
| `<leader>db` | Toggle breakpoint |
| `<leader>dB` | Set conditional breakpoint |
| `<leader>dc` | Continue debugging |
| `<leader>di` | Step into |
| `<leader>do` | Step over |
| `<leader>dO` | Step out |
| `<leader>du` | Toggle debug UI |
| `<leader>dt` | Terminate debug session |
| `<leader>de` | Evaluate expression |
| `<leader>ds` | Debug configurations |
| `<leader>dS` | Debug breakpoints |

## Plugins

- **lazy.nvim** - plugin manager
- **nvim-lspconfig** - LSP configurations
- **nvim-cmp** - completion
- **telescope.nvim** - fuzzy finder
- **Native Treesitter** - syntax highlighting
- **nvim-dap** - debug adapter client
- **nvim-dap-ui** - debugging UI panes
- **mason-nvim-dap.nvim** - Mason debug adapter integration
- **neo-tree.nvim** - file explorer
- **gitsigns.nvim** - git integration
- **lualine.nvim** - statusline
- **bufferline.nvim** - buffer tabs
- **which-key.nvim** - keybinding hints
