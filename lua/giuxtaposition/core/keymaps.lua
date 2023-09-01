vim.g.mapleader = " "
vim.g.maplocalleader = ";"

local keymap = vim.keymap

-- General keymaps
keymap.set({ "i", "v" }, "jk", "<Esc>") -- map jk to Esc in insert and visual mode

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
keymap.set("n", "<leader>fg", "<cmd>Telescope git_status<cr>") -- list git status files
keymap.set("n", "<leader>fr", "<cmd>Telescope registers<cr>") -- list registers
keymap.set("n", "<leader>fm", "<cmd>Telescope marks<cr>") -- list marks

-- smart-splits
keymap.set("", "<C-h>", "<cmd>SmartCursorMoveLeft<cr>") -- move cursor to left split window
keymap.set("", "<C-k>", "<cmd>SmartCursorMoveUp<cr>") -- move cursor to top split window
keymap.set("", "<C-j>", "<cmd>SmartCursorMoveDown<cr>") -- move cursor to bottom split window
keymap.set("", "<C-l>", "<cmd>SmartCursorMoveRight<cr>") -- move cursor to right split window
keymap.set("", "<A-h>", "<cmd>SmartResizeLeft<cr>") -- resize split window left
keymap.set("", "<A-k>", "<cmd>SmartResizeUp<cr>") -- resize split window top
keymap.set("", "<A-j>", "<cmd>SmartResizeDown<cr>") -- resize split window bottom
keymap.set("", "<A-l>", "<cmd>SmartResizeRight<cr>") -- resize split window right

-- trouble (better diagnostics)
keymap.set("n", "<leader>xx", function()
	require("trouble").open()
end)
keymap.set("n", "<leader>xw", function()
	require("trouble").open("workspace_diagnostics")
end)
keymap.set("n", "<leader>xd", function()
	require("trouble").open("document_diagnostics")
end)
keymap.set("n", "<leader>xq", function()
	require("trouble").open("quickfix")
end)
keymap.set("n", "<leader>xl", function()
	require("trouble").open("loclist")
end)
keymap.set("n", "gR", function()
	require("trouble").open("lsp_references")
end)

-- refactoring
vim.keymap.set("x", "<leader>re", ":Refactor extract ")
vim.keymap.set("x", "<leader>rf", ":Refactor extract_to_file ")
vim.keymap.set("x", "<leader>rv", ":Refactor extract_var ")
vim.keymap.set({ "n", "x" }, "<leader>ri", ":Refactor inline_var")
vim.keymap.set("n", "<leader>rb", ":Refactor extract_block")
vim.keymap.set("n", "<leader>rbf", ":Refactor extract_block_to_file")
vim.keymap.set({ "n", "x" }, "<leader>rr", function()
	require("telescope").extensions.refactoring.refactors()
end)
