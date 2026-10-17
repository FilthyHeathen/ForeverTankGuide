--[[
    Heathen's Forever Guide - Modules/Guides/ClassQuests/Warrior.lua
    Full 1–60 Class Quest Progression Guide for Warriors
    Covers: Defensive Stance (10), Berserker Stance (30), Whirlwind Axe (30), Diamond Flask (50).
]]

local ADDON_NAME, HFG = ...
if not HFG then HFG = _G.HFG end
if not HFG then return end

HFG:RegisterGuide({
    id = "ClassQuest_Warrior",
    title = "Warrior Class Progression (1–60: Defensive Stance, Whirlwind Axe, Diamond Flask)",
    category = "Class Quests",
    faction = "Both",
    classes = { "WARRIOR" },
    minLevel = 10,
    maxLevel = 60,
    order = 202,
    steps = {
        {
            title = "1. Level 10: Defensive Stance, Taunt & Bloodrage",
            zone = "Faction Starting Areas",
            coords = { x = 45.0, y = 50.0 },
            text = "Essential core tanking abilities required for any defensive play.\n" ..
                   "• Horde (Orc/Troll): Speak to Tarshaw Jaggedscar in Razor Hill to accept [Veteran Uzzek], head to the Barrens border, and defeat the quillboar invaders.\n" ..
                   "• Horde (Tauren): Speak to Krang Stonehoof in Bloodhoof Village to accept [A Warrior's Training], venture to the Harpy ravine, and collect the war totem.\n" ..
                   "• Horde (Forsaken): Speak to Austil de Mon in Brill to accept [Speak with Dillinger], then collect components in Agamand Mills.\n" ..
                   "• Alliance (Human): Speak to Lycurgus in Goldshire to accept [Elmore's Task], travel to Stormwind and complete the combat trial.\n" ..
                   "• Alliance (Dwarf/Gnome): Speak to Granis Swiftaxe in Kharanos to defeat the trogg champion.\n" ..
                   "• Alliance (Night Elf): Speak to Darnassus trainers to accept the combat challenge.\n" ..
                   "• Rewards: [Defensive Stance], [Taunt], [Sunder Armor], and [Bloodrage]!",
            goals = {
                { type = "ACCEPT", text = "Accept Level 10 Warrior stance quest from your racial trainer" },
                { type = "COMPLETE", text = "Complete the combat trial and defeat designated challenger" },
                { type = "TURNIN", text = "Learn [Defensive Stance], [Taunt], and [Bloodrage]" },
            }
        },
        {
            title = "2. Level 30: The Fray (Berserker Stance & Intercept)",
            zone = "The Barrens (Fray Island)",
            coords = { x = 68.0, y = 48.0 },
            text = "Unlocks [Berserker Stance] and [Intercept], essential for mobility and rage generation.\n" ..
                   "• Speak to any Warrior trainer in major capitals to accept [The Affliction] / [The Island of The Fray].\n" ..
                   "• Travel to Ratchet in The Barrens and swim or boat out to Fray Island off the east coast.\n" ..
                   "• Speak to Klannoc Macleod on the island to begin the trials.\n" ..
                   "• Step onto the center iron grate ring and survive waves of brawlers.\n" ..
                   "• Slay Big Will in single combat inside the ring.\n" ..
                   "• Turn in to Klannoc to immediately learn [Berserker Stance] and [Intercept]!",
            goals = {
                { type = "ACCEPT", questID = 1718, text = "Accept [The Island of The Fray] from Warrior Trainer" },
                { type = "COMPLETE", text = "Survive the trial brawlers on the iron grate at Fray Island" },
                { type = "COMPLETE", text = "Defeat Big Will in single combat" },
                { type = "TURNIN", text = "Learn [Berserker Stance] and [Intercept]" },
            }
        },
        {
            title = "3. Level 30: The Whirlwind Weapon (Whirlwind Axe)",
            zone = "Alterac Mountains & Arathi",
            coords = { x = 80.0, y = 67.0 },
            text = "The legendary Warrior quest rewarding the iconic [Whirlwind Axe] (massive weapon damage spike at level 30).\n" ..
                   "• Accept [The Whirlwind Weapon] from Klannoc Macleod on Fray Island.\n" ..
                   "• Travel to Bath'rah the Windwatcher along the riverbank between Alterac Mountains and Western Plaguelands.\n" ..
                   "• Gather the following 4 reagents (bring friends or buy from AH):\n" ..
                   "    1. [30 Bloodscalp Tusks]: Farmed from Bloodscalp trolls in northern Stranglethorn Vale.\n" ..
                   "    2. [8 Liferoot]: Acquired from Herbalists or the Auction House.\n" ..
                   "    3. [8 Charms of each Element]: Farm Charred, Cresting, and Thundering Charms from elementals in the Arathi Highlands circles (8 Burning, 8 Cresting, 8 Thundering).\n" ..
                   "• Return all items to Bath'rah. He will summon [Cyclonian] (Level 40 Elite wind elemental)!\n" ..
                   "• Slay Cyclonian, loot the [Whirlwind Heart], and claim your [Whirlwind Axe] (or Sword/Warhammer)!",
            goals = {
                { type = "ACCEPT", questID = 1713, text = "Accept [The Whirlwind Weapon] from Bath'rah the Windwatcher" },
                { type = "COMPLETE", text = "Collect 30 Bloodscalp Tusks and 8 Liferoot" },
                { type = "COMPLETE", text = "Collect 8 Burning, 8 Cresting, and 8 Thundering Charms in Arathi" },
                { type = "COMPLETE", text = "Summon and defeat Cyclonian to loot [Whirlwind Heart]" },
                { type = "TURNIN", questID = 1714, text = "Turn in for the legendary [Whirlwind Axe]!" },
            }
        },
        {
            title = "4. Level 50: Sunken Temple Class Quest (Diamond Flask)",
            zone = "Swamp of Sorrows & Sunken Temple",
            coords = { x = 34.0, y = 66.0 },
            text = "The level 50 Warrior quest chain rewarding [Diamond Flask]—one of the strongest healing/AP trinkets in the entire game.\n" ..
                   "• Speak to your capital Warrior trainer to accept [A Troubled Breeze].\n" ..
                   "• Travel to the Fallen Hero of the Horde at the border of Swamp of Sorrows and Blasted Lands.\n" ..
                   "• Accept [Warrior's Blood] -> collect 7 Smoldering Splinters from Un'Goro Crater fire elementals.\n" ..
                   "• Return to the Fallen Hero and accept [Warriors of the Sunken Temple].\n" ..
                   "• Enter the Temple of Atal'Hakkar (Sunken Temple) with a dungeon group.\n" ..
                   "• Slay the 6 Troll minibosses on the upper balcony to collect the required Voodoo Feathers (Amber, Blue, and Green).\n" ..
                   "• Return to the Fallen Hero and choose [Diamond Flask] (+75 Attack Power & +9 HP/5 sec, scales 100% with +Healing)! Also offers [Razorsteel Pauldrons] and [Fury of the Sar'theris].",
            goals = {
                { type = "ACCEPT", questID = 8415, text = "Accept [A Troubled Breeze] from Warrior Trainer" },
                { type = "COMPLETE", questID = 8416, text = "Collect Smoldering Splinters from Un'Goro Crater" },
                { type = "COMPLETE", questID = 8418, text = "Collect Voodoo Feathers from Troll Minibosses in Sunken Temple" },
                { type = "TURNIN", questID = 8418, text = "Turn in to Fallen Hero and select the iconic [Diamond Flask]!" },
            }
        },
    }
})
