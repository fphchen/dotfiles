local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")
local show_desktop = false

-- Key bindings

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Global Keybindings
-- Keybindings for General AwesomeWM
awful.keyboard.append_global_keybindings({
    awful.key({ modkey, "Control", "Shift"}, "h",
        hotkeys_popup.show_help,
        {description="Shortcuts", group="AWESOMEWM"}
    ),
    awful.key({ modkey, "Control", "Shift" }, "m",
        function ()
            mymainmenu:show() 
        end,
        {description = "Menu", group = "AWESOMEWM"}
    ),
    awful.key({ modkey, "Control", "Shift" }, "b",
        function ()
            awful.spawn.with_shell("polybar-msg cmd toggle")
        end,
        {description = "Bar", group = "AWESOMEWM"}
    ),
    awful.key({ modkey, "Control", "Shift" }, "w",
        function ()
            awful.spawn.with_shell("~/.script/wallcolour.sh")
        end,
        {description = "Wallpaper", group = "AWESOMEWM"}
    ),
    -- Desktop Toggle
    awful.key({ modkey, "Control", "Shift" }, "d", 
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
	    {description = "Desktop", group = "AWESOMEWM"}
    ),
    awful.key({}, "Print",
        function ()
            awful.spawn.with_shell("impport -window root screeshot.jpg")
        end,
        {description = "Screenshot", group = "AWESOMEWM"}
    ),
    awful.key({ modkey, "Control", "Shift" }, "a",
        awesome.restart,
        {description = "Reload", group = "AWESOMEWM"}
    ),
    awful.key({ modkey, "Control", "Shift" }, "q",
        awesome.quit,
        {description = "Quit", group = "AWESOMEWM"}
    ),
    awful.key({ modkey, "Control", "Shift" }, "r",
        function ()
            awful.spawn.with_shell("reboot")
        end,
        {description = "Reboot", group = "AWESOMEWM"}
    ),
    awful.key({ modkey, "Control", "Shift" }, "p",
        function ()
            awful.spawn.with_shell("poweroff")
        end,
        {description = "Poweroff", group = "AWESOMEWM"}
    )
})
-- Keybindings for Application Launcher
awful.keyboard.append_global_keybindings({
    -- Terminal
    awful.key({ modkey, }, "t", 
        function () 
            awful.spawn(terminal) 
        end,      
        {description = "Terminal", group = "LAUNCHER"}
    ),
    -- Quick Launcher
    awful.key({ modkey, }, "q", 
        function () 
            awful.spawn("rofi -show") 
        end,      
        {description = "Quick Launcher", group = "LAUNCHER"}
    ),
    -- Browser
    awful.key({ modkey, }, "b", 
        function () 
            awful.spawn("brave") 
        end,      
        {description = "Terminal", group = "LAUNCHER"}
    ),
    -- Processes
    awful.key({ modkey, }, "p", 
        function () 
            awful.spawn("kitty -e htop")
        end,      
        {description = "Processes", group = "LAUNCHER"}
    )
})
-- Keybindings for Tags
awful.keyboard.append_global_keybindings({
    awful.key({ modkey }, "Left",
        awful.tag.viewprev,
        {description = "Previous Tag", group = "TAG"}
    ),
    awful.key({ modkey }, "Right",
        awful.tag.viewnext,
        {description = "Next Tag", group = "TAG"}
    ),
    awful.key({ modkey }, "Tab",
        awful.tag.history.restore,
        {description = "Last Tag", group = "TAG"}
    )
})
-- Keybindings for Window Focus
awful.keyboard.append_global_keybindings({
    awful.key({ modkey, "Mod1"}, "u", 
        awful.client.urgent.jumpto,
        {description = "Urgent Window", group = "WINDOWS"}
    ),
    awful.key({ modkey, "Control" }, "j",
        function ()
            awful.client.focus.byidx(1)
        end,
        {description = "Focus Next", group = "WINDOWS"}
    ),
    awful.key({ modkey, "Control" }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "Focus Previous", group = "WINDOWS"}
    ),
    awful.key({ "Mod1", }, "Tab",
        function ()
            local c = awful.client.focus.history.list[2]
            client.focus = c
            local t = client.focus and client.focus.first_tag or nil
            if t then
                t:view_only()
            end
        end,
        {description = "Last Window", group = "WINDOWS"}
    ),
    awful.key({ modkey, "Shift" }, "j",                                          
        function () 
            awful.client.swap.byidx(1)
        end,
        {description = "Swap w Next", group = "WINDOWS"}
    ),
    awful.key({ modkey, "Shift" }, "k",
        function ()
            awful.client.swap.byidx(-1)
        end,
        {description = "Swap w Previous", group = "WINDOWS"}
    ),
    awful.key({ modkey, "Shift" }, "Up",
       function () 
           awful.tag.incmwfact(0.05)
       end,
       {description = "Increase Master Width", group = "WINDOWS"}
    ),
    awful.key({ modkey, "Shift" }, "Down",     
        function () 
            awful.tag.incmwfact(-0.05)
        end,
    {description = "Decrease Master Width", group = "WINDOWS"}
    ),
    awful.key({ modkey, "Control" }, "n",
        function ()
            local c = awful.client.restore()
            -- Focus restored client
            if c then
                c:activate { raise = true, context = "key.unminimize" }
            end
        end,
        {description = "Restore Minimized", group = "WINDOWS"}
    )
})
-- Keybindings for Layout
awful.keyboard.append_global_keybindings({
    awful.key({ modkey, "Shift" }, "h",
        function () 
            awful.tag.incnmaster(1, nil, true)
        end,
        {description = "Increase Master Clients", group = "LAYOUT"}
    ),
    awful.key({ modkey, "Shift" }, "l",
        function ()
            awful.tag.incnmaster(-1, nil, true)
        end,
        {description = "Decrease Master Clients", group = "LAYOUT"}
    ),
    awful.key({ modkey, "Control" }, "h",
        function ()
            awful.tag.incncol(1, nil, true)
        end,
        {description = "Increase Columns", group = "LAYOUT"}
    ),
    awful.key({ modkey, "Control" }, "l",
        function () 
            awful.tag.incncol(-1, nil, true)
        end,
        {description = "Decrease Columns", group = "LAYOUT"}
    ),
    awful.key({ modkey, }, "space", 
        function () 
            awful.layout.inc(1)
        end,
        {description = "Next Layout", group = "LAYOUT"}
    ),
    awful.key({ modkey, "Shift" }, "space",
        function ()
            awful.layout.inc(-1)
        end,
        {description = "Previous Layout", group = "LAYOUT"}
    )
})

