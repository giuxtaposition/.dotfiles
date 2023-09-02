vim.g.mapleader = " "
vim.g.maplocalleader = ";"

local keymap = vim.keymap

-- General keymaps
keymap.set({ "i", "v" }, "jk", "<Esc>") -- map jk to Esc in insert and visual mode
keymap.set("t", "jk", "<C-\\><C-n>")

keymap.set("n", "x", '"_x') -- do not copy after deleting char
keymap.set("v", "y", "ygv<Esc>") -- yank and remain at cursor position

keymap.set("n", "<leader>nh", ":nohl<CR>") -- clear search highlights

keymap.set("n", "<leader>+", "<C-a>") -- increment
keymap.set("n", "<leader>-", "<C-x>") -- decrement

keymap.set("n", "<leader>sv", "<C-w>v") -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s") -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=") -- make split windows equal width
keymap.set("n", "<leader>sx", ":close<CR>") -- close current split window

keymap.set("n", "<leader>to", ":tabnew<CR>") -- open new tab
keymap.set("n", "<leader>tx", ":tabclose<CR>") -- close current tab
keymap.set("n", "<leader>tn", ":tabn<CR>") -- go to next tab
keymap.set("n", "<Tab>", ":tabn<CR>") -- go to next tab
keymap.set("n", "<leader>tp", ":tabp<CR>") -- go to previous tab

keymap.set("n", "U", "<C-r>") -- Redo

keymap.set("n", "<leader>vf", "$V%") -- selects a whole function definition, arrow function or object
keymap.set("n", "rw", "cw<C-r>0<ESC>") -- replace from under cursor until end of word with yanked text
