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
        -- Disable Titlebars for Normal and Dialog Windows
        ruled.client.append_rule {
            id         = "notitlebars",
            rule_any   = { type = { "normal", "dialog" } },
            properties = { titlebars_enabled = false }
        }
        -- Specific Floating Clients Rules
        ruled.client.append_rule {
            id       = "floating",
            rule_any = {
                -- "Brave",
                instance = {"pavucontrol", "blueman-manager", "nm-connection-editor"},
                class    = {},
                -- Note that the name property shown in xprop might be set slightly after creation of the client
                -- and the name shown there might not match defined rules here.
                name    = {},
                role    = {}
            },
            properties = { floating = true, titlebars_enabled = true, placement = awful.placement.centered}
        }
        -- Set Spotify to always be on "WEB"
        ruled.client.append_rule {
            rule = { class = "[Ss]potify" },
            properties = { screen = 1, tag = "MUSIC" }
        }
        -- Set Signal to always be on "IM"
        ruled.client.append_rule {
            rule = { class = "[Ss]ignal" },
            properties = { screen = 1, tag = "IM" }
        }
    end
)
-- Show Titlebar for Floating Clients
client.connect_signal("property::floating",
    function (c)
        if c.floating then
            awful.titlebar.show(c)
            local placement_rule = (awful.placement.no_offscreen + awful.placement.centered + awful.placement.bottom)
            placement_rule(c)
        else
            awful.titlebar.hide(c)
        end
    end
)
