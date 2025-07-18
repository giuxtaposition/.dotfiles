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
  keys = {
    {
      "]t",
      function()
        require("todo-comments").jump_next()
      end,
      desc = "Next todo comment",
    },
    {
      "[t",
      function()
        require("todo-comments").jump_prev()
      end,
      desc = "Previous todo comment",
    },
    { "<leader>xt", "<cmd>TodoQuickFix<cr>", desc = "Todo (QuickFix)" },
  },
}
