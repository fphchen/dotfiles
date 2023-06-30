local awful = require("awful")
local beautiful = require("beautiful")

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_width = 0,
					 border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          --"Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          --"Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer"},

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = false }
    },

    -- Set Firefox to always map on the tag named "WEB" on screen 1.
    { rule = { class = "[Ff]irefox" },
      properties = { screen = 1, tag = "WEB" } },
    
    -- Set Brave to always map on the tag named "WEB" on screen 1.
    { rule = { class = "[Bb]rave" },
      properties = { screen = 1, tag = "WEB" } },
    
    -- Set Spotify to always map on the tag named "MUSIC" on screen 1.
    { rule = { class = "[Ss]potify" },
      properties = { screen = 1, tag = "MUSIC" } },
    
    -- Set Signal to always map on the tag named "IM" on screen 1.
    { rule = { class = "[Ss]ignal" },
      properties = { screen = 1, tag = "IM" } },
}
-- }}}

