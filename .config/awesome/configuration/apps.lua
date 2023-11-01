local menubar = require("menubar")

apps = {
	terminal = "wezterm",
	editor = os.getenv("EDITOR") or "nvim",
	explorer = "thunar",
	browser = "firefox",
}

apps.editor_cmd = apps.terminal .. " -e " .. apps.editor
apps.explorer_cmd = apps.terminal .. " -e " .. apps.explorer
menubar.utils.terminal = apps.terminal -- Set the terminal for applications that require it

return apps
