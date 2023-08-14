local status, neotest = pcall(require, "neotest")
if not status then
	return
end

neotest.setup({
	adapters = {
		require("neotest-plenary"),
		require("neotest-jest")({
			jestCommand = "npm run test --",
			jestConfigFile = "custom.jest.config.ts",
			env = { CI = true },
			cwd = function(_)
				return vim.fn.getcwd()
			end,
		}),
	},
})

vim.api.nvim_set_keymap("n", "<leader>tr", "<cmd>lua require('neotest').run.run()<cr>", {}) -- Run nearest test
vim.api.nvim_set_keymap("n", "<leader>tw", "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>", {}) -- Run current file
vim.api.nvim_set_keymap("n", "<leader>tl", "<cmd>lua require('neotest').run.run_last()<cr>", {}) -- Run last test
vim.api.nvim_set_keymap("n", "<leader>ts", "<cmd>lua require('neotest').summary.toggle()<cr>", {}) -- Test Summary
vim.api.nvim_set_keymap("n", "<leader>tO", "<cmd>lua require('neotest').output_panel.toggle()<cr>", {}) -- Toggle Output panel
