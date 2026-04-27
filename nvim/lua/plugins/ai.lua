return {
  {
    "akinsho/toggleterm.nvim",
    lazy = false,
    opts = {
      open_mapping = [[<c-\>]],
      direction = "float",
      float_opts = {
        border = "double",
        width = math.ceil(vim.o.columns * 0.8),
        height = math.ceil(vim.o.rows * 0.8),
      },
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)
      local Terminal = require("toggleterm.terminal").Terminal

      local claude = Terminal:new({ cmd = "claude", hidden = true })
      local cursor = Terminal:new({ cmd = "cursor", hidden = true })

      vim.keymap.set("n", "<leader>ac", function() claude:toggle() end, { desc = "Claude Code" })
      vim.keymap.set("n", "<leader>aa", function() cursor:toggle() end, { desc = "Cursor AI CLI" })
    end,
  },
}
