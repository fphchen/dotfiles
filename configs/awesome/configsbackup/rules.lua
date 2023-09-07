local awful = require("awful")
local beautiful = require("beautiful")

-- Rules
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

    -- Disable titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = false }
    },

    -- Assign specific clients to be floating using instance, class, name, and role
    { rule_any = {
        instance = {
            --"copyq",
            -- Enter window instances to be in floating mode permanently
        },
        class = {
            -- "Brave",
            -- Enter window class to be in floating mode permanently
            -- Note that the name property shown in xprop might be set slightly after creation of the client
            -- and the name shown there might not match defined rules here
        },
        name = {
            -- "Event Tester", -- xev
            -- Enter window name to be in floating mode permanently
        },
        role = {
            --"pop-up", -e.g. Google Chrome's (detached) Developer Tools
            -- Enter window role to be in floating mode permanently
        }
      }, properties = { floating = true, titlebars_enabled = true, placement = awful.placement.centered }},

--    -- Floating Window attributes      
--    { rule_any = {type = { "normal", "dialog" }
--      }, properties = { titlebars_enabled = false }
--    },i

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
