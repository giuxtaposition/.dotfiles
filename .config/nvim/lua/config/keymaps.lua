vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local set_keymap = require("config.util.init").keys.set

-- Do things without affecting the registers
set_keymap("n", "x", '"_x', "Do not copy after deleting char")

-- Remapping gj gk for wrapped line
set_keymap("n", "j", "gj", "Down In Wrap", { noremap = true, silent = true })
set_keymap("n", "k", "gk", "Up In Wrap", { noremap = true, silent = true })

-- General keymaps
set_keymap({ "i", "v", "s" }, "jk", "<Esc>", "Map jk to Esc")
set_keymap("n", "U", "<C-r>", "Redo")
set_keymap("n", "<C-A>", "<cmd> %y+<cr>", "Copy whole file")
set_keymap("n", "<leader><leader>b", ':let @+ = expand("%")<cr>', "Yank filename path of current buffer")
set_keymap("n", "<leader>wb", "<C-W>s", "Split window below", { remap = true })
set_keymap("n", "<leader>wv", "<C-W>v", "Split window right", { remap = true })
set_keymap("n", "<Esc>", "<cmd>nohlsearch<CR>", "Clear highlights")

-- Buffers
set_keymap("n", "[b", "<cmd>bprevious<cr>", "Prev buffer")
set_keymap("n", "]b", "<cmd>bnext<cr>", "Next buffer")
set_keymap("n", "<leader>bb", "<cmd>e #<cr>", "Switch to other buffer")

-- windows
set_keymap("n", "<leader>ww", "<C-W>p", "Other window", { remap = true })
set_keymap("n", "<leader>wd", "<C-W>c", "Delete window", { remap = true })
set_keymap("n", "<leader>wb", "<C-W>s", "Split window below", { remap = true })
set_keymap("n", "<leader>wv", "<C-W>v", "Split window right", { remap = true })

-- tabs
set_keymap("n", "<leader><tab>l", "<cmd>tablast<cr>", "Last Tab")
set_keymap("n", "<leader><tab>f", "<cmd>tabfirst<cr>", "First Tab")
set_keymap("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", "New Tab")
set_keymap("n", "<leader><tab>]", "<cmd>tabnext<cr>", "Next Tab")
set_keymap("n", "<leader><tab>d", "<cmd>tabclose<cr>", "Close Tab")
set_keymap("n", "<leader><tab>[", "<cmd>tabprevious<cr>", "Previous Tab")

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
