return {
  -- Mason - zarządzanie serwerami LSP
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "lua-language-server",
        "csharp_ls",
        "typescript-language-server",
      },
    },
  },

  -- Mason LSP Config - integracja Mason z LSP
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "mason.nvim" },
    opts = {
      ensure_installed = {
        "lua_ls",
        "csharp_ls",
        "ts_ls",
      },
    },
  },
}
