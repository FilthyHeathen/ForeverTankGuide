--[[
    Heathen's Forever Guide - Modules/Guides/Horde/Horde_40_50.lua
    Step-by-Step Leveling Guide: Tanaris, Feralas & The Hinterlands (Levels 40–50)
]]

local ADDON_NAME, HFG = ...
if not HFG then HFG = _G.HFG end
if not HFG then return end

HFG:RegisterGuide({
    id = "Horde_Deep_40_50",
    title = "Tanaris, Feralas & The Hinterlands (40–50)",
    category = "Leveling",
    faction = "Horde",
    minLevel = 40,
    maxLevel = 50,
    order = 5,
    steps = {
        {
            title = "Arrival in Gadgetzan (Tanaris)",
            zone = "Tanaris",
            coords = { x = 51.5, y = 26.5 },
            text = "Welcome to the shimmering desert of Tanaris! Discover the flight path and accept all goblin/pirate bounties.",
            goals = {
                { type = "FLY",    text = "Discover Gadgetzan Flight Path" },
                { type = "HEARTH", location = "Gadgetzan", text = "Set Hearthstone at the Gadgetzan Inn" },
                { type = "ACCEPT", questID = 1687, text = "Accept [WANTED: Caliph Scorpidsting]" },
                { type = "ACCEPT", questID = 1560, text = "Accept [Wastewander Justice] from Chief Engineer Bilgewhizzle" },
                { type = "ACCEPT", questID = 2875, text = "Accept [Water Pouch Bounty] from Spigot Operator Fizzwidget" },
            }
        },
        {
            title = "Wastewander Camps & Water Pouches",
            zone = "Tanaris",
            coords = { x = 60.0, y = 35.0 },
            text = "Raid the Wastewander bandit camps scattered across the dunes southeast of Gadgetzan.",
            goals = {
                { type = "COMPLETE", questID = 1560, text = "Slay 10 Wastewander Bandits and 8 Thieves" },
                { type = "COMPLETE", questID = 2875, text = "Collect 5 Wastewander Water Pouches" },
                { type = "COMPLETE", questID = 1687, text = "Defeat Caliph Scorpidsting and loot his head" },
                { type = "TURNIN",   questID = 1560, text = "Turn in [Wastewander Justice]" },
                { type = "TURNIN",   questID = 2875, text = "Turn in [Water Pouch Bounty]" },
                { type = "TURNIN",   questID = 1687, text = "Turn in [WANTED: Caliph Scorpidsting]" },
                { type = "LEVEL",    level = 43,     text = "Reach Level 43" },
            }
        },
        {
            title = "Camp Mojache & Feralas Wilderness",
            zone = "Feralas",
            coords = { x = 75.5, y = 44.0 },
            text = "Travel west into the lush prehistoric forests of Feralas and establish base at Camp Mojache.",
            goals = {
                { type = "FLY",    text = "Discover Camp Mojache Flight Path" },
                { type = "ACCEPT", questID = 2977, text = "Accept [A New Cloak's Sheen] from Hadoken Swiftstrider" },
                { type = "ACCEPT", questID = 2821, text = "Accept [Gordunni Cobalt] from Oran Snakewrithe" },
                { type = "COMPLETE", questID = 2821, text = "Collect 10 Gordunni Cobalt from the southern ruins" },
                { type = "TURNIN",   questID = 2821, text = "Turn in [Gordunni Cobalt]" },
                { type = "LEVEL",    level = 46,    text = "Reach Level 46 and prepare for Zul'Farrak" },
            }
        },
        {
            title = "Revantusk Village & The Hinterlands Coast",
            zone = "The Hinterlands",
            coords = { x = 77.0, y = 80.0 },
            text = "Fly or ride to the eastern coast of The Hinterlands to rendezvous with the Revantusk tribe.",
            goals = {
                { type = "FLY",    text = "Discover Revantusk Village Flight Path" },
                { type = "HEARTH", location = "Revantusk Village", text = "Set Hearthstone at Revantusk Village" },
                { type = "ACCEPT", questID = 7815, text = "Accept [Cannibalistic Cousins] from Primal Torntusk" },
                { type = "ACCEPT", questID = 7816, text = "Accept [Message to the Wildhammer] from OOX-09/HL" },
                { type = "ACCEPT", questID = 7842, text = "Accept [Vilebranch Hooligans] from Huntsman Markhor" },
            }
        },
        {
            title = "Jintha'Alor Assault & Zul'Farrak Preparation",
            zone = "The Hinterlands",
            coords = { x = 58.0, y = 70.0 },
            text = "Storm the massive tiered troll city of Jintha'Alor, liberate sharpbeak, and forge the Mallet of Zul'Farrak.",
            goals = {
                { type = "COMPLETE", questID = 7815, text = "Slay 15 Vilebranch Berserkers and 10 Shadow Hunters" },
                { type = "TURNIN",   questID = 7815, text = "Turn in [Cannibalistic Cousins] at Revantusk Village" },
                { type = "LEVEL",    level = 50,     text = "Reach Level 50 and prepare for Un'Goro Crater" },
            }
        }
    }
})
