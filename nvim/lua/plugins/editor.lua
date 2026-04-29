return {
  {
    "m4xshen/hardtime.nvim",
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    event = "VeryLazy",
    opts = { disabled_filetypes = { "toggleterm", "lazy", "mason", "TelescopePrompt" } },
  },
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "omnisharp", -- C# LSP
        "typescript-language-server", -- TS LSP
        "netcoredbg", -- Debugger dla C#
      },
    },
  },
  {
    "ahmedkhalf/project.nvim",
    event = "VeryLazy",
    config = function()
      require("project_nvim").setup({
        detection_methods = { "lsp", "pattern" },
        patterns = { ".git", "package.json", "*.sln", "*.csproj", "Makefile" },
        silent_chdir = true,
      })
      require("telescope").load_extension("projects")
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
      },
    },
  },
}
