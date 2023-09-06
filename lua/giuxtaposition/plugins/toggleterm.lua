return {
	"akinsho/toggleterm.nvim",
	version = "*",
	opts = {
		size = 15,
		open_mapping = [[<c-\>]],
		hide_numbers = false,
		autochdir = true, -- auto change dir following neovim
		insert_mapping = true, -- open terminal mapping works also in insert mode
	},
	keys = {
		{ "<leader>tth", "<cmd>ToggleTerm size=15 direction=horizontal<cr>", desc = "Horizontal Terminal" },
		{ "<leader>ttv", "<cmd>ToggleTerm size=80 direction=vertical<cr>", desc = "Vertical Terminal" },
	},
}
