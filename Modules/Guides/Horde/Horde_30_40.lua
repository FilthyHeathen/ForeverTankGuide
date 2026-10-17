--[[
    Heathen's Forever Guide - Modules/Guides/Horde/Horde_30_40.lua
    Step-by-Step Leveling Guide: Stranglethorn Vale, Arathi Highlands & Badlands (Levels 30–40)
]]

local ADDON_NAME, HFG = ...
if not HFG then HFG = _G.HFG end
if not HFG then return end

HFG:RegisterGuide({
    id = "Horde_Mid_30_40",
    title = "Stranglethorn Vale, Arathi & Badlands (30–40)",
    category = "Leveling",
    faction = "Horde",
    minLevel = 30,
    maxLevel = 40,
    order = 4,
    steps = {
        {
            title = "Northern Stranglethorn & Nesingwary's Expedition",
            zone = "Stranglethorn Vale",
            coords = { x = 35.5, y = 10.5 },
            text = "Welcome to the jungle! Ride or take the zeppelin to Grom'gol, then head northeast to Nesingwary's Expedition camp.",
            goals = {
                { type = "ACCEPT", questID = 185, text = "Accept [Tiger Mastery] from Ajeck Rouache" },
                { type = "ACCEPT", questID = 190, text = "Accept [Panther Mastery] from Sir S. J. Erlgadin" },
                { type = "ACCEPT", questID = 194, text = "Accept [Raptor Mastery] from Hemet Nesingwary Jr." },
            }
        },
        {
            title = "Mastery Hunts & Grom'gol Bounties",
            zone = "Stranglethorn Vale",
            coords = { x = 32.0, y = 28.0 },
            text = "Hunt young tigers, panthers, and Stranglethorn raptors across the northern jungle canopy.",
            goals = {
                { type = "COMPLETE", questID = 185, text = "Kill 10 Young Stranglethorn Tigers" },
                { type = "COMPLETE", questID = 190, text = "Kill 10 Young Panthers" },
                { type = "COMPLETE", questID = 194, text = "Kill 10 Stranglethorn Raptors" },
                { type = "TURNIN",   questID = 185, text = "Turn in [Tiger Mastery] at Nesingwary" },
                { type = "TURNIN",   questID = 190, text = "Turn in [Panther Mastery] at Nesingwary" },
                { type = "TURNIN",   questID = 194, text = "Turn in [Raptor Mastery] at Nesingwary" },
                { type = "LEVEL",    level = 33,    text = "Reach Level 33 and grab Grom'gol flight path" },
            }
        },
        {
            title = "Hammerfall & Arathi Highlands Outpost",
            zone = "Arathi Highlands",
            coords = { x = 73.0, y = 33.0 },
            text = "Travel northeast through the Thoradin Wall into Arathi Highlands and report to Hammerfall.",
            goals = {
                { type = "FLY",    text = "Discover Hammerfall Flight Path" },
                { type = "HEARTH", location = "Hammerfall", text = "Set Hearthstone at Hammerfall Inn" },
                { type = "ACCEPT", questID = 633, text = "Accept [Hammerfall] / [Foul Magics] from Tor'gan" },
                { type = "ACCEPT", questID = 676, text = "Accept [Call to Arms] from Drum Fel" },
            }
        },
        {
            title = "Witherbark Trolls & Stromgarde Recon",
            zone = "Arathi Highlands",
            coords = { x = 68.0, y = 65.0 },
            text = "Assault the Witherbark village south and collect troll ears and medicine pouches.",
            goals = {
                { type = "COMPLETE", questID = 633, text = "Collect 10 Witherbark Medicine Pouches" },
                { type = "COMPLETE", questID = 676, text = "Defeat 10 Witherbark Shadow Hunters" },
                { type = "TURNIN",   questID = 633, text = "Turn in to Tor'gan at Hammerfall" },
                { type = "TURNIN",   questID = 676, text = "Turn in to Drum Fel at Hammerfall" },
                { type = "LEVEL",    level = 36,    text = "Reach Level 36" },
            }
        },
        {
            title = "Kargath & The Badlands Desert",
            zone = "Badlands",
            coords = { x = 2.5, y = 46.0 },
            text = "Travel south through Loch Modan or Searing Gorge into the arid canyons of Badlands (Kargath).",
            goals = {
                { type = "FLY",    text = "Discover Kargath Flight Path" },
                { type = "ACCEPT", questID = 709, text = "Accept [Badlands Reagent Run] from Jarkal Mossmeld" },
                { type = "ACCEPT", questID = 716, text = "Accept [Coyote Thieves] from Riggle Fuzzprocket" },
                { type = "COMPLETE", questID = 716, text = "Collect 30 Coyote Jowls" },
                { type = "TURNIN",   questID = 716, text = "Turn in [Coyote Thieves]" },
                { type = "LEVEL",    level = 40,    text = "Reach Level 40, purchase your Mount, and train Level 40 skills!" },
            }
        }
    }
})
