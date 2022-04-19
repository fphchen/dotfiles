-- No Tmux installed
package.loaded["awful.hotkeys_popup.keys.tmux"] = {}

-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Show Desktop library
local show_desktop = false
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init("~/.config/awesome/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "alacritty"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.corner.nw,
    awful.layout.suit.corner.ne,
    awful.layout.suit.corner.sw,
    awful.layout.suit.corner.se,
    awful.layout.suit.floating,
    awful.layout.suit.magnifier,
}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal },
				    { "reload", awesome.restart },
				    { "exit to tty", function() awesome.quit() end },
				    { "restart", function() awful.spawn.with_shell("shutdown -r now") end },
				    { "shutdown", function() awful.spawn.with_shell("shutdown now") end }
                                  }
                        })

-- mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
--                                      menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

---- Keyboard map indicator and switcher
--mykeyboardlayout = awful.widget.keyboardlayout()
--
---- {{{ Wibar
---- Create a textclock widget
--mytextclock = wibox.widget.textclock()
--
---- Create a wibox for each screen and add it
--local taglist_buttons = gears.table.join(
--                    awful.button({ }, 1, function(t) t:view_only() end),
--                    awful.button({ modkey }, 1, function(t)
--                                              if client.focus then
--                                                  client.focus:move_to_tag(t)
--                                              end
--                                          end),
--                    awful.button({ }, 3, awful.tag.viewtoggle),
--                    awful.button({ modkey }, 3, function(t)
--                                              if client.focus then
--                                                  client.focus:toggle_tag(t)
--                                              end
--                                          end),
--                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
--                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
--                )
--
--local tasklist_buttons = gears.table.join(
--                     awful.button({ }, 1, function(c)
--                                              if c == client.focus then
--                                                  c.minimized = true
--                                              else
--                                                  c:emit_signal(
--                                                      "request::activate",
--                                                      "tasklist",
--                                                      {raise = true}
--                                                  )
--                                              end
--                                          end),
--                     awful.button({ }, 3, function()
--                                              awful.menu.client_list({ theme = { width = 250 } })
--                                          end),
--                     awful.button({ }, 4, function ()
--                                              awful.client.focus.byidx(1)
--                                          end),
--                     awful.button({ }, 5, function ()
--                                              awful.client.focus.byidx(-1)
--                                          end))

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    -- awful.tag({ "1", "2", "3", "4" "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

    -- Setting default layout for each screen
    local names = { "OVERVIEW", "GENERAL", "CODE", "WEB", "MUSIC", "IM" }
    local l = awful.layout.suit 
    local layouts = {l.fair, l.tile, l.tile, l.tile.fair, l.tile.top, l.tile}
    awful.tag(names, s, layouts)

    -- Top padding for each of the screen
    awful.screen.padding(screen[s], {top=50})

--    -- Create a promptbox for each screen
--    s.mypromptbox = awful.widget.prompt()
--    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
--    -- We need one layoutbox per screen.
--    s.mylayoutbox = awful.widget.layoutbox(s)
--    s.mylayoutbox:buttons(gears.table.join(
--                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
--                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
--                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
--                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
--    -- Create a taglist widget
--    s.mytaglist = awful.widget.taglist {
--        screen  = s,
--        filter  = awful.widget.taglist.filter.all,
--        buttons = taglist_buttons
--    }
--
--    -- Create a tasklist widget
--    s.mytasklist = awful.widget.tasklist {
--        screen  = s,
--        filter  = awful.widget.tasklist.filter.currenttags,
--        buttons = tasklist_buttons
--    }
--
--    -- Create the wibox
--    s.mywibox = awful.wibar({ position = "top", screen = s, height = 40, opacity = 1.0 })
--
--    -- Add widgets to the wibox
--    s.mywibox:setup {
--        layout = wibox.layout.align.horizontal,
--        { -- Left widgets
--            layout = wibox.layout.fixed.horizontal,
--            mylauncher,
--            s.mytaglist,
--            s.mypromptbox,
--        },
--        s.mytasklist, -- Middle widget
--        { -- Right widgets
--            layout = wibox.layout.fixed.horizontal,
--            mykeyboardlayout,
--            wibox.widget.systray(),
--            mytextclock,
--            s.mylayoutbox,
--        },
--    }
end)
---- }}}

---- {{{ Mouse bindings
--root.buttons(gears.table.join(
--    awful.button({ }, 3, function () mymainmenu:toggle() end),
--    awful.button({ }, 4, awful.tag.viewnext),
--    awful.button({ }, 5, awful.tag.viewprev)
--))
---- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
    awful.key({ modkey, "Shift"   }, "`",      hotkeys_popup.show_help,
              {description="keyboard shortcuts", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey, "Shift" }, "w", function () mymainmenu:show() end,
              {description = "main menu", group = "awesome"}),
    
    awful.key({ modkey, "Shift" }, "Print", function () awful.spawn.with_shell("import -window root screenshot.jpg") end,
              {description = "screenshot", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    --awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
    --          {description = "next screen", group = "screen"}),
    --awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
    --          {description = "previous screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "u", awful.client.urgent.jumpto,
              {description = "urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "terminal", group = "launcher"}),
    awful.key({ modkey, "Shift" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),
    awful.key({ "Shift", "Control" }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "decrease master window", group = "layout"}),
    awful.key({ "Shift", "Control" }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "increase master window", group = "layout"}),
    awful.key({ modkey, "Control"  }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase master clients", group = "layout"}),
    awful.key({ modkey, "Control"  }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease master clients", group = "layout"}),
    awful.key({ modkey, "Shift" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase columns", group = "layout"}),
    awful.key({ modkey, "Shift" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "next layout", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "previous layout", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end,
              {description = "restore minimized", group = "client"}),

--    -- Prompt
--    awful.key({ modkey }, "x",
--              function ()
--                  awful.prompt.run {
--                    prompt       = "Run Lua code: ",
--                    textbox      = awful.screen.focused().mypromptbox.widget,
--                    exe_callback = awful.util.eval,
--                    history_path = awful.util.get_cache_dir() .. "/history_eval"
--                  }
--              end,
--              {description = "lua execute prompt", group = "awesome"}),

    -- Toggle Polybar
    awful.key({ modkey, "Control" }, "p", function() awful.spawn.with_shell("polybar-msg cmd toggle") end,
    	      {description = "polybar", group = "client" }),

    -- Unimatrix
    awful.key({ modkey }, "u", function() awful.spawn("alacritty -e unimatrix") end,
    	      {description = "unimatrix", group = "launcher"}),

    -- Cli-Visualizer
    awful.key({ modkey }, "v", function() awful.spawn("alacritty -e vis") end,
    	      {description = "vis", group = "launcher" }),

    -- Htop
    awful.key({ modkey }, "h", function() awful.spawn("alacritty -e htop") end,
    	      {description = "htop", group = "launcher" }),

    -- Rofi
    awful.key({ modkey }, "r", function() awful.util.spawn("rofi -show") end,
    	      {description = "rofi", group = "launcher" }),

    -- Firefox
    awful.key({ modkey }, "f", function() awful.util.spawn("firefox") end,
    	      {description = "firefox", group = "launcher" }),
    
    -- Brave
    awful.key({ modkey }, "b", function() awful.util.spawn("brave") end,
    	      {description = "brave", group = "launcher" }),
    
    -- Spotify
    awful.key({ modkey }, "s", function() awful.util.spawn("spotify") end,
    	      {description = "spotify", group = "launcher" }),

    -- Signal
    awful.key({ modkey }, "d", function() awful.util.spawn("signal-desktop") end,
    	      {description = "signal", group = "launcher" }),
    
    -- Reload Wallpaper & Colour scheme
    awful.key({ modkey, "Control" }, "w", function() awful.spawn.with_shell("~/.script/wallcolour.sh") end,
    	      {description = "wallpaper", group = "client" }),

    -- Desktop
    awful.key({ modkey, "Control" }, "d", 
    	function(c)
	    if show_desktop then
		    for _, c in ipairs(client.get()) do
			c:emit_signal("request::activate", "key.unminimize", {raise = true})
		    end
			show_desktop = false
	    else
		    for _, c in ipairs(client.get()) do
			c.minimized = true
		    end
			show_desktop = true
	    end
	end,
	{description = "desktop", group = "client"})
)

clientkeys = gears.table.join(
    awful.key({ modkey, "Control" }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "fullscreen", group = "client"}),
    --awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
    --          {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey, "Control" }, "c",      function (c) c:kill()                         end,
              {description = "close focused", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 6 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_width = 0,
					 border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          --"Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          --"Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer"},

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = false }
    },

    -- Set Firefox to always map on the tag named "WEB" on screen 1.
    { rule = { class = "[Ff]irefox" },
      properties = { screen = 1, tag = "WEB" } },
    
    -- Set Brave to always map on the tag named "WEB" on screen 1.
    { rule = { class = "[Bb]rave" },
      properties = { screen = 1, tag = "WEB" } },
    
    -- Set Spotify to always map on the tag named "MUSIC" on screen 1.
    { rule = { class = "[Ss]potify" },
      properties = { screen = 1, tag = "MUSIC" } },
    
    -- Set Signal to always map on the tag named "IM" on screen 1.
    { rule = { class = "[Ss]ignal" },
      properties = { screen = 1, tag = "IM" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

client.connect_signal("manage", function (c)
	if c.class == nil then c. minimized = true
		c:connect_signal("property::class", function()
		c.minimized = false
		awful.rules.apply(c)
		end)
	end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

---- Toggle titlebar on or off depending on screen. Creates titlebar if it doesn't exist
--local function setTitlebar(client, s)
--	if s then
--		if client.titlebar == nil then
--			client:emit_signal("request::titlebars", "rules", {})
--		end
--		awful.titlebar.show(client)
--	else
--		awful.titlebar.hide(client)
--	end
--end
--
---- Toggle titlebar on floating status change
--client.connect_signal("property::floating", function(c)
--	setTitlebar(c, c.floating or c.first_tag and c.first_tag.layout.name == "floating")
--end)
--
---- Hook called when a client spawns
--client.connect_signal("manage", function(c)
--	setTitlebar(c, c.floating or c.first_tag.layout == awful.layout.suit.floating)
--end)
--
---- Show titlebars on tags with the floating layout
--tag.connect_signal("property::layout", function(t)
--	-- New to Lua?
--	-- pairs iterates on the table and return a key value pair
--	-- I don't need the key here, so I put _ to ignore it
--	for _, c in pairs(t:clients()) do
--		if t.layout == awful.layout.suit.floating then
--			setTitlebar(c, true)
--		else
--			setTitlebar(c, false)
--		end
--	end
--end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- Gaps
beautiful.useless_gap = 15

-- Notification settings
naughty.config.defaults['icon_size'] = 80
naughty.config.defaults['position'] = 'bottom_left'
naughty.config.presets.low.timeout = 5
naughty.config.presets.normal.timeout = 10

-- Surpress Brave ads notification
naughty.config.presets.brave = { 
	callback = function()
		return false
	end
}
table.insert(naughty.dbus.config.mapping, {{appname = "Brave"}, naughty.config.presets.brave})

-- Surpress Spotify notification
naughty.config.presets.spotify = { 
	callback = function()
		return false
	end
}
table.insert(naughty.dbus.config.mapping, {{appname = "Spotify"}, naughty.config.presets.spotify})

-- Initialize additional services
-- Run single instance programs via autorun.sh script
awful.spawn.with_shell("~/.script/awesome.sh")
awful.spawn.with_shell("~/.script/init.sh")

-- Run startup programs
awful.spawn.with_shell("~/.script/startup.sh")

-- Apply wallpaper & colour scheme settings
awful.spawn.with_shell("~/.script/wallcolour.sh")
