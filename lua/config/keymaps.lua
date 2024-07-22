vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local map = vim.keymap.set

-- Do things without affecting the registers
map("n", "x", '"_x', { desc = "Do not copy after deleting char" })
map("n", "<A>p", '"0p')
map("n", "<A>P", '"0P')
map("v", "<A>p", '"0p')
map("n", "<A>c", '"_c')
map("n", "<A>C", '"_C')
map("v", "<A>c", '"_c')
map("v", "<A>C", '"_C')
map("n", "<A>d", '"_d')
map("n", "<A>D", '"_D')
map("v", "<A>d", '"_d')
map("v", "<A>D", '"_D')

-- General keymaps
map({ "i", "v", "s" }, "jk", "<Esc>", { desc = "Map jk to Esc" })
map("t", "jk", "<C-\\><C-n>", { desc = "Enter normal mode in terminal" })
map("n", "U", "<C-r>", { desc = "Redo" })
map("n", "<leader>+", "<C-a>", { desc = "Increment" })
map("n", "<leader>-", "<C-x>", { desc = "Decrement" })
map("n", "<C-A>", "<cmd> %y+<cr>", { desc = "Copy whole file" })
map("n", "<leader><leader>b", ':let @+ = expand("%")<cr>', { desc = "Yank filename path of current buffer" })
map("n", "<cr>", "o<Esc>", { desc = "add blank line under current line" })
map("n", "<leader>wb", "<C-W>s", { desc = "Split window below", remap = true })
map("n", "<leader>wv", "<C-W>v", { desc = "Split window right", remap = true })
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear highlights" })

-- Buffers
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to other buffer" })

-- windows
map("n", "<leader>ww", "<C-W>p", { desc = "Other window", remap = true })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete window", remap = true })
map("n", "<leader>wb", "<C-W>s", { desc = "Split window below", remap = true })
map("n", "<leader>wv", "<C-W>v", { desc = "Split window right", remap = true })

-- tabs
map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- move over a closing element in insert mode
map("i", "<C-h>", "<Left>", { desc = "Move left in insert mode" })
map("i", "<C-j>", "<Down>", { desc = "Move down in insert mode" })
map("i", "<C-k>", "<Up>", { desc = "Move up in insert mode" })
map("i", "<C-l>", "<Right>", { desc = "Move right in insert mode" })

-- Move Lines
map("n", "<S-A-j>", ":m .+1<cr>==", { desc = "Move line down" })
map("n", "<S-A-k>", ":m .-2<cr>==", { desc = "Move line up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move line down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move line down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move line up" })

-- terminal
map("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to left window" })
map("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to bottom window" })
map("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to top window" })
map("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to right window" })
