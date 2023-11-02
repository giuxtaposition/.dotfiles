local lgi = require("lgi")
local Gtk = lgi.require("Gtk", "3.0")
local gobject = require("gears.object")
local gtable = require("gears.table")
local setmetatable = setmetatable

local icon_theme = { mt = {} }

function icon_theme:get_icon_path(icon_name)
	local icon_info = self.gtk_theme:lookup_icon(icon_name, self.icon_size, 0)
	print("icon_info", icon_info)
	if icon_info then
		local icon_path = icon_info:get_filename()
		if icon_path then
			return icon_path
		end
	end

	return ""
end

local function new(theme_name, icon_size)
	local ret = gobject({})
	gtable.crush(ret, icon_theme, true)

	ret.name = theme_name or nil
	ret.icon_size = icon_size or 48

	if theme_name then
		ret.gtk_theme = Gtk.IconTheme.new()
		Gtk.IconTheme.set_custom_theme(ret.gtk_theme, theme_name)
	else
		ret.gtk_theme = Gtk.IconTheme.get_default()
	end

	return ret
end

function icon_theme.mt:__call(...)
	return new(...)
end

return setmetatable(icon_theme, icon_theme.mt)
