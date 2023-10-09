return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
		{
			"nvim-telescope/telescope-live-grep-args.nvim",
			version = "^1.0.0",
		},
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
		telescope.load_extension("macros")
		telescope.load_extension("live_grep_args")
	end,
	keys = {
		{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Fuzzy find files in cwd" },
		{
			"<leader>fo",
			"<cmd>Telescope oldfiles<cr>",
			desc = "Fuzzy find recent files",
		},
		{
			"<leader>fs",
			function()
				require("telescope").extensions.live_grep_args.live_grep_args()
			end,
			desc = "Find string in cwd",
		},
		{ "<leader>fc", "<cmd>Telescope grep_string<cr>", desc = "Find string under cursor in cwd" },
		{ "<leader>fx", "<cmd>Telescope resume<cr>", desc = "Resume last telescope window" },
		{ "<leader>fr", "<cmd>Telescope registers<cr>", desc = "List registers" },
	},
}
