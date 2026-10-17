--[[
    Heathen's Forever Guide - Modules/Guides/Attunements/Attunement_Raid.lua
    Step-by-Step Guide: Classic Raid Attunements
    Covers: Molten Core, Blackwing Lair, Onyxia's Lair (Horde & Alliance), Naxxramas.
]]

local ADDON_NAME, HFG = ...
if not HFG then HFG = _G.HFG end
if not HFG then return end

HFG:RegisterGuide({
    id = "Attunement_Raid_All",
    title = "Raid Attunements (Molten Core, BWL, Onyxia, Naxxramas)",
    category = "Keys & Attunements",
    faction = "Both",
    minLevel = 55,
    maxLevel = 60,
    order = 102,
    steps = {
        {
            title = "1. Molten Core: Attunement to the Core",
            zone = "Blackrock Mountain",
            coords = { x = 35.0, y = 84.0 },
            text = "Grants direct teleportation access into Molten Core via Lothos Riftwaker.\n" ..
                   "• Speak to Lothos Riftwaker at the bottom of the Blackrock Mountain chains (near the entrance to BRD).\n" ..
                   "• Accept [Attunement to the Core] (Req Level 55).\n" ..
                   "• Enter Blackrock Depths and fight towards the entrance to Molten Core (past the Lyceum and the Molten Bridge).\n" ..
                   "• Interact with the red [Core Fragment] stalagmite on the left wall just outside the instance portal.\n" ..
                   "• Return to Lothos Riftwaker to complete the quest. You can now talk to Lothos to teleport straight into MC!",
            goals = {
                { type = "ACCEPT", questID = 7487, text = "Accept [Attunement to the Core] from Lothos Riftwaker" },
                { type = "COMPLETE", questID = 7487, text = "Loot the Core Fragment outside the Molten Core portal in BRD" },
                { type = "TURNIN", questID = 7487, text = "Turn in [Attunement to the Core] to Lothos Riftwaker" },
            }
        },
        {
            title = "2. Blackwing Lair: Blackhand's Command",
            zone = "Blackrock Mountain",
            coords = { x = 48.0, y = 43.0 },
            text = "Grants direct access to Blackwing Lair by touching the Orb of Command in Blackrock Spire hallway.\n" ..
                   "• Travel up the ramp in Blackrock Mountain towards the entrance of Blackrock Spire.\n" ..
                   "• Take the hallway to the right and defeat the Scarshield Quartermaster (Level 59-60 Elite).\n" ..
                   "• Loot [Blackhand's Command] letter from the Quartermaster and right-click it to start the quest.\n" ..
                   "• Form a group and enter Upper Blackrock Spire (UBRS).\n" ..
                   "• Slay General Drakkisath in the final chamber.\n" ..
                   "• Click the glowing [Orb of Command] located behind General Drakkisath's throne.\n" ..
                   "• Attunement complete! You can now right-click the orb in Blackrock Mountain to teleport into BWL.",
            goals = {
                { type = "ACCEPT", questID = 7761, text = "Loot Blackhand's Command from Scarshield Quartermaster & accept quest" },
                { type = "COMPLETE", questID = 7761, text = "Defeat General Drakkisath in Upper Blackrock Spire (UBRS)" },
                { type = "TURNIN", questID = 7761, text = "Touch the Orb of Command behind General Drakkisath" },
            }
        },
        {
            title = "3. Onyxia's Lair: Horde Chain (Part 1 - Warlord's Command)",
            zone = "Badlands & LBRS",
            coords = { x = 2.0, y = 46.0 },
            faction = "Horde",
            text = "The epic journey to acquire the Drakefire Amulet for Horde champions.\n" ..
                   "• Speak to Warlord Goretooth at Kargath in Badlands to accept [Warlord's Command].\n" ..
                   "• Enter Lower Blackrock Spire (LBRS) with a group.\n" ..
                   "• Slay Highlord Omokk, War Master Voone, and Overlord Wyrmthalak.\n" ..
                   "• Retrieve the Important Blackrock Documents found sitting on the ground near one of the bosses.\n" ..
                   "• Return to Kargath and turn in to Warlord Goretooth.\n" ..
                   "• Accept [Eitrigg's Wisdom], travel to Thrall's chamber in Orgrimmar, and speak to Eitrigg & Thrall.",
            goals = {
                { type = "ACCEPT", questID = 4903, text = "Accept [Warlord's Command] from Warlord Goretooth at Kargath" },
                { type = "COMPLETE", questID = 4903, text = "Slay Omokk, Voone, Wyrmthalak and retrieve Documents in LBRS" },
                { type = "TURNIN", questID = 4903, text = "Turn in [Warlord's Command] at Kargath" },
                { type = "ACCEPT", questID = 4941, text = "Accept [Eitrigg's Wisdom] and speak to Eitrigg & Thrall in Orgrimmar" },
            }
        },
        {
            title = "4. Onyxia's Lair: Horde Chain (Part 2 - Rend & Rexxar)",
            zone = "UBRS & Desolace",
            coords = { x = 50.0, y = 15.0 },
            faction = "Horde",
            text = "Vanquish Rend Blackhand and seek the Champion of the Horde.\n" ..
                   "• Accept [For The Horde!] from Warchief Thrall.\n" ..
                   "• Enter Upper Blackrock Spire (UBRS), survive the Blackhand Stadium waves, and slay Warchief Rend Blackhand!\n" ..
                   "• Loot the Head of Rend Blackhand and return to Thrall in Orgrimmar to receive the Warchief's Blessing and Onyxia questline continuation.\n" ..
                   "• Accept [What the Wind Carries] and travel to Desolace to locate Rexxar (wandering the central road between Nijel's Point and Ghost Walker Post).\n" ..
                   "• Turn in to Rexxar and accept [The Champion of the Horde]. Speak to Rokaro at Shadowprey Village in Desolace.\n" ..
                   "• Accept [The Testament of Rexxar] and speak to Miranda the Hag in Western Plaguelands (Sorrow Hill).",
            goals = {
                { type = "COMPLETE", questID = 4974, text = "Defeat Rend Blackhand in UBRS and return Head of Rend to Thrall" },
                { type = "COMPLETE", text = "Find Rexxar on the main path of Desolace and accept [The Champion of the Horde]" },
                { type = "COMPLETE", text = "Speak to Rokaro and Miranda the Hag in Western Plaguelands" },
            }
        },
        {
            title = "5. Onyxia's Lair: Horde Chain (Part 3 - Drakefire Amulet)",
            zone = "Dustwallow Marsh & UBRS",
            coords = { x = 56.0, y = 87.0 },
            faction = "Horde",
            text = "Infiltrate the black dragonkin and forge the Drakefire Amulet.\n" ..
                   "• Complete Miranda's quest [Eyes of the Beast] by gathering 20 Plated Dragonscale from black drakes in UBRS.\n" ..
                   "• Take the dragon illusion medallion to Emberstrife's Cave in south Dustwallow Marsh.\n" ..
                   "• Equip the amulet to deceive Emberstrife and accept the Test of Skulls:\n" ..
                   "    - Slay Chronalis at Caverns of Time in Tanaris.\n" ..
                   "    - Slay Somnus in Swamp of Sorrows.\n" ..
                   "    - Slay Axtroz in Wetlands (Grim Batol gates).\n" ..
                   "• Return the skulls to Emberstrife to receive the Dull Carved Dragon's Eye.\n" ..
                   "• Bring the eye to Rexxar in Desolace, who instructs you to slay General Drakkisath in UBRS for Drakkisath's Blood!\n" ..
                   "• Return the blood to Rexxar to claim your permanent [Drakefire Amulet]! Carry it in your bags to enter Onyxia's Lair.",
            goals = {
                { type = "COMPLETE", text = "Deceive Emberstrife and collect 3 dragon skulls (Tanaris, Swamp of Sorrows, Wetlands)" },
                { type = "COMPLETE", text = "Slay General Drakkisath in UBRS and loot [Drakkisath's Blood]" },
                { type = "COMPLETE", text = "Return blood to Rexxar in Desolace and claim [Drakefire Amulet]!" },
            }
        },
        {
            title = "6. Onyxia's Lair: Alliance Chain (Part 1 - Dragonkin Menace)",
            zone = "Burning Steppes & Lakeshire",
            coords = { x = 85.0, y = 69.0 },
            faction = "Alliance",
            text = "Uncover the draconic conspiracy threatening the Kingdom of Stormwind.\n" ..
                   "• Travel to Morgan's Vigil in Burning Steppes and speak with Helendis Riverhorn to accept [Dragonkin Menace].\n" ..
                   "• Slay 15 Broodling, 10 Dragonkin, 4 Wyrmkin, and 1 Black Drake in Burning Steppes.\n" ..
                   "• Turn in and accept [The True Masters], deliver the sealed dispatch to Magistrate Solomon in Lakeshire (Redridge Mountains).\n" ..
                   "• Magistrate Solomon sends you to Highlord Bolvar Fordragon in Stormwind Keep.\n" ..
                   "• Bolvar and Lady Katrana Prestor dismiss the report, but Bolvar sends you back to Solomon, who directs you to Marshal Windsor.",
            goals = {
                { type = "ACCEPT", questID = 4182, text = "Accept [Dragonkin Menace] from Helendis Riverhorn at Morgan's Vigil" },
                { type = "COMPLETE", questID = 4182, text = "Slay 30 Black Dragonkin in Burning Steppes" },
                { type = "COMPLETE", text = "Deliver reports to Magistrate Solomon in Redridge & Bolvar in Stormwind Keep" },
            }
        },
        {
            title = "7. Onyxia's Lair: Alliance Chain (Part 2 - Jail Break!)",
            zone = "Blackrock Depths",
            coords = { x = 40.0, y = 55.0 },
            faction = "Alliance",
            text = "Rescue Marshal Windsor from the depths of Blackrock Depths.\n" ..
                   "• Enter Blackrock Depths and locate Marshal Windsor locked inside the detention block cells.\n" ..
                   "• Farm Dark Iron mobs in BRD until [A Crumpled Up Note] drops, revealing the conspiracy.\n" ..
                   "• Accept [A Shred of Hope] and retrieve Windsor's Lost Information from High Interrogator Gerstahn and General Angerforge.\n" ..
                   "• Return to Windsor and begin the famous escort event: [Jail Break!]!\n" ..
                   "• Escort Marshal Windsor safely out of the prison block and to the entrance of Blackrock Depths.",
            goals = {
                { type = "COMPLETE", text = "Find Marshal Windsor in BRD prison cell" },
                { type = "COMPLETE", text = "Loot [A Crumpled Up Note] and retrieve Windsor's Lost Information" },
                { type = "COMPLETE", text = "Successfully escort Marshal Windsor during [Jail Break!]" },
            }
        },
        {
            title = "8. Onyxia's Lair: Alliance Chain (Part 3 - The Great Masquerade & Amulet)",
            zone = "Stormwind City & UBRS",
            coords = { x = 60.0, y = 35.0 },
            faction = "Alliance",
            text = "Expose Lady Katrana Prestor in Stormwind Keep and forge the Drakefire Amulet.\n" ..
                   "• Report to Marshal Windsor at the Gates of Stormwind City.\n" ..
                   "• Accompany Windsor as he marches through the Valley of Heroes into Stormwind Keep.\n" ..
                   "• Confront Lady Katrana Prestor! Windsor exposes her as Onyxia.\n" ..
                   "• Lady Katrana transforms into her draconic form, strikes down Windsor, and summons dragon elites.\n" ..
                   "• Highlord Bolvar Fordragon battles and slays the dragonkin! Speak to Bolvar to accept [The Dragon's Eye].\n" ..
                   "• Travel to Winterspring, step into the blue teleport rune at Mount Neverest to meet Haleh.\n" ..
                   "• Enter UBRS, slay General Drakkisath, and loot [Drakkisath's Blood].\n" ..
                   "• Return to Haleh in Winterspring to receive the completed [Drakefire Amulet]!",
            goals = {
                { type = "COMPLETE", text = "March with Marshal Windsor through Stormwind during [The Great Masquerade]" },
                { type = "COMPLETE", text = "Witness the unmasking of Lady Katrana Prestor in Stormwind Keep" },
                { type = "COMPLETE", text = "Visit Haleh atop Mount Neverest in Winterspring" },
                { type = "COMPLETE", text = "Defeat General Drakkisath in UBRS for [Drakkisath's Blood]" },
                { type = "COMPLETE", text = "Turn in to Haleh and claim your [Drakefire Amulet]!" },
            }
        },
        {
            title = "9. Naxxramas: The Dread Citadel",
            zone = "Eastern Plaguelands",
            coords = { x = 81.0, y = 58.0 },
            text = "Attunement to the dread necropolis of Naxxramas floating above Stratholme.\n" ..
                   "• Requires Level 60 and at least Honored reputation with the Argent Dawn.\n" ..
                   "• Speak to Archmage Angela Dosantos at Light's Hope Chapel in Eastern Plaguelands.\n" ..
                   "• Cost depends entirely on your Argent Dawn standing:\n" ..
                   "    - Honored: 5 Righteous Orbs, 2 Nexus Crystals, 1 Arcane Crystal, and 60 Gold.\n" ..
                   "    - Revered: 2 Righteous Orbs, 1 Nexus Crystal, and 30 Gold.\n" ..
                   "    - Exalted: Completely FREE (0 gold, 0 materials)!\n" ..
                   "• Turn in the quest to become attuned. You can now step onto the teleportation rune in the Stratholme cathedral to enter Naxxramas.",
            goals = {
                { type = "ACCEPT", questID = 9121, text = "Speak with Archmage Angela Dosantos at Light's Hope Chapel" },
                { type = "COMPLETE", text = "Provide the materials required for your Argent Dawn reputation rank" },
                { type = "TURNIN", questID = 9121, text = "Turn in [The Dread Citadel - Naxxramas] for permanent attunement" },
            }
        },
    }
})
