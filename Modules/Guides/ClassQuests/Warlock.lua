--[[
    Heathen's Forever Guide - Modules/Guides/ClassQuests/Warlock.lua
    Full 1–60 Class Quest Progression Guide for Warlocks
    Covers: Voidwalker (10), Succubus (20), Felhunter (30), Infernal/Doomguard (50), Epic Dreadsteed (60).
]]

local ADDON_NAME, HFG = ...
if not HFG then HFG = _G.HFG end
if not HFG then return end

HFG:RegisterGuide({
    id = "ClassQuest_Warlock",
    title = "Warlock Class Progression (1–60: Demons, Infernal, Epic Dreadsteed)",
    category = "Class Quests",
    faction = "Both",
    classes = { "WARLOCK" },
    minLevel = 10,
    maxLevel = 60,
    order = 203,
    steps = {
        {
            title = "1. Level 10: Summon Voidwalker (The Blue Tank)",
            zone = "Faction Capitals / Starting Zones",
            coords = { x = 40.0, y = 50.0 },
            text = "Unlocks your personal leveling tank demon [Summon Voidwalker].\n" ..
                   "• Horde (Orc/Troll): Speak to Gan'rul Bloodeye in Orgrimmar Cleft of Shadow, travel to Skull Rock in Durotar to retrieve the tablet, then summon and defeat the Voidwalker in the summoning circle.\n" ..
                   "• Horde (Forsaken): Speak to Carendin Halgar in Undercity, retrieve the grimoire from Brill graveyard, and summon the demon.\n" ..
                   "• Alliance (Human): Speak to Gakin the Two-Faced in The Slaughtered Lamb basement (Stormwind Mage Quarter), search the catacombs, and bind the demon.\n" ..
                   "• Alliance (Gnome): Speak to Lago Blackwrench in Ironforge Tinkertown, travel to the Quarry, and bind the demon.",
            goals = {
                { type = "ACCEPT", text = "Accept Voidwalker summoning quest from your Warlock trainer" },
                { type = "COMPLETE", text = "Recover the summoning runes and return to summoning circle" },
                { type = "TURNIN", text = "Summon, defeat, and bind the [Summon Voidwalker] spell!" },
            }
        },
        {
            title = "2. Level 20: Summon Succubus (Seduction & Charm)",
            zone = "The Barrens / Wetlands / Ashenvale",
            coords = { x = 62.0, y = 35.0 },
            text = "Unlocks [Summon Succubus], providing crowd control (Seduction) and ranged DPS.\n" ..
                   "• Horde: Speak to Carendin Halgar in Undercity or Gazrog in Orgrimmar. Retrieve the Hearts of the Lovers from Ashenvale and Wetlands, then summon and defeat the Succubus.\n" ..
                   "• Alliance: Speak to Gakin the Two-Faced in Stormwind. Travel to Ashenvale and Wetlands to find the Woodpaw Gnoll lover necklace and the Silverpine defias artifact, return to Stormwind, and bind the Succubus in the basement circle.",
            goals = {
                { type = "ACCEPT", text = "Accept Succubus quest from Warlock Trainer" },
                { type = "COMPLETE", text = "Retrieve the tokens of love and passion" },
                { type = "TURNIN", text = "Summon, defeat, and learn [Summon Succubus]!" },
            }
        },
        {
            title = "3. Level 30: Summon Felhunter (The Spell-Lock Hound)",
            zone = "The Barrens & Thousand Needles",
            coords = { x = 62.0, y = 35.0 },
            text = "Unlocks [Summon Felhunter], the ultimate anti-caster demon with Spell Lock and Devour Magic.\n" ..
                   "• Speak to Strahad Farsan above Ratchet in The Barrens to accept [Tome of the Cabal].\n" ..
                   "• Travel to the Hillsbrad Foothills and collect the torn pages from the Syndicate camps.\n" ..
                   "• Travel to Thousand Needles and collect the Moldering Rod from the ruins.\n" ..
                   "• Return to Strahad in Ratchet to assemble the grimoire.\n" ..
                   "• Cast the summoning ritual, defeat the Felhunter in combat, and permanently learn [Summon Felhunter]!",
            goals = {
                { type = "ACCEPT", questID = 1798, text = "Accept [Tome of the Cabal] from Strahad Farsan in Ratchet" },
                { type = "COMPLETE", text = "Collect pages in Hillsbrad and the Rod in Thousand Needles" },
                { type = "TURNIN", questID = 1806, text = "Summon and bind the Felhunter to learn [Summon Felhunter]!" },
            }
        },
        {
            title = "4. Level 50: Sunken Temple Class Quest & Infernal / Doomguard",
            zone = "Felwood & Sunken Temple",
            coords = { x = 40.0, y = 50.0 },
            text = "Endgame warlock power: Sunken Temple weapons and terrifying demons.\n" ..
                   "• Speak to Niby the Almighty in Felwood (coords: 41.6, 44.8) to accept [What Does Niby Get?].\n" ..
                   "• Complete [Kroshius' Infernal Core] by slaying the colossal shattered infernal Kroshius in Felwood to learn [Summon Infernal]!\n" ..
                   "• Accept [Trolls of a Feather] from Niby and enter Temple of Atal'Hakkar (Sunken Temple).\n" ..
                   "• Collect Voodoo Feathers from the troll minibosses.\n" ..
                   "• Turn in to choose: [Soul Harvester] (iconic Warlock staff/scythe), [Abyss Shroud], or [Robes of Servitude]!\n" ..
                   "• Complete [The Ritual of Doom] from Daio the Decrepit in Blasted Lands to learn [Ritual of Doom] (Doomguard)!",
            goals = {
                { type = "ACCEPT", questID = 8419, text = "Accept class quests from Niby the Almighty in Felwood" },
                { type = "COMPLETE", text = "Defeat Kroshius in Felwood to learn [Summon Infernal]" },
                { type = "COMPLETE", questID = 8421, text = "Collect Voodoo Feathers in Sunken Temple" },
                { type = "TURNIN", questID = 8421, text = "Turn in for [Soul Harvester] scythe or [Abyss Shroud]" },
                { type = "COMPLETE", text = "Complete Ritual of Doom in Blasted Lands for [Ritual of Doom]" },
            }
        },
        {
            title = "5. Level 60: Epic Dreadsteed Mount (Part 1 - Alchemical Materials)",
            zone = "Burning Steppes & Scholomance",
            coords = { x = 12.0, y = 31.0 },
            text = "The dark ritual to summon your 100% Epic Dreadsteed of Xoroth.\n" ..
                   "• Speak to Mor'zul Bloodbringer at the altar in northwest Burning Steppes.\n" ..
                   "• Complete his trade assignments with his goblin assistant Gorzeeki Wildeyes:\n" ..
                   "    - 30 Black Dragonscale.\n" ..
                   "    - 10 Dark Iron Ore.\n" ..
                   "    - 6 Large Radiant Shards.\n" ..
                   "    - 2 Elixirs of Shadow Power.\n" ..
                   "    - 1 Arcanite Bar.\n" ..
                   "• Travel to Scholomance to release the Imps into the alchemy lab to obtain the Infused Shadow Potion.\n" ..
                   "• Purchase the reusable summoning ritual items (Jhabbi's Bell, Wheel of the Black March, and Doomsday Candle) from Gorzeeki (totaling 250g or borrow from a guild Warlock).",
            goals = {
                { type = "ACCEPT", questID = 7622, text = "Accept [Mor'zul Bloodbringer] in Burning Steppes" },
                { type = "COMPLETE", text = "Gather Dragonscales, Dark Iron Ore, Large Radiant Shards, and Arcanite" },
                { type = "COMPLETE", text = "Create Infused Shadow Potion in Scholomance lab" },
            }
        },
        {
            title = "6. Level 60: Epic Dreadsteed Mount (Part 2 - Dire Maul West Ritual)",
            zone = "Dire Maul West",
            coords = { x = 60.0, y = 30.0 },
            text = "The grand summoning event in the demonic prison of Immol'thar.\n" ..
                   "• Form a strong 5-man dungeon group and enter Dire Maul West.\n" ..
                   "• Disable all 5 pylons and defeat the giant demon Immol'thar in the central chamber.\n" ..
                   "• Once the room is cleared, place the Jhabbi's Bell, Wheel of the Black March, and Doomsday Candle in the center of the ring.\n" ..
                   "• Maintain the three artifacts while fighting off waves of invading Xorothian Imps and Dreadguards.\n" ..
                   "• When the runes complete, summon the Xorothian Dreadsteed and the Dreadlord Lord Hel'nurath!\n" ..
                   "• Slay Lord Hel'nurath, then speak to the defeated Xorothian Dreadsteed spirit.\n" ..
                   "• Bind the fiery steed to your soul to permanently learn [Summon Dreadsteed] (100% Epic Mount)!",
            goals = {
                { type = "COMPLETE", text = "Defeat Immol'thar in Dire Maul West" },
                { type = "COMPLETE", text = "Activate the summoning circle and defend the Bell, Wheel, and Candle" },
                { type = "COMPLETE", text = "Defeat Lord Hel'nurath and bind the Xorothian Dreadsteed spirit" },
                { type = "TURNIN", questID = 7631, text = "Learn [Summon Dreadsteed] (100% Epic Mount)!" },
            }
        },
    }
})
