local wezterm = require("wezterm")
local module = {}

function module.apply_to_config(config)
	config.color_scheme = "Catppuccin Mocha"

	config.tab_bar_at_bottom = true
	config.use_fancy_tab_bar = false

	config.colors = {
		tab_bar = {
			background = "#1e1e2e",

			active_tab = {
				bg_color = "#313244",
				fg_color = "#cdd6f4",
			},

			inactive_tab = {
				bg_color = "#1e1e2e",
				fg_color = "#cdd6f4",
			},
			inactive_tab_hover = {
				bg_color = "#313244",
				fg_color = "#cdd6f4",
			},

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

	config.font = wezterm.font("FiraCode Nerd Font")

	config.window_frame = {
		font = wezterm.font("FiraCode Nerd Font"),
	}

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
		local basename = function(s)
			-- Nothing:wezterm little regex can't fix
			return string.gsub(s, "(.*[/\\])(.*)", "%2")
		end
		local cwd = basename(pane:get_current_working_dir())
		-- Current command
		local cmd = basename(pane:get_foreground_process_name())

		-- Time
		local time = wezterm.strftime("%H:%M")

		-- Let's add color to one of the components
		window:set_right_status(wezterm.format({
			-- Wezterm has a built-in nerd fonts
			-- https://wezfurlong.org/wezterm/config/lua/wezterm/nerdfonts.html
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
end

return module
