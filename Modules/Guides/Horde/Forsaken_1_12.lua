--[[
    Heathen's Forever Guide - Modules/Guides/Horde/Forsaken_1_12.lua
    Step-by-Step Leveling Guide: Deathknell & Tirisfal Glades (Levels 1–12)
]]

local ADDON_NAME, HFG = ...
if not HFG then HFG = _G.HFG end
if not HFG then return end

HFG:RegisterGuide({
    id = "Horde_Forsaken_1_12",
    title = "Deathknell & Tirisfal Glades (1–12)",
    faction = "Horde",
    races = { "Forsaken", "FORSAKEN", "Undead", "UNDEAD", "Scourge", "SCOURGE" },
    minLevel = 1,
    maxLevel = 12,
    order = 1,
    steps = {
        {
            title = "Rude Awakening in Deathknell",
            zone = "Deathknell",
            coords = { x = 30.5, y = 66.0 },
            text = "Welcome back to the living world! Speak with Shadow Priest Sarvis inside the crypt.",
            goals = {
                { type = "ACCEPT", questID = 363, text = "Accept [Rude Awakening] from Shadow Priest Sarvis" },
                { type = "TURNIN", questID = 363, text = "Turn in [Rude Awakening] to Novice Torment at the crypt doors" },
                { type = "ACCEPT", questID = 364, text = "Accept [The Damned] from Novice Torment" },
            }
        },
        {
            title = "Starter Bag & Scavenger Duties",
            zone = "Deathknell",
            coords = { x = 31.8, y = 65.5 },
            text = "Speak with Caretaker Duesten and Deathguard Saltain in the courtyard.",
            goals = {
                { type = "ACCEPT", questID = 1007, text = "Accept [Carry Your Weight] / [Scavenger Duties] (6-Slot Bag reward!)" },
                { type = "ACCEPT", questID = 383,  text = "Accept [Marr's Demise] / [A Rogue's Deal] from your class trainer" },
            }
        },
        {
            title = "Cull Mindless Zombies & Gather Scraps",
            zone = "Deathknell",
            text = "Slay Mindless Zombies and Wretched Ghouls outside the crypt walls and collect supplies.",
            goals = {
                { type = "COMPLETE", questID = 364,  text = "Collect 6 Scourge Claws for [The Damned]" },
                { type = "COMPLETE", questID = 1007, text = "Loot 6 Tattered Cloth Sacks for your 6-Slot Bag" },
            }
        },
        {
            title = "Claim 6-Slot Bag & Level 2 Training",
            zone = "Deathknell",
            coords = { x = 31.8, y = 65.5 },
            text = "Turn in your quests to claim your 6-slot bag reward, equip it, and consult your trainer.",
            goals = {
                { type = "TURNIN", questID = 1007, text = "Turn in [Scavenger Duties] (Equip your 6-Slot Bag!)" },
                { type = "TURNIN", questID = 364,  text = "Turn in [The Damned] to Novice Torment" },
                { type = "LEVEL",  level = 2,       text = "Reach Level 2 and learn new spells from your Class Trainer" },
            }
        },
        {
            title = "Night Web Spiders & Marla's Last Wish",
            zone = "Deathknell",
            coords = { x = 32.2, y = 64.8 },
            text = "Pick up quests to clear the spider infestation in the northern woods.",
            goals = {
                { type = "ACCEPT", questID = 3901, text = "Accept [Night Web Hollow] from Executor Arren" },
                { type = "COMPLETE", questID = 3901, text = "Slay 8 Young Night Web Spiders and 5 Night Web Spiders" },
                { type = "TURNIN", questID = 3901, text = "Turn in [Night Web Hollow] to Executor Arren" },
                { type = "LEVEL",  level = 4,       text = "Reach Level 4" },
            }
        },
        {
            title = "Scarlet Armbands & Infiltration",
            zone = "Deathknell",
            coords = { x = 36.5, y = 68.2 },
            text = "Head to the Scarlet camp in the eastern hills and slay Scarlet Converts.",
            goals = {
                { type = "ACCEPT", questID = 365, text = "Accept [Scarlet Armbands] from Executor Arren" },
                { type = "COMPLETE", questID = 365, text = "Collect 12 Scarlet Armbands from Scarlet Converts" },
                { type = "TURNIN", questID = 365, text = "Turn in [Scarlet Armbands] to Executor Arren" },
            }
        },
        {
            title = "Journey to Brill",
            zone = "Tirisfal Glades",
            coords = { x = 61.2, y = 52.4 },
            text = "Exit Deathknell through the gate east and follow the road north to Brill.",
            goals = {
                { type = "LEVEL",  level = 6,       text = "Reach Level 6" },
                { type = "ACCEPT", questID = 367,  text = "Accept [The Executor Zygore] from Deathguard Simmer" },
                { type = "TURNIN", questID = 367,  text = "Turn in [The Executor Zygore] to Executor Zygore in Brill" },
                { type = "HEARTH", location = "Brill", text = "Set Hearthstone at the Gallows' End Tavern in Brill" },
            }
        },
        {
            title = "Gallows' End & Agamand Mills",
            zone = "Tirisfal Glades",
            coords = { x = 45.0, y = 35.0 },
            text = "Pick up quests in Brill and clear Agamand Mills and Solliden Farmstead.",
            goals = {
                { type = "ACCEPT", questID = 358, text = "Accept [A New Plague] from Apothecary Johaan" },
                { type = "ACCEPT", questID = 405, text = "Accept [Graverobbers] from Magistrate Sevren" },
                { type = "COMPLETE", questID = 358, text = "Collect 5 Vile Fin Scales and Gloom Weed" },
                { type = "COMPLETE", questID = 405, text = "Slay 8 Rotting Cadavers and 8 Ravaged Corpses" },
                { type = "TURNIN", questID = 358, text = "Turn in [A New Plague] to Apothecary Johaan" },
                { type = "TURNIN", questID = 405, text = "Turn in [Graverobbers] to Magistrate Sevren" },
                { type = "LEVEL",  level = 10,     text = "Reach Level 10 and train class talent points" },
            }
        },
        {
            title = "Onward to Silverpine Forest",
            zone = "Silverpine Forest",
            coords = { x = 44.5, y = 40.5 },
            text = "Follow the southern road past the gate into Silverpine Forest and report to The Sepulcher.",
            goals = {
                { type = "ACCEPT", questID = 431, text = "Accept [Delivery to Silverpine Forest]" },
                { type = "TURNIN", questID = 431, text = "Turn in to High Executor Hadrec at The Sepulcher" },
                { type = "LEVEL",  level = 12,     text = "Reach Level 12" },
            }
        }
    }
})
