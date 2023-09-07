-- awesome_mode: api-level=4:screen=on
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")

-- Theme handling library
local beautiful = require("beautiful")
-- Declarative object management
local menubar = require("menubar")

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
local hotkeys_popup = require("awful.hotkeys_popup")
require("awful.hotkeys_popup.keys")

-- Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init("~/.config/awesome/configs/theme.lua")
beautiful.useless_gap = 15

-- Default terminal and editor to run.
terminal = "kitty"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

require("configs")
