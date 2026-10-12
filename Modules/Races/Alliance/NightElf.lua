--[[
    ForeverTankGuide - Modules/Races/Alliance/NightElf.lua
    Night Elf Racials, Passives, Synergies, and Macros
]]

local ADDON_NAME, FTG = ...

local NightElfModule = {
    name = "Night Elf",
    token = "NIGHTELF",
    faction = "Alliance",
    description = "Passive avoidance master. Quickness grants a permanent +1% Dodge bonus. Shadowmeld enables unique ambushes and safe out-of-combat drop tricks.",
    brackets = {
        [1] = {
            zones = {
                { name = "Teldrassil", range = "1–10", notes = "Shadowglen to Dolanaar. Dense forests and barrow dens." },
                { name = "Darkshore & Ashenvale", range = "10–20", notes = "Auberdine quest hub and Blackfathom Deeps access." }
            },
            racials = {
                { name = "Quickness", desc = "Increases chance to dodge melee and ranged attacks by 1% passively. Pure mitigation." },
                { name = "Shadowmeld", desc = "Blend into shadows while motionless. Out-of-combat stealth allowing stealth pulls or safe eating/drinking." },
                { name = "Nature Resistance", desc = "+10 Nature Resistance passively. Great against poison and nature spells." },
                { name = "Wisp Spirit", desc = "Increases speed while dead by 50% (makes inevitable dungeon corpse runs much faster)." }
            },
            tankTips = {
                "Quickness contributes directly to pushing crushing and critical strikes off the combat table for Warriors, Paladins, and Druids.",
                "Use Shadowmeld while waiting for mana or healer bio breaks to avoid wandering patrol agro."
            }
        },
        [2] = {
            tankTips = {
                "In Blackfathom Deeps, Nature Resistance mitigates naga and hydra poison spit."
            }
        },
        [3] = {
            tankTips = {
                "As a Night Elf Feral Druid, Quickness stacks directly with high Agility for extreme Dodge percentages."
            }
        },
        [4] = {
            tankTips = {
                "In endgame dungeons (Strat, Scholo, BRD), +1% passive Dodge provides consistent damage avoidance across hundreds of melee swings."
            }
        }
    },
    macros = {
        {
            title = "Night Elf: Shadowmeld Rest",
            desc = "Activates Shadowmeld to stealth and eat/drink without aggroing wandering dungeon patrols.",
            code = "#showtooltip Shadowmeld\n/stopattack\n/cast Shadowmeld"
        }
    }
}

FTG:RegisterRaceModule("NIGHTELF", NightElfModule)
