return {
	-- comment lines
	{
		"numToStr/Comment.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"JoosepAlviste/nvim-ts-context-commentstring",
		},
		config = function()
			local comment = require("Comment")

			local ts_context_commentstring = require("ts_context_commentstring.integrations.comment_nvim")

			comment.setup({
				-- for commenting tsx and jsx files
				pre_hook = ts_context_commentstring.create_pre_hook(),
			})
		end,
	},
	-- change surrounding characters
	{
		"kylechui/nvim-surround",
		event = { "BufReadPre", "BufNewFile" },
		config = true,
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
