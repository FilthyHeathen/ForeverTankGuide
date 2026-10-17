--[[
    Heathen's Forever Guide - Modules/Guides/Alliance/Human_1_12.lua
    Step-by-Step Leveling Guide: Northshire Abbey & Elwynn Forest (Levels 1–12)
]]

local ADDON_NAME, HFG = ...
if not HFG then HFG = _G.HFG end
if not HFG then return end

HFG:RegisterGuide({
    id = "Alliance_Human_1_12",
    title = "Northshire & Elwynn Forest (1–12)",
    faction = "Alliance",
    races = { "Human" },
    minLevel = 1,
    maxLevel = 12,
    order = 1,
    steps = {
        {
            title = "A Threat Within Northshire",
            zone = "Northshire Valley",
            text = "Welcome to Northshire Abbey! Speak with Deputy Willem standing outside the Abbey entrance.",
            goals = {
                { type = "ACCEPT", questID = 783,  text = "Accept [A Threat Within] from Deputy Willem" },
                { type = "TURNIN", questID = 783,  text = "Turn in [A Threat Within] to Marshal McBride inside" },
                { type = "ACCEPT", questID = 7,    text = "Accept [Kobold Vermin] from Marshal McBride" },
            }
        },
        {
            title = "Starter Bag & Northshire Vineyard",
            zone = "Northshire Valley",
            coords = { x = 48.2, y = 41.6 },
            text = "Speak with Brother Danil and Milly Osworth at the vineyard.",
            goals = {
                { type = "ACCEPT", questID = 1001, text = "Accept [Book Return] from Marshal Dughan (6-Slot Bag reward!)" },
                { type = "ACCEPT", questID = 3903, text = "Accept [Milly Osworth] from Milly" },
            }
        },
        {
            title = "Kobold Vermin & Milly's Harvest",
            zone = "Northshire Valley",
            text = "Defeat Kobold Vermin around the pumpkin patch and gather 8 Milly's Harvest buckets.",
            goals = {
                { type = "COMPLETE", questID = 7,    text = "Kill 10 Kobold Vermin" },
                { type = "COMPLETE", questID = 3903, text = "Gather 8 Milly's Harvest buckets" },
            }
        },
        {
            title = "Claim 6-Slot Bag & Report to McBride",
            zone = "Northshire Valley",
            coords = { x = 48.9, y = 41.5 },
            text = "Turn in completed quests and equip your first 6-slot bag reward.",
            goals = {
                { type = "TURNIN", questID = 1001, text = "Turn in [Book Return] (Equip Bag!)" },
                { type = "TURNIN", questID = 7,    text = "Turn in [Kobold Vermin] to Marshal McBride" },
                { type = "TURNIN", questID = 3903, text = "Turn in [Milly Osworth] to Milly" },
                { type = "LEVEL",  level = 2,       text = "Reach Level 2 and visit your Class Trainer" },
            }
        },
        {
            title = "The Defias Brotherhood & Kobold Workers",
            zone = "Northshire Valley",
            text = "Pick up [Brotherhood of Thieves] and [Kobold Workers Needed].",
            goals = {
                { type = "ACCEPT", questID = 18, text = "Accept [Brotherhood of Thieves] from Deputy Willem" },
                { type = "ACCEPT", questID = 15, text = "Accept [Investigate Echo Ridge] from McBride" },
            }
        },
        {
            title = "Echo Ridge Mine & Defias Bandits",
            zone = "Northshire Valley",
            coords = { x = 47.4, y = 31.8 },
            text = "Head north to Echo Ridge Mine and defeat Kobold Workers and Defias Bandits.",
            goals = {
                { type = "COMPLETE", questID = 18, text = "Collect 12 Red Burlap Bandanas from Defias Bandits" },
                { type = "COMPLETE", questID = 15, text = "Kill 10 Kobold Workers at Echo Ridge Mine" },
            }
        },
        {
            title = "Complete Northshire Training",
            zone = "Northshire Valley",
            text = "Turn in both quests at Northshire Abbey and prepare to journey south.",
            goals = {
                { type = "TURNIN", questID = 18, text = "Turn in [Brotherhood of Thieves] to Deputy Willem" },
                { type = "TURNIN", questID = 15, text = "Turn in [Investigate Echo Ridge] to McBride" },
                { type = "LEVEL",  level = 5,    text = "Reach Level 5" },
            }
        },
        {
            title = "Report to Goldshire",
            zone = "Elwynn Forest",
            coords = { x = 42.1, y = 65.9 },
            text = "Exit Northshire gates south and follow the road directly into the Lion's Pride Inn in Goldshire.",
            goals = {
                { type = "ACCEPT", questID = 54, text = "Accept [Report to Goldshire] from Marshal McBride" },
                { type = "TURNIN", questID = 54, text = "Turn in [Report to Goldshire] to Marshal Dughan" },
                { type = "HEARTH", location = "Lion's Pride Inn", text = "Set Hearthstone at Lion's Pride Inn with Innkeeper Farley" },
            }
        }
    }
})
