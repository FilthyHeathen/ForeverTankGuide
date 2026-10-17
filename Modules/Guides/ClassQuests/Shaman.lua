--[[
    Heathen's Forever Guide - Modules/Guides/ClassQuests/Shaman.lua
    Full 1–60 Class Quest Progression Guide for Shamans
    Covers: Call of Earth (4), Fire (10), Water (20), Air (30), Sunken Temple (50).
]]

local ADDON_NAME, HFG = ...
if not HFG then HFG = _G.HFG end
if not HFG then return end

HFG:RegisterGuide({
    id = "ClassQuest_Shaman",
    title = "Shaman Class Progression (1–60: Earth, Fire, Water, Air, Sunken Temple)",
    category = "Class Quests",
    faction = "Horde",
    classes = { "SHAMAN" },
    minLevel = 4,
    maxLevel = 60,
    order = 205,
    steps = {
        {
            title = "1. Level 4: Call of Earth (Earth Totem & Stoneskin)",
            zone = "Durotar / Mulgore",
            coords = { x = 45.0, y = 50.0 },
            text = "Unlocks the [Earth Totem], enabling Stoneskin and Strength of Earth.\n" ..
                   "• Orc/Troll: Speak to Shikrik in Valley of Trials to accept [Call of Earth], collect Felstalker hoofs, drink Earth Sap at the shrine, and defeat the Earth Elemental spirit.\n" ..
                   "• Tauren: Speak to Meela Dawnstrider in Camp Narache, gather ritual herbs, commune with the Earth Mother rock, and receive your totem.\n" ..
                   "• Rewards: [Earth Totem], [Stoneskin Totem], and [Earth Shock]!",
            goals = {
                { type = "ACCEPT", text = "Accept [Call of Earth] from Shaman trainer" },
                { type = "COMPLETE", text = "Commune with the Earth spirit at the elemental shrine" },
                { type = "TURNIN", text = "Receive [Earth Totem] and learn [Stoneskin Totem]!" },
            }
        },
        {
            title = "2. Level 10: Call of Fire (Fire Totem & Searing)",
            zone = "Durotar / Mulgore",
            coords = { x = 50.0, y = 40.0 },
            text = "Unlocks the [Fire Totem], enabling Searing Totem and Fire Nova.\n" ..
                   "• Orc/Troll: Speak to Swart in Razor Hill. Collect fire tar from Razormane geomancers and a burning talisman from Cultists at Skull Rock. Travel to the peak of the mountain in south Durotar to ignite the Fire Brazier, defeat the Fire Spirit, and claim your totem.\n" ..
                   "• Tauren: Speak to Beram Skychaser in Bloodhoof Village. Travel to the fire shrine on the high mesa, offer the torch, and defeat the flame spirit.\n" ..
                   "• Rewards: [Fire Totem] and [Searing Totem]!",
            goals = {
                { type = "ACCEPT", text = "Accept [Call of Fire] from Shaman trainer" },
                { type = "COMPLETE", text = "Collect fire reagents and travel to the peak brazier" },
                { type = "TURNIN", text = "Defeat the Fire Spirit and claim your [Fire Totem]!" },
            }
        },
        {
            title = "3. Level 20: Call of Water (Water Totem & Healing Stream)",
            zone = "The Barrens, Hillsbrad & Ashenvale",
            coords = { x = 44.0, y = 59.0 },
            text = "The grand pilgrimage across Kalimdor and Eastern Kingdoms for the [Water Totem].\n" ..
                   "• Speak to your trainer to accept [Call of Water], then visit Islen Waterseer on the Barrens coast (south of Ratchet).\n" ..
                   "• Visit Brine in southern Barrens, fill your waterskin at the pond, and deliver it.\n" ..
                   "• Journey to Hillsbrad Foothills: fill waterskin at the pure well in Tarren Mill.\n" ..
                   "• Journey to Ashenvale: fill waterskin at the moonwell in Ruins of Stardust.\n" ..
                   "• Journey to Silverpine Forest: collect foul water from the Amberevil elementals.\n" ..
                   "• Return to the Water Shrine in Silverpine, defeat the Corrupt Elemental, and place the pure drop on the altar.\n" ..
                   "• Return to Islen to permanently receive [Water Totem] and learn [Healing Stream Totem] and [Poison Cleansing Totem]!",
            goals = {
                { type = "ACCEPT", questID = 63, text = "Accept [Call of Water] and speak with Islen Waterseer" },
                { type = "COMPLETE", text = "Collect pure water samples in Barrens, Hillsbrad, and Ashenvale" },
                { type = "COMPLETE", text = "Defeat the Corrupt Water Elemental in Silverpine Forest" },
                { type = "TURNIN", questID = 100, text = "Turn in to Islen to receive [Water Totem]!" },
            }
        },
        {
            title = "4. Level 30: Call of Air (Air Totem & Windfury)",
            zone = "Thousand Needles",
            coords = { x = 30.0, y = 33.0 },
            text = "Unlocks the [Air Totem], enabling Windfury Totem and Grace of Air.\n" ..
                   "• Speak to your capital Shaman trainer to accept [Call of Air].\n" ..
                   "• Travel to Prate Cloudseer at the high mountain crest in Thousand Needles (above the Shimmering Flats ramp).\n" ..
                   "• Commune with the wind spirit atop the spire.\n" ..
                   "• Drink the airy concoction to witness the flight of the stormhawk.\n" ..
                   "• Receive your permanent [Air Totem] and unlock [Windfury Totem] and [Grace of Air Totem]!",
            goals = {
                { type = "ACCEPT", questID = 1531, text = "Accept [Call of Air] from Shaman trainer" },
                { type = "COMPLETE", text = "Ascend the high pinnacle in Thousand Needles to meet Prate Cloudseer" },
                { type = "TURNIN", questID = 1532, text = "Commune with the wind and receive [Air Totem]!" },
            }
        },
        {
            title = "5. Level 50: Sunken Temple Class Quest (Enamored Water Spirit)",
            zone = "Azshara & Sunken Temple",
            coords = { x = 28.0, y = 74.0 },
            text = "Endgame Shaman power rewarding the legendary [Enamored Water Spirit] healing trinket.\n" ..
                   "• Speak to your Shaman trainer to accept [Elemental Mastery].\n" ..
                   "• Travel to Bath'rah the Windwatcher along the riverbank in Alterac Mountains.\n" ..
                   "• Gather 20 Elemental Fragments from the elementals in Azshara.\n" ..
                   "• Enter Temple of Atal'Hakkar (Sunken Temple).\n" ..
                   "• Slay the green drakes Morphaz and Hazzas and collect their pure essence.\n" ..
                   "• Return to Bath'rah to claim [Enamored Water Spirit] (instant mana restoration trinket), [Wild Drape] (Resto cape), or [Azurite Fists] (Enhancement mace)!",
            goals = {
                { type = "ACCEPT", questID = 8426, text = "Accept [Elemental Mastery] from Shaman trainer" },
                { type = "COMPLETE", questID = 8427, text = "Collect Elemental Fragments from Azshara elementals" },
                { type = "COMPLETE", questID = 8429, text = "Slay Morphaz in Sunken Temple for pure drake essence" },
                { type = "TURNIN", questID = 8429, text = "Turn in for [Enamored Water Spirit] or [Wild Drape]!" },
            }
        },
    }
})
