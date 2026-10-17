--[[
    Heathen's Forever Guide - Modules/Guides/Horde/OrcTroll_1_12.lua
    Step-by-Step Leveling Guide: Valley of Trials & Sen'jin Village (Levels 1–12)
]]

local ADDON_NAME, HFG = ...
if not HFG then HFG = _G.HFG end
if not HFG then return end

HFG:RegisterGuide({
    id = "Horde_OrcTroll_1_12",
    title = "Valley of Trials & Durotar (1–12)",
    faction = "Horde",
    races = { "Orc", "Troll" },
    minLevel = 1,
    maxLevel = 12,
    order = 1,
    steps = {
        {
            title = "Awakening in the Valley of Trials",
            zone = "Valley of Trials",
            text = "Welcome to Durotar! Speak with Kaltunk directly in front of the Den.",
            goals = {
                { type = "ACCEPT", questID = 1470, text = "Accept [Your Place In The World] from Kaltunk" },
            }
        },
        {
            title = "Report to Gornek",
            zone = "Valley of Trials",
            coords = { x = 44.5, y = 68.8 },
            text = "Head slightly north to Gornek outside the main building.",
            goals = {
                { type = "TURNIN", questID = 1470, text = "Turn in [Your Place In The World] to Gornek" },
                { type = "ACCEPT", questID = 4641, text = "Accept [Cutting Teeth] from Gornek" },
            }
        },
        {
            title = "Early Bag & Starting Supplies",
            zone = "Valley of Trials",
            coords = { x = 44.6, y = 68.2 },
            text = "Accept all available starter quests before leaving the compound.",
            goals = {
                { type = "ACCEPT", questID = 1005, text = "Accept [Carry Your Weight] from Furl Scornbrow (6-Slot Bag reward!)" },
                { type = "ACCEPT", questID = 792,  text = "Accept [Sarkoth] from Hana'zua (crawling on hill south)" },
            }
        },
        {
            title = "Clear Mottled Boars & Collect Canvas",
            zone = "Valley of Trials",
            text = "Slay Mottled Boars across the red dirt flats and loot Canvas Sacks scattered near cactus trees.",
            goals = {
                { type = "COMPLETE", questID = 4641, text = "Kill 10 Mottled Boars for [Cutting Teeth]" },
                { type = "COMPLETE", questID = 1005, text = "Loot 8 Canvas Sacks for [Carry Your Weight]" },
            }
        },
        {
            title = "Claim Your First Bag & Class Trainer",
            zone = "Valley of Trials",
            coords = { x = 44.5, y = 68.8 },
            text = "Return to Gornek and Furl Scornbrow to claim your 6-Slot Bag reward and train level 2 abilities.",
            goals = {
                { type = "TURNIN", questID = 4641, text = "Turn in [Cutting Teeth] to Gornek" },
                { type = "TURNIN", questID = 1005, text = "Turn in [Carry Your Weight] to Furl Scornbrow (Equip Bag!)" },
                { type = "LEVEL",  level = 2,       text = "Reach Level 2 and visit your Class Trainer" },
            }
        },
        {
            title = "Scorpid & Apple Harvest",
            zone = "Valley of Trials",
            text = "Pick up [Sting of the Scorpid] and [Galgar's Cactus Apple Surprise].",
            goals = {
                { type = "ACCEPT", questID = 788,  text = "Accept [Sting of the Scorpid] from Gornek" },
                { type = "ACCEPT", questID = 4402, text = "Accept [Galgar's Cactus Apple Surprise] from Galgar" },
            }
        },
        {
            title = "Slay Sarkoth & Farm Cactus Apples",
            zone = "Valley of Trials",
            coords = { x = 40.6, y = 67.2 },
            text = "Head into the southwest canyon to slay the rare scorpion Sarkoth for Hana'zua.",
            goals = {
                { type = "COMPLETE", questID = 792,  text = "Slay Sarkoth and loot Sarkoth's Claw" },
                { type = "COMPLETE", questID = 788,  text = "Loot 10 Scorpid Tails" },
                { type = "COMPLETE", questID = 4402, text = "Gather 10 Cactus Apples" },
            }
        },
        {
            title = "Complete Valley of Trials Training",
            zone = "Valley of Trials",
            text = "Turn in Sarkoth to Hana'zua, then turn in tails and apples at the compound.",
            goals = {
                { type = "TURNIN", questID = 792,  text = "Turn in [Sarkoth] to Hana'zua" },
                { type = "TURNIN", questID = 788,  text = "Turn in [Sting of the Scorpid] to Gornek" },
                { type = "TURNIN", questID = 4402, text = "Turn in [Galgar's Cactus Apple Surprise] to Galgar" },
                { type = "LEVEL",  level = 4,       text = "Reach Level 4" },
            }
        },
        {
            title = "Burning Blade Invasion (Hidden Cavern)",
            zone = "Valley of Trials",
            coords = { x = 42.1, y = 52.8 },
            text = "Enter the hidden cavern north and defeat Yarrog Baneshadow's familiars.",
            goals = {
                { type = "ACCEPT", questID = 794,  text = "Accept [Vile Familiars] from Zuretha Fargon" },
                { type = "COMPLETE", questID = 794, text = "Kill 12 Vile Familiars and loot Felhound collars" },
                { type = "TURNIN", questID = 794,  text = "Turn in [Vile Familiars] to Zuretha Fargon" },
            }
        },
        {
            title = "Leave for Sen'jin Village",
            zone = "Durotar",
            coords = { x = 55.8, y = 74.4 },
            text = "Exit the Valley of Trials east through the ravine gate and follow the trail southeast to Sen'jin Village.",
            goals = {
                { type = "LEVEL",  level = 6,       text = "Reach Level 6" },
                { type = "ACCEPT", questID = 2161, text = "Accept [Report to Sen'jin Village]" },
                { type = "TURNIN", questID = 2161, text = "Turn in [Report to Sen'jin Village] to Master Gadrin" },
            }
        }
    }
})
