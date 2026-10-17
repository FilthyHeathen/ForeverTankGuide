--[[
    Heathen's Forever Guide - Modules/Guides/ClassQuests/Mage.lua
    Full 1–60 Class Quest Progression Guide for Mages
    Covers: Early Wands (10), Tabetha's Mage Robes & Wands (30), Sunken Temple (50), Conjure Water Rank 7 (60).
]]

local ADDON_NAME, HFG = ...
if not HFG then HFG = _G.HFG end
if not HFG then return end

HFG:RegisterGuide({
    id = "ClassQuest_Mage",
    title = "Mage Class Progression (1–60: Tabetha's Wand, Sunken Temple, Conjure Water)",
    category = "Class Quests",
    faction = "Both",
    classes = { "MAGE" },
    minLevel = 10,
    maxLevel = 60,
    order = 208,
    steps = {
        {
            title = "1. Level 10: Wand & Arcane Focus",
            zone = "Faction Capitals / Starting Zones",
            coords = { x = 40.0, y = 50.0 },
            text = "Unlocks your first magical wand, essential for mana-efficient leveling.\n" ..
                   "• Speak to your local Mage trainer in your starting racial hub.\n" ..
                   "• Collect magical reagents from local elementals or forest beasts.\n" ..
                   "• Combine the components at the arcane forge to craft your first magical wand and unlock spell power bonuses.",
            goals = {
                { type = "ACCEPT", text = "Accept Mage focus quest from your racial trainer" },
                { type = "COMPLETE", text = "Gather magical dust and arcane fragments" },
                { type = "TURNIN", text = "Craft your first magical wand" },
            }
        },
        {
            title = "2. Level 30: Tabetha's Farm & The Mage Robes",
            zone = "Dustwallow Marsh, Desolace & Arathi",
            coords = { x = 46.0, y = 57.0 },
            text = "The premier mid-level Mage questline rewarding top-tier wands and robes.\n" ..
                   "• Speak to your capital Mage trainer to accept [Journey to the Marsh].\n" ..
                   "• Travel to Tabetha's Farm hidden deep in the swamplands of Dustwallow Marsh.\n" ..
                   "• Accept [Hidden Power] and [Infernal Materials]:\n" ..
                   "    - Slay Burning Blade cultists in Desolace to obtain the Ritual Tome.\n" ..
                   "    - Defeat fire and water elementals in Arathi Highlands for elemental charms.\n" ..
                   "• Return to Tabetha to weave your magical rewards:\n" ..
                   "    - Choose your elite wand: [Icefury Wand] (+Frost damage), [Netherforce Wand] (+Arcane damage), or [Combustion Wand] (+Fire damage).\n" ..
                   "    - Receive the prestigious [Robes of the Arcane] / [Celestial Power]!",
            goals = {
                { type = "ACCEPT", questID = 1947, text = "Accept [Journey to the Marsh] from Mage Trainer" },
                { type = "COMPLETE", text = "Visit Tabetha's Farm in Dustwallow Marsh" },
                { type = "COMPLETE", text = "Retrieve Ritual Tome in Desolace & Elemental Charms in Arathi" },
                { type = "TURNIN", questID = 1951, text = "Turn in to Tabetha and select [Icefury Wand] or [Netherforce Wand]!" },
            }
        },
        {
            title = "3. Level 50: Sunken Temple Class Quest (Arcane Crystal Pendant)",
            zone = "Azshara & Sunken Temple",
            coords = { x = 28.0, y = 50.0 },
            text = "Endgame Mage class quest offering exceptional spell penetration and power.\n" ..
                   "• Speak to your capital Mage trainer to accept [Magecraft].\n" ..
                   "• Travel to Sanath Lim-yo in Azshara, then visit Archmage Xylem in his cliffside tower.\n" ..
                   "• Complete [Magic Dust] by harvesting crystallised mana sprites in Azshara.\n" ..
                   "• Enter Temple of Atal'Hakkar (Sunken Temple).\n" ..
                   "• Slay Morphaz and collect the [Blood of Morphaz].\n" ..
                   "• Return to Archmage Xylem and select your reward:\n" ..
                   "    - [Arcane Crystal Pendant]: Superb neck piece (+1% Spell Crit & +6 Spell Power).\n" ..
                   "    - [Glacial Spike]: Outstanding Frost damage wand.\n" ..
                   "    - [Firebreather]: Powerful Fire damage sword.",
            goals = {
                { type = "ACCEPT", questID = 8440, text = "Accept [Magecraft] from Mage Trainer" },
                { type = "COMPLETE", questID = 8441, text = "Visit Archmage Xylem in Azshara and collect Magic Dust" },
                { type = "COMPLETE", questID = 8443, text = "Slay Morphaz in Sunken Temple for [Blood of Morphaz]" },
                { type = "TURNIN", questID = 8443, text = "Turn in to Archmage Xylem for [Arcane Crystal Pendant]!" },
            }
        },
        {
            title = "4. Level 60: Conjure Water Rank 7 (Dire Maul East)",
            zone = "Dire Maul East",
            coords = { x = 60.0, y = 30.0 },
            text = "Unlocks [Conjure Water (Rank 7)], conjuring 10 Morning Glory Dew per cast—essential for raids and dungeons!\n" ..
                   "• Travel to the Shen'dralar Athenaeum (Library) inside Dire Maul (accessible through DM East, North, or West with Crescent Key).\n" ..
                   "• Speak to Lorekeeper Lydros to accept [Arcane Refreshment] (Req Level 60).\n" ..
                   "• Enter Dire Maul East with a group.\n" ..
                   "• Clear down to the hydroponic garden chamber and engage [Hydrospawn] (giant water elemental boss).\n" ..
                   "• Slay Hydrospawn and loot the [Hydrothermal Essence].\n" ..
                   "• Return to Lorekeeper Lydros in the Library to turn in the quest and permanently master [Conjure Water (Rank 7)]!",
            goals = {
                { type = "ACCEPT", questID = 7463, text = "Accept [Arcane Refreshment] from Lorekeeper Lydros in Dire Maul Library" },
                { type = "COMPLETE", questID = 7463, text = "Defeat Hydrospawn in Dire Maul East and loot [Hydrothermal Essence]" },
                { type = "TURNIN", questID = 7463, text = "Turn in to Lorekeeper Lydros to learn [Conjure Water (Rank 7)]!" },
            }
        },
    }
})
