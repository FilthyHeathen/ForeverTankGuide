--[[
    Heathen's Forever Guide - Modules/Guides/Alliance/Alliance_12_20.lua
    Step-by-Step Leveling Guide: Westfall, Redridge & Darkshore (Levels 12–20)
]]

local ADDON_NAME, HFG = ...
if not HFG then HFG = _G.HFG end
if not HFG then return end

HFG:RegisterGuide({
    id = "Alliance_Mid_12_20",
    title = "Westfall & Redridge Mountains (12–20)",
    faction = "Alliance",
    minLevel = 12,
    maxLevel = 20,
    order = 2,
    steps = {
        {
            title = "Sentinel Hill & Westfall Defense",
            zone = "Westfall",
            coords = { x = 56.5, y = 47.5 },
            text = "Welcome to Westfall! Grab the Sentinel Hill flight path, bind hearthstone, and speak with Gryan Stoutmantle.",
            goals = {
                { type = "FLY",    text = "Discover Sentinel Hill Flight Path" },
                { type = "HEARTH", location = "Sentinel Hill", text = "Set Hearthstone at Sentinel Hill" },
                { type = "ACCEPT", questID = 102, text = "Accept [The People's Militia] from Gryan Stoutmantle" },
                { type = "ACCEPT", questID = 151, text = "Accept [Poor Old Blanchy] from Verna Furlbrow" },
                { type = "ACCEPT", questID = 22,  text = "Accept [Goretusk Liver Pie] from Salma Saldean" },
            }
        },
        {
            title = "The People's Militia & Farm Pests",
            zone = "Westfall",
            coords = { x = 48.0, y = 35.0 },
            text = "Patrol the northern farms to defeat Defias Trappers, harvest oats for Blanchy, and hunt Goretusks.",
            goals = {
                { type = "COMPLETE", questID = 102, text = "Kill 15 Defias Trappers and 15 Defias Smugglers" },
                { type = "COMPLETE", questID = 151, text = "Collect 8 Handfuls of Oats for Blanchy" },
                { type = "COMPLETE", questID = 22,  text = "Collect 8 Goretusk Livers and Okra" },
                { type = "TURNIN",   questID = 102, text = "Turn in [The People's Militia] to Gryan Stoutmantle" },
                { type = "TURNIN",   questID = 151, text = "Turn in [Poor Old Blanchy] to Verna Furlbrow" },
                { type = "TURNIN",   questID = 22,  text = "Turn in [Goretusk Liver Pie] to Salma Saldean" },
                { type = "LEVEL",    level = 16,    text = "Reach Level 16" },
            }
        },
        {
            title = "Lakeshire & Redridge Mountains Outpost",
            zone = "Redridge Mountains",
            coords = { x = 30.5, y = 46.0 },
            text = "Journey east into Redridge Mountains. Cross the stone bridge into Lakeshire.",
            goals = {
                { type = "FLY",    text = "Discover Lakeshire Flight Path" },
                { type = "ACCEPT", questID = 120, text = "Accept [Redridge Goulash] from Chef Brell" },
                { type = "ACCEPT", questID = 126, text = "Accept [Blackrock Menace] from Deputy Feldon" },
                { type = "LEVEL",  level = 18,    text = "Reach Level 18" },
            }
        },
        {
            title = "The Deadmines Infiltration",
            zone = "Westfall",
            coords = { x = 42.5, y = 72.0 },
            text = "Prepare to venture into Moonbrook and storm the Deadmines instance.",
            goals = {
                { type = "ACCEPT", questID = 155, text = "Accept [The Defias Brotherhood] from Gryan Stoutmantle" },
                { type = "LEVEL",  level = 20,    text = "Reach Level 20 and prepare for Duskwood" },
            }
        }
    }
})
