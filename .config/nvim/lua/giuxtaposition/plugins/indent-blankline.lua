local status, indent_blankline = pcall(require, "indent_blankline")
if not status then
	return
end

vim.cmd([[highlight IndentBlanklineIndent1 guifg=#f7768e gui=nocombine]])
vim.cmd([[highlight IndentBlanklineIndent2 guifg=#e0af68 gui=nocombine]])
vim.cmd([[highlight IndentBlanklineIndent3 guifg=#9ece6a gui=nocombine]])
vim.cmd([[highlight IndentBlanklineIndent4 guifg=#7aa2f7 gui=nocombine]])
vim.cmd([[highlight IndentBlanklineIndent5 guifg=#bb9af7 gui=nocombine]])
vim.cmd([[highlight IndentBlanklineIndent6 guifg=#7dcfff gui=nocombine]])

indent_blankline.setup({
	filetype_exclude = {},
	show_current_context = true,
	show_current_context_start = true,
	char_highlight_list = {
		"IndentBlanklineIndent1",
		"IndentBlanklineIndent2",
		"IndentBlanklineIndent3",
		"IndentBlanklineIndent4",
		"IndentBlanklineIndent5",
		"IndentBlanklineIndent6",
	},
})
