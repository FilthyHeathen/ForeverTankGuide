--[[
    Heathen's Forever Guide - Modules/Guides/Alliance/Alliance_50_60.lua
    Step-by-Step Leveling Guide: Un'Goro Crater, Felwood & Plaguelands (Levels 50–60)
]]

local ADDON_NAME, HFG = ...
if not HFG then HFG = _G.HFG end
if not HFG then return end

HFG:RegisterGuide({
    id = "Alliance_Endgame_50_60",
    title = "Un'Goro Crater, Felwood & Plaguelands (50–60)",
    category = "Leveling",
    faction = "Alliance",
    minLevel = 50,
    maxLevel = 60,
    order = 6,
    steps = {
        {
            title = "Descent into Un'Goro Crater",
            zone = "Un'Goro Crater",
            coords = { x = 44.0, y = 10.0 },
            text = "Enter Un'Goro Crater from southern Tanaris and establish base at Marshal's Refuge.",
            goals = {
                { type = "FLY",    text = "Discover Marshal's Refuge Flight Path" },
                { type = "HEARTH", location = "Marshal's Refuge", text = "Set Hearthstone at Marshal's Refuge" },
                { type = "ACCEPT", questID = 3881, text = "Accept [The Pylon Towers] and gather Blue/Yellow/Red Power Crystals" },
                { type = "ACCEPT", questID = 4287, text = "Accept [Alien Ecology] from Holiy Maker" },
                { type = "ACCEPT", questID = 4491, text = "Accept [Shizzle's Flyer] from Shizzle" },
            }
        },
        {
            title = "The Un'Goro Circular Route",
            zone = "Un'Goro Crater",
            coords = { x = 50.0, y = 50.0 },
            text = "Defeat Gorishi silithid, Stegodons, and Pterodactyls while gathering dinosaur bones.",
            goals = {
                { type = "COMPLETE", questID = 4287, text = "Collect 8 Un'Goro Gorilla Pelts" },
                { type = "COMPLETE", questID = 4491, text = "Collect 8 Pterodactyl Wings and 8 Dinosaur Scales" },
                { type = "TURNIN",   questID = 4287, text = "Turn in [Alien Ecology]" },
                { type = "TURNIN",   questID = 4491, text = "Turn in [Shizzle's Flyer]" },
                { type = "LEVEL",    level = 53,     text = "Reach Level 53" },
            }
        },
        {
            title = "Chillwind Camp (Western Plaguelands)",
            zone = "Western Plaguelands",
            coords = { x = 43.0, y = 84.5 },
            text = "Fly to Southshore and ride north through the mountain pass into Chillwind Camp (WPL).",
            goals = {
                { type = "FLY",    text = "Discover Chillwind Camp Flight Path" },
                { type = "ACCEPT", questID = 5096, text = "Accept [A Matter of Time] from Chromie" },
                { type = "ACCEPT", questID = 5211, text = "Accept [Target: Felstone Field] (Cauldron Chain)" },
                { type = "COMPLETE", questID = 5211, text = "Defeat Cauldron Lord Bilemouth and loot the key" },
                { type = "TURNIN",   questID = 5211, text = "Turn in [Target: Felstone Field] at Chillwind Camp" },
                { type = "LEVEL",    level = 56,     text = "Reach Level 56" },
            }
        },
        {
            title = "Light's Hope Chapel & Level 60!",
            zone = "Eastern Plaguelands",
            coords = { x = 81.5, y = 58.0 },
            text = "Ride through the plagued ruins of Darrowshire and Corin's Crossing to Light's Hope Chapel.",
            goals = {
                { type = "FLY",    text = "Discover Light's Hope Chapel Flight Path" },
                { type = "HEARTH", location = "Light's Hope Chapel", text = "Set Hearthstone at Light's Hope Chapel" },
                { type = "ACCEPT", questID = 6023, text = "Accept [The Argent Dawn Commission] and equip your trinket" },
                { type = "LEVEL",  level = 60,     text = "CONGRATULATIONS! Reach Level 60 and begin Endgame Attunements!" },
            }
        }
    }
})
