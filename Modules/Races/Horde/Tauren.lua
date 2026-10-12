--[[
    ForeverTankGuide - Modules/Races/Horde/Tauren.lua
    Tauren Racials, Passives, Synergies, and Macros
]]

local ADDON_NAME, FTG = ...

local TaurenModule = {
    name = "Tauren",
    token = "TAUREN",
    faction = "Horde",
    description = "Supreme physical tanking race. High effective health from Endurance (+5% base HP), War Stomp AoE 2-sec stun, and Nature Resistance.",
    brackets = {
        [1] = {
            zones = {
                { name = "Mulgore", range = "1–10", notes = "Camp Narache to Bloodhoof Village. Safe hunting grounds and early mining." },
                { name = "The Barrens", range = "10–20", notes = "Crossroads and Camp Taurajo. Direct access to Wailing Caverns." }
            },
            racials = {
                { name = "War Stomp", desc = "Stuns up to 5 enemies within 8yd for 2 seconds after a 0.5 sec cast (2 min cooldown)." },
                { name = "Endurance", desc = "Increases maximum health by 5% passively. Scales dramatically with high stamina gear." },
                { name = "Nature Resistance", desc = "+10 Nature Resistance passively. Mitigates poison and nature spikes in Wailing Caverns and Maraudon." },
                { name = "Cultivation", desc = "+15 Herbalism skill bonus." }
            },
            tankTips = {
                "War Stomp is an extraordinary emergency AoE peel: stun 5 mobs instantly to allow your healer to recover or to cast Holy Light/Healing Touch safely.",
                "Tauren have an expanded melee hitbox, giving slightly larger range for melee swings and AoE spells like Consecration, Thunder Clap, and Swipe."
            }
        },
        [2] = {
            tankTips = {
                "In Razorfen Kraul, your Nature Resistance helps counter quilboar poison volleys and earth tremors."
            }
        },
        [3] = {
            tankTips = {
                "In Maraudon, +10 Nature Resistance substantially mitigates Princess Theradras dust fields and Noxxion poison clouds."
            }
        },
        [4] = {
            tankTips = {
                "War Stomp into AoE threat abilities (Consecration, Thunder Clap, Sapper) provides an unmissable pack grouping window."
            }
        }
    },
    macros = {
        {
            title = "Tauren: War Stomp Peel",
            desc = "Stops current casting and fires War Stomp to stun all surrounding enemies for 2 seconds.",
            code = "#showtooltip War Stomp\n/stopcasting\n/cast War Stomp"
        }
    }
}

FTG:RegisterRaceModule("TAUREN", TaurenModule)
