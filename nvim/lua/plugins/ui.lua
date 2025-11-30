return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = false,
    opts = {
      term_colors = true,
      color_overrides = {
        mocha = {
          -- base = "1e1e2e",
          base = "#1f1e22",
          mantle = "#232224",
        },
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin-mocha")
    end,
  },
  {
    "folke/tokyonight.nvim",
    -- Włączony tylko po to, żeby LazyVim mógł go załadować (ale nie używamy go)
    -- LazyVim próbuje załadować tokyonight, więc musimy go mieć dostępny
    -- ale ustawiamy catppuccin jako domyślny przez autocmd
    lazy = true,
    priority = 1, -- Niski priorytet, żeby catppuccin załadował się pierwszy
  },

  -- edgy
  {
    "folke/edgy.nvim",
    opts = {
      options = {
        left = { size = 30 },
        bottom = { size = 10 },
        right = { size = 50 },
        top = { size = 10 },
      },
      animate = {
        enabled = false,
      },
    },
  },

  -- bufferline
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        show_buffer_close_icons = false,
      },
    },
    keys = {
      { "<space>t", "<Cmd>BufferLinePick<CR>", desc = "Buffer picker" },
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle pin" },
      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete non-pinned buffers" },
      { "<leader>1", "<Cmd>BufferLineGoToBuffer 1<CR>" },
      { "<leader>2", "<Cmd>BufferLineGoToBuffer 2<CR>" },
      { "<leader>3", "<Cmd>BufferLineGoToBuffer 3<CR>" },
      { "<leader>4", "<Cmd>BufferLineGoToBuffer 4<CR>" },
      { "<leader>5", "<Cmd>BufferLineGoToBuffer 5<CR>" },
      { "<leader>6", "<Cmd>BufferLineGoToBuffer 6<CR>" },
      { "<leader>7", "<Cmd>BufferLineGoToBuffer 7<CR>" },
      { "<leader>8", "<Cmd>BufferLineGoToBuffer 8<CR>" },
      { "<leader>9", "<Cmd>BufferLineGoToBuffer 9<CR>" },
    },
  },

  -- statusline
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.sections.lualine_a =
        { {
          "mode",
          fmt = function(str)
            return str:sub(1, 1)
          end,
        } }
      opts.sections.lualine_c[4] = { LazyVim.lualine.pretty_path({ length = 6 }) }
    end,
  },
}
