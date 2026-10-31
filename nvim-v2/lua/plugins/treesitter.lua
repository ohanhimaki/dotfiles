local parsers = {
  "bash",
  "c_sharp",
  "css",
  "html",
  "javascript",
  "json",
  "lua",
  "luadoc",
  "markdown",
  "markdown_inline",
  "python",
  "razor",
  "regex",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "yaml",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    dependencies = {
      "neovim-treesitter/treesitter-parser-registry",
    },
    config = function()
      local treesitter = require("nvim-treesitter")

      local function install_missing()
        local installed = treesitter.get_installed("parsers")
        local missing = vim.tbl_filter(function(parser)
          return not vim.list_contains(installed, parser)
        end, parsers)

        if #missing == 0 then
          return
        end

        for _, tool in ipairs({ "gcc", "tree-sitter", "curl", "tar" }) do
          if vim.fn.executable(tool) == 0 then
            vim.notify("Treesitter: missing " .. tool .. ". Run bootstrap, then :TSInstallConfigured", vim.log.levels.WARN)
            return
          end
        end

        treesitter.install(missing):await(function(err)
          if err then
            vim.schedule(function()
              vim.notify("Treesitter installation failed: " .. tostring(err), vim.log.levels.ERROR)
            end)
          end
        end)
      end

      vim.api.nvim_create_user_command("TSInstallConfigured", install_missing, {
        desc = "Install configured Treesitter parsers",
      })

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("nvim_v2_treesitter", { clear = true }),
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
        end,
      })

      if vim.env.NVIM_V2_SKIP_INSTALL ~= "1" then
        vim.schedule(install_missing)
      end
    end,
  },
}
