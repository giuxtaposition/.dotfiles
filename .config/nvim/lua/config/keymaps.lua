vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.window_zoomed = false

local util = require("config.util.init")
local set_keymap = util.keys.set

-- Do things without affecting the registers
set_keymap("n", "x", '"_x', "Do not copy after deleting char")

-- Remapping gj gk for wrapped line
set_keymap("n", "j", "gj", "Down In Wrap", { noremap = true, silent = true })
set_keymap("n", "k", "gk", "Up In Wrap", { noremap = true, silent = true })

-- General keymaps
set_keymap({ "i", "v", "s" }, "jk", "<Esc>", "Map jk to Esc")
set_keymap("n", "U", "<C-r>", "Redo")
set_keymap("n", "<C-A>", "<cmd> %y+<cr>", "Copy whole file")
set_keymap("n", "<Esc>", "<cmd>nohlsearch<CR>", "Clear highlights")

-- Buffers
set_keymap("n", "[b", "<cmd>bprevious<cr>", "Prev buffer")
set_keymap("n", "]b", "<cmd>bnext<cr>", "Next buffer")
set_keymap("n", "<leader>bb", "<cmd>e #<cr>", "Switch to other buffer")
set_keymap("n", "<leader>by", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  vim.notify('Copied "' .. path .. '" to the clipboard!')
end, "Yank filename path of current buffer")

-- windows
set_keymap("n", "<leader>ww", "<C-W>p", "Other window", { remap = true })
set_keymap("n", "<leader>wd", "<C-W>c", "Delete window", { remap = true })
set_keymap("n", "<leader>wb", "<C-W>s", "Split window below", { remap = true })
set_keymap("n", "<leader>wv", "<C-W>v", "Split window right", { remap = true })

-- tabs
set_keymap("n", "<C-t>l", "<cmd>tablast<cr>", "Last Tab")
set_keymap("n", "<C-t>f", "<cmd>tabfirst<cr>", "First Tab")
set_keymap("n", "<C-t><tab>", "<cmd>tabnew<cr>", "New Tab")
set_keymap("n", "<C-t>]", "<cmd>tabnext<cr>", "Next Tab")
set_keymap("n", "<C-t>d", "<cmd>tabclose<cr>", "Close Tab")
set_keymap("n", "<C-t>[", "<cmd>tabprevious<cr>", "Previous Tab")
set_keymap("n", "<C-t>o", "<cmd>tabonly<cr>", "Close all other Tabs")

local function toggle_zoom()
  if vim.g.window_zoomed then
    vim.cmd("tabclose")
    vim.g.window_zoomed = false
  else
    vim.cmd("tab split")
    vim.g.window_zoomed = true
  end
end
set_keymap("n", "<leader>zm", toggle_zoom, "Open current window in new tab")

-- move over a closing element in insert mode
set_keymap("i", "<C-h>", "<Left>", "Move left in insert mode")
set_keymap("i", "<C-j>", "<Down>", "Move down in insert mode")
set_keymap("i", "<C-k>", "<Up>", "Move up in insert mode")
set_keymap("i", "<C-l>", "<Right>", "Move right in insert mode")

-- Move Lines
set_keymap("n", "<S-A-j>", ":m .+1<cr>==", "Move line down")
set_keymap("n", "<S-A-k>", ":m .-2<cr>==", "Move line up")
set_keymap("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", "Move line down")
set_keymap("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", "Move line up")
set_keymap("v", "<A-j>", ":m '>+1<cr>gv=gv", "Move line down")
set_keymap("v", "<A-k>", ":m '<-2<cr>gv=gv", "Move line up")

-- terminal
set_keymap("t", "<C-h>", "<cmd>wincmd h<cr>", "Go to left window")
set_keymap("t", "<C-j>", "<cmd>wincmd j<cr>", "Go to bottom window")
set_keymap("t", "<C-k>", "<cmd>wincmd k<cr>", "Go to top window")
set_keymap("t", "<C-l>", "<cmd>wincmd l<cr>", "Go to right window")

-- marks
set_keymap("n", "m", util.marks.add_mark, "Add mark")
set_keymap("n", "'", util.marks.goto_mark, "Go to mark")
set_keymap("n", "<leader>md", util.marks.remove_mark, "Delete mark")
set_keymap("n", "<leader>mD", util.marks.remove_all_marks, "Delete all marks")
set_keymap("n", "<leader>ml", util.marks.list_marks, "List marks")
