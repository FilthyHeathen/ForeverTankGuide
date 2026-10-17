--[[
    Heathen's Forever Guide - Modules/Guides/Alliance/Alliance_30_40.lua
    Step-by-Step Leveling Guide: Stranglethorn Vale, Arathi & Badlands (Levels 30–40)
]]

local ADDON_NAME, HFG = ...
if not HFG then HFG = _G.HFG end
if not HFG then return end

HFG:RegisterGuide({
    id = "Alliance_Mid_30_40",
    title = "Stranglethorn Vale, Arathi & Badlands (30–40)",
    category = "Leveling",
    faction = "Alliance",
    minLevel = 30,
    maxLevel = 40,
    order = 4,
    steps = {
        {
            title = "Rebel Camp & Northern Stranglethorn",
            zone = "Stranglethorn Vale",
            coords = { x = 37.5, y = 3.5 },
            text = "Welcome to Stranglethorn Vale! Establish base at the Rebel Camp just south of the Duskwood river border.",
            goals = {
                { type = "ACCEPT", questID = 202, text = "Accept [Krazek's Cookery] from Corporal Kaleb" },
                { type = "ACCEPT", questID = 575, text = "Accept [The Second Rebellion] from Lieutenant Doren" },
                { type = "ACCEPT", questID = 185, text = "Visit Nesingwary's Expedition camp and accept [Tiger Mastery]" },
            }
        },
        {
            title = "Nesingwary Hunts & Kurzen Jungle Outpost",
            zone = "Stranglethorn Vale",
            coords = { x = 44.0, y = 10.0 },
            text = "Defeat Kurzen Jungle Fighters and complete first-tier beast hunts across northern Stranglethorn.",
            goals = {
                { type = "COMPLETE", questID = 575, text = "Kill 10 Kurzen Jungle Fighters" },
                { type = "COMPLETE", questID = 185, text = "Kill 10 Young Stranglethorn Tigers" },
                { type = "TURNIN",   questID = 575, text = "Turn in [The Second Rebellion] at Rebel Camp" },
                { type = "TURNIN",   questID = 185, text = "Turn in [Tiger Mastery] at Nesingwary" },
                { type = "LEVEL",    level = 33,    text = "Reach Level 33 and take the boat to Booty Bay" },
            }
        },
        {
            title = "Refuge Pointe & Arathi Highlands",
            zone = "Arathi Highlands",
            coords = { x = 46.0, y = 46.0 },
            text = "Travel north from Wetlands through the Thandol Span into Arathi Highlands and report to Refuge Pointe.",
            goals = {
                { type = "FLY",    text = "Discover Refuge Pointe Flight Path" },
                { type = "HEARTH", location = "Refuge Pointe", text = "Set Hearthstone at Refuge Pointe" },
                { type = "ACCEPT", questID = 639, text = "Accept [Worth Its Weight in Gold]" },
                { type = "ACCEPT", questID = 654, text = "Accept [Northfold Manor] from Captain Nials" },
            }
        },
        {
            title = "Syndicate Operations & Stromgarde Keep",
            zone = "Arathi Highlands",
            coords = { x = 30.0, y = 28.0 },
            text = "Assault Northfold Manor to slay Syndicate rogues and recover stolen insignias.",
            goals = {
                { type = "COMPLETE", questID = 654, text = "Slay 10 Syndicate Highwaymen and 10 Mercenaries" },
                { type = "TURNIN",   questID = 654, text = "Turn in [Northfold Manor] at Refuge Pointe" },
                { type = "LEVEL",    level = 36,    text = "Reach Level 36" },
            }
        },
        {
            title = "Badlands Expedition & Level 40 Mount!",
            zone = "Badlands",
            coords = { x = 65.0, y = 43.0 },
            text = "Travel south through Loch Modan into the dust of Badlands. Slay rock elementals and coyotes.",
            goals = {
                { type = "ACCEPT", questID = 716, text = "Accept [Coyote Thieves] and collect Coyote Jowls" },
                { type = "COMPLETE", questID = 716, text = "Collect 30 Coyote Jowls" },
                { type = "TURNIN",   questID = 716, text = "Turn in [Coyote Thieves]" },
                { type = "LEVEL",    level = 40,    text = "Reach Level 40, purchase your Mount, and train Level 40 abilities!" },
            }
        }
    }
})
