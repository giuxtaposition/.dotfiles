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
	config = function(_, opts)
		require("toggleterm").setup(opts)
		local Terminal = require("toggleterm.terminal").Terminal
		local lazygit = Terminal:new({
			cmd = "lazygit",
			hidden = true,
			direction = "float",
			float_opts = {
				border = "double",
			},
			-- function to run on opening the terminal
			on_open = function(term)
				vim.cmd("startinsert!")
				vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
			end,
		})

		function _lazygit_toggle()
			lazygit:toggle()
		end
	end,
	keys = {
		{ "<leader>tth", "<cmd>ToggleTerm size=15 direction=horizontal<cr>", desc = "Horizontal Terminal" },
		{ "<leader>ttv", "<cmd>ToggleTerm size=80 direction=vertical<cr>", desc = "Vertical Terminal" },
		{ "<leader>g", "<cmd>lua _lazygit_toggle()<CR>", desc = "Lazygit Terminal" },
	},
}
