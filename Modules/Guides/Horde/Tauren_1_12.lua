--[[
    Heathen's Forever Guide - Modules/Guides/Horde/Tauren_1_12.lua
    Step-by-Step Leveling Guide: Camp Narache & Mulgore (Levels 1–12)
]]

local ADDON_NAME, HFG = ...
if not HFG then HFG = _G.HFG end
if not HFG then return end

HFG:RegisterGuide({
    id = "Horde_Tauren_1_12",
    title = "Camp Narache & Mulgore (1–12)",
    faction = "Horde",
    races = { "Tauren" },
    minLevel = 1,
    maxLevel = 12,
    order = 1,
    steps = {
        {
            title = "Awakening on Red Cloud Mesa",
            zone = "Camp Narache",
            coords = { x = 44.5, y = 76.5 },
            text = "Welcome to the sacred plains of Mulgore! Speak with Chief Hawkwind in the center of Camp Narache.",
            goals = {
                { type = "ACCEPT", questID = 747, text = "Accept [The First Step] from Chief Hawkwind" },
                { type = "TURNIN", questID = 747, text = "Turn in [The First Step] to Grull Hawkwind" },
                { type = "ACCEPT", questID = 752, text = "Accept [A Humble Task] from Greatmother Hawkwind" },
            }
        },
        {
            title = "Starter Bag & Plainstrider Feed",
            zone = "Camp Narache",
            coords = { x = 45.0, y = 76.0 },
            text = "Speak with Antur Fallow to start your starter bag quest and collect water pitchers.",
            goals = {
                { type = "ACCEPT", questID = 1006, text = "Accept [Plainstrider Scavenging] (6-Slot Bag reward!)" },
                { type = "ACCEPT", questID = 753,  text = "Accept [Rites of the Earthmother] from Grull Hawkwind" },
            }
        },
        {
            title = "Cull Plainstriders & Collect Water Pitchers",
            zone = "Camp Narache",
            text = "Hunt Plainstriders across Red Cloud Mesa and collect Water Pitchers from the well.",
            goals = {
                { type = "COMPLETE", questID = 752,  text = "Fetch water pitcher from the water well" },
                { type = "COMPLETE", questID = 1006, text = "Gather 6 Plainstrider Feathers for your 6-Slot Bag" },
                { type = "TURNIN",   questID = 752,  text = "Turn in [A Humble Task] to Greatmother Hawkwind" },
                { type = "TURNIN",   questID = 1006, text = "Turn in [Plainstrider Scavenging] (Equip 6-Slot Bag!)" },
                { type = "LEVEL",    level = 2,      text = "Reach Level 2 and visit your Class Trainer" },
            }
        },
        {
            title = "Bristleback Threat & Pine Nuts",
            zone = "Camp Narache",
            coords = { x = 48.0, y = 82.0 },
            text = "Slay Bristleback Battleboars along the southern ridge and collect pine nuts.",
            goals = {
                { type = "ACCEPT",   questID = 757, text = "Accept [The Battleboars] from Grull Hawkwind" },
                { type = "COMPLETE", questID = 757, text = "Kill 8 Bristleback Battleboars" },
                { type = "TURNIN",   questID = 757, text = "Turn in [The Battleboars] to Grull Hawkwind" },
                { type = "LEVEL",    level = 6,     text = "Reach Level 6 and prepare to leave the Mesa" },
            }
        },
        {
            title = "Descend to Bloodhoof Village",
            zone = "Mulgore",
            coords = { x = 46.5, y = 60.5 },
            text = "Descend Red Cloud Mesa through the northern path and follow the road to Bloodhoof Village.",
            goals = {
                { type = "HEARTH", location = "Bloodhoof Village", text = "Set Hearthstone at Bloodhoof Village Inn" },
                { type = "ACCEPT", questID = 763, text = "Accept [Sharing the Land] from Baine Bloodhoof" },
                { type = "ACCEPT", questID = 744, text = "Accept [Dangers of the Windfury] from Ruul Eagletalon" },
            }
        },
        {
            title = "Thunder Bluff & The Barrens Onward",
            zone = "Mulgore",
            coords = { x = 60.0, y = 51.5 },
            text = "Deliver offerings to the elders atop the great mesas of Thunder Bluff, then head east to The Barrens.",
            goals = {
                { type = "FLY",    text = "Discover Thunder Bluff Flight Path" },
                { type = "LEVEL",  level = 12,    text = "Reach Level 12 and proceed to The Crossroads" },
            }
        }
    }
})
