local awful = require("awful")
local gears = require("gears")
local hotkeys_popup = require("awful.hotkeys_popup")
local myhotkeys_menu = hotkeys_popup.widget.new({ width = 1000, height = 1000, border_width = 0 })
---- Enable hotkeys help widget for VIM and other apps
---- when client with a matching name is opened:
--require("awful.hotkeys_popup.keys")

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- -- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- {{{ Key bindings
globalkeys = gears.table.join(
-- Key bindings for AwesomeWM
    awful.key({ modkey, "Control" }, "c",
        function () 
            local c = client.focus
            if c then
                c:kill()
            end
        end,
        {description = "close focused", group = "client"}),

    awful.key({ modkey, "Shift" }, "Return", 
        function ()
            local c = client.focus
            if c then
                c:swap(awful.client.getmaster())
            end
        end,
        {description = "move to master", group = "client"}),

    awful.key({ modkey, "Mod1" }, "u", 
        awful.client.urgent.jumpto,   
        {description = "urgent", group = "client"}),
 
    awful.key({ "Mod1" }, "Tab",
        function ()
            local c = awful.client.focus.history.previous()
            if c  then
                c:raise()
            end
        end,
        {description = "go back", group = "client"}),

    awful.key({ }, "F11",
        function ()
            local c = client.focus
            if c then
                c.fullscreen = not c.fullscreen
                c:raise()
            end
        end,
        {description = "fullscreen", group = "client"}),

    --awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     
    --    {description = "toggle floating", group = "client"}),
    
-- Key bindings for Launcher
    -- Terminal
    awful.key({ modkey }, "t", 
        function () 
            awful.spawn(terminal) end,
        {description = "terminal", group = "launcher"}),
    
    -- Rofi
    awful.key({ modkey }, "q", 
        function() 
            awful.util.spawn("rofi -show") end,
    	{description = "rofi", group = "launcher" }),

    -- Brave
    awful.key({ modkey }, "b", 
        function() 
            awful.util.spawn("brave") end,
    	{description = "brave", group = "launcher" }),

    -- Htop
    awful.key({ modkey }, "h", 
        function() 
            awful.spawn("kitty -e htop") end,
    	{description = "htop", group = "launcher" }),

-- ****************************************************************************** 

    awful.key({ modkey, "Shift" }, "`",
        function () 
            myhotkeys_menu:show_help()
        end,
        {description="keyboard shortcuts", group="awesome"}),
    awful.key({ modkey, "Shift" }, "m", 
        function () 
            mymainmenu:show() 
        end,
        {description = "main menu", group = "awesome"}),
    awful.key({ modkey, "Shift" }, "Print", 
        function () 
            awful.spawn.with_shell("import -window root screenshot.jpg") 
        end,
        {description = "screenshot", group = "awesome"}),
    awful.key({ modkey, "Shift" }, "r", awesome.restart,
        {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
        {description = "quit awesome", group = "awesome"}),
    -- Toggle Polybar
    awful.key({ modkey, "Shift" }, "p", 
        function () 
            awful.spawn.with_shell("polybar-msg cmd toggle") 
        end,
        {description = "(un)hide polybar", group = "awesome" }),
    -- Reload Wallpaper & Colour scheme
    awful.key({ modkey, "Shift" }, "w", 
        function () 
            awful.spawn.with_shell("~/.script/wallcolour.sh") 
        end,
        {description = "refresh wallpaper", group = "awesome" }),
    -- Desktop
    awful.key({ modkey, "Shift" }, "d", 
    	function ()
            local c = client.focus
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
	{description = "desktop", group = "awesome"}),

-- Key bindings for Client
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
    
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    
    awful.key({ modkey, "Control" }, "j",
        function ()
            local c = awful.client.focus.history.list[2]
            client.focus = c
            local t = client.focus and client.focus.first_tag or nil
            if t then
                t:view_only()
            end
            c:raise()
        end,
        {description = "previous", group = "client"}),

    awful.key({ modkey, "Shift" }, "n",
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

    awful.key({ modkey,           }, "o", 
        function () 
            local c = client.focus
            c:move_to_screen()
        end,
        {description = "move to screen", group = "client"}),
    
    awful.key({ modkey,           }, "",
        function ()
            local c = client.focus
            c.ontop = not c.ontop
        end,
        {description = "toggle keep on top", group = "client"}),
    
    awful.key({ modkey, "Control" }, "n",
        function ()
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            local c = client.focus
            c.minimized = true
        end,
        {description = "minimize", group = "client"}),

    awful.key({ modkey, "Control" }, "m",
        function ()
            local c = client.focus
            c.maximized = not c.maximized
            c:raise()
        end,
        {description = "(un)maximize", group = "client"}),
    
    awful.key({ modkey, "Control" }, "v",
        function ()
            local c = client.focus
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end,
        {description = "(un)maximize vertically", group = "client"}),
    
    awful.key({ modkey, "Control"   }, "b",
        function ()
            local c = client.focus
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end,
        {description = "(un)maximize horizontally", group = "client"}),

-- Key bindings for Tags
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

-- Key bindings for Layout
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













-- Unused key bindings
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
--    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
--              {description = "next screen", group = "screen"}),
--    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
--              {description = "previous screen", group = "screen"}),
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 5 do
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

-- Set keys
root.keys(globalkeys)
-- }}}

