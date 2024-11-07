return {
	"echasnovski/mini.indentscope",
	opts = {
		-- symbol = "▏",
		symbol = "│",
		options = { try_as_border = true },
	},
	event = { "BufReadPost", "BufWritePost", "BufNewFile" },
	init = function()
		vim.api.nvim_create_autocmd("FileType", {
			pattern = {
				"help",
				"alpha",
				"dashboard",
				"NvimTree",
				"Trouble",
				"trouble",
				"lazy",
				"mason",
				"notify",
				"toggleterm",
				"lazyterm",
			},
			callback = function()
				vim.b.miniindentscope_disable = true
			end,
		})
	end,
}
