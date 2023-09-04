local awful = require("awful")

-- Initialize Polybar for AwesomeWM 
awful.spawn.with_shell("~/.script/awesome/polybar.sh")

-- Run single instance programs via init.sh
awful.spawn.with_shell("~/.script/awesome/init.sh")

-- Run startup programs via startup.sh
awful.spawn.with_shell("~/.script/awesome/startup.sh")

-- Apply wallpaper & set colour scheme using pywal
awful.spawn.with_shell("~/.script/wallcolour.sh")
