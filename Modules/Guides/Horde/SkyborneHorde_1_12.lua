--[[
    Heathen's Forever Guide - Modules/Guides/Horde/SkyborneHorde_1_12.lua
    Step-by-Step Leveling Guide: Skyborne Sanctuary & Kalimdor Descent (Levels 1–12)
]]

local ADDON_NAME, HFG = ...
if not HFG then HFG = _G.HFG end
if not HFG then return end

HFG:RegisterGuide({
    id = "Horde_Skyborne_1_12",
    title = "Skyborne Sanctuary & Kalimdor Descent (1–12)",
    faction = "Horde",
    races = { "SKYBORNE_HORDE" },
    minLevel = 1,
    maxLevel = 12,
    order = 1,
    steps = {
        {
            title = "The Wind-Trial Awakening",
            zone = "Skyborne Sanctuary",
            coords = { x = 48.0, y = 52.0 },
            text = "Welcome to the high-altitude aerie! Speak with Wind-Keeper Kaelen to initiate your trial rites.",
            goals = {
                { type = "ACCEPT", questID = 9101, text = "Accept [Wind-Trial: First Flight] from Wind-Keeper Kaelen" },
            }
        },
        {
            title = "Aerie Scouting & Aerial Glide Practice",
            zone = "Skyborne Sanctuary",
            coords = { x = 49.5, y = 50.2 },
            text = "Leap from the upper perch and activate Aerial Glide to drift safely down to the lower terrace.",
            goals = {
                { type = "COMPLETE", questID = 9101, text = "Use Aerial Glide and report to Talon-Guard Vren" },
                { type = "TURNIN", questID = 9101, text = "Turn in [Wind-Trial: First Flight] to Talon-Guard Vren" },
                { type = "ACCEPT", questID = 9102, text = "Accept [Perch Predators] from Talon-Guard Vren" },
            }
        },
        {
            title = "Starter Bag & Mountain Provisions",
            zone = "Skyborne Sanctuary",
            coords = { x = 47.8, y = 49.5 },
            text = "Speak with Aerie Supplymaster Zephyr to secure your adventurer supplies and emergency satchel.",
            goals = {
                { type = "ACCEPT", questID = 9103, text = "Accept [Clifftop Provisions] from Supplymaster Zephyr (6-Slot Bag reward!)" },
            }
        },
        {
            title = "Clear Mountain Predators & Gather Provisions",
            zone = "Skyborne Sanctuary",
            text = "Defeat Sharpbeak Harriers along the crags and gather 6 Feathered Satchels.",
            goals = {
                { type = "COMPLETE", questID = 9102, text = "Slay 8 Sharpbeak Harriers for [Perch Predators]" },
                { type = "COMPLETE", questID = 9103, text = "Gather 6 Feathered Satchels for [Clifftop Provisions]" },
            }
        },
        {
            title = "Claim 6-Slot Bag & Class Rites",
            zone = "Skyborne Sanctuary",
            coords = { x = 47.8, y = 49.5 },
            text = "Turn in your quests to claim your 6-slot bag reward, equip it, and consult your trainer.",
            goals = {
                { type = "TURNIN", questID = 9103, text = "Turn in [Clifftop Provisions] to Supplymaster Zephyr (Equip Bag!)" },
                { type = "TURNIN", questID = 9102, text = "Turn in [Perch Predators] to Talon-Guard Vren" },
                { type = "LEVEL",  level = 2,       text = "Reach Level 2 and visit your Class Trainer" },
            }
        },
        {
            title = "Disturbed Wind Elementals",
            zone = "Skyborne Sanctuary",
            coords = { x = 52.0, y = 46.0 },
            text = "Venture into the Gusting Caverns to quell agitated Gust Elementals and collect Wind Essence.",
            goals = {
                { type = "ACCEPT", questID = 9104, text = "Accept [Calming the Tempest] from Gale-Shaper Thera" },
                { type = "COMPLETE", questID = 9104, text = "Collect 6 Whispering Wind Essences" },
                { type = "TURNIN", questID = 9104, text = "Turn in [Calming the Tempest] to Gale-Shaper Thera" },
                { type = "LEVEL",  level = 5,       text = "Reach Level 5" },
            }
        },
        {
            title = "Descent to Kalimdor: The Barrens",
            zone = "The Barrens",
            coords = { x = 52.2, y = 30.5 },
            text = "Take the flight descent or glide down to Crossroads in The Barrens to rendezvous with the Horde vanguard.",
            goals = {
                { type = "ACCEPT", questID = 9105, text = "Accept [Descent to the Crossroads] from Wind-Keeper Kaelen" },
                { type = "TURNIN", questID = 9105, text = "Turn in [Descent to the Crossroads] to Sergra Darkthorn" },
                { type = "HEARTH", location = "Crossroads", text = "Set your Hearthstone at the Crossroads Inn" },
                { type = "LEVEL",  level = 10,      text = "Reach Level 10 and prepare for Wailing Caverns" },
            }
        }
    }
})
