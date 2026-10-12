--[[
    ForeverTankGuide - Modules/Classes/Rogue.lua
    Blade Dance / Rogue Tank Skeleton & Evasion Mechanics
]]

local ADDON_NAME, FTG = ...

local RogueModule = {
    name = "Rogue (Blade Dance Tank)",
    token = "ROGUE",
    description = "Evasion and parry avoidance tanking using Ghostly Strike, Blade Dance physical mitigation, Riposte disarms, and combo-point parry scaling.",
    brackets = {
        [1] = {
            name = "Phase 1: Levels 1–20",
            minLevel = 1,
            maxLevel = 20,
            summary = "Early avoidance mechanics, Sinister Strike combo generation, and Evasion cooldown tanking.",
            zones = {
                { name = "Silverpine / Westfall / Barrens", range = "1–20", notes = "Poisons questline at lvl 20; Thistle Tea recipe." }
            },
            abilities = {
                { level = 8, name = "Evasion", desc = "+50% dodge chance for 15 seconds on a 5-minute cooldown." },
                { level = 10, name = "Slice and Dice", desc = "Increases attack speed by 30% for rapid poison applications and threat generation." },
                { level = 14, name = "Kick", desc = "Instant melee caster interrupt." }
            },
            tankRules = {
                "Always face targets directly: Rogue tanking depends 100% on Dodge and Parry; getting hit from behind removes avoidance entirely.",
                "Maintain active combo point spenders for defense and attack speed buffs.",
                "Use Gouge as an active secondary interrupt or to pause damage while waiting for energy."
            }
        },

        [2] = {
            name = "Phase 2: Levels 20–40",
            minLevel = 20,
            maxLevel = 40,
            summary = "Ghostly Strike avoidance (+15% dodge), Riposte disarm, and Blade Flurry multi-target cleave.",
            zones = {
                { name = "Hillsbrad / Arathi / SM", range = "20–40", notes = "Defiance and Agility leather gear farming." }
            },
            abilities = {
                { level = 20, name = "Ghostly Strike (Talent)", desc = "Deals weapon damage and increases dodge chance by 15% for 7 seconds." },
                { level = 20, name = "Riposte (Talent)", desc = "Strikes for 150% weapon damage and disarms the target for 6 seconds following a parry." },
                { level = 30, name = "Blade Flurry (Talent)", desc = "Increases attack speed by 20% and cleaves an additional nearby enemy." }
            },
            tankRules = {
                "Keep Ghostly Strike on cooldown for uninterrupted +15% dodge uptime.",
                "Trigger Riposte immediately on parry to eliminate incoming physical weapon damage from dangerous mobs.",
                "Pop Blade Flurry + explosives for multi-target dungeon pack snap threat."
            }
        },

        [3] = {
            name = "Phase 3: Levels 40–52",
            minLevel = 40,
            maxLevel = 52,
            summary = "Adrenaline Rush burst threat, Blind crowd control peels, and high agility dungeon leather.",
            zones = {
                { name = "Tanaris / Hinterlands / ZF", range = "40–52", notes = "Farming Devilsaur leather pieces and Zul'Farrak swords." }
            },
            abilities = {
                { level = 34, name = "Blind", desc = "Disorients target for up to 10 seconds. Superb for peeling adds off your healer." },
                { level = 40, name = "Adrenaline Rush (Talent)", desc = "Doubles energy regeneration for 15 seconds on a 5-minute cooldown." }
            },
            tankRules = {
                "Use Blind to instantly neutralize stray dungeon mobs without losing your primary target.",
                "Feint is inverted or avoided in tank stance—ensure you are using your designated threat strikes.",
                "Keep Instant Poison or high-threat oils coated on both main hand and off hand daggers/swords."
            }
        },

        [4] = {
            name = "Phase 4: Levels 52–60",
            minLevel = 52,
            maxLevel = 60,
            summary = "Avoidance cap ceiling (~102.4% combined Miss + Dodge + Parry to become completely unhittable during cooldowns).",
            zones = {
                { name = "EPL / Strat / Scholo / UBRS", range = "52–60", notes = "Shadowcraft armor set and high agility rings/trinkets." }
            },
            abilities = {
                { level = 60, name = "Max Rank Evasion & Ghostly Strike", desc = "Peak physical avoidance." }
            },
            tankRules = {
                "Stack pure Agility: each point gives armor, crit, and significant dodge percentage.",
                "Chain Evasion into Ghostly Strike on heavy physical boss enrages.",
                "Keep Flash Powder and Blinding Powder stocked in large stacks in your bags."
            }
        }
    },
    macros = {
        {
            title = "Rogue: Kick Interrupt",
            desc = "Kicks mouseover enemy or current target without interrupting auto attack.",
            code = "#showtooltip Kick\n/cast [@mouseover,harm,nodead][harm,nodead] Kick"
        },
        {
            title = "Rogue: Panic Evasion",
            desc = "Pops Evasion immediately and triggers Ghostly Strike for maximum avoidance.",
            code = "#showtooltip Evasion\n/stopcasting\n/cast Evasion\n/cast Ghostly Strike"
        }
    }
}

FTG:RegisterClassModule("ROGUE", RogueModule)
