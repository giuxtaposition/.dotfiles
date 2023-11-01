local awful = require("awful")
local gears = require("gears")
local hotkeys_popup = require("awful.hotkeys_popup").widget

local apps = require("configuration.apps")


local modKey = "Mod4"
local alt = "Mod1"
local ctrl = "Control"
local shift = "Shift"

-- Mouse Keybindings
awful.mouse.append_global_mousebindings({
	awful.button({}, 4, awful.tag.viewnext), -- scroll up = show next tag
	awful.button({}, 5, awful.tag.viewprev), -- scroll down = show prev tag
})

-- Launchers
awful.keyboard.append_global_keybindings({
	-- Open terminal
	awful.key({ modKey }, "Return", function()
		awful.spawn(apps.terminal)
	end, { description = "open a terminal", group = "launcher" }),

	-- Apps launcher
	awful.key({ modKey }, "d", function()
		awful.spawn.with_shell("sh $HOME/.config/rofi/bin/launcher")
	end, { description = "rofi launcher", group = "launcher" }),

	-- Run prompt
	awful.key({ modKey }, "r", function()
		awful.spawn.with_shell("sh $HOME/.config/rofi/bin/runner")
	end, { description = "rofi prompt", group = "launcher" }),

	-- Powermenu
	awful.key({ modKey }, "p", function()
		awful.spawn.with_shell("sh $HOME/.config/rofi/bin/powermenu")
	end, { description = "rofi power menu", group = "launcher" }),
})

-- Awesome
awful.keyboard.append_global_keybindings({
	awful.key({ modKey, shift }, "s", hotkeys_popup.show_help, { description = "show help", group = "awesome" }),
	awful.key({ modKey, ctrl }, "r", awesome.restart, { description = "reload awesome", group = "awesome" }),
	awful.key({ modKey, shift }, "e", awesome.quit, { description = "quit awesome", group = "awesome" }),
	awful.key({ modKey }, "x", function()
		awful.prompt.run({
			prompt = "Run Lua code: ",
			textbox = awful.screen.focused().mypromptbox.widget,
			exe_callback = awful.util.eval,
			history_path = awful.util.get_cache_dir() .. "/history_eval",
		})
	end, { description = "lua execute prompt", group = "awesome" }),
})

-- Tags related keybindings
awful.keyboard.append_global_keybindings({
	awful.key({ modKey }, "Left", awful.tag.viewprev, { description = "view previous", group = "tag" }),
	awful.key({ modKey }, "Right", awful.tag.viewnext, { description = "view next", group = "tag" }),

	awful.key({ modKey, shift }, "Left", function()
		-- get current tag
		local t = client.focus and client.focus.first_tag or nil
		if t == nil then
			return
		end
		-- get previous tag (modulo 9 excluding 0 to wrap from 1 to 9)
		local tag = client.focus.screen.tags[(t.index - 2) % 9 + 1]
		awful.client.movetotag(tag)
		awful.tag.viewprev()
	end, { description = "move client to previous tag and switch to it", group = "tag" }),

	awful.key({ modKey, shift }, "Right", function()
		-- get current tag
		local t = client.focus and client.focus.first_tag or nil
		if t == nil then
			return
		end
		-- get next tag (modulo 9 excluding 0 to wrap from 9 to 1)
		local tag = client.focus.screen.tags[(t.index % 9) + 1]
		awful.client.movetotag(tag)
		awful.tag.viewnext()
	end, { description = "move client to next tag and switch to it", group = "tag" }),

	awful.key({ modKey }, "Escape", awful.tag.history.restore, { description = "go back", group = "tag" }),
})

