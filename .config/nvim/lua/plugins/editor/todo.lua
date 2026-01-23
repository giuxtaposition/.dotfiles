vim.pack.add({ {
  src = "https://github.com/folke/todo-comments.nvim",
} })

local set_keymap = require("config.util.keys").set

set_keymap("n", "<leader>xt", "<cmd>TodoQuickFix<cr>", "Todo (QuickFix)")
