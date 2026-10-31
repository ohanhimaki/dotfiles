local servers = {
  "cssls",
  "eslint",
  "html",
  "jsonls",
  "markdown_oxide",
  "pyright",
  "tailwindcss",
  lua_ls = {
    root_markers = { ".git", ".luarc.json", ".luarc.jsonc", "stylua.toml" },
    settings = {
      Lua = {
        runtime = { version = "LuaJIT" },
        diagnostics = { globals = { "vim", "Snacks", "MiniDiff", "MiniFiles" } },
        workspace = {
          checkThirdParty = false,
          library = { vim.env.VIMRUNTIME },
        },
        telemetry = { enable = false },
      },
    },
  },
  ts_ls = {
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    settings = {
      javascript = {
        inlayHints = {
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayParameterNameHints = "all",
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayVariableTypeHints = true,
        },
      },
      typescript = {
        inlayHints = {
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayParameterNameHints = "all",
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayVariableTypeHints = true,
        },
      },
    },
  },
}

local mason_servers = {
  "cssls",
  "eslint",
  "html",
  "jsonls",
  "lua_ls",
  "markdown_oxide",
  "pyright",
  "tailwindcss",
  "ts_ls",
}

return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
      "saghen/blink.cmp",
      {
        "mason-org/mason.nvim",
        lazy = false,
        opts = {
          registries = {
            "github:mason-org/mason-registry",
            "github:Crashdummyy/mason-registry",
          },
        },
      },
      {
        "mason-org/mason-lspconfig.nvim",
        lazy = false,
        opts = function()
          return {
            automatic_enable = false,
            ensure_installed = vim.env.NVIM_V2_SKIP_INSTALL == "1" and {} or mason_servers,
          }
        end,
      },
      {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        lazy = false,
        opts = {
          ensure_installed = {
            "csharpier",
            "prettier",
            "roslyn",
            "ruff",
            "stylua",
            "xmlformatter",
          },
          run_on_start = vim.env.NVIM_V2_SKIP_INSTALL ~= "1",
          start_delay = 1000,
        },
      },
    },
    config = function()
      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })

      for name, config in pairs(servers) do
        if type(name) == "number" then
          name = config
          config = {}
        end
        vim.lsp.config(name, config)
        vim.lsp.enable(name)
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("nvim_v2_lsp_attach", { clear = true }),
        callback = function(args)
          local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
          local function map(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = args.buf, desc = "LSP: " .. desc })
          end

          map("gd", function() Snacks.picker.lsp_definitions() end, "Definitions")
          map("gD", function() Snacks.picker.lsp_declarations() end, "Declarations")
          map("gR", function() Snacks.picker.lsp_references() end, "References")
          map("gI", function() Snacks.picker.lsp_implementations() end, "Implementations")
          map("gy", function() Snacks.picker.lsp_type_definitions() end, "Type definitions")
          map("K", vim.lsp.buf.hover, "Hover")
          map("<leader>ca", vim.lsp.buf.code_action, "Code action")
          map("<leader>cr", vim.lsp.buf.rename, "Rename")
          map("<leader>ss", function() Snacks.picker.lsp_symbols() end, "Document symbols")
          map("<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, "Workspace symbols")
          map("<leader>lsr", function()
            vim.notify("Restarting LSP client: " .. client.name)
            vim.cmd("LspRestart " .. client.name)
          end, "Restart")
        end,
      })
    end,
  },
}