-- Keybindings for Screen
awful.keyboard.append_global_keybindings({
    awful.key({ modkey, "Control" }, "j", 
        function () 
            awful.screen.focus_relative(1)
        end,
        {description = "focus the next screen", group = "SCREEN"}
    ),
    awful.key({ modkey, "Control" }, "k",
        function () 
            awful.screen.focus_relative(-1)
        end,
        {description = "focus the previous screen", group = "SCREEN"}
    )
})

awful.keyboard.append_global_keybindings({
    awful.key {
        modifiers   = { modkey },
        keygroup    = "numrow",
        description = "Go to Tag",
        group       = "TAG",
        on_press    = 
            function (index)
                local screen = awful.screen.focused()
                local tag = screen.tags[index]
                if tag then
                    tag:view_only()
                end
            end,
    },
    awful.key {
        modifiers   = { modkey, "Control" },
        keygroup    = "numrow",
        description = "Toggle Tag",
        group       = "TAG",
        on_press    = 
            function (index)
                local screen = awful.screen.focused()
                local tag = screen.tags[index]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end,
    },
    awful.key {
        modifiers = { modkey, "Shift" },
        keygroup    = "numrow",
        description = "Move Focus to Tag",
        group       = "TAG",
        on_press    = 
            function (index)
                if client.focus then
                    local tag = client.focus.screen.tags[index]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end,
    },
    awful.key {
        modifiers   = { modkey, "Control", "Shift" },
        keygroup    = "numrow",
        description = "Toggle Focuse on Tag",
        group       = "TAG",
        on_press    = 
            function (index)
                if client.focus then
                    local tag = client.focus.screen.tags[index]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end,
    },
    awful.key {
        modifiers   = { modkey },
        keygroup    = "numpad",
        description = "Select Layout",
        group       = "LAYOUT",
        on_press    = 
            function (index)
                local t = awful.screen.focused().selected_tag
                if t then
                    t.layout = t.layouts[index] or t.layout
                end
            end,
    }
})
--Unused Global Keybindings
awful.keyboard.append_global_keybindings({
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
--    awful.key({ modkey }, "r",
--        function () 
--            awful.screen.focused().mypromptbox:run() 
--        end,
--        {description = "run prompt", group = "launcher"}),
--    awful.key({ modkey }, "n",
--        function() 
--            menubar.show()
--        end,
--        {description = "menubar", group = "launcher"}),
--    awful.key({ modkey, "Control" }, "Tab",
--        function ()
--            awful.client.focus.history.previous()
--            if client.focus then
--                client.focus:raise()
--            end
--        end,
--        {description = "Focus Last", group = "WINDOWS"}
--    )
})

