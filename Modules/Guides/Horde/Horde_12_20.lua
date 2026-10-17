--[[
    Heathen's Forever Guide - Modules/Guides/Horde/Horde_12_20.lua
    Step-by-Step Leveling Guide: The Crossroads, Northern Barrens & Silverpine (Levels 12–20)
]]

local ADDON_NAME, HFG = ...
if not HFG then HFG = _G.HFG end
if not HFG then return end

HFG:RegisterGuide({
    id = "Horde_Mid_12_20",
    title = "The Crossroads & Northern Barrens (12–20)",
    faction = "Horde",
    minLevel = 12,
    maxLevel = 20,
    order = 2,
    steps = {
        {
            title = "Arrival at The Crossroads",
            zone = "The Barrens",
            coords = { x = 52.0, y = 30.0 },
            text = "Welcome to the crossroads of Kalimdor! Grab the flight path, bind your hearthstone, and accept all town quests.",
            goals = {
                { type = "FLY",    text = "Discover The Crossroads Flight Path" },
                { type = "HEARTH", location = "Crossroads", text = "Set Hearthstone at The Crossroads Inn" },
                { type = "ACCEPT", questID = 844, text = "Accept [Plainstrider Menace] from Sergra Darkthorn" },
                { type = "ACCEPT", questID = 848, text = "Accept [The Forgotten Pools] from Tonga Runetotem" },
                { type = "ACCEPT", questID = 871, text = "Accept [Raptor Thieves] from Gazrog" },
            }
        },
        {
            title = "Savannah Hunting & The Forgotten Pools",
            zone = "The Barrens",
            coords = { x = 45.0, y = 22.0 },
            text = "Hunt Fleeting Plainstriders and Sunscale Raptors across the northern savannah and inspect the Forgotten Pools oasis.",
            goals = {
                { type = "COMPLETE", questID = 844, text = "Collect 7 Plainstrider Beaks" },
                { type = "COMPLETE", questID = 871, text = "Collect 12 Raptor Heads" },
                { type = "COMPLETE", questID = 848, text = "Explore the bubbling fissure at The Forgotten Pools" },
                { type = "TURNIN",   questID = 844, text = "Turn in [Plainstrider Menace] to Sergra Darkthorn" },
                { type = "TURNIN",   questID = 871, text = "Turn in [Raptor Thieves] to Gazrog" },
                { type = "TURNIN",   questID = 848, text = "Turn in [The Forgotten Pools] to Tonga Runetotem" },
                { type = "LEVEL",    level = 15,    text = "Reach Level 15" },
            }
        },
        {
            title = "The Stagnant Oasis & Fungus Scavenging",
            zone = "The Barrens",
            coords = { x = 55.5, y = 43.0 },
            text = "Journey southeast to the Stagnant Oasis to slay Kolkar centaur and harvest spore mushrooms.",
            goals = {
                { type = "ACCEPT", questID = 855, text = "Accept [The Stagnant Oasis] from Tonga Runetotem" },
                { type = "ACCEPT", questID = 880, text = "Accept [Altered Beings] from Mahren Skyseer" },
                { type = "COMPLETE", questID = 855, text = "Examine the bubbler in the center of the Stagnant Oasis" },
                { type = "COMPLETE", questID = 880, text = "Collect 8 Altered Centaur Bracers" },
                { type = "TURNIN",   questID = 855, text = "Turn in [The Stagnant Oasis] to Tonga Runetotem" },
                { type = "TURNIN",   questID = 880, text = "Turn in [Altered Beings] to Mahren Skyseer" },
                { type = "LEVEL",    level = 18,    text = "Reach Level 18" },
            }
        },
        {
            title = "Wailing Caverns & Leaders of the Fang",
            zone = "The Barrens",
            coords = { x = 46.0, y = 36.5 },
            text = "Venture into the eye above Wailing Caverns to speak with the Disciple of Naralex and prepare for your first major dungeon.",
            goals = {
                { type = "ACCEPT", questID = 847, text = "Accept [Leaders of the Fang] from Naralex's Disciple" },
                { type = "ACCEPT", questID = 902, text = "Accept [Smart Drinks] from Mangletooth" },
                { type = "LEVEL",  level = 20,    text = "Reach Level 20 and prepare for Camp Taurajo & Thousand Needles" },
            }
        }
    }
})
