--[[
    Heathen's Forever Guide - Modules/Guides/Horde/Horde_50_60.lua
    Step-by-Step Leveling Guide: Un'Goro Crater, Felwood & Plaguelands (Levels 50–60)
]]

local ADDON_NAME, HFG = ...
if not HFG then HFG = _G.HFG end
if not HFG then return end

HFG:RegisterGuide({
    id = "Horde_Endgame_50_60",
    title = "Un'Goro Crater, Felwood & Plaguelands (50–60)",
    category = "Leveling",
    faction = "Horde",
    minLevel = 50,
    maxLevel = 60,
    order = 6,
    steps = {
        {
            title = "Descent into Un'Goro Crater",
            zone = "Un'Goro Crater",
            coords = { x = 44.0, y = 10.0 },
            text = "Descend the southwestern ramp from Tanaris into the primordial jungle of Un'Goro Crater. Ride to Marshal's Refuge.",
            goals = {
                { type = "FLY",    text = "Discover Marshal's Refuge Flight Path" },
                { type = "HEARTH", location = "Marshal's Refuge", text = "Set Hearthstone at Marshal's Refuge" },
                { type = "ACCEPT", questID = 3881, text = "Accept [The Pylon Towers] and gather Blue/Yellow/Red Power Crystals" },
                { type = "ACCEPT", questID = 4287, text = "Accept [Alien Ecology] from Holiy Maker" },
                { type = "ACCEPT", questID = 4491, text = "Accept [Shizzle's Flyer] from Shizzle" },
            }
        },
        {
            title = "The Great Un'Goro Circuit & Tar Pits",
            zone = "Un'Goro Crater",
            coords = { x = 50.0, y = 50.0 },
            text = "Embark on the massive circular route: slay Gorishi silithid, Stegodons, Pterodactyls, and watch out for roaming Devilsaurs!",
            goals = {
                { type = "COMPLETE", questID = 4287, text = "Collect 8 Un'Goro Gorilla Pelts" },
                { type = "COMPLETE", questID = 4491, text = "Collect 8 Pterodactyl Wings and 8 Dinosaur Scales" },
                { type = "TURNIN",   questID = 4287, text = "Turn in [Alien Ecology]" },
                { type = "TURNIN",   questID = 4491, text = "Turn in [Shizzle's Flyer]" },
                { type = "LEVEL",    level = 53,     text = "Reach Level 53" },
            }
        },
        {
            title = "Bloodvenom Post & Corrupted Felwood",
            zone = "Felwood",
            coords = { x = 34.0, y = 52.0 },
            text = "Travel north to the tainted boughs of Felwood. Discover Bloodvenom Post and ally with Timbermaw Hold.",
            goals = {
                { type = "FLY",    text = "Discover Bloodvenom Post Flight Path" },
                { type = "ACCEPT", questID = 5155, text = "Accept [A Husband's Last Wish] / [Wild Guardians]" },
                { type = "ACCEPT", questID = 8461, text = "Accept [Timbermaw Ally] at the northern tunnel" },
                { type = "LEVEL",  level = 55,     text = "Reach Level 55 and discover Everlook in Winterspring" },
            }
        },
        {
            title = "Western Plaguelands: The Bulwark & Cauldrons",
            zone = "Western Plaguelands",
            coords = { x = 83.0, y = 72.0 },
            text = "Travel east to the Tirisfal/WPL border at The Bulwark. Speak with High Executor Derrington and Shadow Priestess Vandis.",
            goals = {
                { type = "FLY",    text = "Discover The Bulwark Flight Path" },
                { type = "ACCEPT", questID = 5212, text = "Accept [Target: Felstone Field] (Cauldron Chain)" },
                { type = "COMPLETE", questID = 5212, text = "Defeat the Cauldron Lord at Felstone Field and loot the key" },
                { type = "TURNIN",   questID = 5212, text = "Turn in [Target: Felstone Field] at The Bulwark" },
                { type = "LEVEL",    level = 57,     text = "Reach Level 57" },
            }
        },
        {
            title = "Eastern Plaguelands: Light's Hope Chapel & Level 60!",
            zone = "Eastern Plaguelands",
            coords = { x = 81.5, y = 58.0 },
            text = "Ride through the corrupted fungal valley to the final bastion of the Argent Dawn at Light's Hope Chapel.",
            goals = {
                { type = "FLY",    text = "Discover Light's Hope Chapel Flight Path" },
                { type = "HEARTH", location = "Light's Hope Chapel", text = "Set Hearthstone at Light's Hope Chapel" },
                { type = "ACCEPT", questID = 6023, text = "Accept [The Argent Dawn Commission] and equip your trinket" },
                { type = "LEVEL",  level = 60,     text = "CONGRATULATIONS! Reach Level 60 and begin Endgame Attunements!" },
            }
        }
    }
})
