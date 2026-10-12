--[[
    Heathen's Forever Guide - Modules/Races/Horde/Tauren.lua
    Tauren Racials, Passives, Synergies, Quest Routing, and Macros
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
                { name = "Camp Narache (Mulgore)", range = "1â€“6", notes = "Tauren starting plateau: Plainstrider, Bristleback Quilboar, and Rite of Strength quests." },
                { name = "Mulgore / Bloodhoof Village", range = "6â€“10", notes = "Bloodhoof Village hub: Venture Co. mine, Swoop hunting, and Thunder Bluff transition." },
                { name = "The Barrens (Crossroads & Camp Taurajo)", range = "10â€“20", notes = "Crossroads & Camp Taurajo hubs: Razorfen Kraul/Wailing Caverns prep and Centaur/Harpy chains." }
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
            zones = {
                { name = "Stonetalon Mountains & Ashenvale (Splintertree)", range = "20â€“28", notes = "Sun Rock Retreat and Splintertree Post: Blackfathom Deeps and Warsong lumber quests." },
                { name = "Hillsbrad Foothills (Tarren Mill)", range = "22â€“32", notes = "Tarren Mill Horde hub: high-XP Syndicate and Hillsbrad town quests." },
                { name = "Thousand Needles (Freewind Post)", range = "25â€“35", notes = "Freewind Post & Shimmering Flats (Mirage Raceway) dense beast grinding circuit." },
                { name = "Arathi Highlands (Hammerfall) & STV (Grom'gol)", range = "30â€“40", notes = "Hammerfall Horde stronghold and Grom'gol Base Camp jungle quests." }
            },
            tankTips = {
                "In Razorfen Kraul, your Nature Resistance helps counter quilboar poison volleys and earth tremors."
            }
        },
        [3] = {
            zones = {
                { name = "Badlands (Kargath)", range = "40â€“45", notes = "Kargath Horde outpost, Uldaman dungeon quests, and Rock Elemental farming." },
                { name = "Feralas (Camp Mojache)", range = "42â€“50", notes = "Camp Mojache Tauren/Horde stronghold: Gordunni ogres, Sprite Darters, and Yeti hides." },
                { name = "Tanaris (Gadgetzan)", range = "42â€“50", notes = "Wastewander camps and Zul'Farrak full dungeon quest completion." },
                { name = "The Hinterlands (Revantusk Village)", range = "45â€“52", notes = "Revantusk Village Horde hub and Jintha'Alor elite quest progression." }
            },
            tankTips = {
                "In Maraudon, +10 Nature Resistance substantially mitigates Princess Theradras dust fields and Noxxion poison clouds."
            }
        },
        [4] = {
            zones = {
                { name = "Felwood (Bloodvenom Post)", range = "50â€“55", notes = "Bloodvenom Post Horde hub: cleansing Felwood and Timbermaw Hold tunnel access." },
                { name = "Un'Goro Crater (Marshal's Refuge)", range = "51â€“56", notes = "Dense circular quest circuit and herbalism node paradise." },
                { name = "Western & Eastern Plaguelands (Bulwark / Light's Hope)", range = "52â€“60", notes = "Argent Dawn cauldrons, Stratholme, and Scholomance dungeon attunements." },
                { name = "Winterspring (Everlook)", range = "55â€“60", notes = "Winterfall Firewater farming, Black Lotus herbs, and pre-raid BIS quests." }
            },
            tankTips = {
                "War Stomp into AoE threat abilities (Consecration, Thunder Clap, Sapper) provides an unmissable pack grouping window."
            }
        }
    },
    macros = {
        {
            category = "Defensive / Tank",
            title = "Tauren: War Stomp Peel",
            desc = "Stops current casting and fires War Stomp to stun all surrounding enemies for 2 seconds.",
            code = "#showtooltip War Stomp\n/stopcasting\n/cast War Stomp"
        }
    }
}

FTG:RegisterRaceModule("TAUREN", TaurenModule)
