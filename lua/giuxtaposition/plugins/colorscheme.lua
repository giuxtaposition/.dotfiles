return {
	"catppuccin/nvim",
	name = "catppuccin",
	lazy = false,
	priority = 1000,

	config = function()
		local catppuccin = require("catppuccin")
		catppuccin.setup({
			flavour = "mocha", -- latte, frappe, macchiato, mocha
			integrations = {
				telescope = {
					enabled = true,
				},
				nvimtree = true,
				cmp = true,
				indent_blankline = { enabled = true, colored_indent_levels = false },
				mason = true,
				treesitter = true,
				lsp_saga = true,
				neogit = true,
				noice = true,
				native_lsp = {
					enabled = true,
					virtual_text = {
						errors = { "italic" },
						hints = { "italic" },
						warnings = { "italic" },
						information = { "italic" },
					},
					underlines = {
						errors = { "underline" },
						hints = { "underline" },
						warnings = { "underline" },
						information = { "underline" },
					},
					inlay_hints = {
						background = true,
					},
				},
				gitsigns = true,
				neotest = true,
				markdown = true,
				rainbow_delimiters = true,
				which_key = true,
			},
		})
		-- setup must be called before loading
		vim.cmd.colorscheme("catppuccin")
	end,
}
