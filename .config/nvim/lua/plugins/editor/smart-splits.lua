local set_keymap = require("config.util.keys").set

set_keymap({ "n", "x" }, "<A-h>", "<cmd>SmartResizeLeft<CR>", "Resize left")
set_keymap({ "n", "x" }, "<A-j>", "<cmd>SmartResizeDown<CR>", "Resize down")
set_keymap({ "n", "x" }, "<A-k>", "<cmd>SmartResizeUp<CR>", "Resize up")
set_keymap({ "n", "x" }, "<A-l>", "<cmd>SmartResizeRight<CR>", "Resize right")
set_keymap({ "n", "x" }, "<A-Left>", "<cmd>SmartResizeLeft<CR>", "Resize left")
set_keymap({ "n", "x" }, "<A-Down>", "<cmd>SmartResizeDown<CR>", "Resize down")
set_keymap({ "n", "x" }, "<A-Up>", "<cmd>SmartResizeUp<CR>", "Resize up")
set_keymap({ "n", "x" }, "<A-Right>", "<cmd>SmartResizeRight<CR>", "Resize right")
set_keymap({ "n", "x" }, "<C-h>", "<cmd>SmartCursorMoveLeft<CR>", "Focus left window")
set_keymap({ "n", "x" }, "<C-j>", "<cmd>SmartCursorMoveDown<CR>", "Focus bottom window")
set_keymap({ "n", "x" }, "<C-k>", "<cmd>SmartCursorMoveUp<CR>", "Focus top window")
set_keymap({ "n", "x" }, "<C-l>", "<cmd>SmartCursorMoveRight<CR>", "Focus right window")
set_keymap({ "n", "x" }, "<leader><leader>h", "<cmd>SmartSwapLeft<CR>", "Swap left buffer")
set_keymap({ "n", "x" }, "<leader><leader>j", "<cmd>SmartSwapDown<CR>", "Swap bottom buffer")
set_keymap({ "n", "x" }, "<leader><leader>k", "<cmd>SmartSwapUp<CR>", "Swap top buffer")
set_keymap({ "n", "x" }, "<leader><leader>l", "<cmd>SmartSwapRight<CR>", "Swap right buffer")
set_keymap({ "n", "x" }, "<C-Left>", "<cmd>SmartCursorMoveLeft<CR>", "Focus left window")
set_keymap({ "n", "x" }, "<C-Down>", "<cmd>SmartCursorMoveDown<CR>", "Focus bottom window")
set_keymap({ "n", "x" }, "<C-Up>", "<cmd>SmartCursorMoveUp<CR>", "Focus top window")
set_keymap({ "n", "x" }, "<C-Right>", "<cmd>SmartCursorMoveRight<CR>", "Focus right window")
set_keymap({ "n", "x" }, "<leader><leader><left>", "<cmd>SmartSwapLeft<CR>", "Swap left buffer")
set_keymap({ "n", "x" }, "<leader><leader><down>", "<cmd>SmartSwapDown<CR>", "Swap bottom buffer")
set_keymap({ "n", "x" }, "<leader><leader><up>", "<cmd>SmartSwapUp<CR>", "Swap top buffer")
set_keymap({ "n", "x" }, "<leader><leader><right>", "<cmd>SmartSwapRight<CR>", "Swap right buffer")

return {
  "mrjones2014/smart-splits.nvim",
  lazy = false,
  opts = {},
}
