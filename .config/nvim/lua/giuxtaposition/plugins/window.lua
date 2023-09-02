return {
	-- smart splits with wezterm support
	{
		"mrjones2014/smart-splits.nvim",
		lazy = false,
		keys = {
			{ "<C-h>", "<cmd>SmartCursorMoveLeft<cr>", desc = "Move cursor to the left split window" },
			{ "<C-k>", "<cmd>SmartCursorMoveUp<cr>", desc = "Move cursor to the top split window" },
			{ "<C-j>", "<cmd>SmartCursorMoveDown<cr>", desc = "Move cursor to the left split window" },
			{ "<C-l>", "<cmd>SmartCursorMoveRight<cr>", desc = "Move cursor to the left split window" },
			{ "<A-h>", "<cmd>SmartResizeLeft<cr>", desc = "Resize split window left" },
			{ "<A-k>", "<cmd>SmartResizeUp<cr>", desc = "Resize split window top" },
			{ "<A-j>", "<cmd>SmartResizeDown<cr>", desc = "Resize split window bottom" },
			{ "<A-l>", "<cmd>SmartResizeRight<cr>", desc = "Resize split window right" },
		},
	},
	-- maximizes and restores current split
	{
		"anuvyklack/windows.nvim",
		dependencies = { "anuvyklack/middleclass" },
		opts = { autowidth = { enable = false } },
		keys = {
			{ "<leader>sm", "<cmd>WindowsMaximize<CR>", desc = "Toggle maximize window" },
		},
	},
}
