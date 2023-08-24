local status, bufferline = pcall(require, "bufferline")
if not status then
	return
end

bufferline.setup({
	options = {
		mode = "tabs",
		separator_style = "thin",
		always_show_bufferline = false,
		show_buffer_close_icons = true,
		show_close_icon = true,
		color_icons = true,
		indicator = {
			style = "none",
		},
		show_tab_indicators = true,
	},
	highlights = require("catppuccin.groups.integrations.bufferline").get(),
})
