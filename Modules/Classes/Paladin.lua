--[[
    Heathen's Forever Guide - Modules/Classes/Paladin.lua
    Paladin Multi-Spec Module: Protection (Tank), Holy (Healer), Retribution (Melee DPS)
]]

local ADDON_NAME, HFG = ...

local PaladinModule = {
    name = "Paladin",
    token = "PALADIN",
    defaultSpec = "PROTECTION",
    specs = {
        ["PROTECTION"] = {
            specName = "Protection (Tank)",
            role = "TANK",
            order = 1,
            statPriority = "Stamina > Defense (to 440 Cap) > Spell Power / Block Value > Armor > MP5",
            phaseGuidance = {
                [1] = {
                    name = "Phase 1: Levels 1–20",
                    summary = "Early holy survivability, 30yd bomb pull mechanics, and learning threat peel via Judgement.",
                    zones = {
                        { name = "Silverpine / Westfall / Northern Barrens", range = "10–20", notes = "Follow main quest chains; dense Copper/Tin veins for early engineering." }
                    },
                    abilities = {
                        { level = 6, name = "Holy Strike", desc = "Primary single-target on-hit threat generator." },
                        { level = 10, name = "Seal / Judgement of Fury", desc = "High threat multiplier. Use Judgement of Fury as your 10yd peel/taunt tool." }
                    },
                    rules = {
                        "Always initiate trash pulls from 30yd with explosives to pull casters into melee clusters.",
                        "Reserve Judgement of Fury for peel: snap taunt loose mobs at 10yd when they target healer or caster.",
                        "Buff Devotion Aura or Retribution Aura (Ret Aura generates passive holy threat on 3+ attackers)."
                    }
                },
                [2] = {
                    name = "Phase 2: Levels 20–40",
                    summary = "The AoE tanking breakthrough with baseline Consecration, grenade grouping, and transition to Plate Armor.",
                    zones = {
                        { name = "Hillsbrad / Arathi / STV", range = "20–40", notes = "Tarren Mill, Southshore, and Hammerfall quest hubs; rich Iron and Heavy Stone." }
                    },
                    abilities = {
                        { level = 20, name = "Baseline Consecration", desc = "The bread-and-butter AoE holy threat zone. Pulse tick threat locks down groups." },
                        { level = 40, name = "Plate Armor Training", desc = "Huge armor mitigation upgrade. Prioritize replacing mail with heavy plate." }
                    },
                    rules = {
                        "Toss an Iron Grenade on casting packs to interrupt and bundle them together before dropping Consecration.",
                        "Always drink to at least 70% mana between pulls—Protection Paladin threat is completely mana-fueled.",
                        "Equip high block value shields: Redoubt doubles your block chance after taking a critical strike."
                    }
                },
                [3] = {
                    name = "Phase 3: Levels 40–52",
                    summary = "Goblin Engineering specialization, deep Protection talents with Holy Shield, and high-density dungeon cleave.",
                    zones = {
                        { name = "Tanaris / Feralas / WPL", range = "40–52", notes = "Gadgetzan, Camp Mojache, and Caer Darrow; abundant Mithril and Mageweave." }
                    },
                    abilities = {
                        { level = 40, name = "Holy Shield (Talent)", desc = "Key mitigation & reactive holy threat spell. Increases block chance by 30% and reflects holy damage on block." },
                        { level = 50, name = "Cleanse", desc = "Removes 1 Poison, 1 Disease, and 1 Magic effect in a single GCD." }
                    },
                    rules = {
                        "Keep Holy Shield active on cooldown whenever taking damage from 2+ targets—charges deplete rapidly.",
                        "For high-threat openers on 5+ mobs: pop Sapper Charge into Rank 1 Consecration for instant snap agro.",
                        "Position boss backs to your group and watch your own back to avoid being critically hit or parried."
                    }
                },
                [4] = {
                    name = "Phase 4: Levels 52–60",
                    summary = "Endgame preparation, Thorium-tier engineering, pre-raid BIS dungeon tanking, and raid blessings.",
                    zones = {
                        { name = "Un'Goro / Winterspring / EPL", range = "52–60", notes = "Rich Thorium Veins, Stratholme entrance, and high-density undead camps." }
                    },
                    abilities = {
                        { level = 56, name = "Greater Blessings (Kings/Sanctuary)", desc = "Greater Blessing of Sanctuary provides holy damage reduction and damage reflection on block." },
                        { level = 60, name = "Max Rank Consecration & Holy Shield", desc = "Peak TPS (Threat Per Second) output." }
                    },
                    rules = {
                        "In Stratholme and Scholomance, weave Holy Wrath into openers for 3 sec mass stun on demons/undead.",
                        "LOS (Line of Sight) pull caster mobs around doorways or pillars to force them to cluster on your Consecration.",
                        "Keep Greater Blessing of Sanctuary active on yourself for flat damage reduction and holy damage reflection."
                    }
                }
            },
            macros = {
                {
                    category = "Defensive / Tank",
                    title = "Prot: Mouseover Peel Judgement",
                    desc = "Casts Judgement on mouseover enemy target, falling back to your current target.",
                    code = "#showtooltip Judgement\n/cast [@mouseover,harm,nodead][harm,nodead] Judgement"
                },
                {
                    category = "Defensive / Tank",
                    title = "Prot: Target-of-Target Taunt",
                    desc = "Peels runaway mobs by targeting the teammate being attacked and judging their target.",
                    code = "#showtooltip Judgement\n/cast [@targettarget,harm,nodead][harm,nodead] Judgement"
                },
                {
                    category = "Defensive / Tank",
                    title = "Prot: Panic Shield Wall",
                    desc = "Emergency survivability macro stopping any active casts to fire Bulwark and Holy Shield instantly.",
                    code = "#showtooltip Templar's Bulwark\n/stopcasting\n/cast Templar's Bulwark\n/cast Holy Shield"
                },
                {
                    category = "Healing / Mouseover",
                    title = "Paladin: Clutch Cleanse",
                    desc = "Dispels poison/disease/magic on friendly mouseover without dropping your current hostile target.",
                    code = "#showtooltip Cleanse\n/cast [@mouseover,help,nodead][@player] Cleanse"
                }
            }
        },

        ["HOLY"] = {
            specName = "Holy (Healer)",
            role = "HEALER",
            order = 2,
            statPriority = "Spell Crit (Illumination Mana Refund) > Healing Power > Intellect > MP5 > Stamina",
            phaseGuidance = {
                [1] = {
                    name = "Phase 1: Levels 1–20",
                    summary = "Early Holy Light triage, Blessing of Wisdom uptime, and melee Seal of Wisdom/Crusader weaving.",
                    zones = {
                        { name = "Tirisfal / Elwynn / Silverpine", range = "1–20", notes = "Group up for elite quests and early dungeon healing in RFC and Deadmines." }
                    },
                    abilities = {
                        { level = 1, name = "Holy Light", desc = "Large, slow 2.5 sec single-target heal. Pre-cast and cancel if tank takes no damage." },
                        { level = 14, name = "Blessing of Wisdom", desc = "Essential passive MP5 buff for yourself and all mana users." },
                        { level = 18, name = "Blessing of Protection (BoP)", desc = "Grants physical immunity to a party member for 6–10 sec. Instant lifesaver for clothies!" }
                    },
                    rules = {
                        "Downrank Holy Light: Use Rank 1 or Rank 2 during steady damage to conserve mana; save max rank for tank spikes.",
                        "Stand in melee range during safe pulls to auto-attack with Seal of Wisdom once unlocked for free mana.",
                        "Use Hammer of Justice to stun loose runners attacking you rather than running away from the tank."
                    }
                },
                [2] = {
                    name = "Phase 2: Levels 20–40",
                    summary = "Flash of Light efficiency breakthrough, Illumination talent 100% crit mana refunds, and Cleanse.",
                    zones = {
                        { name = "Hillsbrad / Scarlet Monastery / STV", range = "20–40", notes = "Spam Scarlet Monastery Library and Cathedral for caster/healing gear." }
                    },
                    abilities = {
                        { level = 20, name = "Flash of Light", desc = "Fast 1.5 sec ultra-mana-efficient heal. Your primary dungeon and raid healing spell!" },
                        { level = 30, name = "Illumination (Talent)", desc = "Gives 100% mana refund whenever your Flash of Light, Holy Light, or Holy Shock critically heals!" },
                        { level = 30, name = "Divine Favor (Talent)", desc = "Guarantees your next heal is a 100% critical strike with zero net mana cost." }
                    },
                    rules = {
                        "Prioritize Flash of Light over Holy Light: Flash of Light has unmatched Healing-Per-Mana and fast cast speed.",
                        "Stack Intellect and Spell Crit gear—every critical heal refunds 100% of its mana cost via Illumination.",
                        "Keep Blessing of Salvation on trigger-happy DPS so your tank maintains clean threat control."
                    }
                },
                [3] = {
                    name = "Phase 3: Levels 40–52",
                    summary = "Holy Shock instant burst triage, Plate/Mail intellect mixing, and Cleanse magic dispels.",
                    zones = {
                        { name = "Tanaris / Hinterlands / Maraudon", range = "40–52", notes = "Zul'Farrak and Maraudon healing trinkets and intellect shields." }
                    },
                    abilities = {
                        { level = 40, name = "Holy Shock (Talent)", desc = "Instant cast heal (or damage) on a 30 sec cooldown. Essential emergency heal while moving." },
                        { level = 42, name = "Cleanse", desc = "Removes Poison, Disease, and Magic in a single cast—keep your tank free of slows and hexes." }
                    },
                    rules = {
                        "Pair Divine Favor + Holy Shock or Max Rank Holy Light for an instant guaranteed critical emergency heal.",
                        "Don't restrict yourself strictly to Plate: Cloth and Leather items with high +Healing and Spell Crit are superior in PvE.",
                        "Maintain Seal of Wisdom or Judgement of Light on dungeon bosses to passively heal melee attackers."
                    }
                },
                [4] = {
                    name = "Phase 4: Levels 52–60",
                    summary = "Endgame downranking mastery (FoL Rank 1, 4, 6), Pre-Raid BIS +Healing gear, and endless mana sustain.",
                    zones = {
                        { name = "BRD / Dire Maul / Stratholme / Scholo", range = "52–60", notes = "Farm Padre's Trousers, Robes of the Exalted, and Briarwood Reed." }
                    },
                    abilities = {
                        { level = 50, name = "Lay on Hands", desc = "Instantly heals a target for an amount equal to your maximum health." },
                        { level = 60, name = "Greater Blessings", desc = "15-minute raid-wide blessings (Wisdom, Kings, Salvation, Light)." }
                    },
                    rules = {
                        "Keep Greater Blessing of Light active on the Main Tank to massively boost all incoming Holy Light and Flash of Light heals.",
                        "Downrank Flash of Light (Rank 4) with +300 Healing power for endless nonstop casting that never goes OOM.",
                        "Use Divine Shield + heal spam during chaotic dungeon pulls so you cannot be interrupted or killed."
                    }
                }
            },
            macros = {
                {
                    category = "Healing / Mouseover",
                    title = "Holy: Mouseover Flash of Light",
                    desc = "Casts Flash of Light on friendly mouseover frame or unit, falling back to target or player.",
                    code = "#showtooltip Flash of Light\n/cast [@mouseover,help,nodead][help,nodead][@player] Flash of Light"
                },
                {
                    category = "Healing / Mouseover",
                    title = "Holy: Mouseover Holy Light",
                    desc = "Casts Holy Light on friendly mouseover frame or unit.",
                    code = "#showtooltip Holy Light\n/cast [@mouseover,help,nodead][help,nodead][@player] Holy Light"
                },
                {
                    category = "Healing / Mouseover",
                    title = "Holy: Divine Favor + Holy Shock",
                    desc = "Pops Divine Favor for 100% crit and fires an instant Holy Shock on mouseover friendly target.",
                    code = "#showtooltip Holy Shock\n/cast Divine Favor\n/cast [@mouseover,help,nodead][help,nodead][@player] Holy Shock"
                },
                {
                    category = "Healing / Mouseover",
                    title = "Holy: Emergency BoP Save",
                    desc = "Instantly casts Blessing of Protection on a friendly mouseover mage/warlock/healer.",
                    code = "#showtooltip Blessing of Protection\n/stopcasting\n/cast [@mouseover,help,nodead][help,nodead] Blessing of Protection"
                }
            }
        },

        ["RETRIBUTION"] = {
            specName = "Retribution (DPS)",
            role = "DPS",
            order = 3,
            statPriority = "Hit (to 9% Cap) >Weapon DPS (Slow 3.50+ 2H) > Crit > Strength > Agility / Spell Power",
            phaseGuidance = {
                [1] = {
                    name = "Phase 1: Levels 1–20",
                    summary = "Slow 2-handed weapon swing timer management, Seal of the Crusader, and Seal of Command unlock at 20.",
                    zones = {
                        { name = "Tirisfal / Silverpine / Barrens", range = "1–20", notes = "Quest rewards with slow 2H maces and swords." }
                    },
                    abilities = {
                        { level = 6, name = "Seal of the Crusader", desc = "Increases attack speed by 40%; Judge on bosses to increase Holy damage taken." },
                        { level = 20, name = "Seal of Command (Talent)", desc = "Core Retribution talent: gives a 7 PPM chance to deal 70% weapon damage as extra Holy damage!" }
                    },
                    rules = {
                        "Always use the slowest, highest top-end damage Two-Handed weapon available (3.50 to 3.80 speed) to maximize Seal of Command procs.",
                        "Never clip your swing timer: activate Seals and Judgements immediately AFTER a melee swing lands.",
                        "Downrank Seal of Command (Rank 1) when solo grinding to save 65% mana while dealing nearly identical proc damage."
                    }
                },
                [2] = {
                    name = "Phase 2: Levels 20–40",
                    summary = "Pursuit of Justice (+8% mount/run speed), Vengeance stacking crit damage, and Scarlet Monastery 2H weapons.",
                    zones = {
                        { name = "Hillsbrad / Arathi / STV / SM", range = "20–40", notes = "Verigan's Fist / Bonebiter / Ravager in Scarlet Monastery." }
                    },
                    abilities = {
                        { level = 22, name = "Pursuit of Justice (Talent)", desc = "+8% movement and mounted speed passively. Huge leveling efficiency multiplier." },
                        { level = 30, name = "Sanctity Aura (Talent)", desc = "Increases Holy damage done by party members by 10%." },
                        { level = 35, name = "Vengeance (Talent)", desc = "Gives you a +15% physical and holy damage bonus for 8 sec after dealing a critical strike." }
                    },
                    rules = {
                        "Judge Seal of the Crusader on high-HP targets first, then maintain Seal of Command.",
                        "Use Hammer of Justice while Seal of Command is active: Seal of Command deals guaranteed double damage against stunned targets!",
                        "Watch your threat on big crits: keep Blessing of Salvation on yourself in 5-man dungeons."
                    }
                },
                [3] = {
                    name = "Phase 3: Levels 40–52",
                    summary = "Repentance crowd control, Plate DPS gear, and Zul'Farrak / Maraudon 2H power spikes.",
                    zones = {
                        { name = "Tanaris / Hinterlands / Feralas", range = "40–52", notes = "The Rockpounder in Zul'Farrak and Princess Theradras drops." }
                    },
                    abilities = {
                        { level = 40, name = "Repentance (Talent)", desc = "Puts humanoid target in meditation for up to 6 seconds. Great CC and PvP gap closer." },
                        { level = 44, name = "Hammer of Wrath", desc = "Ranged holy execute usable on targets below 20% health." }
                    },
                    rules = {
                        "In undead dungeons, weave Exorcism on cooldown for massive instant holy crits that trigger Vengeance.",
                        "Carry mana potions and Demonic Runes if weaving Consecration into AoE dungeon trash pulls.",
                        "Use Cleanse on melee partners when they are Frost Nova'd or slowed so the whole group stays on target."
                    }
                },
                [4] = {
                    name = "Phase 4: Levels 52–60",
                    summary = "9% Melee Hit cap, Lionheart Helm / Devilsaur sets, and Seal Twisting (Command into Righteousness).",
                    zones = {
                        { name = "Un'Goro / EPL / BRD / UBRS", range = "52–60", notes = "Blackhand's Breadth, Hand of Justice, and Demise / Arcanite Reaper." }
                    },
                    abilities = {
                        { level = 60, name = "Seal Twisting Technique", desc = "Cast Seal of Righteousness 0.4s before weapon swing to trigger BOTH Seal of Command and Righteousness on one swing!" }
                    },
                    rules = {
                        "Reach 9% Melee Hit first so your white swings and Judgements never miss level 63 bosses.",
                        "Use a Weapon Swing Timer to master Seal Twisting during the final 0.4s window of your swing.",
                        "Provide Nightfall axe or Sanctity Aura utility to boost raid caster/holy damage."
                    }
                }
            },
            macros = {
                {
                    category = "Burst / DPS",
                    title = "Ret: StartAttack + Judgement",
                    desc = "Ensures auto-attack is active while firing Judgement on current target.",
                    code = "#showtooltip Judgement\n/startattack\n/cast Judgement"
                },
                {
                    category = "Burst / DPS",
                    title = "Ret: Exorcism Undead Burst",
                    desc = "Starts melee swing and immediately blasts Undead/Demon target with Exorcism.",
                    code = "#showtooltip Exorcism\n/startattack\n/cast Exorcism"
                },
                {
                    category = "Burst / DPS",
                    title = "Ret: Repentance Mouseover CC",
                    desc = "Incapacitates mouseover enemy or current target without losing primary focus.",
                    code = "#showtooltip Repentance\n/cast [@mouseover,harm,nodead][harm,nodead] Repentance"
                }
            }
        }
    }
}

HFG:RegisterClassModule("PALADIN", PaladinModule)
