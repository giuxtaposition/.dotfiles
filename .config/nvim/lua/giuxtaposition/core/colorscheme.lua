local status, catppuccin = pcall(require, "catppuccin")
if not status then
	print("Colorscheme not found!")
	return
end

catppuccin.setup({
	flavour = "mocha", -- latte, frappe, macchiato, mocha
	integrations = {
		telescope = true,
		nvimtree = true,
		cmp = true,
		indent_blankline = { enabled = true, colored_indent_levels = false },
		mason = true,
		treesitter = true,
		lsp_saga = true,
	},
})

-- setup must be called before loading
vim.cmd.colorscheme("catppuccin")
