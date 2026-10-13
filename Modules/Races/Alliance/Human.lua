--[[
    Heathen's Forever Guide - Modules/Races/Alliance/Human.lua
    Human Racials, Passives, Synergies, Quest Routing, and Macros
]]

local ADDON_NAME, FTG = ...

local HumanModule = {
    name = "Human",
    token = "HUMAN",
    faction = "Alliance",
    description = "Unrivaled weapon skill titan. Sword & Mace Specialization (+5 skill) reduces boss glancing blow penalties and eliminates missed attacks. The Human Spirit boosts passive spirit mana regen.",
    brackets = {
        [1] = {
            zones = {
                { name = "Northshire Abbey (Elwynn Forest)", range = "1–6", notes = "Human starting abbey: Kobold Vermin, Defias Thugs, and Garrick Padfoot." },
                { name = "Elwynn Forest / Goldshire", range = "6–10", notes = "Goldshire & Eastvale Logging Camp: Fargodeep/Jasperlode mines, Hogger, and Westbrook Garrison." },
                { name = "Westfall (Sentinel Hill) & Redridge Mountains", range = "10–20", notes = "Sentinel Hill Defias Brotherhood chain -> Deadmines (VanCleef) & Lakeshire (Redridge) quests." }
            },
            racials = {
                { name = "Sword & Mace Specialization", desc = "+5 skill with Swords and Maces. Reduces boss glancing blow damage penalty from 35% down to 5% and lowers hit cap requirement." },
                { name = "The Human Spirit", desc = "Increases total Spirit by 5% passively, amplifying out-of-5-second-rule mana and health regeneration." },
                { name = "Perception", desc = "Dramatically increases stealth detection for 20 sec on a 3 min cooldown. Great for spotting dungeon rogues and stealth adds." },
                { name = "Diplomacy", desc = "Reputation gains increased by 10% (superb for Argent Dawn, Hydraxian Waterlords, and Thorium Brotherhood)." }
            },
            tankTips = {
                "Always favor Swords and Maces over Axes or Daggers: +5 weapon skill is worth ~3% Hit and removes glancing blow damage penalties against level 63 boss mobs.",
                "Use Perception before entering rooms with stealthed mobs (e.g. Shadowfang Keep, Scholomance, Stratholme)."
            }
        },
        [2] = {
            zones = {
                { name = "Duskwood (Darkshire) & Wetlands (Menethil)", range = "20–30", notes = "Darkshire undead/worgen chains (Stitches & Mor'Ladim), The Stockade, and Wetlands dragonmaw camps." },
                { name = "Hillsbrad Foothills (Southshore)", range = "25–33", notes = "Southshore Alliance coastal hub: Syndicate assassins, Yeti cave, and murloc shore." },
                { name = "Arathi Highlands (Refuge Pointe)", range = "30–40", notes = "Refuge Pointe Alliance hub: Stromgarde Keep, Boulderfist ogres, and Witherbark trolls." },
                { name = "Stranglethorn Vale (Rebel Camp)", range = "30–40", notes = "Rebel Camp (North STV), Nesingwary's Expedition, and Booty Bay pirate chains." }
            },
            tankTips = {
                "In Deadmines and Stockade, Sword Specialization makes your weapon attacks rarely get parried or dodged."
            }
        },
        [3] = {
            zones = {
                { name = "Feralas (Feathermoon Stronghold)", range = "40–48", notes = "Feathermoon Stronghold Alliance island hub: Gordunni ogres, Yetis, and Maraudon prep." },
                { name = "Tanaris (Gadgetzan)", range = "42–50", notes = "Wastewander bandits, Southsea pirates, and Zul'Farrak dungeon quest stack." },
                { name = "The Hinterlands (Aerie Peak)", range = "43–50", notes = "Aerie Peak Wildhammer Alliance hub: Witherbark/Vilebranch trolls and Jintha'Alor elite quests." },
                { name = "Searing Gorge & Blasted Lands", range = "48–52", notes = "Thorium Point quests, Key to Searing Gorge, and Blackrock Depths preparation." }
            },
            tankTips = {
                "In Maraudon and Zul'Farrak, keep a fast 1H sword or mace equipped for steady, unparried threat delivery."
            }
        },
        [4] = {
            zones = {
                { name = "Un'Goro Crater (Marshal's Refuge)", range = "51–55", notes = "High-density circular quest loop, crystals, and Devilsaur leather." },
                { name = "Western Plaguelands (Chillwind Camp)", range = "52–58", notes = "Chillwind Camp Alliance hub: Scourge cauldrons, Andorhal, and Scholomance key chain." },
                { name = "Eastern Plaguelands (Light's Hope) & Burning Steppes", range = "54–60", notes = "Morgan's Vigil (Onyxia attunement), Tirion Fordring chains, and Stratholme." },
                { name = "Winterspring (Everlook)", range = "55–60", notes = "Winterfall furbolgs and endgame pre-raid BIS preparation." }
            },
            tankTips = {
                "In Stratholme and Scholomance, Diplomacy accelerates your Argent Dawn revered/exalted reputation grinding by 10%."
            }
        }
    },
    macros = {
        {
            category = "Defensive / Tank",
            title = "Human: Perception Stealth Detect",
            desc = "Activates Perception to detect hidden stealthed dungeon mobs before they ambush your group.",
            code = "#showtooltip Perception\n/cast Perception"
        }
    }
}

FTG:RegisterRaceModule("HUMAN", HumanModule)
