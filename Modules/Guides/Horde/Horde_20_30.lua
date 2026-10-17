--[[
    Heathen's Forever Guide - Modules/Guides/Horde/Horde_20_30.lua
    Step-by-Step Leveling Guide: Southern Barrens, Thousand Needles & Hillsbrad (Levels 20–30)
]]

local ADDON_NAME, HFG = ...
if not HFG then HFG = _G.HFG end
if not HFG then return end

HFG:RegisterGuide({
    id = "Horde_Mid_20_30",
    title = "Southern Barrens, Thousand Needles & Hillsbrad (20–30)",
    faction = "Horde",
    minLevel = 20,
    maxLevel = 30,
    order = 3,
    steps = {
        {
            title = "Camp Taurajo & Southern Barrens Outpost",
            zone = "The Barrens",
            coords = { x = 44.5, y = 59.2 },
            text = "Welcome to Camp Taurajo! Grab the flight path and accept all outpost bounties.",
            goals = {
                { type = "FLY",    text = "Discover Camp Taurajo Flight Path" },
                { type = "ACCEPT", questID = 899, text = "Accept [Tribes at War] from Mangletooth" },
                { type = "ACCEPT", questID = 878, text = "Accept [Weapons of Choice] from Tatternack Steelforge" },
                { type = "ACCEPT", questID = 870, text = "Accept [The Zhevra] from Jorn Skycaller" },
            }
        },
        {
            title = "Centaur War & Bristleback Quillboar",
            zone = "The Barrens",
            text = "Head into the southern canyons and water oases to defeat Bristlebacks and Kolkar centaurs.",
            goals = {
                { type = "COMPLETE", questID = 899, text = "Kill 6 Bristleback Geomancers and 12 Water Seekers" },
                { type = "COMPLETE", questID = 878, text = "Collect 3 Centaur Battleaxes and 3 Shields" },
                { type = "TURNIN",   questID = 899, text = "Turn in [Tribes at War] to Mangletooth" },
                { type = "TURNIN",   questID = 878, text = "Turn in [Weapons of Choice] to Tatternack Steelforge" },
                { type = "LEVEL",    level = 22,    text = "Reach Level 22" },
            }
        },
        {
            title = "Descent into Thousand Needles (Freewind Post)",
            zone = "Thousand Needles",
            coords = { x = 46.1, y = 51.6 },
            text = "Journey south to the Great Lift. Descend the elevator (or Skyborne Aerial Glide!) and cross the suspension bridges up to Freewind Post.",
            goals = {
                { type = "FLY",    text = "Discover Freewind Post Flight Path" },
                { type = "HEARTH", location = "Freewind Post", text = "Set Hearthstone at Freewind Post Inn" },
                { type = "ACCEPT", questID = 1111, text = "Accept [Alien Egg] from Hagar Lightninghoof" },
                { type = "ACCEPT", questID = 1134, text = "Accept [Wind Rider] from Elu" },
                { type = "ACCEPT", questID = 1177, text = "Accept [The Grimtotem Clan] from Cliffwatcher Longhorn" },
            }
        },
        {
            title = "Grimtotem Sabotage & Wind Rider Taming",
            zone = "Thousand Needles",
            coords = { x = 32.0, y = 35.0 },
            text = "Assault the Grimtotem mesas across the precarious rope bridges and hunt Highperch Wyverns.",
            goals = {
                { type = "COMPLETE", questID = 1177, text = "Defeat 10 Grimtotem Raiders and recover Secret Plans" },
                { type = "COMPLETE", questID = 1134, text = "Collect 8 Highperch Wyvern Venom Glands" },
                { type = "TURNIN",   questID = 1177, text = "Turn in [The Grimtotem Clan] to Cliffwatcher Longhorn" },
                { type = "TURNIN",   questID = 1134, text = "Turn in [Wind Rider] to Elu" },
                { type = "LEVEL",    level = 25,     text = "Reach Level 25" },
            }
        },
        {
            title = "Alien Egg & Whitereach Post Expeditions",
            zone = "Thousand Needles",
            coords = { x = 21.5, y = 46.0 },
            text = "Head to the serpent canyons in the far west to find the Alien Egg and aid Kanati Greycloud.",
            goals = {
                { type = "COMPLETE", questID = 1111, text = "Recover the Alien Egg from the western spires" },
                { type = "TURNIN",   questID = 1111, text = "Turn in [Alien Egg] to Hagar Lightninghoof at Freewind Post" },
                { type = "LEVEL",    level = 26,     text = "Reach Level 26 and visit Class Trainer for new rank abilities" },
            }
        },
        {
            title = "Hillsbrad Foothills Transit: Tarren Mill",
            zone = "Hillsbrad Foothills",
            coords = { x = 63.2, y = 20.8 },
            text = "Take the zeppelin to Undercity and ride south through Silverpine Forest into Tarren Mill (Hillsbrad Foothills).",
            goals = {
                { type = "FLY",    text = "Discover Tarren Mill Flight Path" },
                { type = "ACCEPT", questID = 543, text = "Accept [The Battle for Hillsbrad] from Darthalia" },
                { type = "ACCEPT", questID = 529, text = "Accept [Elixir of Pain] from Apothecary Lydon" },
                { type = "ACCEPT", questID = 549, text = "Accept [Helcular's Rod] from Novice Veranna" },
            }
        },
        {
            title = "The Battle for Hillsbrad: Farmland Offensive",
            zone = "Hillsbrad Foothills",
            coords = { x = 36.0, y = 44.0 },
            text = "Assault the northern Hillsbrad fields, defeat human peasants and councilmen, and recover the farm registry.",
            goals = {
                { type = "COMPLETE", questID = 543, text = "Slay 15 Hillsbrad Farmers and 15 Farmhands" },
                { type = "COMPLETE", questID = 529, text = "Collect 10 Creeper Ichor from forest mountain lions/spiders" },
                { type = "TURNIN",   questID = 543, text = "Turn in [The Battle for Hillsbrad] to Darthalia" },
                { type = "TURNIN",   questID = 529, text = "Turn in [Elixir of Pain] to Apothecary Lydon" },
                { type = "LEVEL",    level = 28,    text = "Reach Level 28" },
            }
        },
        {
            title = "Helcular's Rod & The Alterac Foothills",
            zone = "Hillsbrad Foothills",
            coords = { x = 54.0, y = 82.0 },
            text = "Venture into the yetimus caves in the northern snow to loot Helcular's Rod, then charge the flame braziers outside Southshore.",
            goals = {
                { type = "COMPLETE", questID = 549, text = "Recover Helcular's Rod from the Yeti Cave" },
                { type = "TURNIN",   questID = 549, text = "Turn in [Helcular's Rod] to Novice Veranna at Tarren Mill" },
            }
        },
        {
            title = "The Mirage Raceway & Shimmering Flats",
            zone = "Thousand Needles",
            coords = { x = 80.0, y = 77.0 },
            text = "Hearth back to Freewind Post and run far east into the salt flats of the Shimmering Flats (Mirage Raceway).",
            goals = {
                { type = "ACCEPT", questID = 1104, text = "Accept [Rocket Car Parts] from Kravel Koalbeard" },
                { type = "ACCEPT", questID = 1108, text = "Accept [Salt Flat Venom] from Fizzle Brassbolts" },
                { type = "LEVEL",  level = 30,     text = "Reach Level 30 and prepare for Razorfen Kraul" },
            }
        }
    }
})
