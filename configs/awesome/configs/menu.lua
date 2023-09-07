local awful = require("awful")
local beautiful = require("beautiful")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

-- Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
}

mymainmenu = awful.menu({
    items = { 
        { "Awesome", myawesomemenu, beautiful.awesome_icon },
        { "Shortcuts", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
        { "Terminal", terminal },
        { "Reload", awesome.restart },
        { "Quit", function() awesome.quit() end },
		{ "Restart", function() awful.spawn.with_shell("reboot") end },
		{ "Poweroff", function() awful.spawn.with_shell("poweroff") end }
    }
})

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
