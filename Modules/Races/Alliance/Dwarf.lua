--[[
    Heathen's Forever Guide - Modules/Races/Alliance/Dwarf.lua
    Dwarf Racials, Passives, Synergies, Quest Routing, and Macros
]]

local ADDON_NAME, FTG = ...

local DwarfModule = {
    name = "Dwarf",
    token = "DWARF",
    faction = "Alliance",
    description = "God-tier defensive tanking and healing race. Stoneform removes all bleed, poison, and disease debuffs and grants +10% Armor. Frost Resistance and Find Treasure.",
    brackets = {
        [1] = {
            zones = {
                { name = "Coldridge Valley (Dun Morogh)", range = "1â€“6", notes = "Dwarf & Gnome starting valley: Rockjaw Troggs, Frostmane Troll cave, and Boar hunting." },
                { name = "Dun Morogh / Kharanos", range = "6â€“10", notes = "Kharanos hub, Brewnall Village, Gol'Bolar Quarry, and Ironforge tram connection." },
                { name = "Loch Modan (Thelsamar) & Wetlands", range = "10â€“20", notes = "Thelsamar & Farstrider Lodge quests, Stonesplitter Troggs, and Westfall/Deadmines option." }
            },
            racials = {
                { name = "Stoneform", desc = "Dispels all Bleed, Poison, and Disease effects and grants complete immunity to them, plus +10% Armor for 8 seconds (3 min cooldown)!" },
                { name = "Frost Resistance", desc = "+10 Frost Resistance passively. Great against frost mages and Stratholme water elementals." },
                { name = "Gun Specialization", desc = "+5 skill with guns and ranged weapon crit." },
                { name = "Find Treasure", desc = "Displays chests and locked treasure boxes on the minimap." }
            },
            tankTips = {
                "Stoneform is the ONLY ability in vanilla/classic WoW that removes Bleed debuffs (like Rend or boss mortal bleeds) and stacking poisons.",
                "Pop Stoneform immediately when poisoned in Wailing Caverns, RFK, or Maraudon to cancel devastating dot ticks."
            }
        },
        [2] = {
            zones = {
                { name = "Wetlands (Menethil Harbor) & Duskwood (Darkshire)", range = "20â€“30", notes = "Menethil Harbor excavations/orcs, Darkshire undead chains, and Gnomeregan/Stockade runs." },
                { name = "Hillsbrad Foothills (Southshore)", range = "25â€“33", notes = "Southshore Alliance hub: Durnholde Syndicate, Yeti cave, and Hillsbrad fields." },
                { name = "Arathi Highlands (Refuge Pointe)", range = "30â€“40", notes = "Refuge Pointe Alliance hub: Stromgarde Keep, Faldir's Cove, and Witherbark trolls." },
                { name = "Stranglethorn Vale (Rebel Camp)", range = "30â€“40", notes = "Rebel Camp, Nesingwary's Expedition (+5 Gun Skill synergy!), and Booty Bay." }
            },
            tankTips = {
                "In Shadowfang Keep and Scarlet Monastery, Stoneform eliminates disease and bleed effects without needing healer dispels."
            }
        },
        [3] = {
            zones = {
                { name = "Badlands & Uldaman (Ironforge Explorers' League)", range = "38â€“44", notes = "Prospector quests tied directly to Ironforge's Explorers' League and Uldaman." },
                { name = "Feralas (Feathermoon Stronghold)", range = "42â€“48", notes = "Feathermoon Stronghold Alliance hub: Gordunni ogres, Yetis, and Maraudon prep." },
                { name = "Tanaris (Gadgetzan) & Hinterlands (Aerie Peak)", range = "43â€“50", notes = "Aerie Peak Wildhammer dwarves, Jintha'Alor elites, and Zul'Farrak dungeon quests." },
                { name = "Searing Gorge (Thorium Point)", range = "48â€“52", notes = "Dark Iron dwarf bounties and Blackrock Depths key preparation." }
            },
            tankTips = {
                "In Maraudon and Zul'Farrak, Stoneform completely negates Princess Theradras and Noxxion lethal stacking nature poisons."
            }
        },
        [4] = {
            zones = {
                { name = "Un'Goro Crater (Marshal's Refuge)", range = "51â€“55", notes = "High-density circular quest loop and rich Thorium veins." },
                { name = "Western Plaguelands (Chillwind Camp)", range = "52â€“58", notes = "Chillwind Camp Alliance hub: Scourge cauldrons and Scholomance key chain." },
                { name = "Eastern Plaguelands (Light's Hope) & Burning Steppes", range = "54â€“60", notes = "Morgan's Vigil (Onyxia attunement), Blackrock Depths, and Stratholme." },
                { name = "Winterspring (Everlook)", range = "55â€“60", notes = "Winterfall furbolgs and endgame pre-raid BIS preparation." }
            },
            tankTips = {
                "In UBRS (Rend Blackhand) and Stratholme, Stoneform's +10% armor buff and bleed immunity turns deadly physical spikes into manageable blows."
            }
        }
    },
    macros = {
        {
            category = "Defensive / Tank",
            title = "Dwarf: Stoneform Cleanse & Armor",
            desc = "Instantly clears all bleeds, poisons, and diseases and gains +10% armor.",
            code = "#showtooltip Stoneform\n/stopcasting\n/cast Stoneform"
        }
    }
}

FTG:RegisterRaceModule("DWARF", DwarfModule)
