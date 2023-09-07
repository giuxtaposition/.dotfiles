return {
	"nvim-lua/plenary.nvim", -- lua functions that many plugins use
	-- handle TODOs in projects
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
	},
}
