local awful = require("awful")
local ruled = require("ruled")
local naughty = require("naughty")

-- Notifications

-- Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
naughty.connect_signal("request::display_error", function(message, startup)
    naughty.notification {
        urgency = "critical",
        title   = "Oops, an error happened"..(startup and " during startup!" or "!"),
        message = message
    }
end)

ruled.notification.connect_signal('request::rules',
    function()
        -- All notifications will match this rule.
        ruled.notification.append_rule {
            rule       = { },
            properties = {
                screen = awful.screen.preferred,
                implicit_timeout = 5,
            }
        }
    end
)

naughty.connect_signal("request::display",
    function(n)
        naughty.layout.box { notification = n }
    end
)

-- Notification settings
naughty.config.defaults['icon_size'] = 80
naughty.config.defaults['position'] = 'bottom_left'
naughty.config.presets.low.timeout = 5
naughty.config.presets.normal.timeout = 10

-- Surpress Spotify notification
naughty.config.presets.spotify = { 
	callback = 
        function()
		    return false
	    end
}

table.insert(naughty.dbus.config.mapping, {{appname = "Spotify"}, naughty.config.presets.spotify})

---- Enable sloppy focus, so that focus follows mouse.
--client.connect_signal("mouse::enter", function(c)
--    c:activate { context = "mouse_enter", raise = false }
--end
--)
