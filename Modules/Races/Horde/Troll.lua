--[[
    ForeverTankGuide - Modules/Races/Horde/Troll.lua
    Troll Racials, Passives, Synergies, and Macros
]]

local ADDON_NAME, FTG = ...

local TrollModule = {
    name = "Troll",
    token = "TROLL",
    faction = "Horde",
    description = "Berserking haste accelerator and sustained Regeneration tank. Beast Slaying grants bonus damage against beasts in Wailing Caverns and Zul'Farrak.",
    brackets = {
        [1] = {
            zones = {
                { name = "Echo Isles & Durotar", range = "1–10", notes = "Sen'jin Village to Razor Hill." },
                { name = "The Barrens", range = "10–20", notes = "Crossroads and beast hunting." }
            },
            racials = {
                { name = "Berserking", desc = "Increases attack and casting speed by 10% to 30% depending on how damaged you are (3 min cooldown)." },
                { name = "Regeneration", desc = "Health regeneration rate increased by 10%; 10% of total health regeneration continues during combat!" },
                { name = "Beast Slaying", desc = "Damage dealt versus Beasts increased by 5% (superb for Wailing Caverns, RFK, and Un'Goro)." },
                { name = "Bow / Throwing Specialization", desc = "+5 skill with bows and thrown weapons." }
            },
            tankTips = {
                "Berserking activates when you are low on HP: use the attack haste to rapidly deliver threat strikes or cast heals.",
                "In-combat Regeneration provides constant passive trickle recovery over long boss fights."
            }
        },
        [2] = {
            tankTips = {
                "Beast Slaying amplifies your damage and threat against raptors, bats, and spiders across Hillsbrad and STV."
            }
        },
        [3] = {
            tankTips = {
                "In Zul'Farrak, Berserking turns your melee swing timers into rapid-fire proc engines on the pyramid stairs."
            }
        },
        [4] = {
            tankTips = {
                "Pair Berserking with high mana regeneration seals or Flurry talents for sustained threat output."
            }
        }
    },
    macros = {
        {
            title = "Troll: Berserking Threat Haste",
            desc = "Activates Berserking during combat to accelerate attack speed and threat generation.",
            code = "#showtooltip Berserking\n/cast Berserking\n/startattack"
        }
    }
}

FTG:RegisterRaceModule("TROLL", TrollModule)
