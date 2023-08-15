vim.g.mapleader = " "
vim.g.maplocalleader = ";"

local keymap = vim.keymap

-- General keymaps
keymap.set("i", ";;", "<Esc>") -- map ;; to Esc in insert mode
keymap.set("v", ";;", "<Esc>") -- map ;; to Esc in visual mode

keymap.set("n", "x", '"_x') -- do not copy after deleting char

keymap.set("n", "<leader>nh", ":nohl<CR>") -- clear search highlights

keymap.set("n", "<leader>+", "<C-a>") -- increment
keymap.set("n", "<leader>-", "<C-x>") -- decrement

keymap.set("n", "<leader>sv", "<C-w>v") -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s") -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=") -- make split windows equal width
keymap.set("n", "<leader>sx", ":close<CR>") -- close current split window
keymap.set("", "<C-h>", "<C-w>h") -- move cursor to left split window
keymap.set("", "<C-k>", "<C-w>k") -- move cursor to top split window
keymap.set("", "<C-j>", "<C-w>j") -- move cursor to bottom split window
keymap.set("", "<C-l>", "<C-w>l") -- move cursor to right split window

keymap.set("n", "<leader>to", ":tabnew<CR>") -- open new tab
keymap.set("n", "<leader>tx", ":tabclose<CR>") -- close current tab
keymap.set("n", "<leader>tn", ":tabn<CR>") -- go to next tab
keymap.set("n", "<Tab>", ":tabn<CR>") -- go to next tab
keymap.set("n", "<leader>tp", ":tabp<CR>") -- go to previous tab

keymap.set("n", "U", "<C-r>") -- Redo

keymap.set("n", "<leader>vf", "$V%") -- selects a whole function definition, arrow function or object

keymap.set("v", "y", "ygv<Esc>") -- yank and remain at cursor position

-- Plugins keymaps

-- windows.nvim
keymap.set("n", "<leader>sm", ":WindowsMaximize<CR>")

-- nvim-tree
keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")

-- telescope
keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>") -- find files within current working directory, respects .gitignore
keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>") -- find string in current working directory as you type
keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>") -- find string under cursor in current working directory
keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>") -- list open buffers in current neovim instance
keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>") -- list available help tags
keymap.set("n", "<leader>fx", "<cmd>Telescope resume<cr>") -- resume last telescope window
