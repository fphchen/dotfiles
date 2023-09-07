local awful = require("awful")
local ruled = require("ruled")

-- Rules
-- Rules to apply to new clients.
ruled.client.connect_signal("request::rules", 
    function()
        -- All clients will match this rule.
        ruled.client.append_rule {
            id         = "global",
            rule       = { },
            properties = {
                focus     = awful.client.focus.filter,
                raise     = true,
                screen    = awful.screen.preferred,
                placement = awful.placement.no_overlap+awful.placement.no_offscreen
            }
        }
        -- Disable Titlebars for Normal and Dialogs
        ruled.client.append_rule {
            id         = "titlebars",
            rule_any   = { type = { "normal", "dialog" } },
            properties = { titlebars_enabled = false }
        }
        -- Specific Floating Clients Rules
        ruled.client.append_rule {
            id       = "floating",
            rule_any = {
                -- "Brave",
                instance = {},
                class    = {},
                -- Note that the name property shown in xprop might be set slightly after creation of the client
                -- and the name shown there might not match defined rules here.
                name    = {},
                role    = {}
            },
            properties = { floating = true, titlebars_enabled = true }
        }
        ---- Set Firefox to always map on the tag named "2" on screen 1.
        ruled.client.append_rule {
            rule = { class = "[Ss]ignal" },
            properties = { screen = 1, tag = "2" }
        }
    end
)
