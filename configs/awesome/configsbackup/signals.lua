local awful = require("awful")
local gears = require("gears")

clientbuttons = gears.table.join(
    awful.button({ }, 1, 
        function (c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
        end
    ),
    awful.button({ modkey }, 1, 
        function (c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
            awful.mouse.client.move(c)
        end
    ),
    awful.button({ modkey }, 3, 
        function (c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
            awful.mouse.client.resize(c)
        end
    )
)

-- Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", 
    function (c)
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        if not awesome.startup then awful.client.setslave(c) end

        if awesome.startup
            and not c.size_hints.user_position
            and not c.size_hints.program_position then
            -- Prevent clients from being unreachable after screen count changes.
            awful.placement.no_offscreen(c)
        end
    end
)
--
client.connect_signal("manage", 
    function (c)
	    if c.class == nil then c. minimized = true
		    c:connect_signal("property::class", 
                function()
		            c.minimized = false
		            awful.rules.apply(c)
		        end
            )
	    end
    end
)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", 
    function (c)
        c:emit_signal("request::activate", "mouse_enter", {raise = false})
    end
)
