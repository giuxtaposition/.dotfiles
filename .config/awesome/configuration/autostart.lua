-- List of apps to start once on start-up
return {
	run_on_start_up = {
		-- "picom --config " .. filesystem.get_configuration_dir() .. "configuration/picom.conf",
		-- 'nm-applet --indicator', -- wifi
		--'blueberry-tray', -- Bluetooth tray icon
		--'xfce4-power-manager', -- Power manager
	},
}
