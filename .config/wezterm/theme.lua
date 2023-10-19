local wezterm = require("wezterm")
local icons = require("icons")

local module = {}

function module.apply_to_config(config)
	config.color_scheme = "Catppuccin Mocha"

	config.tab_bar_at_bottom = true
	config.use_fancy_tab_bar = false

	config.colors = {
		tab_bar = {
			background = "#1e1e2e",

			-- The new tab button that let you create new tabs
			new_tab = {
				bg_color = "#1e1e2e",
				fg_color = "#cdd6f4",
			},
			new_tab_hover = {
				-- The color of the background area for the tab
				bg_color = "#313244",
				-- The color of the text for the tab
				fg_color = "#cdd6f4",
			},
		},
	}

	config.font = wezterm.font_with_fallback({
		"JetBrains Mono Nerd Font",
		"Symbols Nerd Font Mono",
		"Noto Serif CJK KR",
	})

	config.window_frame = {
		font = wezterm.font("JetBrains Mono Nerd Font"),
	}
	local basename = function(s)
		return string.gsub(s, "(.*[/\\])(.*)", "%2")
	end

	wezterm.on("update-right-status", function(window, pane)
		-- Workspace name
		local stat = window:active_workspace()
		-- It's a little silly to have workspace name all the time
		-- Utilize this to display LDR or current key table name
		if window:active_key_table() then
			stat = window:active_key_table()
		end
		if window:leader_is_active() then
			stat = "LDR"
		end

		-- Current working directory
		local cwd = basename(pane:get_current_working_dir())
		-- Current command
		local cmd = basename(pane:get_foreground_process_name())
		-- Time
		local time = wezterm.strftime("%H:%M")

		-- Let's add color to one of the components
		window:set_right_status(wezterm.format({
			{ Text = wezterm.nerdfonts.oct_table .. "  " .. stat },
			{ Text = " | " },
			{ Text = wezterm.nerdfonts.md_folder .. "  " .. cwd },
			{ Text = " | " },
			{ Foreground = { Color = "#b4befe" } },
			{ Text = wezterm.nerdfonts.fa_code .. "  " .. cmd },
			"ResetAttributes",
			{ Text = " | " },
			{ Text = wezterm.nerdfonts.md_clock .. "  " .. time },
			{ Text = " |" },
		}))
	end)

	local function get_process(tab)
		local process_name = basename(tab.active_pane.foreground_process_name)
		return wezterm.format(icons.process_icons[process_name] or { { Text = string.format("[%s]", process_name) } })
	end

	local function tab_title(tab)
		local current_dir = basename(tab.active_pane.current_working_dir)

		return string.format(" %s %s  ", get_process(tab), current_dir)
	end

	wezterm.on("format-tab-title", function(tab, tabs, panes, _config, hover, max_width)
		local edge_background = "#181825"
		local background = "#1e1e2e"
		local foreground = "#cdd6f4"

		if tab.is_active then
			background = "#313244"
			foreground = "#b4befe"
		elseif hover then
			background = "#313244"
			foreground = "#cdd6f4"
		end

		local edge_foreground = background

		local title = tab_title(tab)

		-- ensure that the titles fit in the available space,
		-- and that we have room for the edges.
		title = wezterm.truncate_right(title, max_width - 2)

		return {
			{ Background = { Color = edge_background } },
			{ Foreground = { Color = edge_foreground } },
			{ Text = icons.LEFT_TAB_EDGE },
			{ Background = { Color = background } },
			{ Foreground = { Color = foreground } },
			{ Text = title },
			{ Background = { Color = edge_background } },
			{ Foreground = { Color = edge_foreground } },
			{ Text = icons.RIGHT_TAB_EDGE },
		}
	end)
end

return module
