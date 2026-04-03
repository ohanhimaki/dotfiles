vim.diagnostic.config({
  virtual_text = true,
  virtual_lines = false,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})
--add all lsp packages using vim.pack.add. use mason
vim.pack.add({
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/mason-org/mason.nvim",
  "https://github.com/mason-org/mason-lspconfig.nvim",
  "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
})
--
require("mason").setup({
  registries = {
    "github:mason-org/mason-registry",
    "github:Crashdummyy/mason-registry",
  },
})
require("mason-lspconfig").setup()
require("mason-tool-installer").setup({
  ensure_installed = {
    "lua-language-server",
    "xmlformatter",
    "csharpier",
    "prettier",
    "stylua",
    "bicep-lsp",
    "html-lsp",
    "css-lsp",
    "eslint-lsp",
    "typescript-language-server",
    "json-lsp",
    "rust-analyzer",
    "roslyn",
    "netcoredbg",
    -- Python tools
    "pyright",
    -- "debugpy",
    "ruff",
    "markdown-oxide",
  },
})
local M = {}
M.capabilities = vim.lsp.protocol.make_client_capabilities()

M.capabilities.textDocument.completion.completionItem = {
  documentationFormat = { "markdown", "plaintext" },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  },
}

local lua_lsp_settings = {
  Lua = {
    runtime = { version = "LuaJIT" },
    diagnostics = {
      globals = { "vim", "require" },
    },
    workspace = {
       checkThirdParty = false,
      library = vim.api.nvim_get_runtime_file("", true),
    },
    telemetry = {
      enable = false,
    },
  },
  root_markers = { '.git', '.hg', 'nvim-pack-lock.json' },
}
-- vim.lsp.config("*", { capabilities = M.capabilities, on_init = M.on_init })
vim.lsp.config("lua_ls", { settings = lua_lsp_settings })
vim.lsp.enable("lua_ls")
local servers = { "html", "cssls", "pyright", "markdown_oxide", "likec4" }
vim.lsp.enable(servers)
