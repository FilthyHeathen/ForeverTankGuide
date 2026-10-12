--[[
    ForeverTankGuide - Modules/Races/Horde/Orc.lua
    Orc Racials, Passives, Synergies, and Macros
]]

local ADDON_NAME, FTG = ...

local OrcModule = {
    name = "Orc",
    token = "ORC",
    faction = "Horde",
    description = "Hardiness stun resist titan and Axe Specialization expert. Blood Fury provides high threat bursts (use with caution due to healing debuffs).",
    brackets = {
        [1] = {
            zones = {
                { name = "Durotar", range = "1–10", notes = "Valley of Trials to Razor Hill. Direct road to Orgrimmar and Ragefire Chasm." },
                { name = "Northern Barrens", range = "10–20", notes = "Dense mining, centaur camps, and crossroads." }
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
            tankTips = {
                "Axe Specialization grants +5 weapon skill, giving you +3% hit against same-level mobs and lowering enemy parry chance."
            }
        },
        [3] = {
            tankTips = {
                "Equip one-handed axes (e.g. Gatorbite Axe from Maraudon) to maximize the +5 Axe Specialization hit & glancing blow rating."
            }
        },
        [4] = {
            tankTips = {
                "In Scholomance and Stratholme, Hardiness frequently resists lethal Ghoul stuns and Skeletal Flayer concussive bashes."
            }
        }
    },
    macros = {
        {
            title = "Orc: Safe Opener Blood Fury",
            desc = "Uses Blood Fury strictly at pull initiation with warning text to healer.",
            code = "#showtooltip Blood Fury\n/cast Blood Fury\n/startattack"
        }
    }
}

FTG:RegisterRaceModule("ORC", OrcModule)
