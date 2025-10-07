local set_keymap = require("config.util.keys").set

set_keymap("n", "<leader>xt", "<cmd>TodoQuickFix<cr>", "Todo (QuickFix)")

return {
  "folke/todo-comments.nvim",
  cmd = { "TodoTrouble" },
  event = { "BufReadPost", "BufWritePost", "BufNewFile" },
  opts = {
    keywords = {
      GIU = {
        icon = "󰄛 ",
        color = "hint",
      },
      IN_PROGRESS = { icon = " ", color = "hint" },
    },
    highlight = {
      pattern = [[.*<(KEYWORDS)\s*]],
      comments_only = vim.bo.filetype == "markdown" and false or true,
    },
    search = {
      pattern = [[\b(KEYWORDS)\b]],
    },
  },
}
