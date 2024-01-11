vim.g.mapleader = " "
vim.g.maplocalleader = ";"

local Map = require("config.util").Map

-- General keymaps
Map({ "i", "v" }, "jk", "<Esc>", { desc = "Map jk to Esc" })
Map("t", "jk", "<C-\\><C-n>", { desc = "Enter normal mode in terminal" })
Map("n", "x", '"_x', { desc = "Do not copy after deleting char" })
Map("v", "y", "ygv<Esc>", { desc = "Yank and remain at cursor position" })
Map("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })
Map("n", "U", "<C-r>", { desc = "Redo" })
Map("n", "<leader>+", "<C-a>", { desc = "Increment" })
Map("n", "<leader>-", "<C-x>", { desc = "Decrement" })
Map("n", "<leader>vf", "$V%", { desc = "Selects a whole function definition, arrow function or object" })
Map("n", "rw", "viwpyiw", { desc = "Replace from under cursor until end of word with yanked text" })
Map("n", "n", "nzz", { desc = "Center cursor/screen on next search find" })
Map("n", "N", "Nzz", { desc = "Center cursor/screen on previous search find" })
Map("n", "<C-A>", "<cmd> %y+<cr>", { desc = "Copy whole file" })
Map("n", "<leader>ss", ":%s/<C-r><C-w>/", { desc = "Find and replace all occurrences of word under cursor" })
Map("n", "<leader><leader>", ':let @+ = expand("%")<cr>', { desc = "Yank filename path of current buffer" })
Map("n", "<cr>", "o<Esc>", { desc = "add blank line under current line" })

-- Buffers
Map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
Map("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
Map("n", "<leader>x", "<cmd>b#<cr>", { desc = "Close current buffer" })
Map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to other buffer" })

-- Windows
Map("n", "<leader>wv", "<C-w>v", { desc = "Split window vertically" })
Map("n", "<leader>wh", "<C-w>s", { desc = "Split window horizontally" })
Map("n", "<leader>wx", ":close<CR>", { desc = "Close current split window" })

-- Tabs
Map("n", "<leader><tab><tab>", ":tabnew<CR>", { desc = "Open new tab" })
Map("n", "<leader><tab>x", ":tabclose<CR>", { desc = "Close current tab" })
Map("n", "<leader><tab>]", ":tabn<CR>", { desc = "Go to next tab" })
Map("n", "<leader><tab>[", ":tabp<CR>", { desc = "Go to previous tab" })

-- move over a closing element in insert mode
Map("i", "<C-h>", "<Left>", { desc = "Move left in insert mode" })
Map("i", "<C-j>", "<Down>", { desc = "Move down in insert mode" })
Map("i", "<C-k>", "<Up>", { desc = "Move up in insert mode" })
Map("i", "<C-l>", "<Right>", { desc = "Move right in insert mode" })

-- Move Lines
Map("n", "<S-A-j>", ":m .+1<cr>==", { desc = "Move line down" })
Map("n", "<S-A-k>", ":m .-2<cr>==", { desc = "Move line up" })
Map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move line down" })
Map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move line up" })
Map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move line down" })
Map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move line up" })

-- Terminal mappings
Map("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to left window" })
Map("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to lower window" })
Map("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to upper window" })
Map("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to right window" })

---- Auto indent on empty line.
Map("n", "i", function()
  return string.match(vim.api.nvim_get_current_line(), "%g") == nil and "cc" or "i"
end, { expr = true, noremap = true })