-- Focus related keybindings
awful.keyboard.append_global_keybindings({
	awful.key({ modKey }, "j", function()
		awful.client.focus.byidx(1)
	end, { description = "focus next by index", group = "client" }),

	awful.key({ modKey }, "k", function()
		awful.client.focus.byidx(-1)
	end, { description = "focus previous by index", group = "client" }),

	awful.key({ modKey, shift }, "j", function()
		awful.screen.focus_relative(1)
	end, { description = "focus the next screen", group = "screen" }),

	awful.key({ modKey, shift }, "k", function()
		awful.screen.focus_relative(-1)
	end, { description = "focus the previous screen", group = "screen" }),

	awful.key({ modKey }, "u", awful.client.urgent.jumpto, { description = "jump to urgent client", group = "client" }),

	awful.key({ modKey }, "Tab", function()
		awful.client.focus.history.previous()
		if client.focus then
			client.focus:raise()
		end
	end, { description = "go back", group = "client" }),
	awful.key({ modKey, shift }, "n", function()
		local c = awful.client.restore()
		-- Focus restored client
		if c then
			c:emit_signal("request::activate", "key.unminimize", { raise = true })
		end
	end, { description = "restore minimized", group = "client" }),
})

-- Layout related keybindings
awful.keyboard.append_global_keybindings({
	awful.key({ modKey, shift }, "j", function()
		awful.client.swap.byidx(1)
	end, { description = "swap with next client by index", group = "client" }),

	awful.key({ modKey, shift }, "k", function()
		awful.client.swap.byidx(-1)
	end, { description = "swap with previous client by index", group = "client" }),

	awful.key({ modKey }, "l", function()
		awful.tag.incmwfact(0.05)
	end, { description = "increase master width factor", group = "layout" }),

	awful.key({ modKey }, "h", function()
		awful.tag.incmwfact(-0.05)
	end, { description = "decrease master width factor", group = "layout" }),

	awful.key({ modKey, shift }, "h", function()
		awful.tag.incnmaster(1, nil, true)
	end, { description = "increase the number of master clients", group = "layout" }),

	awful.key({ modKey, shift }, "l", function()
		awful.tag.incnmaster(-1, nil, true)
	end, { description = "decrease the number of master clients", group = "layout" }),

	awful.key({ modKey, shift }, "h", function()
		awful.tag.incncol(1, nil, true)
	end, { description = "increase the number of columns", group = "layout" }),

	awful.key({ modKey, shift }, "l", function()
		awful.tag.incncol(-1, nil, true)
	end, { description = "decrease the number of columns", group = "layout" }),

	awful.key({ modKey }, "space", function()
		awful.layout.inc(1)
	end, { description = "select next", group = "layout" }),

	awful.key({ modKey, shift }, "space", function()
		awful.layout.inc(-1)
	end, { description = "select previous", group = "layout" }),
})

