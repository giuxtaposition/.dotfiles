return {
	-- comment lines
	{
		"echasnovski/mini.comment",
		event = "VeryLazy",
		dependencies = { { "JoosepAlviste/nvim-ts-context-commentstring", lazy = true } },
		opts = {
			options = {
				custom_commentstring = function()
					return require("ts_context_commentstring.internal").calculate_commentstring()
						or vim.bo.commentstring
				end,
			},
		},
	},
	-- change surrounding characters
	{
		"echasnovski/mini.surround",
		opts = {
			mappings = {
				add = "gza", -- Add surrounding in Normal and Visual modes
				delete = "gzd", -- Delete surrounding
				find = "gzf", -- Find surrounding (to the right)
				find_left = "gzF", -- Find surrounding (to the left)
				highlight = "gzh", -- Highlight surrounding
				replace = "gzr", -- Replace surrounding
				update_n_lines = "gzn", -- Update `n_lines`
			},
		},
	},
	-- better text-objects
	{
		"echasnovski/mini.ai",
		-- keys = {
		--   { "a", mode = { "x", "o" } },
		--   { "i", mode = { "x", "o" } },
		-- },
		event = "VeryLazy",
		dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },

		opts = function()
			local ai = require("mini.ai")
			return {
				n_lines = 500,
				custom_textobjects = {
					o = ai.gen_spec.treesitter({
						a = { "@block.outer", "@conditional.outer", "@loop.outer" },
						i = { "@block.inner", "@conditional.inner", "@loop.inner" },
					}, {}),
					f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
					c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
					t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
				},
			}
		end,
	},
	-- auto close characters
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {},
	},
	-- refactoring
	{
		"ThePrimeagen/refactoring.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {},
		keys = {
			{ "<leader>ce", ":Refactor extract ", mode = "x", desc = "Extract to function" },
			{ "<leader>cf", ":Refactor extract_to_file ", mode = "x", desc = "Extract to file" },
			{ "<leader>cv", ":Refactor extract_var ", mode = "x", desc = "Extract to variable" },
			{ "<leader>ci", ":Refactor inline_var", mode = { "n", "x" }, desc = "Inline variable" },
			{ "<leader>cb", ":Refactor extract_block", desc = "Extract block to function" },
			{ "<leader>cbf", ":Refactor extract_block_to_file", desc = "Extract block to file" },
		},
	},
}
