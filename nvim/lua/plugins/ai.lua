return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      open_mapping = [[<c-\>]],
      direction = "float",
      float_opts = {
        border = "double",
        width = function()
          return math.ceil(vim.o.columns * 0.8)
        end,
        height = function()
          return math.ceil(vim.o.lines * 0.8)
        end,
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
