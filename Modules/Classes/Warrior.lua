--[[
    ForeverTankGuide - Modules/Classes/Warrior.lua
    Protection Warrior Progression, Stance Dance, Rage Mechanics & Threat Tools
]]

local ADDON_NAME, FTG = ...

local WarriorModule = {
    name = "Warrior (Protection)",
    token = "WARRIOR",
    description = "Master of physical damage mitigation, active active Shield Block defense, Sunder Armor stacking, and defensive cooldowns.",
    brackets = {
        [1] = {
            name = "Phase 1: Levels 1–20",
            minLevel = 1,
            maxLevel = 20,
            summary = "Learn Defensive Stance (lvl 10), Taunt, and Sunder Armor threat rotation.",
            zones = {
                { name = "Silverpine / Barrens", range = "10–20", notes = "Defensive Stance class quest chain at level 10." }
            },
            abilities = {
                { level = 10, name = "Defensive Stance & Taunt", desc = "Primary tank stance (-10% damage taken, +threat multiplier) and 8yd snap taunt." },
                { level = 10, name = "Sunder Armor", desc = "Primary threat-per-rage generator. Keep 5 stacks rolling on main target." },
                { level = 14, name = "Demoralizing Shout", desc = "Reduces enemy attack power and generates initial multi-target snap threat." }
            },
            tankRules = {
                "Open packs with Bloodrage + Shoot/Bomb, then Demoralizing Shout to lock initial healer threat.",
                "Tab-target Sunder Armor: cycle between targets to spread steady high threat across 2-3 mobs.",
                "Keep Shield Block pressed on cooldown against heavy melee hitting bosses to push crushes off the combat table."
            }
        },

        [2] = {
            name = "Phase 2: Levels 20–40",
            minLevel = 20,
            maxLevel = 40,
            summary = "Shield Bash interrupts, Challenging Shout group peel, and Plate Armor transition at level 40.",
            zones = {
                { name = "Hillsbrad / Arathi / Thousand Needles", range = "20–40", notes = "Whirlwind weapon & Berserker Stance questlines at level 30." }
            },
            abilities = {
                { level = 24, name = "Revenge", desc = "High-threat, low-cost strike usable after dodging, blocking, or parrying." },
                { level = 26, name = "Challenging Shout", desc = "10-minute AoE taunt emergency lifesaver for 10 seconds." },
                { level = 40, name = "Shield Slam (Talent)", desc = "Heavy single target holy damage scaling with shield block value; dispels 1 magic effect." }
            },
            tankRules = {
                "Revenge is your highest Threat-Per-Rage button—press it immediately every time it lights up.",
                "Use Shield Block to guarantee a block and instantly activate Revenge procs.",
                "Stance dance safely: when switching to Berserker for Berserker Rage, beware losing accumulated rage (Tactical Mastery talent needed)."
            }
        },

        [3] = {
            name = "Phase 3: Levels 40–52",
            minLevel = 40,
            maxLevel = 52,
            summary = "Concussion Blow crowd control, Last Stand emergency health, and deeper mitigation scaling.",
            zones = {
                { name = "Tanaris / Hinterlands / Feralas", range = "40–52", notes = "Zul'Farrak & Maraudon physical mitigation trials." }
            },
            abilities = {
                { level = 30, name = "Concussion Blow (Talent)", desc = "5-second physical stun with solid upfront threat." },
                { level = 50, name = "Shield Wall", desc = "75% damage reduction for 10 seconds on a 30-minute cooldown." }
            },
            tankRules = {
                "Pool 30-40 rage before pulling dungeon bosses so you can instantly deliver Shield Slam + Sunder.",
                "Call for caster crowd control on larger packs; Warrior AoE threat is limited compared to Paladins.",
                "Keep Battle Shout buff active on 4 melee party members to generate passive threat on every pull."
            }
        },

        [4] = {
            name = "Phase 4: Levels 52–60",
            minLevel = 52,
            maxLevel = 60,
            summary = "Pre-raid defense cap (440 Defense skill for 60 uncrushable/uncrittable against raid bosses).",
            zones = {
                { name = "BRD / Stratholme / Scholomance / UBRS", range = "52–60", notes = "Acquiring Deathbone, Valor, and Draconian Deflector." }
            },
            abilities = {
                { level = 60, name = "Max Rank Shield Slam & Revenge", desc = "Capstone physical threat ceiling." },
                { level = 60, name = "Last Stand", desc = "Instant 30% maximum health increase for 20 seconds." }
            },
            tankRules = {
                "Stack Defense rating until 440 (soft cap) to completely remove critical strikes from level 63 boss tables.",
                "Use Disarm on dual-wielding and enraging dungeon bosses to cut incoming physical spike damage by 50%.",
                "Keep Taunt and Mocking Blow mapped to readily accessible keybinds for instantaneous target swaps."
            }
        }
    },
    macros = {
        {
            title = "Warrior: Taunt / Mouseover",
            desc = "Casts Taunt in Defensive Stance on mouseover enemy or current hostile target.",
            code = "#showtooltip Taunt\n/cast [stance:1/3] Defensive Stance; [@mouseover,harm,nodead][harm,nodead] Taunt"
        },
        {
            title = "Warrior: Panic Shield Wall",
            desc = "Swaps immediately to 1H weapon and Shield, enters Defensive Stance, and triggers Shield Wall.",
            code = "#showtooltip Shield Wall\n/cast [nostance:2] Defensive Stance\n/equipslot 16 [noworn:One-Handed] YourWeaponName\n/equipslot 17 [noworn:Shields] YourShieldName\n/cast Shield Wall"
        },
        {
            title = "Warrior: Stance-Dance Intercept",
            desc = "Swaps to Berserker Stance, fires Intercept to stun runaway target, and returns to Defensive Stance.",
            code = "#showtooltip Intercept\n/cast [nostance:3] Berserker Stance\n/cast Intercept\n/cast [stance:3] Defensive Stance"
        }
    }
}

FTG:RegisterClassModule("WARRIOR", WarriorModule)
