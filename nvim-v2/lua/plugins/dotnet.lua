local roslyn_settings = {
  ["csharp|background_analysis"] = {
    background_analysis = {
      dotnet_analyzer_diagnostics_scope = "openFiles",
      dotnet_compiler_diagnostics_scope = "openFiles",
    },
  },
  ["csharp|code_lens"] = {
    dotnet_enable_references_code_lens = true,
    dotnet_enable_tests_code_lens = true,
  },
  ["csharp|completion"] = {
    dotnet_provide_regex_completions = true,
    dotnet_show_completion_items_from_unimported_namespaces = true,
    dotnet_show_name_completion_suggestions = true,
  },
  ["csharp|formatting"] = {
    dotnet_organize_imports_on_format = true,
  },
  ["csharp|inlay_hints"] = {
    csharp_enable_inlay_hints_for_implicit_object_creation = true,
    csharp_enable_inlay_hints_for_implicit_variable_types = true,
    csharp_enable_inlay_hints_for_lambda_parameter_types = true,
    csharp_enable_inlay_hints_for_types = true,
    dotnet_enable_inlay_hints_for_indexer_parameters = true,
    dotnet_enable_inlay_hints_for_literal_parameters = true,
    dotnet_enable_inlay_hints_for_object_creation_parameters = true,
    dotnet_enable_inlay_hints_for_other_parameters = true,
    dotnet_enable_inlay_hints_for_parameters = true,
    dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
    dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
    dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
  },
  ["razor|completion"] = {
    dotnet_show_completion_items_from_unimported_namespaces = true,
  },
  ["razor|formatting"] = {
    dotnet_organize_imports_on_format = true,
  },
  ["razor|inlay_hints"] = {
    dotnet_enable_inlay_hints_for_parameters = true,
    dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
    dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
  },
}

return {
  {
    "seblyng/roslyn.nvim",
    ft = { "cs", "razor" },
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    opts = {
      broad_search = false,
      filewatching = "auto",
      lock_target = false,
    },
    init = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("nvim_v2_roslyn_attach", { clear = true }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client or client.name ~= "roslyn" then
            return
          end

          vim.keymap.set("n", "<leader>tr", vim.lsp.codelens.run, {
            buffer = args.buf,
            desc = "Test: run CodeLens",
          })
          vim.lsp.codelens.enable(true, {
            bufnr = args.buf,
          })
        end,
      })
    end,
    config = function(_, opts)
      vim.lsp.config("roslyn", {
        settings = roslyn_settings,
      })
      require("roslyn").setup(opts)
    end,
  },
}
