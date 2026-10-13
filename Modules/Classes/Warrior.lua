--[[
    Heathen's Forever Guide - Modules/Classes/Warrior.lua
    Warrior Multi-Spec Module: Protection (Tank), Arms (2H Melee DPS), Fury (Dual-Wield DPS)
]]

local ADDON_NAME, HFG = ...

local WarriorModule = {
    name = "Warrior",
    token = "WARRIOR",
    defaultSpec = "PROTECTION",
    specs = {
        ["PROTECTION"] = {
            specName = "Protection (Tank)",
            role = "TANK",
            order = 1,
            statPriority = "Defense (to 440 Cap) > Stamina > Block Value / Armor > Hit (6-9%) > Strength / Agility",
            phaseGuidance = {
                [1] = {
                    name = "Phase 1: Levels 1–20",
                    summary = "Learn Defensive Stance (lvl 10), Taunt, and Sunder Armor threat rotation.",
                    zones = {
                        { name = "Silverpine / Barrens / Westfall", range = "10–20", notes = "Defensive Stance class quest chain at level 10." }
                    },
                    abilities = {
                        { level = 10, name = "Defensive Stance & Taunt", desc = "Primary tank stance (-10% damage taken, +threat multiplier) and 8yd snap taunt." },
                        { level = 10, name = "Sunder Armor", desc = "Primary threat-per-rage generator. Keep 5 stacks rolling on main target." },
                        { level = 14, name = "Demoralizing Shout", desc = "Reduces enemy attack power and generates initial multi-target snap threat." }
                    },
                    rules = {
                        "Open packs with Bloodrage + Shoot/Bomb, then Demoralizing Shout to lock initial healer threat.",
                        "Tab-target Sunder Armor: cycle between targets to spread steady high threat across 2-3 mobs.",
                        "Keep Shield Block pressed on cooldown against heavy melee hitting bosses to push crushes off the combat table."
                    }
                },
                [2] = {
                    name = "Phase 2: Levels 20–40",
                    summary = "Revenge high-efficiency threat, Challenging Shout group peel, and Plate Armor transition at level 40.",
                    zones = {
                        { name = "Hillsbrad / Arathi / Thousand Needles", range = "20–40", notes = "Berserker Stance questline at level 30." }
                    },
                    abilities = {
                        { level = 24, name = "Revenge", desc = "High-threat, low-cost strike usable after dodging, blocking, or parrying." },
                        { level = 26, name = "Challenging Shout", desc = "10-minute AoE taunt emergency lifesaver for 6 seconds." },
                        { level = 40, name = "Shield Slam (Talent)", desc = "Heavy single target threat scaling with shield block value; dispels 1 magic effect." }
                    },
                    rules = {
                        "Revenge is your highest Threat-Per-Rage button—press it immediately every time it lights up.",
                        "Use Shield Block to guarantee a block and instantly activate Revenge procs.",
                        "Stance dance safely: invest 5/5 Tactical Mastery so you retain up to 25 rage when swapping stances."
                    }
                },
                [3] = {
                    name = "Phase 3: Levels 40–52",
                    summary = "Concussion Blow crowd control, Last Stand emergency health, and deeper mitigation scaling.",
                    zones = {
                        { name = "Tanaris / Hinterlands / Feralas", range = "40–52", notes = "Zul'Farrak & Maraudon physical mitigation trials." }
                    },
                    abilities = {
                        { level = 30, name = "Concussion Blow (Talent)", desc = "5-second physical stun with solid upfront threat." },
                        { level = 50, name = "Shield Wall", desc = "75% damage reduction for 10 seconds on a 30-minute cooldown." }
                    },
                    rules = {
                        "Pool 30-40 rage before pulling dungeon bosses so you can instantly deliver Shield Slam + Sunder.",
                        "Call for caster crowd control on larger packs; use Engineering grenades to stun and cluster AoE pulls.",
                        "Keep Battle Shout buff active on melee party members to generate passive buff threat."
                    }
                },
                [4] = {
                    name = "Phase 4: Levels 52–60",
                    summary = "Pre-raid defense cap (440 Defense skill for uncrushable/uncrittable against raid bosses).",
                    zones = {
                        { name = "BRD / Stratholme / Scholomance / UBRS", range = "52–60", notes = "Acquiring Deathbone, Valor, and Draconian Deflector." }
                    },
                    abilities = {
                        { level = 60, name = "Max Rank Shield Slam & Revenge", desc = "Capstone physical threat ceiling." },
                        { level = 60, name = "Last Stand (Talent)", desc = "Instant 30% maximum health increase for 20 seconds." }
                    },
                    rules = {
                        "Stack Defense rating until 440 (soft cap) to remove critical strikes from level 63 boss tables.",
                        "Use Disarm on dual-wielding and enraging dungeon bosses to cut incoming physical spike damage by 50%.",
                        "Keep Taunt and Mocking Blow mapped to accessible keybinds for instantaneous target swaps."
                    }
                }
            },
            macros = {
                {
                    category = "Defensive / Tank",
                    title = "Prot: Mouseover Taunt",
                    desc = "Switches to Defensive Stance if needed and casts Taunt on mouseover or current target.",
                    code = "#showtooltip Taunt\n/cast [stance:1/3] Defensive Stance; [@mouseover,harm,nodead][harm,nodead] Taunt"
                },
                {
                    category = "Defensive / Tank",
                    title = "Prot: Panic Shield Wall",
                    desc = "Enters Defensive Stance, equips 1H + Shield, and triggers Shield Wall.",
                    code = "#showtooltip Shield Wall\n/cast [nostance:2] Defensive Stance\n/cast Shield Wall"
                },
                {
                    category = "Defensive / Tank",
                    title = "Prot: Stance-Dance Intercept",
                    desc = "Swaps to Berserker Stance, fires Intercept to stun runaway target, and returns to Defensive Stance.",
                    code = "#showtooltip Intercept\n/cast [nostance:3] Berserker Stance\n/cast Intercept\n/cast [stance:3] Defensive Stance"
                }
            }
        },

        ["ARMS"] = {
            specName = "Arms (2H Melee DPS)",
            role = "DPS",
            order = 2,
            statPriority = "Hit (to 9% Cap) > Slow 2H Weapon DPS > Crit > Strength > Attack Power",
            phaseGuidance = {
                [1] = {
                    name = "Phase 1: Levels 1–20",
                    summary = "Hamstring kiting between slow 2H swings, Overpower dodges, and Rend ticks.",
                    zones = {
                        { name = "Barrens / Westfall / Silverpine", range = "1–20", notes = "Acquire slowest possible 2-handed axe, mace, or sword." }
                    },
                    abilities = {
                        { level = 4, name = "Charge", desc = "Generates initial rage and stuns target for 1 sec." },
                        { level = 12, name = "Overpower", desc = "Unblockable, unparriable, undodgeable strike usable after enemy dodges (+50% crit with talents)." }
                    },
                    rules = {
                        "Use the Hamstring Kite method while soloing: hit mob with slow 3.6s 2H weapon, strafe away until swing timer resets, then step in to trade 1 hit for 1 hit instead of 1 for 3.",
                        "Avoid spamming Heroic Strike while leveling—it cancels your next white swing's rage generation; use Sunder or Cleave instead."
                    }
                },
                [2] = {
                    name = "Phase 2: Levels 20–40",
                    summary = "Sweeping Strikes cleave king, Whirlwind Axe quest at 30, and Mortal Strike at 40.",
                    zones = {
                        { name = "Hillsbrad / Arathi / STV", range = "20–40", notes = "Complete Whirlwind Axe quest chain in Arathi/STV as soon as possible at level 30!" }
                    },
                    abilities = {
                        { level = 30, name = "Sweeping Strikes (Talent)", desc = "Your next 5 melee attacks strike an additional nearby opponent! Unmatched 2-target dungeon cleave." },
                        { level = 36, name = "Whirlwind", desc = "Spins in Berserker Stance hitting up to 4 enemies for full weapon damage." },
                        { level = 40, name = "Mortal Strike (Talent)", desc = "Instant heavy weapon strike that reduces healing on target by 50%." }
                    },
                    rules = {
                        "Pool 60+ rage before a 2-4 mob pack, pop Sweeping Strikes in Battle Stance, swap to Berserker Stance, and press Whirlwind for double-procced massive burst.",
                        "Always wait for your tank to get 2 Sunders before unleashing Sweeping Strikes + Whirlwind."
                    }
                },
                [3] = {
                    name = "Phase 3: Levels 40–52",
                    summary = "Mortal Strike + Whirlwind rotation, Sword/Axe Specialization procs, and Execution phases.",
                    zones = {
                        { name = "Tanaris / Hinterlands / Maraudon", range = "40–52", notes = "Executioner's Cleaver, Gatorbite, or Princess 2H drops." }
                    },
                    abilities = {
                        { level = 35, name = "Axe / Sword Specialization (Talent)", desc = "+5% Crit with Axes or 5% chance for an extra free attack with Swords." }
                    },
                    rules = {
                        "Stay in Berserker Stance (+3% Crit) during single-target boss fights; dance to Battle Stance only when Overpower procs.",
                        "Below 20% boss health, dump all rage into Execute."
                    }
                },
                [4] = {
                    name = "Phase 4: Levels 52–60",
                    summary = "Endgame 2H cleave, Arcanite Reaper / Obsidian Edged Blade, and PvP Mortal Strike dominance.",
                    zones = {
                        { name = "BRD / UBRS / AV", range = "52–60", notes = "Ice Barbed Spear (AV quest), Blackhand's Breadth, Hand of Justice." }
                    },
                    abilities = {
                        { level = 60, name = "Recklessness", desc = "Grants 100% critical strike chance on all attacks for 15 seconds (30 min cooldown)." }
                    },
                    rules = {
                        "Carry a Lip (Limited Invulnerability Potion) whenever popping Sweeping Strikes + Recklessness on dungeon/raid packs.",
                        "Maintain Battle Shout across your melee party at all times."
                    }
                }
            },
            macros = {
                {
                    category = "Burst / DPS",
                    title = "Arms: Charge + Overpower Dance",
                    desc = "Enters Battle Stance and fires Charge out of combat or Overpower in combat.",
                    code = "#showtooltip Overpower\n/cast [nostance:1] Battle Stance\n/cast [nocombat] Charge; Overpower\n/startattack"
                },
                {
                    category = "Burst / DPS",
                    title = "Arms: Sweeping Strikes into Whirlwind",
                    desc = "Pops Sweeping Strikes in Battle Stance, then dances to Berserker Stance for Whirlwind.",
                    code = "#showtooltip Sweeping Strikes\n/cast [nostance:1] Battle Stance\n/cast Sweeping Strikes\n/cast [stance:1] Berserker Stance"
                },
                {
                    category = "Burst / DPS",
                    title = "Arms: Mortal Strike + StartAttack",
                    desc = "Starts auto-attack and immediately executes Mortal Strike.",
                    code = "#showtooltip Mortal Strike\n/startattack\n/cast Mortal Strike"
                }
            }
        },

        ["FURY"] = {
            specName = "Fury (Dual-Wield DPS)",
            role = "DPS",
            order = 3,
            statPriority = "Hit (6% w/ +5 Weapon Skill or 9% Cap) > Crit > Strength / Attack Power > Haste (Flurry)",
            phaseGuidance = {
                [1] = {
                    name = "Phase 1: Levels 1–20",
                    summary = "Cruelty (+5% Crit), early rage generation, and Dual Wield unlock at level 20.",
                    zones = {
                        { name = "Barrens / Westfall / Silverpine", range = "1–20", notes = "Pick up Cruelty 5/5 first for +5% melee crit." }
                    },
                    abilities = {
                        { level = 20, name = "Dual Wield", desc = "Allows equipping a one-handed weapon in the off-hand slot." }
                    },
                    rules = {
                        "Note that Dual Wielding incurs a 24% base white miss penalty—use a slow 2H until you acquire decent hit or green-level mobs.",
                        "Max out Cruelty (5/5) immediately at levels 10–14."
                    }
                },
                [2] = {
                    name = "Phase 2: Levels 20–40",
                    summary = "Death Wish cooldown (+20% physical damage), Flurry (+30% attack speed on crit), and Bloodthirst at 40.",
                    zones = {
                        { name = "SM / RFK / Hillsbrad / STV", range = "20–40", notes = "Sword of Omen and Vanquisher's Sword quest rewards (SM & RFD)." }
                    },
                    abilities = {
                        { level = 30, name = "Death Wish (Talent)", desc = "Increases physical damage by 20% and grants fear immunity for 30 sec." },
                        { level = 35, name = "Flurry (Talent)", desc = "Increases attack speed by 30% for your next 3 swings after landing a critical strike." },
                        { level = 40, name = "Bloodthirst (Talent)", desc = "Instant attack dealing 45% of your total Attack Power as damage and healing on next swings." }
                    },
                    rules = {
                        "Equip a slow Main Hand (2.6–2.8 speed) for big Whirlwind hits, and a fast Off Hand (1.5–1.8 speed) to proc Flurry and Unbridled Wrath.",
                        "Queue Heroic Strike or Cleave while Dual Wielding: while queued, your Off-Hand weapon does NOT suffer the dual-wield miss penalty!"
                    }
                },
                [3] = {
                    name = "Phase 3: Levels 40–52",
                    summary = "Thrash Blade questline (Maraudon), Bloodthirst + Whirlwind cooldown alignment, and Hit rating pursuit.",
                    zones = {
                        { name = "Tanaris / Maraudon / Hinterlands", range = "40–52", notes = "Complete Princess Theradras quest for Thrash Blade and Blackstone Ring (+1% Hit)." }
                    },
                    abilities = {
                        { level = 40, name = "Bloodthirst + Whirlwind Loop", desc = "Core 6s Bloodthirst and 10s Whirlwind Berserker Stance rotation." }
                    },
                    rules = {
                        "Keep Bloodthirst and Whirlwind on cooldown; only cast Heroic Strike when Rage exceeds 55+ so you never delay Bloodthirst.",
                        "Grab Blackstone Ring from Maraudon immediately—your first +1% Hit ring."
                    }
                },
                [4] = {
                    name = "Phase 4: Levels 52–60",
                    summary = "Endgame raid scaling titan: Lionheart Helm, Devilsaur Set, Dal'Rend's Sacred Charge, and Heroic Strike queueing.",
                    zones = {
                        { name = "BRD / UBRS / Strat", range = "52–60", notes = "Dal'Rend's Swords (UBRS), Hand of Justice (BRD), Lionheart Helm (BS)." }
                    },
                    abilities = {
                        { level = 52, name = "Execute Phase (<20%)", desc = "Highest DPS phase in the game—convert all pooled rage into Execute." }
                    },
                    rules = {
                        "Acquire 6% Hit (if Human with Swords/Maces or Orc with Axes) or 9% Hit so yellow attacks never miss.",
                        "Combine Death Wish + Mighty Rage Potion during the final 30 seconds of boss encounters."
                    }
                }
            },
            macros = {
                {
                    category = "Burst / DPS",
                    title = "Fury: Bloodthirst + StartAttack",
                    desc = "Starts auto-attack and fires Bloodthirst immediately.",
                    code = "#showtooltip Bloodthirst\n/startattack\n/cast Bloodthirst"
                },
                {
                    category = "Burst / DPS",
                    title = "Fury: Berserker Whirlwind",
                    desc = "Swaps to Berserker Stance if needed and casts Whirlwind.",
                    code = "#showtooltip Whirlwind\n/cast [nostance:3] Berserker Stance\n/startattack\n/cast Whirlwind"
                },
                {
                    category = "Burst / DPS",
                    title = "Fury: Death Wish + Trinket Burst",
                    desc = "Activates Death Wish and top trinket slot for maximum burst DPS.",
                    code = "#showtooltip Death Wish\n/use 13\n/cast Death Wish\n/startattack"
                }
            }
        }
    }
}

HFG:RegisterClassModule("WARRIOR", WarriorModule)
