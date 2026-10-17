--[[
    Heathen's Forever Guide - Modules/Guides/Alliance/SkyborneAlliance_1_12.lua
    Step-by-Step Leveling Guide: Skyborne Aerie & Auberdine Descent (Levels 1–12)
]]

local ADDON_NAME, HFG = ...
if not HFG then HFG = _G.HFG end
if not HFG then return end

HFG:RegisterGuide({
    id = "Alliance_Skyborne_1_12",
    title = "Skyborne Aerie & Darkshore Descent (1–12)",
    faction = "Alliance",
    races = { "SKYBORNE_ALLIANCE" },
    minLevel = 1,
    maxLevel = 12,
    order = 1,
    steps = {
        {
            title = "Awakening on the Grand Pinnacle",
            zone = "Skyborne Aerie",
            coords = { x = 46.5, y = 51.0 },
            text = "Welcome to the high mountain peaks! Speak with High-Watcher Aeris to begin your initiation rites.",
            goals = {
                { type = "ACCEPT", questID = 9201, text = "Accept [Wind-Trial: Skybound Initiation] from High-Watcher Aeris" },
            }
        },
        {
            title = "Aerial Glide Practice to the Outpost",
            zone = "Skyborne Aerie",
            coords = { x = 48.0, y = 49.0 },
            text = "Leap from the Grand Pinnacle and use Aerial Glide to land safely at the Vanguard Terrace.",
            goals = {
                { type = "COMPLETE", questID = 9201, text = "Glide down and report to Sentinel Kora" },
                { type = "TURNIN", questID = 9201, text = "Turn in [Wind-Trial: Skybound Initiation] to Sentinel Kora" },
                { type = "ACCEPT", questID = 9202, text = "Accept [Harpy Intrusion] from Sentinel Kora" },
            }
        },
        {
            title = "Securing Mountain Provisions & Starter Bag",
            zone = "Skyborne Aerie",
            coords = { x = 46.8, y = 48.2 },
            text = "Speak with Quartermaster Gailen to acquire field rations and your initial 6-slot satchel.",
            goals = {
                { type = "ACCEPT", questID = 9203, text = "Accept [Rations for the Ridge] from Gailen (6-Slot Bag reward!)" },
            }
        },
        {
            title = "Repel Harpies & Gather Crag Lichen",
            zone = "Skyborne Aerie",
            text = "Defeat Cloudfeather Harpies along the rocky bluffs and harvest 8 Crag Lichen bundles.",
            goals = {
                { type = "COMPLETE", questID = 9202, text = "Slay 8 Cloudfeather Harpies for [Harpy Intrusion]" },
                { type = "COMPLETE", questID = 9203, text = "Gather 8 Crag Lichen bundles for [Rations for the Ridge]" },
            }
        },
        {
            title = "Claim 6-Slot Bag & Level 2 Training",
            zone = "Skyborne Aerie",
            coords = { x = 46.8, y = 48.2 },
            text = "Turn in your quests to claim your 6-slot bag reward, equip it, and consult your trainer.",
            goals = {
                { type = "TURNIN", questID = 9203, text = "Turn in [Rations for the Ridge] to Quartermaster Gailen (Equip Bag!)" },
                { type = "TURNIN", questID = 9202, text = "Turn in [Harpy Intrusion] to Sentinel Kora" },
                { type = "LEVEL",  level = 2,       text = "Reach Level 2 and visit your Class Trainer" },
            }
        },
        {
            title = "The Corrupted Breeze",
            zone = "Skyborne Aerie",
            coords = { x = 50.5, y = 43.5 },
            text = "Investigate the northern cliffside cave where shadow harpies have corrupted the wind currents.",
            goals = {
                { type = "ACCEPT", questID = 9204, text = "Accept [Shadow Over the Peak] from High-Watcher Aeris" },
                { type = "COMPLETE", questID = 9204, text = "Defeat Matron Darkfeather and recover the Wind Crystal" },
                { type = "TURNIN", questID = 9204, text = "Turn in [Shadow Over the Peak] to High-Watcher Aeris" },
                { type = "LEVEL",  level = 5,       text = "Reach Level 5" },
            }
        },
        {
            title = "Descent to Darkshore: Auberdine",
            zone = "Darkshore",
            coords = { x = 37.0, y = 44.0 },
            text = "Take the flight descent or glide down toward Darkshore to establish contact at Auberdine.",
            goals = {
                { type = "ACCEPT", questID = 9205, text = "Accept [Descent to Auberdine] from High-Watcher Aeris" },
                { type = "TURNIN", questID = 9205, text = "Turn in [Descent to Auberdine] to Terenthis at Auberdine" },
                { type = "HEARTH", location = "Auberdine", text = "Set Hearthstone at Auberdine Inn" },
                { type = "LEVEL",  level = 10,      text = "Reach Level 10 and prepare for Blackfathom Deeps" },
            }
        }
    }
})
