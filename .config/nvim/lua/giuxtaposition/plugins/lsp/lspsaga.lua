local saga_status, saga = pcall(require, "lspsaga")
if not saga_status then
	return
end

saga.setup({
	-- keybinds for navigation in lspsaga window
	scroll_preview = { scroll_down = "<C-f>", scroll_up = "<C-b>" },
	-- use enter to open file with definition preview
	definition = {
		keys = {
			edit = "<CR>",
			vsplit = "v",
			split = "h",
		},
	},
	finder = {
		keys = {
			edit = "<CR>",
			toggle_or_open = "<TAB>",
			vsplit = "v",
			split = "h",
		},
	},
	rename = {
		keys = {
			quit = "q",
		},
		in_select = false,
	},
	ui = {
		kind = require("catppuccin.groups.integrations.lsp_saga").custom_kind(),
		devicon = true,
		expand = "󰁌",
		collapse = "󰡍",
	},
})
