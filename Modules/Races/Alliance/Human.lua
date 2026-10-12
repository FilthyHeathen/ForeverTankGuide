--[[
    ForeverTankGuide - Modules/Races/Alliance/Human.lua
    Human Racials, Passives, Synergies, and Macros
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
                { name = "Elwynn Forest", range = "1–10", notes = "Northshire to Goldshire. Abundant copper nodes and safe mining." },
                { name = "Westfall & Redridge", range = "10–20", notes = "Deadmines quest chain; Defias bandit camps." }
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
            tankTips = {
                "In Deadmines and Stockade, Sword Specialization makes your weapon attacks rarely get parried or dodged."
            }
        },
        [3] = {
            tankTips = {
                "In Maraudon and Zul'Farrak, keep a fast 1H sword or mace equipped for steady, unparried threat delivery."
            }
        },
        [4] = {
            tankTips = {
                "In Stratholme and Scholomance, Diplomacy accelerates your Argent Dawn revered/exalted reputation grinding by 10%."
            }
        }
    },
    macros = {
        {
            title = "Human: Perception Stealth Detect",
            desc = "Activates Perception to detect hidden stealthed dungeon mobs before they ambush your group.",
            code = "#showtooltip Perception\n/cast Perception"
        }
    }
}

FTG:RegisterRaceModule("HUMAN", HumanModule)
