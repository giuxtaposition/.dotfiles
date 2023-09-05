vim.g.mapleader = " "
vim.g.maplocalleader = ";"

function Map(mode, lhs, rhs, opts)
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.keymap.set(mode, lhs, rhs, options)
end

-- General keymaps
Map({ "i", "v" }, "jk", "<Esc>", { desc = "Map jk to Esc" })
Map("t", "jk", "<C-\\><C-n>", { desc = "Enter normal mode in terminal" })

Map("n", "x", '"_x', { desc = "Do not copy after deleting char" })
Map("v", "y", "ygv<Esc>", { desc = "Yank and remain at cursor position" })

Map("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

Map("n", "<leader>+", "<C-a>", { desc = "Increment" })
Map("n", "<leader>-", "<C-x>", { desc = "Decrement" })

Map("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
Map("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
Map("n", "<leader>sx", ":close<CR>", { desc = "Close current split window" })

Map("n", "<leader>to", ":tabnew<CR>", { desc = "Open new tab" })
Map("n", "<leader>tx", ":tabclose<CR>", { desc = "Close current tab" })
Map("n", "<leader>tn", ":tabn<CR>", { desc = "Go to next tab" })
Map("n", "<leader>tp", ":tabp<CR>", { desc = "Go to previous tab" })

Map("n", "U", "<C-r>", { desc = "Redo" })

Map("n", "<leader>vf", "$V%", { desc = "Selects a whole function definition, arrow function or object" })
Map("n", "rw", "viwpyiw", { desc = "Replace from under cursor until end of word with yanked text" })

Map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
Map("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
Map("n", "<leader>x", "<cmd>b#<cr>", { desc = "Close current buffer" })

Map("n", "n", "nzz", { desc = "Center cursor/screen on next search find" })
Map("n", "N", "Nzz", { desc = "Center cursor/screen on previous search find" })

-- move over a closing element in insert mode
Map("i", "<C-h>", "<Left>", { desc = "Move left in insert mode" })
Map("i", "<C-j>", "<Down>", { desc = "Move down in insert mode" })
Map("i", "<C-k>", "<Up>", { desc = "Move up in insert mode" })
Map("i", "<C-l>", "<Right>", { desc = "Move right in insert mode" })

-- Move Lines
Map("n", "<A-S-j>", ":m .+1<cr>==", { desc = "Move line down" })
Map("n", "<A-S-k>", ":m .-2<cr>==", { desc = "Move line up" })
Map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move line down" })
Map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move line up" })
Map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move line down" })
Map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move line up" })

Map("n", "<C-A>", "<cmd> %y+<cr>", { desc = "Copy whole file" })

Map("n", "<leader>s", ":%s/<C-r><C-w>/", { desc = "Find and replace all occurrences of word under cursor" })
