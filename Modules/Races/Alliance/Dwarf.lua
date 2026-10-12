--[[
    ForeverTankGuide - Modules/Races/Alliance/Dwarf.lua
    Dwarf Racials, Passives, Synergies, and Macros
]]

local ADDON_NAME, FTG = ...

local DwarfModule = {
    name = "Dwarf",
    token = "DWARF",
    faction = "Alliance",
    description = "God-tier defensive tanking race. Stoneform removes all bleed, poison, and disease debuffs and grants +10% Armor. Frost Resistance and Find Treasure.",
    brackets = {
        [1] = {
            zones = {
                { name = "Dun Morogh", range = "1–10", notes = "Coldridge Valley to Kharanos. Ironforge mining trainers." },
                { name = "Loch Modan & Wetlands", range = "10–20", notes = "Thelsamar and Menethil Harbor. High density of Tin and Bronze." }
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
            tankTips = {
                "In Shadowfang Keep and Scarlet Monastery, Stoneform eliminates disease and bleed effects without needing healer dispels."
            }
        },
        [3] = {
            tankTips = {
                "In Maraudon and Zul'Farrak, Stoneform completely negates Princess Theradras and Noxxion lethal stacking nature poisons."
            }
        },
        [4] = {
            tankTips = {
                "In UBRS (Rend Blackhand) and Stratholme, Stoneform's +10% armor buff and bleed immunity turns deadly physical spikes into manageable blows."
            }
        }
    },
    macros = {
        {
            title = "Dwarf: Stoneform Cleanse & Armor",
            desc = "Instantly clears all bleeds, poisons, and diseases and gains +10% armor.",
            code = "#showtooltip Stoneform\n/stopcasting\n/cast Stoneform"
        }
    }
}

FTG:RegisterRaceModule("DWARF", DwarfModule)
