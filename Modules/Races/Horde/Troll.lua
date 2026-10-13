--[[
    Heathen's Forever Guide - Modules/Races/Horde/Troll.lua
    Troll Racials, Passives, Synergies, Quest Routing, and Macros
]]

local ADDON_NAME, FTG = ...

local TrollModule = {
    name = "Troll",
    token = "TROLL",
    faction = "Horde",
    description = "Berserking haste accelerator and sustained Regeneration tank/healer/DPS. Beast Slaying grants bonus damage against beasts in Wailing Caverns and Zul'Farrak.",
    brackets = {
        [1] = {
            zones = {
                { name = "Valley of Trials (Durotar)", range = "1–6", notes = "Darkspear & Orc starting valley: Scorpids, Vile Familiars, and Burning Blade Coven." },
                { name = "Durotar (Sen'jin Village & Razor Hill)", range = "6–10", notes = "Echo Isles (Zalazane & Minshina's Skull), Tiragarde Keep, and Razor Hill quests." },
                { name = "Northern Barrens (Crossroads & Ratchet)", range = "10–20", notes = "Crossroads hub, Raptor/Beast hunting (+5% Beast Slaying!), and Wailing Caverns." }
            },
            racials = {
                { name = "Berserking", desc = "Increases attack and casting speed by 10% to 30% depending on how damaged you are (3 min cooldown)." },
                { name = "Regeneration", desc = "Health regeneration rate increased by 10%; 10% of total health regeneration continues during combat!" },
                { name = "Beast Slaying", desc = "Damage dealt versus Beasts increased by 5% (superb for Barrens, Wailing Caverns, STV, and Un'Goro)." },
                { name = "Bow / Throwing Specialization", desc = "+5 skill with bows and thrown weapons." }
            },
            tankTips = {
                "Berserking activates when you are low on HP: use the attack/cast haste to rapidly deliver threat strikes or emergency heals.",
                "In-combat Regeneration provides constant passive trickle recovery over long boss fights."
            }
        },
        [2] = {
            zones = {
                { name = "Stonetalon Mountains & Ashenvale (Splintertree)", range = "20–28", notes = "Sun Rock Retreat and Splintertree Post Horde quests; Blackfathom Deeps access." },
                { name = "Hillsbrad Foothills (Tarren Mill)", range = "22–32", notes = "Tarren Mill Horde quest hub and Scarlet Monastery proximity." },
                { name = "Thousand Needles (Freewind Post)", range = "25–35", notes = "Freewind Post & Shimmering Flats (Mirage Raceway) beast grinding." },
                { name = "Arathi Highlands (Hammerfall) & STV (Grom'gol)", range = "30–40", notes = "Hammerfall Horde outpost and Grom'gol Base Camp Nesingwary beast chains." }
            },
            tankTips = {
                "Beast Slaying amplifies your damage and threat against raptors, panthers, and tigers across Hillsbrad and STV."
            }
        },
        [3] = {
            zones = {
                { name = "Badlands (Kargath)", range = "40–45", notes = "Kargath Horde outpost, Coyote/Buzzard beast packs, and Uldaman quests." },
                { name = "Feralas (Camp Mojache)", range = "42–50", notes = "Camp Mojache Horde hub: Gordunni ogres, wolves, and Maraudon prep." },
                { name = "Tanaris (Gadgetzan)", range = "42–50", notes = "Wastewander bandits and Zul'Farrak dungeon quest stack." },
                { name = "The Hinterlands (Revantusk Village)", range = "45–52", notes = "Revantusk Village Darkspear-allied troll hub and Jintha'Alor elite quests." }
            },
            tankTips = {
                "In Zul'Farrak, Berserking turns your melee swing timers and spell casts into rapid-fire proc engines on the pyramid stairs."
            }
        },
        [4] = {
            zones = {
                { name = "Felwood (Bloodvenom Post)", range = "50–55", notes = "Bloodvenom Post Horde hub: Timbermaw Hold reputation and corrupted beasts." },
                { name = "Un'Goro Crater (Marshal's Refuge)", range = "51–56", notes = "Ravasaur and Devilsaur hunting (+5% Beast Slaying bonus!)." },
                { name = "Western & Eastern Plaguelands (Bulwark / Light's Hope)", range = "52–60", notes = "Argent Dawn cauldrons, Stratholme, and Scholomance dungeon runs." },
                { name = "Winterspring (Everlook)", range = "55–60", notes = "Frostsaber/Chimera beast grinding and endgame pre-raid BIS preparation." }
            },
            tankTips = {
                "Pair Berserking with high mana regeneration seals, Flurry talents, or Chain Heal for sustained throughput."
            }
        }
    },
    macros = {
        {
            category = "Burst / DPS",
            title = "Troll: Berserking Threat / Cast Haste",
            desc = "Activates Berserking during combat to accelerate attack and casting speed.",
            code = "#showtooltip Berserking\n/cast Berserking\n/startattack"
        }
    }
}

FTG:RegisterRaceModule("TROLL", TrollModule)
