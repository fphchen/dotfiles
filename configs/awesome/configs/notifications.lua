local naughty = require("naughty")

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
