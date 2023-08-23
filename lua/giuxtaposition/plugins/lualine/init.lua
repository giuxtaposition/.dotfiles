local status, lualine = pcall(require, "lualine")
if not status then
	return
end

local filename_with_icon = require("lualine.components.filename"):extend()
filename_with_icon.apply_icon = require("lualine.components.filetype").apply_icon

lualine.setup({
	options = {
		theme = "catppuccin",
		section_separators = {
			right = "",
			left = " ",
		},
		component_separators = "",
	},
	extensions = { "nvim-tree" },
	sections = {
		lualine_a = {
			{
				"mode",
				icons_enabled = true,
				icon = "",
			},
		},
		lualine_b = { { "", draw_empty = true, padding = 0 } },
		lualine_c = {
			{
				filename_with_icon,
				color = { fg = "#cdd6f4", bg = "#313244" },
				separator = { right = "" },
				padding = { left = 0, right = 1 },
			},
			{ "branch", separator = nil, padding = { left = 1, right = 0 } },
			{
				"diff",
				colored = false,
				symbols = { added = "  ", modified = "  ", removed = "  " },
				padding = { left = 0 },
			},
		},
		lualine_x = {
			{ "diagnostics", symbols = { error = " ", warn = "  ", info = "󰋼 ", hint = "󰛩 " } },
			{ require("giuxtaposition.plugins.lualine.lsp_status"), color = { fg = "#b4befe" } },
		},
		lualine_y = {
			{
				function()
					return [[󰉋 ]]
				end,
				color = { fg = "#1e1e2e", bg = "#eba0ac" },
				padding = 0,
			},
			{ require("giuxtaposition.plugins.lualine.cwd"), color = { fg = "#cdd6f4", bg = "#313244" } },
		},
		lualine_z = {
			{
				function()
					return [[ ]]
				end,
				padding = 0,
			},
			{ "progress", color = { fg = "#cdd6f4", bg = "#313244" } },
		},
	},
})
