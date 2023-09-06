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
    awful.key({ modkey, "Control", "Shift" }, "h",
        function () 
            myhotkeys_menu:show_help()
        end,
        {description="Shortcuts", group="AwesomeWM"}),

    awful.key({ modkey, "Control", "Shift" }, "m", 
        function () 
            mymainmenu:show() 
        end,
        {description = "Menu", group = "AwesomeWM"}),

    awful.key({ modkey, "Control", "Shift" }, "a", 
        awesome.restart,
        {description = "Reload", group = "AwesomeWM"}),
    
    awful.key({ modkey, "Control", "Shift" }, "q",
        awesome.quit,
        {description = "Quit", group = "AwesomeWM"}),

    awful.key({ modkey, "Control", "Shift" }, "r",
        function ()
            awful.spawn.with_shell("shutdown -r now")
        end,
        {description = "Reboot", group = "AwesomeWM"}),

    awful.key({ modkey, "Control", "Shift" }, "p",
        function ()
            awful.spawn.with_shell("shutdown now")
        end,
        {description = "Poweroff", group = "AwesomeWM"}),

    -- Reload Wallpaper & Colour scheme
    awful.key({ modkey, "Control", "Shift" }, "w", 
        function () 
            awful.spawn.with_shell("~/.script/wallcolour.sh") 
        end,
        {description = "Wallpaper", group = "AwesomeWM" }),

    awful.key({}, "Print", 
        function () 
            awful.spawn.with_shell("import -window root screenshot.jpg") 
        end,
        {description = "Screenshot", group = "AwesomeWM"}),

    -- Toggle Polybar
    awful.key({ modkey, "Control", "Shift" }, "p", 
        function () 
            awful.spawn.with_shell("polybar-msg cmd toggle") 
        end,
        {description = "Polybar Toggle", group = "AwesomeWM" }),

    -- Key bindings for Window Management
    awful.key({ modkey, "Control" }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "Focus Next", group = "Windows"}),
   
    awful.key({ modkey, "Control" }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "Focus Previous", group = "Windows"}),
    
    awful.key({ modkey, "Shift" }, "j",
        function ()
            awful.client.swap.byidx(1)
        end,
        {description = "Move Next", group = "Windows"}),
  
    awful.key({ modkey, "Shift" }, "k", 
        function () 
            awful.client.swap.byidx(-1)
        end,
        {description = "Move Previous", group = "Windows"}),
  
    awful.key({modkey, "Shift" }, "Up",
        function () 
            awful.tag.incmwfact(0.05)
        end,
        {description = "Decrease Master", group = "Windows"}),
    
    awful.key({modkey, "Shift" }, "Down",
        function () 
            awful.tag.incmwfact(-0.05)
        end,
        {description = "Increase Master", group = "Windows"}),

    awful.key({ modkey, "Control" }, "c",
        function () 
            if client.focus then
                client.focus:kill()
            end
        end,
        {description = "Close Focused", group = "Windows"}),

    awful.key({ modkey, "Shift" }, "Return", 
        function ()
            if client.focus then
                client.focus:swap(awful.client.getmaster())
            end
        end,
        {description = "Move to Master", group = "Windows"}),

    awful.key({ modkey, "Mod1" }, "u", 
        awful.client.urgent.jumpto,   
        {description = "Urgent Window", group = "Windows"}),
 
    awful.key({ "Mod1" }, "Tab",
        function ()
            local c = awful.client.focus.history.previous()
            if c then
                c:raise()
            end
        end,
        {description = "Last Window", group = "Windows"}),

    awful.key({ modkey, }, "j",
        function ()
            local c = awful.client.focus.history.list[2]
            client.focus = c
            local t = client.focus and client.focus.first_tag or nil
            if t then
                t:view_only()
            end
            c:raise()
        end,
        {description = "Previous Window", group = "Windows"}),

    awful.key({ }, "F11",
        function ()
            awful.spawn.with_shell("polybar-msg cmd toggle") 
            if client.focus then
                client.focus.fullscreen = not client.focus.fullscreen
                client.focus:raise()
            end
        end,
        {description = "Fullscreen", group = "Windows"}),

    -- Desktop Toggle
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
	    {description = "Desktop", group = "AwesomeWM"}),

    --awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     
    --    {description = "toggle floating", group = "client"}),


    -- Key bindings for Window Layout Management
    awful.key({ modkey,           }, "space",
        function ()
            awful.layout.inc(1)
        end,
        {description = "Next Layout", group = "Layout"}),
    
    awful.key({ modkey, "Shift"   }, "space",
        function ()
            awful.layout.inc(-1)
        end,
        {description = "Previous Layout", group = "Layout"}),

    awful.key({ modkey, "Control" }, "Up",
        function () 
            awful.tag.incnmaster( 1, nil, true)
        end,
        {description = "Increase Master Clients", group = "Layout"}),
    
    awful.key({ modkey, "Control"  }, "Down",
        function ()
            awful.tag.incnmaster(-1, nil, true) 
        end,
        {description = "Decrease Master Clients", group = "Layout"}),

    -- Key bindings for Tag/Workspace Management
    awful.key({ modkey }, "Left",
        awful.tag.viewprev,
        {description = "Preivous Workspaces", group = "Tags/Workspaces"}),

    awful.key({ modkey }, "Right",
        awful.tag.viewnext,
        {description = "Next Workspaces", group = "Tags/Workspaces"}),
    
    awful.key({ modkey }, "Tab", 
        awful.tag.history.restore,
        {description = "Last Workspaces", group = "Tags/Workspaces"}),

    -- Key bindings for Launcher
    -- Terminal
    awful.key({ modkey }, "t", 
        function () 
            awful.spawn(terminal)
        end,
        {description = "Terminal", group = "Launcher"}),
    
    -- Rofi
    awful.key({ modkey }, "q", 
        function() 
            awful.util.spawn("rofi -show")
        end,
        {description = "Quick Launcher", group = "Launcher" }),

    -- Brave
    awful.key({ modkey }, "b", 
        function() 
            awful.util.spawn("brave")
        end,
        {description = "Browser", group = "Launcher" }),

    -- Htop
    awful.key({ modkey }, "p", 
        function() 
            awful.spawn("kitty -e htop")
        end,
        {description = "Htop", group = "Launcher" }),

