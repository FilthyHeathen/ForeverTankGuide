--[[
    Heathen's Forever Guide - Modules/Guides/Alliance/DwarfGnome_1_12.lua
    Step-by-Step Leveling Guide: Coldridge Valley & Dun Morogh (Levels 1–12)
]]

local ADDON_NAME, HFG = ...
if not HFG then HFG = _G.HFG end
if not HFG then return end

HFG:RegisterGuide({
    id = "Alliance_DwarfGnome_1_12",
    title = "Coldridge Valley & Dun Morogh (1–12)",
    faction = "Alliance",
    races = { "Dwarf", "Gnome" },
    minLevel = 1,
    maxLevel = 12,
    order = 1,
    steps = {
        {
            title = "Awakening in Coldridge Valley",
            zone = "Coldridge Valley",
            coords = { x = 28.5, y = 67.5 },
            text = "Welcome to the snowy peaks of Dun Morogh! Speak with Jherrhart inside the Anvilmar bunker.",
            goals = {
                { type = "ACCEPT", questID = 179, text = "Accept [Dwarven Outfitters] from Grelin Whitebeard" },
                { type = "ACCEPT", questID = 182, text = "Accept [The Boar Threat] from Sten Stoutarm" },
            }
        },
        {
            title = "Starter Bag & Coldridge Supplies",
            zone = "Coldridge Valley",
            coords = { x = 28.8, y = 67.2 },
            text = "Speak with Thorek at the camp to secure your starter 6-slot bag quest.",
            goals = {
                { type = "ACCEPT", questID = 1002, text = "Accept [Coldridge Scavenging] (6-Slot Bag reward!)" },
            }
        },
        {
            title = "Cull Mountain Boars & Troggs",
            zone = "Coldridge Valley",
            text = "Defeat Mountain Boars and Rockjaw Troggs in the snowdrift plains.",
            goals = {
                { type = "COMPLETE", questID = 182,  text = "Kill 8 Small Mountain Boars" },
                { type = "COMPLETE", questID = 1002, text = "Collect 6 Thick Boar Ribs for your 6-Slot Bag" },
                { type = "COMPLETE", questID = 179,  text = "Collect 8 Restocked Wolf Pelts" },
                { type = "TURNIN",   questID = 182,  text = "Turn in [The Boar Threat] to Sten Stoutarm" },
                { type = "TURNIN",   questID = 1002, text = "Turn in [Coldridge Scavenging] (Equip 6-Slot Bag!)" },
                { type = "TURNIN",   questID = 179,  text = "Turn in [Dwarven Outfitters] to Grelin Whitebeard" },
                { type = "LEVEL",    level = 2,      text = "Reach Level 2 and visit your Class Trainer" },
            }
        },
        {
            title = "Frostmane Trolls & The Pass",
            zone = "Coldridge Valley",
            coords = { x = 25.0, y = 74.0 },
            text = "Clear the Frostmane Troll camp south and retrieve Felix's lost gear.",
            goals = {
                { type = "ACCEPT",   questID = 183, text = "Accept [The Troll Cave]" },
                { type = "COMPLETE", questID = 183, text = "Slay 14 Frostmane Novices" },
                { type = "TURNIN",   questID = 183, text = "Turn in [The Troll Cave]" },
                { type = "LEVEL",    level = 6,     text = "Reach Level 6 and journey through Coldridge Pass to Kharanos" },
            }
        },
        {
            title = "Kharanos & Thunderbrew Distillery",
            zone = "Dun Morogh",
            coords = { x = 46.5, y = 52.5 },
            text = "Follow the road east out of the tunnel to Kharanos. Set hearthstone and discover Ironforge.",
            goals = {
                { type = "HEARTH", location = "Kharanos", text = "Set Hearthstone at the Thunderbrew Inn in Kharanos" },
                { type = "FLY",    text = "Run into Ironforge and discover Ironforge Flight Path" },
                { type = "LEVEL",  level = 12,    text = "Reach Level 12 and prepare for Loch Modan" },
            }
        }
    }
})
