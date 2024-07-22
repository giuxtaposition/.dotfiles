return {
  "mrjones2014/smart-splits.nvim",
  lazy = false,
  opts = {},
  keys = {
    {
      "<A-h>",
      "<cmd>SmartResizeLeft<CR>",
      desc = "Resize left",
      mode = { "n", "x" },
    },
    {
      "<A-j>",
      "<cmd>SmartResizeDown<CR>",
      desc = "Resize down",
    },
    {
      "<A-k>",
      "<cmd>SmartResizeUp<CR>",
      desc = "Resize up",
    },
    {
      "<A-l>",
      "<cmd>SmartResizeRight<CR>",
      desc = "Resize right",
    },
    {
      "<C-h>",
      "<cmd>SmartCursorMoveLeft<CR>",
      desc = "Focus left window",
    },
    {
      "<C-j>",
      "<cmd>SmartCursorMoveDown<CR>",
      desc = "Focus bottom window",
    },
    {
      "<C-k>",
      "<cmd>SmartCursorMoveUp<CR>",
      desc = "Focus top window",
    },
    {
      "<C-l>",
      "<cmd>SmartCursorMoveRight<CR>",
      desc = "Focus right window",
    },
    {
      "<leader><leader>h",
      "<cmd>SmartSwapLeft<CR>",
      desc = "Swap left buffer",
    },
    {
      "<leader><leader>j",
      "<cmd>SmartSwapDown<CR>",
      desc = "Swap bottom buffer",
    },
    {
      "<leader><leader>k",
      "<cmd>SmartSwapUp<CR>",
      desc = "Swap top buffer",
    },
    {
      "<leader><leader>l",
      "<cmd>SmartSwapRight<CR>",
      desc = "Swap right buffer",
    },
  },
}
