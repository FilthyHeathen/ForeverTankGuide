--[[
    Heathen's Forever Guide - Modules/Guides/Alliance/NightElf_1_12.lua
    Step-by-Step Leveling Guide: Shadowglen & Teldrassil (Levels 1–12)
]]

local ADDON_NAME, HFG = ...
if not HFG then HFG = _G.HFG end
if not HFG then return end

HFG:RegisterGuide({
    id = "Alliance_NightElf_1_12",
    title = "Shadowglen & Teldrassil (1–12)",
    faction = "Alliance",
    races = { "NightElf" },
    minLevel = 1,
    maxLevel = 12,
    order = 1,
    steps = {
        {
            title = "Awakening in Shadowglen",
            zone = "Shadowglen",
            coords = { x = 58.0, y = 40.0 },
            text = "Welcome to Teldrassil! Speak with Conservator Ilthalaine under the great boughs.",
            goals = {
                { type = "ACCEPT", questID = 456, text = "Accept [The Balance of Nature] from Conservator Ilthalaine" },
            }
        },
        {
            title = "Starter Bag & Fel Moss Scavenging",
            zone = "Shadowglen",
            coords = { x = 58.5, y = 41.0 },
            text = "Speak with Dirania Silvershine to start your starter 6-slot bag quest.",
            goals = {
                { type = "ACCEPT", questID = 1003, text = "Accept [Shadowglen Provisions] (6-Slot Bag reward!)" },
            }
        },
        {
            title = "Balance of Nature & Young Boars",
            zone = "Shadowglen",
            text = "Defeat Young Nightsabers and Mangy Nightsabers and gather moss.",
            goals = {
                { type = "COMPLETE", questID = 456,  text = "Kill 7 Young Nightsabers and 4 Mangy Nightsabers" },
                { type = "COMPLETE", questID = 1003, text = "Gather 6 Teldrassil Lichen bundles for your 6-Slot Bag" },
                { type = "TURNIN",   questID = 456,  text = "Turn in [The Balance of Nature] to Conservator Ilthalaine" },
                { type = "TURNIN",   questID = 1003, text = "Turn in [Shadowglen Provisions] (Equip 6-Slot Bag!)" },
                { type = "LEVEL",    level = 2,      text = "Reach Level 2 and visit your Class Trainer" },
            }
        },
        {
            title = "Fel Moss & Grellkin Clearing",
            zone = "Shadowglen",
            coords = { x = 60.0, y = 35.0 },
            text = "Cleanse the corrupted Grellkin and retrieve the tainted wood.",
            goals = {
                { type = "ACCEPT",   questID = 457, text = "Accept [Fel Moss Corruption]" },
                { type = "COMPLETE", questID = 457, text = "Collect 8 Fel Moss from Grellkin" },
                { type = "TURNIN",   questID = 457, text = "Turn in [Fel Moss Corruption]" },
                { type = "LEVEL",    level = 6,     text = "Reach Level 6 and journey down to Dolanaar" },
            }
        },
        {
            title = "Dolanaar & Darnassus",
            zone = "Teldrassil",
            coords = { x = 55.5, y = 56.5 },
            text = "Follow the road south to Dolanaar. Set hearthstone and visit Darnassus.",
            goals = {
                { type = "HEARTH", location = "Dolanaar", text = "Set Hearthstone at Dolanaar Inn" },
                { type = "FLY",    text = "Visit Darnassus and discover Darnassus Flight Path" },
                { type = "LEVEL",  level = 12,    text = "Reach Level 12 and take the boat to Darkshore (Auberdine)" },
            }
        }
    }
})
