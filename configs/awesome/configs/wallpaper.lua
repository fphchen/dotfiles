local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

beautiful.init("~/.config/awesome/configs/theme.lua")
beautiful.useless_gap = 15

-- {{{ Wallpaper
screen.connect_signal("request::wallpaper", 
    function(s)
        awful.wallpaper {
            screen = s,
            widget = {
                {
                    image     = beautiful.wallpaper,
                    upscale   = true,
                    downscale = true,
                    widget    = wibox.widget.imagebox,
                },
                valign = "center",
                halign = "center",
                tiled  = false,
                widget = wibox.container.tile,
            }
        }
    end
)
