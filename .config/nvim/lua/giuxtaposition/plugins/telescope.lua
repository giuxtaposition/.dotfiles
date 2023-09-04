return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")

		telescope.setup({
			defaults = {
				path_display = { "truncate " },
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous, -- move to prev result
						["<C-j>"] = actions.move_selection_next, -- move to next result
						["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
					},
				},
				vimgrep_arguments = {
					"rg",
					"--with-filename",
					"--line-number",
					"--column",
					"--smart-case",
					"--hidden",
				},
			},
			pickers = {
				find_files = {
					hidden = true,
					file_ignore_patterns = { "node_modules", ".git" },
				},
			},
		})

		telescope.load_extension("fzf")
	end,
	keys = {
		{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Fuzzy find files in cwd" },
		{
			"<leader>fo",
			"<cmd>Telescope oldfiles<cr>",
			desc = "Fuzzy find recent files",
		},
		{ "<leader>fs", "<cmd>Telescope live_grep<cr>", desc = "Find string in cwd" },
		{ "<leader>fc", "<cmd>Telescope grep_string<cr>", desc = "Find string under cursor in cwd" },
		{ "<leader>fx", "<cmd>Telescope resume<cr>", desc = "Resume last telescope window" },
		{ "<leader>fr", "<cmd>Telescope registers<cr>", desc = "List registers" },
	},
}
