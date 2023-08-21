local menubar = require("menubar")

apps = {

	-- Your default terminal
	terminal = "wezterm",

	-- Your default text editor
	editor = os.getenv("EDITOR") or "vim",

	-- editor_cmd = terminal .. " -e " .. editor,

	explorer = "pcmanfm",
	browser = "firefox",
}

apps.editor_cmd = apps.terminal .. " -e " .. apps.editor
apps.explorer_cmd = apps.terminal .. " -e " .. apps.explorer
menubar.utils.terminal = apps.terminal -- Set the terminal for applications that require it

return apps