-- Client Keybindings
client.connect_signal("request::default_keybindings",
    function()
        awful.keyboard.append_client_keybindings({
            awful.key({}, "F11",
                function (c)
                    c.fullscreen = not c.fullscreen
                    c:raise()
                end,
            {description = "Fullscreen", group = "CLIENTS"}
            ),
            awful.key({ modkey, "Control" }, "c",
                function (c) 
                    c:kill()
                end,
                {description = "Close", group = "CLIENTS"}
            ),
            awful.key({ modkey, "Mod1" }, "f",
                awful.client.floating.toggle                     ,
                {description = "Floating", group = "CLIENTS"}
            ),
            awful.key({ modkey, "Shift" }, "Return", 
                function (c) 
                    c:swap(awful.client.getmaster()) 
                end,
                {description = "Swap w Master", group = "CLIENTS"}
            ),
            awful.key({ modkey, "Mod1"}, "t",
                function (c) 
                    c.ontop = not c.ontop
                end,
                {description = "On Top", group = "CLIENTS"}
            ),
            awful.key({ modkey, "Control" }, "n",
                function (c)
                    -- The client currently has the input focus, so it cannot be
                    -- minimized, since minimized clients can't have the focus.
                    c.minimized = true
                end,
                {description = "Minimize", group = "CLIENTS"}
            ),
            awful.key({ modkey, "Control" }, "m",
                function (c)
                    c.maximized = not c.maximized
                    c:raise()
                end,
                {description = "Maximize", group = "CLIENTS"}
            ),
        })
    end
)
-- Unused Client Keybindings
client.connect_signal("request::default_keybindings",
    function()
--        awful.keyboard.append_client_keybindings({
--            awful.key({ modkey,           }, "o",
--                function (c) 
--                    c:move_to_screen()
--                end,
--                {description = "move to screen", group = "client"}
--            ),
--            awful.key({ modkey, "Control" }, "m",
--                function (c)
--                    c.maximized_vertical = not c.maximized_vertical
--                    c:raise()
--                end,
--                {description = "(un)maximize vertically", group = "client"}),
--            awful.key({ modkey, "Shift"   }, "m",
--                function (c)
--                    c.maximized_horizontal = not c.maximized_horizontal
--                    c:raise()
--                end,
--                {description = "(un)maximize horizontally", group = "client"}),
--        })
    end
)
