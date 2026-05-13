vim.lsp.config("roslyn", {
  settings = {
    ["csharp|background_analysis"] = {
      dotnet_analyzer_diagnostics_scope = "openFiles",
      dotnet_compiler_diagnostics_scope = "openFiles",
    },
    ["csharp|inlay_hints"] = {
      csharp_enable_inlay_hints_for_types = true,
      dotnet_enable_inlay_hints_for_parameters = true,
      dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
    },
    ["csharp|code_lens"] = {
      dotnet_enable_references_code_lens = true,
    },
  },
})

return {
  {
    "seblyng/roslyn.nvim",
    ft = "cs",
    opts = {
      broad_search = true,
      lock_target = true,
      filewatching = "roslyn",
      silent = true,
      extensions = {
        razor = { enabled = false },
      },
    },
  },
}