-- ****************************************************************************** 
    awful.key({ modkey, }, "n",
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

-- Key bindings for Layout
    awful.key({ modkey, "Shift" }, "h",
        function ()
            awful.tag.incncol( 1, nil, true)
        end,
        {description = "increase columns", group = "layout"}),
    
    awful.key({ modkey, "Shift" }, "l",
        function () 
            awful.tag.incncol(-1, nil, true)
        end,
        {description = "decrease columns", group = "layout"})
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

-- Set Global Keys
root.keys(globalkeys)

-- Unused key bindings
--    -- Prompt
--    awful.key({ modkey }, "x",
--        function ()
--            awful.prompt.run {
--                prompt = "Run Lua code: ",
--                textbox = awful.screen.focused().mypromptbox.widget,
--                exe_callback = awful.util.eval,
--                history_path = awful.util.get_cache_dir() .. "/history_eval"
--            }
--        end,
--        {description = "Lua Prompt", group = "AwesomeWM"}),
--    
--    -- Key bindings for Screen Management
--    awful.key({ modkey,           }, "o", 
--        function () 
--            local c = client.focus
--            c:move_to_screen()
--        end,
--        {description = "Move to Screen", group = "Screens"}),
--
--    awful.key({ modkey, "Control" }, "j", 
--        function () 
--            awful.screen.focus_relative(1) 
--        end,
--        {description = "Next Screen", group = "Screens"}),
--    
--    awful.key({ modkey, "Control" }, "k",
--        function () 
--            awful.screen.focus_relative(-1)
--        end,
--        {description = "Previous Screen", group = "Screens"}),
--    
--    awful.key({ modkey, "Control" }, "v",
--        function ()
--            local c = client.focus
--            c.maximized_vertical = not c.maximized_vertical
--            c:raise()
--        end,
--        {description = "Maximize Vertically Toggle", group = "Windows"}),
--    
--    awful.key({ modkey, "Control"   }, "b",
--        function ()
--            local c = client.focus
--            c.maximized_horizontal = not c.maximized_horizontal
--            c:raise()
--        end,
--        {description = "Maximize Horizontally Toggle", group = "Windows"}),
