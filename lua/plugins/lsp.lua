-- Neovim 0.11+ LSP configuration
-- Uses nvim-lspconfig for server definitions + vim.lsp.enable() API

-- Servers to ensure are installed via Mason.
local mason_ensure_installed = {
  "lua_ls",       -- Neovim config
  "nil_ls",       -- Nix (nixd not available in Mason)
  "bashls",       -- Shell scripts
  "jsonls",       -- JSON configs
  "html",         -- HTML
  "cssls",        -- CSS
  "marksman",     -- Markdown
  "taplo",        -- TOML
  "yamlls",       -- YAML
}

local treesitter_parsers = {
  "lua",
  "c",
  "cpp",
  "python",
  "nix",
  "rust",
  "bash",
  "markdown",
  "markdown_inline",
  "html",
  "html_tags",
  "javascript",
  "jsx",
  "css",
  "vim",
  "git_config",
  "git_rebase",
  "gitattributes",
  "gitcommit",
  "gitignore",
}

return {
  {
    "neovim-treesitter/nvim-treesitter",
    name = "nvim-treesitter",
    dependencies = {
      "neovim-treesitter/treesitter-parser-registry",
      "williamboman/mason.nvim",
    },
    lazy = false,
    build = ":TSUpdate",
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("config_treesitter", { clear = true }),
        pattern = {
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
        },
        callback = function(event)
          if pcall(vim.treesitter.start, event.buf) then
            vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
    config = function()
      require("nvim-treesitter").setup()

      local function has_c_compiler()
        return vim.fn.executable("cc") == 1
          or vim.fn.executable("gcc") == 1
          or vim.fn.executable("clang") == 1
      end

      local function install_missing_parsers(missing)
        if not has_c_compiler() then
          vim.notify_once(
            "A C compiler is required to install or update Treesitter parsers",
            vim.log.levels.WARN
          )
          return
        end

        require("nvim-treesitter").install(missing)
      end

      local function tree_sitter_cli_works()
        if vim.fn.executable("tree-sitter") == 0 then
          return false
        end

        local result = vim.system({ "tree-sitter", "--version" }, { text = true }):wait()
        if result.code == 0 then
          return true
        end

        vim.notify_once(
          "tree-sitter CLI is installed but cannot run. On NixOS, enable nix-ld so Mason-installed binaries can execute.",
          vim.log.levels.WARN
        )
        return false
      end

      local function ensure_treesitter_cli(callback)
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
          vim.notify_once(
            "tree-sitter CLI is required to install or update parsers; install tree-sitter-cli or enable mason.nvim",
            vim.log.levels.WARN
          )
          return
        end

        mason.setup()
        registry.refresh(function()
          local package_ok, package = pcall(registry.get_package, "tree-sitter-cli")
          if not package_ok then
            vim.notify_once(
              "Mason registry does not include tree-sitter-cli; install tree-sitter-cli before running :TSUpdate",
              vim.log.levels.WARN
            )
            return
          end

          if package:is_installed() then
            if tree_sitter_cli_works() then
              callback()
            end
            return
          end

          if package:is_installing() then
            vim.notify_once("tree-sitter-cli is already being installed by Mason", vim.log.levels.INFO)
            return
          end

          vim.notify_once("Installing tree-sitter-cli with Mason for Treesitter parser updates", vim.log.levels.INFO)
          package:install({}, function(success, error)
            if success and tree_sitter_cli_works() then
              callback()
            else
              vim.notify(
                "Failed to install tree-sitter-cli with Mason: " .. tostring(error),
                vim.log.levels.WARN
              )
            end
          end)
        end)
      end

      local installed = require("nvim-treesitter.config").get_installed()
      local missing = vim.iter(treesitter_parsers)
          :filter(function(parser)
            return not vim.tbl_contains(installed, parser)
          end)
          :totable()

      if #missing == 0 and #vim.api.nvim_list_uis() == 0 then
        return
      end

      ensure_treesitter_cli(function()
        if #missing > 0 then
          install_missing_parsers(missing)
        end
      end)
    end
  },

  {
    "m4xshen/autoclose.nvim",
    config = function()
      require("autoclose").setup()
    end
  },

  -- Mason: portable LSP installer. On NixOS this requires nix-ld for
  -- downloaded Linux binaries to run.
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = mason_ensure_installed,
        automatic_installation = false,  -- Only install what's in ensure_installed
      })
    end
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "saghen/blink.cmp",
    },
    config = function()
      local lspconfig = require('lspconfig')

      -- Neovim 0.12 exposes built-in :lsp commands and skips lspconfig's legacy
      -- :Lsp* aliases. Recreate the old names so existing mappings keep working.
      if vim.fn.exists(':lsp') == 2 and vim.fn.exists(':LspStart') == 0 then
        vim.api.nvim_create_user_command('LspStart', function(info)
          vim.cmd('lsp enable ' .. table.concat(info.fargs, ' '))
        end, { nargs = '*' })

        vim.api.nvim_create_user_command('LspRestart', function(info)
          vim.cmd('lsp restart ' .. table.concat(info.fargs, ' '))
        end, { nargs = '*', bang = true })

        vim.api.nvim_create_user_command('LspStop', function(info)
          local suffix = info.bang and '!' or ''
          vim.cmd('lsp stop' .. suffix .. ' ' .. table.concat(info.fargs, ' '))
        end, { nargs = '*', bang = true })
      end

      -- Diagnostic display configuration
      vim.diagnostic.config({
        virtual_text = {
          prefix = '●',
          spacing = 2,
          current_line = true;
        },
        float = {
          border = 'rounded',
          source = true,
        },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = '',
            [vim.diagnostic.severity.WARN] = '',
            [vim.diagnostic.severity.INFO] = '',
            [vim.diagnostic.severity.HINT] = '',
          },
        },
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })

      -- Add border to hover and signature help windows.
      local hover_handler = vim.lsp.handlers.hover
      vim.lsp.handlers['textDocument/hover'] = function(err, result, ctx, config)
        return hover_handler(err, result, ctx, vim.tbl_extend('force', config or {}, {
          border = 'rounded',
        }))
      end

      local signature_help_handler = vim.lsp.handlers.signature_help
      vim.lsp.handlers['textDocument/signatureHelp'] = function(err, result, ctx, config)
        return signature_help_handler(err, result, ctx, vim.tbl_extend('force', config or {}, {
          border = 'rounded',
        }))
      end

      -- Get all known server names by scanning lspconfig's lsp directory
      local function get_all_servers()
        local servers = {}
        local lsp_path = vim.fn.stdpath('data') .. '/lazy/nvim-lspconfig/lsp'
        local files = vim.fn.readdir(lsp_path, function(name)
          return name:sub(-4) == '.lua'
        end)
        for _, file in ipairs(files) do
          local server = file:sub(1, -5)
          table.insert(servers, server)
        end
        return servers
      end

      local all_servers = get_all_servers()

      local capabilities = require('blink.cmp').get_lsp_capabilities()

      -- Global config applied to all servers
      vim.lsp.config('*', {
        autostart = false,  -- Don't auto-attach, use <leader>css to start manually
        capabilities = capabilities,
      })

      -- Server-specific settings (merged with lspconfig defaults)
      vim.lsp.config.lua_ls = {
        settings = {
          Lua = {
            diagnostics = {
              globals = { 'vim' }
            }
          }
        }
      }

      -- Check if server binary is available
      local function is_server_installed(config)
        if config.default_config and config.default_config.cmd then
          local cmd = config.default_config.cmd[1]
          return vim.fn.executable(cmd) == 1
        end
        return false
      end

      -- Find and start LSP server(s) for current filetype
      local function lsp_start_smart()
        local ft = vim.bo.filetype
        if ft == '' then
          vim.notify("No filetype detected", vim.log.levels.WARN)
          return
        end

        -- Find all matching servers (filetype match + binary installed)
        local matching = {}
        for _, server in ipairs(all_servers) do
          local ok, config = pcall(require, 'lspconfig.configs.' .. server)
          if ok and config.default_config and config.default_config.filetypes then
            if vim.tbl_contains(config.default_config.filetypes, ft) and is_server_installed(config) then
              table.insert(matching, server)
            end
          end
        end

        -- Sort for consistent ordering
        table.sort(matching)

        local function start_server(server)
          vim.lsp.enable(server)
        end

        if #matching == 0 then
          vim.notify("No LSP server installed for filetype: " .. ft, vim.log.levels.WARN)
        elseif #matching == 1 then
          start_server(matching[1])
        else
          vim.ui.select(matching, {
            prompt = "Select LSP server:",
          }, function(choice)
            if choice then
              start_server(choice)
            end
          end)
        end
      end

      -- LSP keybindings
      require("which-key").add({
        { "<leader>cs",  group = "LSP Commands" },
        { "<leader>cf",  function() vim.lsp.buf.format() end, desc = "Code Format" },
        { "<leader>csi", ":checkhealth vim.lsp<CR>",          desc = "LSP Info" },
        { "<leader>csr", ":lsp restart<CR>",                  desc = "LSP Restart" },
        { "<leader>css", lsp_start_smart,                     desc = "LSP Start" },
        { "<leader>csx", ":lsp stop<CR>",                     desc = "LSP Stop" },
      })
    end
  },
}
