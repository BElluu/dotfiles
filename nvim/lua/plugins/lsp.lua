return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = { spacing = 4, source = "if_many" },
        severity_sort = true,
      },
      inlay_hints = { enabled = false },
      codelens = { enabled = false },
      servers = {
        omnisharp = { enabled = false },
        elixirls = {},
      },
    },
  },
}
