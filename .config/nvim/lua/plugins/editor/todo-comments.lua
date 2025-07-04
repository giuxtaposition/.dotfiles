local _, colors = pcall(require, "andromeda.colors")

return {
  "folke/todo-comments.nvim",
  cmd = { "TodoTrouble" },
  event = { "BufReadPost", "BufWritePost", "BufNewFile" },
  opts = {
    keywords = {
      GIU = {
        icon = "󰄛 ",
        color = "giu",
      },
    },
    colors = {
      giu = colors.purple0,
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
    { "<leader>xt", "<cmd>TodoQuickFix<cr>", desc = "Todo (QuickFix)" },
  },
}
