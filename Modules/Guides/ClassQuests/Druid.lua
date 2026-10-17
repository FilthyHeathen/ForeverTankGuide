--[[
    Heathen's Forever Guide - Modules/Guides/ClassQuests/Druid.lua
    Full 1–60 Class Quest Progression Guide for Druids
    Covers: Bear Form (10), Cure Poison (14), Aquatic Form (16), Sunken Temple (50).
]]

local ADDON_NAME, HFG = ...
if not HFG then HFG = _G.HFG end
if not HFG then return end

HFG:RegisterGuide({
    id = "ClassQuest_Druid",
    title = "Druid Class Progression (1–60: Bear Form, Aquatic Form, Sunken Temple)",
    category = "Class Quests",
    faction = "Both",
    classes = { "DRUID" },
    minLevel = 10,
    maxLevel = 60,
    order = 204,
    steps = {
        {
            title = "1. Level 10: Heed the Call (Bear Form, Growl & Enrage)",
            zone = "Moonglade & Starting Zones",
            coords = { x = 52.0, y = 40.0 },
            text = "Unlocks the iconic [Bear Form], the foundation of Druid tanking and survivability.\n" ..
                   "• Speak to your Druid trainer in Darnassus, Dolanaar, Thunder Bluff, or Bloodhoof Village.\n" ..
                   "• Learn [Teleport: Moonglade] and teleport into Nighthaven.\n" ..
                   "• Speak to Dendrite Starblaze in Moonglade, then travel to the Shrine of the Great Bear Spirit.\n" ..
                   "• Commune with the spirit to receive its blessing.\n" ..
                   "• Return to your home zone:\n" ..
                   "    - Night Elf: Travel to Darkshore (cave east of Auberdine), use the Cenarion Dust, and defeat Lunaclaw.\n" ..
                   "    - Tauren: Travel to the Barrens border, summon Lunaclaw at the moonstone rock, and defeat him.\n" ..
                   "• Speak to your local trainer to permanently learn [Bear Form], [Growl], and [Enrage]!",
            goals = {
                { type = "ACCEPT", text = "Accept [Heed the Call] and teleport to Moonglade" },
                { type = "COMPLETE", text = "Commune with the Great Bear Spirit in Moonglade" },
                { type = "COMPLETE", text = "Summon and defeat Lunaclaw using Cenarion Dust" },
                { type = "TURNIN", text = "Learn [Bear Form], [Growl], and [Enrage]!" },
            }
        },
        {
            title = "2. Level 14: Lessons Anew (Cure Poison)",
            zone = "Moonglade & Darkshore / The Barrens",
            coords = { x = 52.0, y = 40.0 },
            text = "Unlocks [Cure Poison], essential for cleansing deadly venoms.\n" ..
                   "• Teleport to Moonglade and speak to Dendrite Starblaze to accept [Lessons Anew].\n" ..
                   "• Night Elves gather Earthroot and fungal samples in Darkshore, then cure 10 poisoned animals at Cliffspring Falls.\n" ..
                   "• Tauren gather Prairie Stalks and well water in Mulgore/Barrens, then administer antidote to sick gazelles.\n" ..
                   "• Return to your trainer to learn [Cure Poison]!",
            goals = {
                { type = "ACCEPT", text = "Accept [Lessons Anew] in Moonglade" },
                { type = "COMPLETE", text = "Gather herbs, craft the antidote, and heal sick animals" },
                { type = "TURNIN", text = "Learn [Cure Poison]!" },
            }
        },
        {
            title = "3. Level 16: Trial of the Sea Lion (Aquatic Form)",
            zone = "Moonglade & Coastal Waters",
            coords = { x = 52.0, y = 40.0 },
            text = "Unlocks [Aquatic Form] (50% swim speed increase and underwater breathing).\n" ..
                   "• Teleport to Moonglade and speak to Dendrite Starblaze to accept [Trial of the Sea Lion].\n" ..
                   "• Gather the two halves of the Sea Lion Pendant:\n" ..
                   "    - Night Elf: Retrieve the Agility Pendant from the sunken reef off Darkshore coast, and the Endurance Pendant from the ocean trench near Westfall/Silverpine.\n" ..
                   "    - Tauren: Retrieve the Agility Pendant from the fissure in the Great Sea off the Sludge Fen (Barrens), and Endurance Pendant off the coast of Silverpine Forest.\n" ..
                   "• Bring both halves to the Shrine of Remulos in Moonglade to fuse them into the [Sea Lion Pendant].\n" ..
                   "• Turn in to your class trainer to permanently learn [Aquatic Form]!",
            goals = {
                { type = "ACCEPT", questID = 30, text = "Accept [Trial of the Sea Lion] in Moonglade" },
                { type = "COMPLETE", text = "Dive into coastal waters and recover both halves of the Pendant" },
                { type = "COMPLETE", text = "Fuse the halves at the Shrine of Remulos in Moonglade" },
                { type = "TURNIN", text = "Learn [Aquatic Form]!" },
            }
        },
        {
            title = "4. Level 50: Sunken Temple Class Quest (Forest's Embrace / Grizzled Pelt)",
            zone = "Un'Goro Crater & Sunken Temple",
            coords = { x = 63.0, y = 68.0 },
            text = "Endgame class quest providing exceptional Druid gear.\n" ..
                   "• Speak to your capital Druid trainer to accept [Torwa Pathfinder].\n" ..
                   "• Travel to Torwa Pathfinder at the south entrance of Un'Goro Crater.\n" ..
                   "• Complete [Bloodpetal Poison] by collecting samples from lashers.\n" ..
                   "• Enter Temple of Atal'Hakkar (Sunken Temple).\n" ..
                   "• Slay Morphaz and collect the [Blood of Morphaz].\n" ..
                   "• Return to Torwa Pathfinder and select your reward:\n" ..
                   "    - [Grizzled Pelt]: Outstanding Feral Tank chestpiece with high armor and stamina.\n" ..
                   "    - [Forest's Embrace]: Superb Resto/Balance chestpiece with healing and mana per 5.\n" ..
                   "    - [Moonshadow Stave]: Solid hybrid caster staff.",
            goals = {
                { type = "ACCEPT", questID = 8422, text = "Accept [Torwa Pathfinder] from Druid Trainer" },
                { type = "COMPLETE", questID = 8423, text = "Complete Un'Goro Crater assignments for Torwa" },
                { type = "COMPLETE", questID = 8425, text = "Slay Morphaz in Sunken Temple and loot [Blood of Morphaz]" },
                { type = "TURNIN", questID = 8425, text = "Turn in for [Grizzled Pelt] or [Forest's Embrace]!" },
            }
        },
    }
})