-- Tag related keybindings
-- TODO:
awful.keyboard.append_global_keybindings({
    awful.key {
        modifiers   = { modKey },
        keygroup    = "numrow",
        description = "only view tag",
        group       = "tag",
        on_press    = function (index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then
                tag:view_only()
            end
        end,
    },

    awful.key {
        modifiers   = { modKey, ctrl },
        keygroup    = "numrow",
        description = "toggle tag",
        group       = "tag",
        on_press    = function (index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then
                awful.tag.viewtoggle(tag)
            end
        end,
    },

    awful.key {
        modifiers = { modKey, shift },
        keygroup    = "numrow",
        description = "move focused client to tag",
        group       = "tag",
        on_press    = function (index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then
                    client.focus:move_to_tag(tag)
                end
            end
        end,
    },

    awful.key {
        modifiers   = { modKey, ctrl, shift },
        keygroup    = "numrow",
        description = "toggle focused client on tag",
        group       = "tag",
        on_press    = function (index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then
                    client.focus:toggle_tag(tag)
                end
            end
        end,
    },

    awful.key {
        modifiers   = { modKey },
        keygroup    = "numpad",
        description = "select layout directly",
        group       = "layout",
        on_press    = function (index)
            local t = awful.screen.focused().selected_tag
            if t then
                t.layout = t.layouts[index] or t.layout
            end
        end,
    }
})


-- mouse mgmt
local clientButtons = gears.table.join(
        awful.button({ }, 1, function (c)
            c:activate { context = "mouse_click" }
        end),

        awful.button({ modKey }, 1, function (c)
            c:activate { context = "mouse_click", action = "mouse_move"  }
        end),

        awful.button({ modKey }, 3, function (c)
            c:activate { context = "mouse_click", action = "mouse_resize"}
        end)
)

-- client mgmt
local clientKeys = gears.table.join(
    awful.keyboard.append_client_keybindings({
        awful.key({ modKey,           }, "f",
            function (c)
                c.fullscreen = not c.fullscreen
                c:raise()
            end,
        {description = "toggle fullscreen", group = "client"}),


        awful.key({ modKey }, "q",      function (c) c:kill() end,
                {description = "close", group = "client"}),

        awful.key({ modKey }, "x",  awful.client.floating.toggle,
                {description = "toggle floating", group = "client"}),


        awful.key({ modKey, ctrl }, "Return", function (c) c:swap(awful.client.getmaster()) end,
                {description = "move to master", group = "client"}),


        awful.key({ modKey,           }, "o",      function (c) c:move_to_screen()               end,
                {description = "move to screen", group = "client"}),


        awful.key({ modKey,           }, "t",      function (c) c.ontop = not c.ontop            end,
                {description = "toggle keep on top", group = "client"}),


        awful.key({ modKey,           }, "n",
            function (c)
                c.minimized = true
            end ,
        {description = "minimize", group = "client"}),


        awful.key({ modKey,           }, "z",
            function (c)
                c.maximized = not c.maximized
                c:raise()
            end ,
        {description = "(un)maximize", group = "client"}),

    })
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
-- for i = 1, 9 do
-- 	-- Hack to only show tags 1 and 9 in the shortcut window (mod+s)
-- 	local descr_view, descr_toggle, descr_move, descr_toggle_focus
-- 	if i == 1 or i == 9 then
-- 		descr_view = { description = "view tag #", group = "tag" }
-- 		descr_toggle = { description = "toggle tag #", group = "tag" }
-- 		descr_move = { description = "move focused client to tag #", group = "tag" }
-- 		descr_toggle_focus = { description = "toggle focused client on tag #", group = "tag" }
-- 	end
-- 	keymaps = awful.util.table.join(
-- 		keymaps,
-- 		-- View tag only.
-- 		awful.key({ modKey }, "#" .. i + 9, function()
-- 			local screen = awful.screen.focused()
-- 			local tag = screen.tags[i]
-- 			if tag then
-- 				tag:view_only()
-- 			end
-- 		end, descr_view),
-- 		-- Toggle tag display.
-- 		awful.key({ modKey, shift }, "#" .. i + 9, function()
-- 			local screen = awful.screen.focused()
-- 			local tag = screen.tags[i]
-- 			if tag then
-- 				awful.tag.viewtoggle(tag)
-- 			end
-- 		end, descr_toggle),
-- 		-- Move client to tag.
-- 		awful.key({ modKey, shift }, "#" .. i + 9, function()
-- 			if _G.client.focus then
-- 				local tag = _G.client.focus.screen.tags[i]
-- 				if tag then
-- 					_G.client.focus:move_to_tag(tag)
-- 				end
-- 			end
-- 		end, descr_move),
-- 		-- Toggle tag on focused client.
-- 		awful.key({ modKey, ctrl, shift }, "#" .. i + 9, function()
-- 			if _G.client.focus then
-- 				local tag = _G.client.focus.screen.tags[i]
-- 				if tag then
-- 					_G.client.focus:toggle_tag(tag)
-- 				end
-- 			end
-- 		end, descr_toggle_focus)
-- 	)
-- end
--

return {
  modKey,
  clientButtons,
  clientKeys
}
