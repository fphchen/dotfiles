local awful = require("awful")
local beautiful = require("beautiful")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
local myhotkeys_menu = hotkeys_popup.widget.new({ width = 1000, height = 1000, border_width = 0 })

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
--require("awful.hotkeys_popup.keys")

-- This is used later as the default terminal and editors to run
terminal = "kitty"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
}

mymainmenu = awful.menu(
    { items = 
        { 
        { "Awesome", myawesomemenu, beautiful.awesome_icon },
        { "Shortcuts", function() myhotkeys_menu:show_help(nil, awful.screen.focused()) end },
        { "Terminal", terminal },
		{ "Reload", awesome.restart },
		{ "Quit", function() awesome.quit() end },
		{ "Restart", function() awful.spawn.with_shell("reboot") end },
		{ "Poweroff", function() awful.spawn.with_shell("poweroff") end }
        }
    }
)

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it

-- mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
--                                      menu = mymainmenu })
