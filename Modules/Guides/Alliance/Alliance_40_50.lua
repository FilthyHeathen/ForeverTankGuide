--[[
    Heathen's Forever Guide - Modules/Guides/Alliance/Alliance_40_50.lua
    Step-by-Step Leveling Guide: Tanaris, Feralas & The Hinterlands (Levels 40–50)
]]

local ADDON_NAME, HFG = ...
if not HFG then HFG = _G.HFG end
if not HFG then return end

HFG:RegisterGuide({
    id = "Alliance_Deep_40_50",
    title = "Tanaris, Feralas & The Hinterlands (40–50)",
    category = "Leveling",
    faction = "Alliance",
    minLevel = 40,
    maxLevel = 50,
    order = 5,
    steps = {
        {
            title = "Arrival in Gadgetzan (Tanaris)",
            zone = "Tanaris",
            coords = { x = 51.5, y = 26.5 },
            text = "Welcome to Tanaris! Discover the flight path and pick up all neutral goblin bounties.",
            goals = {
                { type = "FLY",    text = "Discover Gadgetzan Flight Path" },
                { type = "HEARTH", location = "Gadgetzan", text = "Set Hearthstone at Gadgetzan Inn" },
                { type = "ACCEPT", questID = 1560, text = "Accept [Wastewander Justice]" },
                { type = "ACCEPT", questID = 2875, text = "Accept [Water Pouch Bounty]" },
                { type = "ACCEPT", questID = 1687, text = "Accept [WANTED: Caliph Scorpidsting]" },
            }
        },
        {
            title = "Wastewander Justice & Pirate Cove",
            zone = "Tanaris",
            coords = { x = 60.0, y = 35.0 },
            text = "Raid the Wastewander camps across the dunes and clear the Southbreak Shore pirate cove.",
            goals = {
                { type = "COMPLETE", questID = 1560, text = "Slay 10 Wastewander Bandits and 8 Thieves" },
                { type = "COMPLETE", questID = 2875, text = "Collect 5 Wastewander Water Pouches" },
                { type = "COMPLETE", questID = 1687, text = "Defeat Caliph Scorpidsting" },
                { type = "TURNIN",   questID = 1560, text = "Turn in [Wastewander Justice]" },
                { type = "TURNIN",   questID = 2875, text = "Turn in [Water Pouch Bounty]" },
                { type = "TURNIN",   questID = 1687, text = "Turn in [WANTED: Caliph Scorpidsting]" },
                { type = "LEVEL",    level = 43,     text = "Reach Level 43" },
            }
        },
        {
            title = "Feathermoon Stronghold (Feralas)",
            zone = "Feralas",
            coords = { x = 30.5, y = 43.0 },
            text = "Travel west into Feralas and take the ferry to the island fortress of Feathermoon Stronghold.",
            goals = {
                { type = "FLY",    text = "Discover Feathermoon Stronghold Flight Path" },
                { type = "ACCEPT", questID = 2845, text = "Accept [The Ruins of Solarsal] from Shandris Feathermoon" },
                { type = "ACCEPT", questID = 2846, text = "Accept [The Hatecrest Threat] from Latronicus Moonspear" },
                { type = "COMPLETE", questID = 2846, text = "Defeat 10 Hatecrest Sirens and 8 Myrmidons" },
                { type = "TURNIN",   questID = 2846, text = "Turn in [The Hatecrest Threat]" },
                { type = "LEVEL",    level = 46,    text = "Reach Level 46 and prepare for Zul'Farrak" },
            }
        },
        {
            title = "Aerie Peak & Wildhammer Hinterlands",
            zone = "The Hinterlands",
            coords = { x = 14.5, y = 44.5 },
            text = "Fly north to the Wildhammer dwarf mountain aerie at Aerie Peak.",
            goals = {
                { type = "FLY",    text = "Discover Aerie Peak Flight Path" },
                { type = "HEARTH", location = "Aerie Peak", text = "Set Hearthstone at Aerie Peak" },
                { type = "ACCEPT", questID = 2642, text = "Accept [Troll Patrol] from Falstad Wildhammer" },
                { type = "ACCEPT", questID = 2781, text = "Accept [Witherbark Cages] from Gryphon Master Talonaxe" },
                { type = "COMPLETE", questID = 2781, text = "Inspect the troll cages in southern Hinterlands" },
                { type = "TURNIN",   questID = 2781, text = "Turn in [Witherbark Cages] at Aerie Peak" },
                { type = "LEVEL",    level = 50,     text = "Reach Level 50 and prepare for Un'Goro Crater" },
            }
        }
    }
})
