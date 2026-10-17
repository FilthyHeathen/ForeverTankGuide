--[[
    Heathen's Forever Guide - Modules/Guides/Attunements/Keys_Dungeon.lua
    Step-by-Step Guide: Essential Classic Dungeon Keys
    Covers: Scarlet Key, Mallet of Zul'Farrak, Scepter of Celebras,
    Shadowforge Key, Skeleton Key (Scholomance), Key to the City, Crescent Key, Workshop Key.
]]

local ADDON_NAME, HFG = ...
if not HFG then HFG = _G.HFG end
if not HFG then return end

HFG:RegisterGuide({
    id = "Keys_Dungeon_All",
    title = "Dungeon Keys Compendium (Scarlet, Mallet, Scepter, BRD, Scholo, DM)",
    category = "Keys & Attunements",
    faction = "Both",
    minLevel = 30,
    maxLevel = 60,
    order = 101,
    steps = {
        {
            title = "1. Scarlet Key (Scarlet Monastery)",
            zone = "Scarlet Monastery",
            coords = { x = 70.0, y = 30.0 },
            text = "Unlocks Scarlet Monastery Armory and Cathedral wings.\n" ..
                   "• Enter Scarlet Monastery Library.\n" ..
                   "• Fight through to Arcanist Doan's chamber.\n" ..
                   "• Defeat Doan and loot the [Scarlet Key] from Doan's Strongbox on the table behind him.",
            goals = {
                { type = "COMPLETE", text = "Clear Scarlet Monastery: Library to Arcanist Doan" },
                { type = "COMPLETE", text = "Loot [Scarlet Key] from Doan's Strongbox" },
            }
        },
        {
            title = "2. Workshop Key (Gnomeregan Backdoor)",
            zone = "Gnomeregan",
            coords = { x = 24.0, y = 38.0 },
            text = "Unlocks the Gnomeregan workshop back entrance in Dun Morogh.\n" ..
                   "• Enter Gnomeregan dungeon.\n" ..
                   "• Proceed across the elevated catwalks to Electrocutioner 6000.\n" ..
                   "• Defeat Electrocutioner 6000 to loot the [Workshop Key].",
            goals = {
                { type = "COMPLETE", text = "Defeat Electrocutioner 6000 inside Gnomeregan" },
                { type = "COMPLETE", text = "Loot [Workshop Key]" },
            }
        },
        {
            title = "3. Mallet of Zul'Farrak (Summon Gahz'rilla)",
            zone = "The Hinterlands",
            coords = { x = 48.0, y = 68.0 },
            text = "Required to strike the Gong of Bethekk and summon the hydra boss Gahz'rilla in Zul'Farrak.\n" ..
                   "• Head to Altar of Zul in The Hinterlands.\n" ..
                   "• Fight to the top of the pyramid and slay Qiaga the Keeper (Level 50 Elite).\n" ..
                   "• Loot the [Sacred Mallet] from Qiaga.\n" ..
                   "• Travel east to Jintha'Alor elite troll city and fight all the way to the top altar.\n" ..
                   "• Use the Sacred Mallet at the altar to forge the permanent [Mallet of Zul'Farrak]!",
            goals = {
                { type = "COMPLETE", text = "Slay Qiaga the Keeper at Altar of Zul and loot [Sacred Mallet]" },
                { type = "COMPLETE", text = "Climb to the top of Jintha'Alor" },
                { type = "COMPLETE", text = "Use Sacred Mallet at Jintha'Alor altar to create [Mallet of Zul'Farrak]" },
            }
        },
        {
            title = "4. Scepter of Celebras (Inner Maraudon Portal)",
            zone = "Maraudon",
            coords = { x = 29.0, y = 62.0 },
            text = "Unlocks the portal directly to the inner sanctum of Maraudon (Princess Theradras & Rotgrip).\n" ..
                   "• Defeat Noxxion in Orange side and loot [Celebrian Rod].\n" ..
                   "• Defeat Lord Vyletongue in Purple side and loot [Celebrian Diamond].\n" ..
                   "• Venture down to Celebras the Cursed in the grove between both sides.\n" ..
                   "• Defeat Celebras to redeem his spirit, accept [Legends of Maraudon], and speak to him.\n" ..
                   "• Watch the purification ritual and receive the permanent [Scepter of Celebras].",
            goals = {
                { type = "ACCEPT", questID = 7044, text = "Accept [Legends of Maraudon] from Celebras the Redeemed" },
                { type = "COMPLETE", questID = 7044, text = "Collect Celebrian Rod and Celebrian Diamond" },
                { type = "TURNIN", questID = 7044, text = "Turn in [Legends of Maraudon] and complete ritual for [Scepter of Celebras]" },
            }
        },
        {
            title = "5. Shadowforge Key (Blackrock Depths Gates)",
            zone = "Blackrock Depths",
            coords = { x = 40.0, y = 35.0 },
            text = "Unlocks the massive iron doors, gates, and shortcuts throughout Blackrock Depths.\n" ..
                   "• Die anywhere in Blackrock Mountain or BRD.\n" ..
                   "• As a ghost, climb the chains in Blackrock Mountain to the central tomb room.\n" ..
                   "• Speak with the spirit of Franclorn Forgewright and accept [Dark Iron Legacy].\n" ..
                   "• Resurrect and enter BRD. Navigate to Fineous Darkvire and slay him for [Ironfel].\n" ..
                   "• Clear into the Ring of the Law, proceed to the Shrine of Franclorn Forgewright behind the secret bust, and place Ironfel to receive the [Shadowforge Key]!",
            goals = {
                { type = "ACCEPT", questID = 3802, text = "Speak to ghost Franclorn Forgewright to accept [Dark Iron Legacy]" },
                { type = "COMPLETE", questID = 3802, text = "Defeat Fineous Darkvire and loot [Ironfel]" },
                { type = "TURNIN", questID = 3802, text = "Turn in at the Shrine of Franclorn Forgewright to forge [Shadowforge Key]" },
            }
        },
        {
            title = "6. Skeleton Key (Key to Scholomance)",
            zone = "Western Plaguelands",
            coords = { x = 43.0, y = 84.0 },
            text = "Unlocks the iron gates of Scholomance on Caer Darrow island.\n" ..
                   "• Alliance starts with Commander Ashlam Valorfist at Chillwind Camp; Horde starts with High Executor Derrington at The Bulwark.\n" ..
                   "• Complete [Clear the Way] / [Scarlet Diversion] and [All Along the Watchtowers].\n" ..
                   "• Accept [Scholomance] -> [Skeletal Fragments]. Slay Skeletons in Andorhal to gather 15 Skeletal Fragments.\n" ..
                   "• Travel to Gadgetzan and pay Krinkle Goodsteel 15 Gold for an Imbued Skeletal Key Mold.\n" ..
                   "• Slay Araj the Summoner in the center of Andorhal for the Scarab of Araj.\n" ..
                   "• Plunge the key into the lava atop Fire Plume Ridge in Un'Goro Crater to forge the completed [Skeleton Key]!",
            goals = {
                { type = "COMPLETE", text = "Complete [Skeletal Fragments] in Western Plaguelands" },
                { type = "COMPLETE", text = "Purchase Imbued Key Mold from Krinkle Goodsteel in Gadgetzan (15g)" },
                { type = "COMPLETE", text = "Defeat Araj the Summoner in Andorhal for Scarab of Araj" },
                { type = "COMPLETE", text = "Forge key at Fire Plume Ridge lava pool in Un'Goro Crater" },
                { type = "COMPLETE", text = "Receive completed [Skeleton Key]" },
            }
        },
        {
            title = "7. Key to the City (Stratholme Service Gate)",
            zone = "Stratholme",
            coords = { x = 40.0, y = 20.0 },
            text = "Unlocks the East Service Entrance to Stratholme, providing immediate access to the Undead / Baron Rivendare side.\n" ..
                   "• Enter Stratholme via the Front Gate (Living Side).\n" ..
                   "• Fight through to the Festival Lane / King's Square area.\n" ..
                   "• Slay Magistrate Barthilas and loot the [Key to the City].\n" ..
                   "• Note: If Barthilas runs away during the fight, he will wait at the Slaughterhouse entrance in the Undead section.",
            goals = {
                { type = "COMPLETE", text = "Enter Stratholme and locate Magistrate Barthilas" },
                { type = "COMPLETE", text = "Defeat Magistrate Barthilas" },
                { type = "COMPLETE", text = "Loot [Key to the City]" },
            }
        },
        {
            title = "8. Crescent Key (Dire Maul North & West)",
            zone = "Dire Maul",
            coords = { x = 60.0, y = 30.0 },
            text = "Unlocks the grand entrance doors to Dire Maul North and Dire Maul West.\n" ..
                   "• Enter Dire Maul East (Warpwood Quarter).\n" ..
                   "• Speak to the mischievous imp Pusillin near the entrance.\n" ..
                   "• Pursue Pusillin as he flees across the instance corridors, speaking to him at each stopping point.\n" ..
                   "• In the final courtyard, Pusillin turns hostile with an entourage of wild imps.\n" ..
                   "• Slay Pusillin and loot the permanent [Crescent Key]!",
            goals = {
                { type = "COMPLETE", text = "Speak to Pusillin at entrance of Dire Maul East" },
                { type = "COMPLETE", text = "Chase Pusillin through Dire Maul East corridors" },
                { type = "COMPLETE", text = "Defeat Pusillin in final chamber and loot [Crescent Key]" },
            }
        },
    }
})
