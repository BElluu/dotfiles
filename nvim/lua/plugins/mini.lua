return {
  -- Mini.nvim - zestaw małych, wydajnych pluginów
  {
    "echasnovski/mini.nvim",
    version = false,
    config = function()
      -- Mini.pairs - automatyczne pary (może zastąpić nvim-autopairs)
      require("mini.pairs").setup()

      -- Mini.surround - surround text objects (może zastąpić nvim-surround)
      require("mini.surround").setup({
        mappings = {
          add = "sa", -- Surround Add
          delete = "sd", -- Surround Delete
          find = "sf", -- Surround Find
          find_left = "sF", -- Surround Find Left
          highlight = "sh", -- Surround Highlight
          replace = "sr", -- Surround Replace
          update_n_lines = "sn", -- Surround Update n lines
        },
      })

      -- Mini.comment - komentarze (może zastąpić Comment.nvim)
      require("mini.comment").setup()

      -- Mini.ai - lepsze text objects
      require("mini.ai").setup({
        n_lines = 500,
      })

      -- Mini.bracketed - nawigacja między nawiasami, konfliktami, itp.
      require("mini.bracketed").setup()

      -- Mini.indentscope - wizualizacja wcięć (może zastąpić indent-blankline)
      require("mini.indentscope").setup({
        symbol = "│",
        options = { try_as_border = true },
      })

      -- Mini.statusline - lekka statusline (opcjonalnie, jeśli chcesz zastąpić lualine)
      -- require("mini.statusline").setup()
    end,
  },
}

