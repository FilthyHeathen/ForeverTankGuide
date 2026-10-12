--[[
    ForeverTankGuide - Modules/Classes/Rogue.lua
    Rogue Multi-Spec Module: Blade Dance (Tank), Combat (Swords/Daggers DPS), Assassination/Subtlety
]]

local ADDON_NAME, FTG = ...

local RogueModule = {
    name = "Rogue",
    token = "ROGUE",
    defaultSpec = "BLADE_DANCE",
    specs = {
        ["BLADE_DANCE"] = {
            specName = "Blade Dance (Avoidance Tank)",
            role = "TANK",
            order = 1,
            statPriority = "Agility (Dodge + Armor + Crit) > Stamina > Hit (to 9%) > Parry / Defense > Attack Power",
            phaseGuidance = {
                [1] = {
                    name = "Phase 1: Levels 1–20",
                    summary = "Early avoidance mechanics, Sinister Strike combo generation, and Evasion cooldown tanking.",
                    zones = {
                        { name = "Silverpine / Westfall / Barrens", range = "1–20", notes = "Poisons questline at lvl 20; Thistle Tea recipe." }
                    },
                    abilities = {
                        { level = 8, name = "Evasion", desc = "+50% dodge chance for 15 seconds on a 5-minute cooldown." },
                        { level = 10, name = "Slice and Dice", desc = "Increases attack speed by 30% for rapid poison applications and threat generation." },
                        { level = 12, name = "Kick", desc = "Instant melee caster interrupt." }
                    },
                    rules = {
                        "Always face targets directly: Rogue tanking depends 100% on Dodge and Parry; getting hit from behind removes avoidance entirely.",
                        "Maintain active combo point spenders for defense and attack speed buffs.",
                        "Use Gouge as an active secondary interrupt or to pause damage while waiting for energy."
                    }
                },
                [2] = {
                    name = "Phase 2: Levels 20–40",
                    summary = "Ghostly Strike avoidance (+15% dodge), Riposte disarm, and Blade Flurry multi-target cleave.",
                    zones = {
                        { name = "Hillsbrad / Arathi / SM", range = "20–40", notes = "Deflection and Agility leather gear farming." }
                    },
                    abilities = {
                        { level = 20, name = "Ghostly Strike (Talent)", desc = "Deals weapon damage and increases dodge chance by 15% for 7 seconds." },
                        { level = 20, name = "Riposte (Talent)", desc = "Strikes for 150% weapon damage and disarms the target for 6 seconds following a parry." },
                        { level = 30, name = "Blade Flurry (Talent)", desc = "Increases attack speed by 20% and cleaves an additional nearby enemy." }
                    },
                    rules = {
                        "Keep Ghostly Strike on cooldown for uninterrupted +15% dodge uptime.",
                        "Trigger Riposte immediately on parry to eliminate incoming physical weapon damage from dangerous mobs.",
                        "Pop Blade Flurry + explosives for multi-target dungeon pack snap threat."
                    }
                },
                [3] = {
                    name = "Phase 3: Levels 40–52",
                    summary = "Adrenaline Rush burst threat, Blind crowd control peels, and high agility dungeon leather.",
                    zones = {
                        { name = "Tanaris / Hinterlands / ZF", range = "40–52", notes = "Farming Devilsaur leather pieces and Zul'Farrak swords." }
                    },
                    abilities = {
                        { level = 34, name = "Blind", desc = "Disorients target for up to 10 seconds. Superb for peeling adds off your healer." },
                        { level = 40, name = "Adrenaline Rush (Talent)", desc = "Doubles energy regeneration for 15 seconds on a 5-minute cooldown." }
                    },
                    rules = {
                        "Use Blind to instantly neutralize stray dungeon mobs without losing your primary target.",
                        "Keep Instant Poison coated on both main hand and off hand weapons for steady threat ticks."
                    }
                },
                [4] = {
                    name = "Phase 4: Levels 52–60",
                    summary = "Avoidance cap ceiling (~102.4% combined Miss + Dodge + Parry to become unhittable during cooldowns).",
                    zones = {
                        { name = "EPL / Strat / Scholo / UBRS", range = "52–60", notes = "Shadowcraft armor set and high agility rings/trinkets." }
                    },
                    abilities = {
                        { level = 60, name = "Max Rank Evasion & Ghostly Strike", desc = "Peak physical avoidance." }
                    },
                    rules = {
                        "Stack pure Agility: each point gives armor, crit, and significant dodge percentage.",
                        "Chain Evasion into Ghostly Strike on heavy physical boss enrages.",
                        "Keep Flash Powder and Blinding Powder stocked in large stacks in your bags."
                    }
                }
            },
            macros = {
                {
                    category = "Defensive / Tank",
                    title = "Rogue Tank: Panic Evasion + Ghostly",
                    desc = "Pops Evasion immediately and triggers Ghostly Strike for maximum avoidance.",
                    code = "#showtooltip Evasion\n/stopcasting\n/cast Evasion\n/cast Ghostly Strike"
                },
                {
                    category = "Defensive / Tank",
                    title = "Rogue: Riposte + Sinister Strike",
                    desc = "Fires Riposte immediately whenever a parry activates it, otherwise Sinister Strike.",
                    code = "#showtooltip Sinister Strike\n/startattack\n/cast Riposte\n/cast Sinister Strike"
                }
            }
        },

        ["COMBAT_DPS"] = {
            specName = "Combat (Swords / Daggers DPS)",
            role = "DPS",
            order = 2,
            statPriority = "Hit (to 9% Yellow / +5 Weapon Skill) > Slow Main-Hand DPS > Agility / Crit > Attack Power",
            phaseGuidance = {
                [1] = {
                    name = "Phase 1: Levels 1–20",
                    summary = "Improved Sinister Strike (2/2 = 40 Energy cost), Precision (+5% Hit), and Dual Wield at 10.",
                    zones = {
                        { name = "Tirisfal / Elwynn / Westfall / Barrens", range = "1–20", notes = "Cruel Barb (Deadmines) or Outlaw Sabre (BFD)." }
                    },
                    abilities = {
                        { level = 10, name = "Slice and Dice", desc = "Your #1 DPS finisher: +30% attack speed! Never let Slice and Dice drop in combat!" },
                        { level = 10, name = "Dual Wield & Sprint", desc = "Off-hand weapon unlock and 50–70% movement speed burst." }
                    },
                    rules = {
                        "Always use a SLOW Main-Hand weapon (2.60–2.80 speed) to maximize Sinister Strike damage, and a FAST Off-Hand (1.40–1.50 speed) to proc Instant Poison.",
                        "Maintain 1-2 point Slice and Dice at 100% uptime—it out-DPSes Eviscerate on any fight lasting longer than 8 seconds."
                    }
                },
                [2] = {
                    name = "Phase 2: Levels 20–40",
                    summary = "Dual Wield Specialization (+50% Off-hand damage), Blade Flurry (lvl 30), and Sword Spec (+5% extra swing)!",
                    zones = {
                        { name = "Hillsbrad / STV / SM / RFD", range = "20–40", notes = "Sword of Omen (SM Quest) + Vanquisher's Sword (RFD Quest)!" }
                    },
                    abilities = {
                        { level = 20, name = "Poisons (Instant & Crippling)", desc = "Coat both weapons with Instant Poison for 15–20% total DPS increase." },
                        { level = 30, name = "Blade Flurry (Talent)", desc = "+20% attack speed and strikes a second nearby opponent for 15 seconds!" },
                        { level = 35, name = "Sword Specialization (Talent)", desc = "5% chance to get an extra free Main-Hand attack after hitting an enemy!" }
                    },
                    rules = {
                        "At level 37–39, complete the Scarlet Monastery and Razorfen Downs quests for Sword of Omen + Vanquisher's Sword—they carry you to level 50!",
                        "Use Feint or Vanish immediately if Blade Flurry cleave pulls aggro off your tank."
                    }
                },
                [3] = {
                    name = "Phase 3: Levels 40–52",
                    summary = "Adrenaline Rush (lvl 40), Thrash Blade (Maraudon), and Lockpicking 225+.",
                    zones = {
                        { name = "Tanaris / Hinterlands / Maraudon", range = "40–52", notes = "Thrash Blade (Maraudon Princess quest) stacks with Sword Specialization!" }
                    },
                    abilities = {
                        { level = 40, name = "Adrenaline Rush (Talent)", desc = "100% increased Energy regeneration for 15 seconds!" }
                    },
                    rules = {
                        "Combine Blade Flurry + Adrenaline Rush + Thistle Tea on dungeon bosses for unmatched physical burst.",
                        "Keep your Lockpicking leveled up to open locked dungeon doors (SM, BRD, Scholo) and lockboxes for your group."
                    }
                },
                [4] = {
                    name = "Phase 4: Levels 52–60",
                    summary = "Weapon Expertise (+5 Weapon Skill = 305), Dal'Rend's Sacred Charge, Devilsaur Set, and Raid DPS.",
                    zones = {
                        { name = "BRD / UBRS / Strat / Scholo", range = "52–60", notes = "Dal'Rend's Swords (UBRS), Hand of Justice (BRD), Tarnished Elven Rings (DM)." }
                    },
                    abilities = {
                        { level = 60, name = "305 Weapon Skill (Weapon Expertise 2/2)", desc = "Built-in +5 Sword/Dagger skill reduces glancing blow penalties against level 63 raid bosses!" }
                    },
                    rules = {
                        "Because Combat grants +5 Weapon Skill natively in talents, Rogues are top-tier raid DPS regardless of race!",
                        "Never let Slice and Dice drop on bosses; spend excess combo points on 5-point Eviscerate."
                    }
                }
            },
            macros = {
                {
                    category = "Burst / DPS",
                    title = "Combat: Sinister Strike + StartAttack",
                    desc = "Starts auto-attack immediately even if out of Energy, and casts Sinister Strike.",
                    code = "#showtooltip Sinister Strike\n/startattack\n/cast Sinister Strike"
                },
                {
                    category = "Burst / DPS",
                    title = "Combat: Mouseover Kick Interrupt",
                    desc = "Instantly kicks mouseover enemy caster or current target.",
                    code = "#showtooltip Kick\n/cast [@mouseover,harm,nodead][harm,nodead] Kick"
                },
                {
                    category = "Burst / DPS",
                    title = "Combat: Mouseover Blind Peel",
                    desc = "Blinds a loose mouseover mob attacking your healer without dropping your main target.",
                    code = "#showtooltip Blind\n/cast [@mouseover,harm,nodead][harm,nodead] Blind"
                }
            }
        },

        ["ASSASSINATION"] = {
            specName = "Assassination (Poisons & Seal Fate Daggers)",
            role = "DPS",
            order = 3,
            statPriority = "Crit (to proc Seal Fate +2 Combo Points!) > Hit (to 9% Yellow) > Daggers / Fast Weapons > Agility > Attack Power",
            phaseGuidance = {
                [1] = {
                    name = "Phase 1: Levels 1–20",
                    summary = "Malice (+5% Crit), Ruthlessness, and Improved Eviscerate (+15% Finisher Damage).",
                    zones = {},
                    abilities = {
                        { level = 14, name = "Ambush & Backstab", desc = "Massive rear-positional dagger openers and builders." }
                    },
                    rules = {
                        "Take Remorseless Attacks (2/2) while leveling—every mob you kill grants +40% Crit on your next Sinister Strike, Backstab, or Ambush!"
                    }
                },
                [2] = {
                    name = "Phase 2: Levels 20–40",
                    summary = "Vile Poisons (+20% Poison Damage), Improved Poisons, and Cold Blood (lvl 30 Guaranteed Crit!).",
                    zones = {},
                    abilities = {
                        { level = 30, name = "Cold Blood (Talent)", desc = "Increases the critical strike chance of your next offensive ability by 100%!" },
                        { level = 30, name = "Kidney Shot", desc = "Up to 6-second melee stun finisher—locks down dangerous dungeon casters." }
                    },
                    rules = {
                        "Save Cold Blood for 5-combo-point Eviscerates to instantly delete low-health dungeon bosses or PvP targets."
                    }
                },
                [3] = {
                    name = "Phase 3: Levels 40–52",
                    summary = "Seal Fate (+1 Extra Combo Point on every Critical Strike!) and Vigor (110 Max Energy).",
                    zones = {},
                    abilities = {
                        { level = 40, name = "Seal Fate (5/5 Talent)", desc = "Critical strikes from combo-generating abilities grant an additional combo point!" }
                    },
                    rules = {
                        "With Seal Fate, a single Backstab or Sinister Strike crit generates 2 combo points (and Cheap Shot generates 3), flooding you with 5-point finishers!"
                    }
                },
                [4] = {
                    name = "Phase 4: Levels 52–60",
                    summary = "High-Crit Seal Fate Daggers, Aged Core Leather Gloves (+5 Dagger Skill), and Relentless Strikes.",
                    zones = {},
                    abilities = {
                        { level = 60, name = "Cold Blood + 5pt Eviscerate", desc = "Guaranteed 2,000+ critical finisher with Relentless Strikes (+25 Energy refund)." }
                    },
                    rules = {
                        "Always maintain 100% Slice and Dice uptime first, then dump rapid Seal Fate 5-point Eviscerates with Relentless Strikes energy refunds."
                    }
                }
            },
            macros = {
                {
                    category = "Burst / DPS",
                    title = "Assassination: Cold Blood + 5pt Eviscerate",
                    desc = "Activates Cold Blood off the GCD and immediately fires a guaranteed critical Eviscerate.",
                    code = "#showtooltip Eviscerate\n/cast Cold Blood\n/cast Eviscerate"
                }
            }
        }
    }
}

FTG:RegisterClassModule("ROGUE", RogueModule)
