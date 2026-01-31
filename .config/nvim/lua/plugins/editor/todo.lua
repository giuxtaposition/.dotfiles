vim.pack.add({ {
  src = "https://github.com/folke/todo-comments.nvim",
} })

require("todo-comments").setup()

local set_keymap = require("config.util.keys").set

set_keymap("n", "<leader>xt", "<cmd>TodoQuickFix<cr>", "Todo (QuickFix)")
