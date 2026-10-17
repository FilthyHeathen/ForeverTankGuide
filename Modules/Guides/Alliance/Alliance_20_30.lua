--[[
    Heathen's Forever Guide - Modules/Guides/Alliance/Alliance_20_30.lua
    Step-by-Step Leveling Guide: Duskwood, Wetlands & Southshore (Levels 20–30)
]]

local ADDON_NAME, HFG = ...
if not HFG then HFG = _G.HFG end
if not HFG then return end

HFG:RegisterGuide({
    id = "Alliance_Mid_20_30",
    title = "Duskwood, Wetlands & Southshore (20–30)",
    faction = "Alliance",
    minLevel = 20,
    maxLevel = 30,
    order = 3,
    steps = {
        {
            title = "Arrival in Darkshire (Duskwood)",
            zone = "Duskwood",
            coords = { x = 73.5, y = 44.5 },
            text = "Welcome to the shrouded forest of Duskwood! Grab the flight path, set hearthstone, and report to Night Watch commander Althea Ebonlocke.",
            goals = {
                { type = "FLY",    text = "Discover Darkshire Flight Path" },
                { type = "HEARTH", location = "Darkshire", text = "Set Hearthstone at the Scarlet Raven Tavern in Darkshire" },
                { type = "ACCEPT", questID = 56,  text = "Accept [The Night Watch] from Commander Althea Ebonlocke" },
                { type = "ACCEPT", questID = 163, text = "Accept [Raven Hill] from Jitters" },
                { type = "ACCEPT", questID = 93,  text = "Accept [The Hermit] from Madame Eva" },
            }
        },
        {
            title = "The Night Watch & The Rotting Orchard",
            zone = "Duskwood",
            coords = { x = 60.0, y = 50.0 },
            text = "Patrol the cemetery grounds and orchards west of Darkshire to defeat Skeletal Warriors and Ghouls.",
            goals = {
                { type = "COMPLETE", questID = 56, text = "Kill 8 Skeletal Warriors and 6 Skeletal Mages" },
                { type = "TURNIN",   questID = 56, text = "Turn in [The Night Watch] to Commander Althea" },
                { type = "LEVEL",    level = 23,    text = "Reach Level 23" },
            }
        },
        {
            title = "Raven Hill Cemetery & Abercrombie",
            zone = "Duskwood",
            coords = { x = 28.0, y = 31.0 },
            text = "Journey far west along the foggy road to Raven Hill Cemetery and visit the Hermit Abercrombie.",
            goals = {
                { type = "COMPLETE", questID = 93,  text = "Speak with Abercrombie at his hovel" },
                { type = "TURNIN",   questID = 93,  text = "Turn in [The Hermit] to Abercrombie" },
                { type = "ACCEPT",   questID = 227, text = "Accept [The Legend of Stalvan] from Madame Eva" },
                { type = "LEVEL",    level = 25,    text = "Reach Level 25 and beware of Stitches on the road!" },
            }
        },
        {
            title = "Wetlands: Menethil Harbor & Greenwarden",
            zone = "Wetlands",
            coords = { x = 10.5, y = 60.0 },
            text = "Take the Deeprun Tram or fly to Ironforge, travel through Loch Modan to Wetlands, and discover Menethil Harbor.",
            goals = {
                { type = "FLY",    text = "Discover Menethil Harbor Flight Path" },
                { type = "ACCEPT", questID = 279, text = "Accept [Digging Through the Ooze] from Sida" },
                { type = "ACCEPT", questID = 285, text = "Accept [The Absent Minded Prospector]" },
                { type = "LEVEL",  level = 27,    text = "Reach Level 27" },
            }
        },
        {
            title = "Hillsbrad Foothills: Southshore Outpost",
            zone = "Hillsbrad Foothills",
            coords = { x = 50.0, y = 56.0 },
            text = "Take the boat or run north along the coast into Southshore. Discover the flight path and pick up syndicate/coastal bounties.",
            goals = {
                { type = "FLY",    text = "Discover Southshore Flight Path" },
                { type = "ACCEPT", questID = 505, text = "Accept [Syndicate Assassins] from Magistrate Burnside" },
                { type = "ACCEPT", questID = 538, text = "Accept [Costly Menace] from Darren Malvew" },
                { type = "LEVEL",  level = 30,    text = "Reach Level 30 and prepare for Arathi Highlands & Stranglethorn Vale" },
            }
        }
    }
})
