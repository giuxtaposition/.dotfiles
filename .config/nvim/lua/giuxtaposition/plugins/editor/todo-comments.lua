return {
  "folke/todo-comments.nvim",
  cmd = { "TodoTrouble", "TodoTelescope" },
  event = { "BufReadPost", "BufWritePost", "BufNewFile" },
  opts = {
    keywords = {
      GIU = {
        icon = "󰄛 ",
        color = "giu",
      },
    },
    colors = {
      giu = require("giuxtaposition.config.colors").magenta,
    },
    highlight = {
      pattern = [[.*<(KEYWORDS)\s*]],
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
    { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
    { "<leader>xg", "<cmd>TodoTrouble keywords=GIU<cr>", desc = "Giu (Trouble)" },
    { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
    { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },
    { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
  },
}
