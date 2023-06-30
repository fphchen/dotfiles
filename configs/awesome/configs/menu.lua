local awful = require("awful")
local beautiful = require("beautiful")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
local myhotkeys_menu = hotkeys_popup.widget.new({ width = 1000, height = 1000, border_width = 0 })

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
--require("awful.hotkeys_popup.keys")

-- This is used later as the default terminal and editors to run
terminal = "alacritty"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() myhotkeys_menu:show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal },
				    { "reload", awesome.restart },
				    { "exit to tty", function() awesome.quit() end },
				    { "restart", function() awful.spawn.with_shell("shutdown -r now") end },
				    { "shutdown", function() awful.spawn.with_shell("shutdown now") end }
                                  }
                        })

-- mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
--                                      menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}
