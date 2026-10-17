--[[
    Heathen's Forever Guide - Modules/Guides/ClassQuests/Paladin.lua
    Full 1–60 Class Quest Progression Guide for Paladins
    Covers: Redemption (12), Verigan's Fist (20), Sunken Temple (50), Epic Charger (60).
]]

local ADDON_NAME, HFG = ...
if not HFG then HFG = _G.HFG end
if not HFG then return end

HFG:RegisterGuide({
    id = "ClassQuest_Paladin",
    title = "Paladin Class Progression (1–60: Redemption, Verigan's Fist, Epic Charger)",
    category = "Class Quests",
    faction = "Alliance",
    classes = { "PALADIN" },
    minLevel = 10,
    maxLevel = 60,
    order = 201,
    steps = {
        {
            title = "1. Level 12: The Tome of Divinity (Redemption / Resurrection)",
            zone = "Stormwind / Ironforge",
            coords = { x = 39.0, y = 29.0 },
            text = "Unlocks the essential resurrection spell [Redemption].\n" ..
                   "• Human Paladins: Speak to Duthorian Rall in Stormwind Cathedral to receive [The Tome of Divinity].\n" ..
                   "• Dwarf Paladins: Speak to Brandur Ironhammer in Ironforge.\n" ..
                   "• Speak to Stephanie Turner or Gazin Tenorm, then head to the mortuary/inn to collect materials.\n" ..
                   "• Defeat Defias Rogues in Elwynn / Dark Iron in Loch Modan for the required token.\n" ..
                   "• Use the Symbol of Life on the fallen NPC to resurrect them.\n" ..
                   "• Return to your trainer to learn [Redemption] (Rank 1)!",
            goals = {
                { type = "ACCEPT", questID = 1642, text = "Accept [The Tome of Divinity] from Paladin Trainer" },
                { type = "COMPLETE", questID = 1643, text = "Collect the Symbol of Life and resurrect the fallen defender" },
                { type = "TURNIN", questID = 1644, text = "Learn [Redemption] resurrection spell" },
            }
        },
        {
            title = "2. Level 20: The Test of Righteousness (Verigan's Fist)",
            zone = "Stormwind & Dungeons",
            coords = { x = 39.0, y = 29.0 },
            text = "The ultimate low-level Paladin weapon quest for [Verigan's Fist] (massive 2H Mace) and Sense Undead.\n" ..
                   "• Speak to Duthorian Rall in Stormwind Cathedral to accept [The Tome of Valor] -> [The Test of Righteousness].\n" ..
                   "• Speak to Jordan Stilwell outside Ironforge gates. He tasks you with gathering 4 legendary components:\n" ..
                   "    1. [Jordan's Smithing Hammer]: Looted inside Deadmines from the Goblin Foundry or Shadow Council minion.\n" ..
                   "    2. [Jordan's Refined Ore]: Looted from a crate in Shadowfang Keep courtyard.\n" ..
                   "    3. [Kor Gem]: Looted from Naga or Twilight cultists inside Blackfathom Deeps (BFD).\n" ..
                   "    4. [Whitestone Oak Lumber]: Looted from Dun Garok dwarven riflemen in southern Hillsbrad Foothills.\n" ..
                   "• Return all 4 items to Jordan Stilwell to forge [Verigan's Fist]!",
            goals = {
                { type = "ACCEPT", questID = 1653, text = "Accept [The Test of Righteousness] from Jordan Stilwell" },
                { type = "COMPLETE", text = "Loot Jordan's Hammer in Deadmines & Jordan's Ore in SFK" },
                { type = "COMPLETE", text = "Loot Kor Gem in Blackfathom Deeps & Lumber in Dun Garok" },
                { type = "TURNIN", questID = 1654, text = "Turn in components to Jordan Stilwell and receive [Verigan's Fist]!" },
            }
        },
        {
            title = "3. Level 50: Sunken Temple Class Quest (Lightforged Blade / Sanctified Orb)",
            zone = "Stormwind & Sunken Temple",
            coords = { x = 38.0, y = 32.0 },
            text = "The endgame class quest providing powerful pre-raid gear options.\n" ..
                   "• Speak to Lord Grayson Shadowbreaker in Stormwind Cathedral to accept [A Call to Arms] -> [The Forging of the Mightstone].\n" ..
                   "• Travel to Un'Goro Crater and collect 20 Bloodscent Scraps and 20 Volcanic Ash.\n" ..
                   "• Return to Lord Grayson, then enter Temple of Atal'Hakkar (Sunken Temple).\n" ..
                   "• Slay the green dragons Morphaz and Hazzas to retrieve the [Blood of Morphaz].\n" ..
                   "• Choose your reward: [Lightforged Blade] (fast 1H sword), [Sanctified Orb] (Holy off-hand), or [Chivalric Boots] (Plate boots).",
            goals = {
                { type = "ACCEPT", questID = 8411, text = "Accept [A Call to Arms] from Lord Grayson Shadowbreaker" },
                { type = "COMPLETE", questID = 8412, text = "Gather materials in Un'Goro Crater and forge the Mightstone" },
                { type = "COMPLETE", questID = 8414, text = "Slay Morphaz in Sunken Temple and loot [Blood of Morphaz]" },
                { type = "TURNIN", questID = 8414, text = "Turn in for [Lightforged Blade], [Sanctified Orb], or [Chivalric Boots]" },
            }
        },
        {
            title = "4. Level 60: Epic Charger Mount (Part 1 - Purification Materials)",
            zone = "Stormwind & Ironforge",
            coords = { x = 39.0, y = 29.0 },
            text = "The prestigious Paladin Epic Charger mount quest chain (100% ground speed).\n" ..
                   "• Speak to Lord Grayson Shadowbreaker in Stormwind Cathedral to accept [The Divination Scryer].\n" ..
                   "• Gather the required materials:\n" ..
                   "    - 150 Gold donation to the Cathedral.\n" ..
                   "    - 1 Pristine Black Diamond.\n" ..
                   "    - 1 Azerothian Diamond.\n" ..
                   "    - 6 Stratholme Holy Water (from Stratholme supply crates).\n" ..
                   "    - 40 Arthas' Tears herbs.\n" ..
                   "    - 20 Enriched Manna Biscuits (from Argent Dawn vendor in EPL).\n" ..
                   "• Travel to Grimand Elmore in the Dwarven District of Stormwind to craft the Arcanite Barding (requires 150 Gold, 6 Arcanite Bars, and 10 Arthas' Tears).",
            goals = {
                { type = "ACCEPT", questID = 7637, text = "Accept epic mount quest from Lord Grayson Shadowbreaker" },
                { type = "COMPLETE", text = "Acquire Stratholme Holy Water, Diamonds, and Herbs" },
                { type = "COMPLETE", text = "Craft Arcanite Barding with Grimand Elmore (6 Arcanite Bars, 150g)" },
            }
        },
        {
            title = "5. Level 60: Epic Charger Mount (Part 2 - Scholomance Ritual)",
            zone = "Scholomance",
            coords = { x = 40.0, y = 50.0 },
            text = "The climactic battle in the Great Ossuary of Scholomance.\n" ..
                   "• Obtain the [Divination Scryer] and [Feed Pouch] from Lord Grayson Shadowbreaker.\n" ..
                   "• Travel to Dirge Quikcleave in Gadgetzan to purchase [Enriched Manna Biscuits] recipe if needed, then visit Merideth Carlson in Southshore to obtain blessed feed.\n" ..
                   "• Form a dungeon party and enter Scholomance.\n" ..
                   "• Clear down to the Great Ossuary (Rattlegore's basement room).\n" ..
                   "• Clear all undead and place the Divination Scryer in the center of the room to begin the ritual.\n" ..
                   "• Defeat 4 consecutive waves of spectral spirits using appropriate Judgements.\n" ..
                   "• Slay Death Knight Darkreaver and his ghostly charger.\n" ..
                   "• Redeem the charger spirit to permanently learn [Summon Charger]!",
            goals = {
                { type = "COMPLETE", text = "Clear Rattlegore's Great Ossuary in Scholomance" },
                { type = "COMPLETE", text = "Place Divination Scryer and defeat 4 spirit waves with Judgements" },
                { type = "COMPLETE", text = "Slay Death Knight Darkreaver and release the Charger spirit" },
                { type = "TURNIN", questID = 7648, text = "Learn [Summon Charger] (100% Epic Mount)!" },
            }
        },
    }
})
