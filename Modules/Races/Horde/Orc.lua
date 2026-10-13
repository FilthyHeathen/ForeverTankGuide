--[[
    Heathen's Forever Guide - Modules/Races/Horde/Orc.lua
    Orc Racials, Passives, Synergies, Quest Routing, and Macros
]]

local ADDON_NAME, HFG = ...

local OrcModule = {
    name = "Orc",
    token = "ORC",
    faction = "Horde",
    description = "Hardiness stun resist titan and Axe Specialization expert. Blood Fury provides high threat bursts (use with caution due to healing debuffs).",
    brackets = {
        [1] = {
            zones = {
                { name = "Valley of Trials (Durotar)", range = "1–6", notes = "Orc starting valley: Sarkoth, Burning Blade Coven cave, and Peon tasks." },
                { name = "Durotar (Sen'jin Village & Razor Hill)", range = "6–10", notes = "Tiragarde Keep marines, Echo Isles Zalazane, Skull Rock, and Ragefire Chasm prep." },
                { name = "Northern Barrens (Crossroads & Ratchet)", range = "10–20", notes = "Crossroads hub, Kolkar Centaurs, Harpies, and Wailing Caverns dungeon quests." }
            },
            racials = {
                { name = "Hardiness", desc = "Increases chance to resist stun effects by an astounding 25% passively." },
                { name = "Axe Specialization", desc = "Increases skill with Axes and Two-Handed Axes by 5, dramatically reducing boss dodge and parry." },
                { name = "Blood Fury", desc = "Increases base melee attack power by 25% for 15 sec, but reduces healing received by 50% for 25 sec (WARNING for tanks)." },
                { name = "Command", desc = "Increases pet damage by 5% (benefits Warlock and Hunter pets)." }
            },
            tankTips = {
                "Hardiness passively saves your life against dungeon trash and bosses that use concussive stuns (you cannot block, dodge, or parry while stunned).",
                "WARNING ON BLOOD FURY: Only trigger Blood Fury during pull openers when you have full health or shields, never during heavy incoming damage phases due to the -50% healing received debuff!"
            }
        },
        [2] = {
            zones = {
                { name = "Stonetalon Mountains & Ashenvale (Splintertree)", range = "20–28", notes = "Sun Rock Retreat and Splintertree Post Horde quests; Blackfathom Deeps access." },
                { name = "Hillsbrad Foothills (Tarren Mill)", range = "22–32", notes = "Tarren Mill Horde quest hub and Scarlet Monastery proximity." },
                { name = "Thousand Needles (Freewind Post)", range = "25–35", notes = "Freewind Post & Shimmering Flats (Mirage Raceway) rapid XP loop." },
                { name = "Arathi Highlands (Hammerfall) & STV (Grom'gol)", range = "30–40", notes = "Hammerfall Horde outpost and Grom'gol Base Camp jungle quests." }
            },
            tankTips = {
                "Axe Specialization grants +5 weapon skill, giving you +3% hit against same-level mobs and lowering enemy parry chance."
            }
        },
        [3] = {
            zones = {
                { name = "Badlands (Kargath)", range = "40–45", notes = "Kargath Horde outpost, Uldaman pre-quests, and solid stone/elemental grinding." },
                { name = "Feralas (Camp Mojache)", range = "42–50", notes = "Camp Mojache Horde hub: Gordunni ogres, Woodpaw gnolls, and Maraudon prep." },
                { name = "Tanaris (Gadgetzan)", range = "42–50", notes = "Wastewander bandits and Zul'Farrak dungeon quest stack." },
                { name = "The Hinterlands (Revantusk Village)", range = "45–52", notes = "Revantusk Village Horde coastal hub and Jintha'Alor elite quests." }
            },
            tankTips = {
                "Equip one-handed axes (e.g. Gatorbite Axe from Maraudon) to maximize the +5 Axe Specialization hit & glancing blow rating."
            }
        },
        [4] = {
            zones = {
                { name = "Felwood (Bloodvenom Post)", range = "50–55", notes = "Bloodvenom Post Horde hub: Timbermaw Hold reputation and Satyr farming." },
                { name = "Un'Goro Crater (Marshal's Refuge)", range = "51–56", notes = "High-density quest circuit and Devilsaur hunting." },
                { name = "Western & Eastern Plaguelands (Bulwark / Light's Hope)", range = "52–60", notes = "Argent Dawn cauldrons, Stratholme, and Scholomance dungeon runs." },
                { name = "Winterspring (Everlook)", range = "55–60", notes = "Winterfall furbolgs and endgame pre-raid BIS preparation." }
            },
            tankTips = {
                "In Scholomance and Stratholme, Hardiness frequently resists lethal Ghoul stuns and Skeletal Flayer concussive bashes."
            }
        }
    },
    macros = {
        {
            category = "Burst / DPS",
            title = "Orc: Safe Opener Blood Fury",
            desc = "Uses Blood Fury strictly at pull initiation.",
            code = "#showtooltip Blood Fury\n/cast Blood Fury\n/startattack"
        }
    }
}

HFG:RegisterRaceModule("ORC", OrcModule)
