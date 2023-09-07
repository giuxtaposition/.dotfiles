return {
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"antoinemadec/FixCursorHold.nvim",
			"haydenmeade/neotest-jest",
		},
		opts = function()
			return {
				adapters = {
					require("neotest-jest")({
						jestCommand = "npm test --",
						jestConfigFile = "custom.jest.config.ts",
						env = { CI = true },
						cwd = function()
							return vim.fn.getcwd()
						end,
					}),
				},
			}
		end,
		keys = {
			{ "<leader>tr", "<cmd>lua require('neotest').run.run()<cr>", desc = "Run nearest test" },
			{
				"<leader>tw",
				"<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>",
				desc = "Run tests in current file",
			},
			{ "<leader>tW", "<cmd>lua require('neotest').run.run(vim.loop.cwd())<cr>", desc = "Run all test files" },
			{ "<leader>tl", "<cmd>lua require('neotest').run.run_last()<cr>", desc = "Run last test" },
			{ "<leader>ts", "<cmd>lua require('neotest').summary.toggle()<cr>", desc = "Toggle tests summary" },
			{
				"<leader>tO",
				"<cmd>lua require('neotest').output_panel.toggle()<cr>",
				desc = "Toggle tests output panel",
			},
		},
	},
}
