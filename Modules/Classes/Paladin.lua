--[[
    ForeverTankGuide - Modules/Classes/Paladin.lua
    Protection Paladin Progression, Abilities, Rotations, Talents, and Macros
]]

local ADDON_NAME, FTG = ...

local PaladinModule = {
    name = "Paladin (Protection)",
    token = "PALADIN",
    description = "Holy mana-fueled AoE tanking specialist. High block value, reflective Holy damage, and Consecration area denial.",
    brackets = {
        [1] = {
            name = "Phase 1: Levels 1–20",
            minLevel = 1,
            maxLevel = 20,
            summary = "Early holy survivability, 30yd bomb pull mechanics, and learning threat peel via Judgement.",
            zones = {
                { name = "Silverpine / Northern Barrens", range = "10–20", notes = "Follow Sepulcher and Crossroads quest chains; dense mining nodes." }
            },
            abilities = {
                { level = 6, name = "Holy Strike", desc = "Primary single-target on-hit threat generator." },
                { level = 10, name = "Seal / Judgement of Fury", desc = "High threat multiplier. Use Judgement of Fury as your 10yd peel/taunt tool." }
            },
            tankRules = {
                "Always initiate trash pulls from 30yd with explosives to pull casters into melee clusters.",
                "Reserve Judgement of Fury for peel: snap taunt loose mobs at 10yd when they target healer or caster.",
                "Buff Devotion Aura or Retribution Aura (Ret Aura generates passive holy threat on 3+ attackers)."
            }
        },

        [2] = {
            name = "Phase 2: Levels 20–40",
            minLevel = 20,
            maxLevel = 40,
            summary = "The AoE tanking breakthrough with baseline Consecration, grenade grouping, and transition to Plate Armor.",
            zones = {
                { name = "Hillsbrad / Arathi", range = "20–40", notes = "Tarren Mill and Hammerfall quest hubs; rich Iron and Heavy Stone." }
            },
            abilities = {
                { level = 20, name = "Baseline Consecration", desc = "The bread-and-butter AoE holy threat zone. Pulse tick threat locks down groups." },
                { level = 40, name = "Plate Armor Training", desc = "Huge armor mitigation upgrade. Prioritize replacing mail with heavy plate." }
            },
            tankRules = {
                "Toss an Iron Grenade on casting packs to interrupt and bundle them together before dropping Consecration.",
                "Always drink to at least 70% mana between pulls—Protection Paladin threat is completely mana-fueled.",
                "Equip high block value shields: Redoubt doubles your block chance after taking a critical strike."
            }
        },

        [3] = {
            name = "Phase 3: Levels 40–52",
            minLevel = 40,
            maxLevel = 52,
            summary = "Goblin Engineering specialization, deep Protection talents with Holy Shield, and high-density dungeon cleave.",
            zones = {
                { name = "Tanaris / Feralas / WPL", range = "40–52", notes = "Gadgetzan, Camp Mojache, and Caer Darrow; abundant Mithril and Mageweave." }
            },
            abilities = {
                { level = 40, name = "Holy Shield (Talent)", desc = "Key mitigation & reactive holy threat spell. Increases block chance by 30% and reflects holy damage on block." },
                { level = 50, name = "Cleanse", desc = "Removes 1 Poison, 1 Disease, and 1 Magic effect in a single GCD." }
            },
            tankRules = {
                "Keep Holy Shield active on cooldown whenever taking damage from 2+ targets—charges deplete rapidly.",
                "For high-threat openers on 5+ mobs: pop Sapper Charge into Rank 1 Consecration for instant snap agro.",
                "Position boss backs to your group and watch your own back to avoid being critically hit or parried."
            }
        },

        [4] = {
            name = "Phase 4: Levels 52–60",
            minLevel = 52,
            maxLevel = 60,
            summary = "Endgame preparation, Thorium-tier engineering, pre-raid BIS dungeon tanking, and raid blessings.",
            zones = {
                { name = "Un'Goro / Winterspring / EPL", range = "52–60", notes = "Rich Thorium Veins, Stratholme entrance, and high-density undead camps." }
            },
            abilities = {
                { level = 56, name = "Greater Blessings (Kings/Sanctuary)", desc = "Greater Blessing of Sanctuary provides holy damage reduction and damage reflection on block." },
                { level = 60, name = "Max Rank Consecration & Holy Shield", desc = "Peak TPS (Threat Per Second) output." }
            },
            tankRules = {
                "In Stratholme and Scholomance, weave Holy Wrath into openers for 3 sec mass stun on demons/undead.",
                "LOS (Line of Sight) pull caster mobs around doorways or pillars to force them to cluster on your Consecration.",
                "Keep Greater Blessing of Sanctuary active on yourself for flat damage reduction and holy damage reflection."
            }
        }
    },
    macros = {
        {
            title = "Paladin: Mouseover Peel",
            desc = "Casts Judgement on mouseover enemy target, falling back to your current target.",
            code = "#showtooltip Judgement\n/cast [@mouseover,harm,nodead][harm,nodead] Judgement"
        },
        {
            title = "Paladin: Target-of-Target Taunt",
            desc = "Peels runaway mobs by targeting the teammate being attacked and judging their target.",
            code = "#showtooltip Judgement\n/cast [@targettarget,harm,nodead][harm,nodead] Judgement"
        },
        {
            title = "Paladin: Clutch Cleanse",
            desc = "Dispels poison/disease/magic on friendly mouseover without dropping your current hostile target.",
            code = "#showtooltip Cleanse\n/cast [@mouseover,help,nodead][@player] Cleanse"
        },
        {
            title = "Paladin: Panic Shield Wall",
            desc = "Emergency survivability macro stopping any active casts to fire Bulwark and Holy Shield instantly.",
            code = "#showtooltip Templar's Bulwark\n/stopcasting\n/cast Templar's Bulwark\n/cast Holy Shield"
        }
    }
}

FTG:RegisterClassModule("PALADIN", PaladinModule)
