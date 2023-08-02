-- No Tmux installed
--package.loaded["awful.hotkeys_popup.keys.tmux"] = {}

-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local awful = require("awful")
-- Widget and layout library
local wibox = require("wibox")
-- Show Desktop library
local show_desktop = false
require("awful.autofocus")
require("configs")

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

---- Keyboard map indicator and switcher
--mykeyboardlayout = awful.widget.keyboardlayout()
--
---- {{{ Wibar
---- Create a textclock widget
--mytextclock = wibox.widget.textclock()
--
---- Create a wibox for each screen and add it
--local taglist_buttons = gears.table.join(
--                    awful.button({ }, 1, function(t) t:view_only() end),
--                    awful.button({ modkey }, 1, function(t)
--                                              if client.focus then
--                                                  client.focus:move_to_tag(t)
--                                              end
--                                          end),
--                    awful.button({ }, 3, awful.tag.viewtoggle),
--                    awful.button({ modkey }, 3, function(t)
--                                              if client.focus then
--                                                  client.focus:toggle_tag(t)
--                                              end
--                                          end),
--                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
--                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
--                )
--
--local tasklist_buttons = gears.table.join(
--                     awful.button({ }, 1, function(c)
--                                              if c == client.focus then
--                                                  c.minimized = true
--                                              else
--                                                  c:emit_signal(
--                                                      "request::activate",
--                                                      "tasklist",
--                                                      {raise = true}
--                                                  )
--                                              end
--                                          end),
--                     awful.button({ }, 3, function()
--                                              awful.menu.client_list({ theme = { width = 250 } })
--                                          end),
--                     awful.button({ }, 4, function ()
--                                              awful.client.focus.byidx(1)
--                                          end),
--                     awful.button({ }, 5, function ()
--                                              awful.client.focus.byidx(-1)
--                                          end))