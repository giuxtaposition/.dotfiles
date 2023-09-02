return {
	{ "nvim-neotest/neotest-plenary" },
	{
		"nvim-neotest/neotest",
		dependencies = {
			"haydenmeade/neotest-jest",
			"nvim-treesitter/nvim-treesitter",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-neotest/neotest-plenary",
		},
		opts = {
			adapters = {
				"neotest-plenary",
				{
					"neotest-jest",
					{
						jestCommand = "npm run test --",
						jestConfigFile = "custom.jest.config.ts",
						env = { CI = true },
						cwd = function(_)
							return vim.fn.getcwd()
						end,
					},
				},
			},
			keys = {
				{ "<leader>tr", "<cmd>lua require('neotest').run.run()<cr>", desc = "Run nearest test" },
				{
					"<leader>tw",
					"<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>",
					desc = "Run tests in current file",
				},
				{ "<leader>tl", "<cmd>lua require('neotest').run.run_last()<cr>", desc = "Run last test" },
				{ "<leader>ts", "<cmd>lua require('neotest').summary.toggle()<cr>", desc = "Toggle tests summary" },
				{
					"<leader>tO",
					"<cmd>lua require('neotest').output_panel.toggle()<cr>",
					desc = "Toggle tests output panel",
				},
			},
		},
	},
}
