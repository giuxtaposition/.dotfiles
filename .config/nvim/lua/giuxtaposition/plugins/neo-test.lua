return {
	{ "nvim-neotest/neotest-plenary" },
	{ "haydenmeade/neotest-jest" },
	{
		"nvim-neotest/neotest",
		dependencies = {
			"haydenmeade/neotest-jest",
			"nvim-treesitter/nvim-treesitter",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-neotest/neotest-plenary",
		},

		config = function()
			local neotest = require("neotest")

			neotest.setup({
				library = { plugins = { "neotest" }, types = true },
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
			})
		end,
		-- config = function(_, opts)
		-- 	local neotest_ns = vim.api.nvim_create_namespace("neotest")
		-- 	vim.diagnostic.config({
		-- 		virtual_text = {
		-- 			format = function(diagnostic)
		-- 				-- Replace newline and tab characters with space for more compact diagnostics
		-- 				local message =
		-- 					diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
		-- 				return message
		-- 			end,
		-- 		},
		-- 	}, neotest_ns)
		--
		-- 	if opts.adapters then
		-- 		local adapters = {}
		-- 		for name, config in pairs(opts.adapters or {}) do
		-- 			if type(name) == "number" then
		-- 				if type(config) == "string" then
		-- 					config = require(config)
		-- 				end
		-- 				adapters[#adapters + 1] = config
		-- 			elseif config ~= false then
		-- 				local adapter = require(name)
		-- 				if type(config) == "table" and not vim.tbl_isempty(config) then
		-- 					local meta = getmetatable(adapter)
		-- 					if adapter.setup then
		-- 						adapter.setup(config)
		-- 					elseif meta and meta.__call then
		-- 						adapter(config)
		-- 					else
		-- 						error("Adapter " .. name .. " does not support setup")
		-- 					end
		-- 				end
		-- 				adapters[#adapters + 1] = adapter
		-- 			end
		-- 		end
		-- 		opts.adapters = adapters
		-- 	end
		--
		-- 	require("neotest").setup(opts)
		-- end,
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
