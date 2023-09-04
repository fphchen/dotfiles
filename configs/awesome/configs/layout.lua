local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")

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

-- Path to theme.lua
-- Theme define colours, icons, font, and wallpapers
beautiful.init("~/.config/awesome/theme.lua")

-- Gaps
beautiful.useless_gap = 15

-- Set Wallpaper
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

screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    -- awful.tag({ "1", "2", "3", "4" "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

    -- Setting default layout for each screen
    local names = { "GENERAL", "CODE", "WEB", "MUSIC", "IM" }
    local l = awful.layout.suit 
    local layouts = {l.fair, l.tile, l.tile.fair, l.tile.top, l.tile}
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

