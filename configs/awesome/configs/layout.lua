local awful = require("awful")

-- Layout
-- Table of layouts to cover with awful.layout.inc, order matters.
tag.connect_signal("request::default_layouts", 
    function()
        awful.layout.append_default_layouts({
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
        })
    end
)

screen.connect_signal("request::desktop_decoration", 
    function(s)
        -- Each screen has its own tag table.
        -- awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])
        local tagnames = {"A", "B", "C", "D", "E" }
        local l = awful.layout.suit
        local layouts = {l.tile, l.tile, l.tile, l.tile.top, l.tile}
        awful.tag(tagnames, s, layouts)
        awful.screen.padding(screen[s], {top=45})
    end
)

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
