--[[
    Heathen's Forever Guide - Modules/Classes/Shaman.lua
    Shaman Multi-Spec Module: Enhancement Tank (Way of Earth), Enhancement (Melee DPS), Elemental (Caster DPS), Restoration (Healer)
]]

local ADDON_NAME, FTG = ...

local ShamanModule = {
    name = "Shaman",
    token = "SHAMAN",
    defaultSpec = "WARDEN_TANK",
    specs = {
        ["WARDEN_TANK"] = {
            specName = "Enhancement (Tank / Way of Earth)",
            role = "TANK",
            order = 1,
            statPriority = "Stamina > Armor / Shield Block > Defense > Spell/Melee Hit > Agility / Strength",
            phaseGuidance = {
                [1] = {
                    name = "Phase 1: Levels 1â€“20",
                    summary = "Rockbiter Weapon imbues (+threat), Earth Shock ranged peels, and Stoneskin Totem physical reduction.",
                    zones = {
                        { name = "Durotar / Mulgore / Barrens", range = "1â€“20", notes = "Totem questlines (Earth, Fire, Water) and RFC/WC runs." }
                    },
                    abilities = {
                        { level = 1, name = "Rockbiter Weapon", desc = "Imbues your melee weapon with bonus attack power and extreme threat generation." },
                        { level = 4, name = "Earth Shock", desc = "20yd high threat shock and caster spell interrupt." },
                        { level = 4, name = "Stoneskin Totem", desc = "Reduces incoming physical damage for all nearby party members." }
                    },
                    rules = {
                        "Always keep Rockbiter Weapon active on your 1H weapon for steady high threat.",
                        "Use Earth Shock Rank 1 as a cheap interrupt, or max rank for ranged snap taunting.",
                        "Drop Stoneskin Totem and Searing Totem before engaging melee packs."
                    }
                },
                [2] = {
                    name = "Phase 2: Levels 20â€“40",
                    summary = "Shield Specialization block value, Parry talent unlock, and Ghost Wolf repositioning.",
                    zones = {
                        { name = "Thousand Needles / Hillsbrad / RFK / SM", range = "20â€“40", notes = "Enhancement talent tree push down to Parry and Shield spec." }
                    },
                    abilities = {
                        { level = 20, name = "Ghost Wolf", desc = "40% movement speed for quick positioning." },
                        { level = 28, name = "Grounding Totem", desc = "Absorbs one harmful spell targeted at nearby party members every 15 seconds." },
                        { level = 30, name = "Parry (Talent)", desc = "Unlocks the ability to parry enemy melee attacksâ€”mandatory defensive milestone." }
                    },
                    rules = {
                        "Drop Grounding Totem on caster packs to absorb shadow bolts and fireballs meant for your healer.",
                        "Equip high armor Mail (at 40) and heavy shields with high block value.",
                        "Conserve shocks for interrupts and loose mob peeling so you don't go OOM mid-pull."
                    }
                },
                [3] = {
                    name = "Phase 3: Levels 40â€“52",
                    summary = "Mail Armor transition at 40, Chain Lightning multi-target pull openers, and Zul'Farrak / Maraudon.",
                    zones = {
                        { name = "Tanaris / Hinterlands / Maraudon", range = "40â€“52", notes = "Mail armor upgrades and Mark of the Chosen trinket." }
                    },
                    abilities = {
                        { level = 32, name = "Chain Lightning", desc = "Tri-target nature damage burst opener." },
                        { level = 40, name = "Stormstrike (Talent)", desc = "Instant melee strike that increases the next 2 Nature damage sources by 20%." }
                    },
                    rules = {
                        "Pre-cast Chain Lightning into Earth Shock + Fire Nova Totem for an explosive AoE pull on 3+ targets.",
                        "Drop Grace of Air Totem (+Agility = Dodge & Armor) when tanking heavy physical bosses, or Windfury Totem when threat is needed.",
                        "Use Tremor Totem proactively against fear-heavy dungeon encounters."
                    }
                },
                [4] = {
                    name = "Phase 4: Levels 52â€“60",
                    summary = "Endgame elemental warding, high resistance totem swapping, and BRD/Stratholme/Scholo tanking.",
                    zones = {
                        { name = "Eastern Plaguelands / BRD / Scholo", range = "52â€“60", notes = "Draconian Deflector, Force of Will, and defense mail." }
                    },
                    abilities = {
                        { level = 60, name = "Resistance Totems (Fire/Frost/Nature)", desc = "+60 Elemental Resistance to the entire party." }
                    },
                    rules = {
                        "Communicate with your group when dropping Stoneclaw Totem + Engineering Target Dummy as emergency AoE decoys.",
                        "Maintain Purge on enemy bosses to strip dangerous shields and haste buffs.",
                        "Pair Engineering Force Reactive Disk + Lightning Shield for high reactive AoE threat."
                    }
                }
            },
            macros = {
                {
                    category = "Defensive / Tank",
                    title = "Shaman: Mouseover Earth Shock Peel",
                    desc = "Casts Earth Shock on mouseover enemy or current target to interrupt or snap taunt.",
                    code = "#showtooltip Earth Shock\n/stopcasting\n/cast [@mouseover,harm,nodead][harm,nodead] Earth Shock"
                },
                {
                    category = "Defensive / Tank",
                    title = "Shaman: Emergency Grounding Totem",
                    desc = "Stops casting immediately and drops Grounding Totem to eat incoming boss spells.",
                    code = "#showtooltip Grounding Totem\n/stopcasting\n/cast Grounding Totem"
                }
            }
        },

        ["ENHANCEMENT_DPS"] = {
            specName = "Enhancement (Melee DPS)",
            role = "DPS",
            order = 2,
            statPriority = "Hit (to 9% Cap) > Slow 2H Weapon DPS > Crit (Flurry) > Strength > Attack Power",
            phaseGuidance = {
                [1] = {
                    name = "Phase 1: Levels 1â€“20",
                    summary = "Rockbiter consistency, Flame Shock DoTs, and Searing Totem single-target pressure.",
                    zones = {
                        { name = "Durotar / Mulgore / Barrens", range = "1â€“20", notes = "Crescent Staff (Wailing Caverns quest) at level 18." }
                    },
                    abilities = {
                        { level = 10, name = "Flame Shock & Searing Totem", desc = "Sustained fire damage over time." }
                    },
                    rules = {
                        "Use Rockbiter Weapon until level 30â€”it gives reliable flat DPS on every swing without RNG dry spells."
                    }
                },
                [2] = {
                    name = "Phase 2: Levels 20â€“40",
                    summary = "Windfury Weapon at level 30, Flurry (+30% attack speed on crit), and slow 2H axes/maces.",
                    zones = {
                        { name = "Hillsbrad / STV / SM", range = "20â€“40", notes = "Ravager or Corpsemaker (RFK) for massive Windfury crits." }
                    },
                    abilities = {
                        { level = 30, name = "Windfury Weapon", desc = "20% chance on hit to grant 2 extra attacks with bonus Attack Power!" },
                        { level = 35, name = "Flurry (Talent)", desc = "+30% attack speed for your next 3 swings after landing a critical strike." }
                    },
                    rules = {
                        "Always use a slow (3.40â€“3.80 speed) Two-Handed Axe or Mace with Windfury Weapon.",
                        "Beware Windfury threat spikes in dungeons: wait 3 seconds for the tank before swinging!"
                    }
                },
                [3] = {
                    name = "Phase 3: Levels 40â€“52",
                    summary = "Stormstrike at level 40, Totem Twisting (Windfury + Grace of Air), and Mail armor.",
                    zones = {
                        { name = "Tanaris / Hinterlands / Maraudon", range = "40â€“52", notes = "The Rockpounder (Zul'Farrak) or Gatorbite." }
                    },
                    abilities = {
                        { level = 40, name = "Stormstrike (Talent)", desc = "Instant extra melee swing that can trigger Windfury!" }
                    },
                    rules = {
                        "Master Totem Twisting for your melee group: drop Windfury Totem (buff lasts 10s on party weapons), immediately drop Grace of Air Totem for 8.5s, then re-drop Windfury!"
                    }
                },
                [4] = {
                    name = "Phase 4: Levels 52â€“60",
                    summary = "Nightfall Axe raid support, Hand of Justice + Windfury chains, and Elemental Devastation.",
                    zones = {
                        { name = "BRD / UBRS / AV", range = "52â€“60", notes = "The Unstoppable Force (AV Exalted), Hand of Justice, Blackhand's Breadth." }
                    },
                    abilities = {
                        { level = 60, name = "Windfury + Totem Twisting", desc = "Premier melee group multiplier." }
                    },
                    rules = {
                        "Use Earth Shock Rank 1 if you only need an interrupt without generating massive threat; use Flame Shock / Frost Shock for damage."
                    }
                }
            },
            macros = {
                {
                    category = "Burst / DPS",
                    title = "Enh: Stormstrike + StartAttack",
                    desc = "Initiates melee attack and fires Stormstrike immediately.",
                    code = "#showtooltip Stormstrike\n/startattack\n/cast Stormstrike"
                },
                {
                    category = "Burst / DPS",
                    title = "Enh: Rank 1 Earth Shock Interrupt",
                    desc = "Interrupts enemy spellcasting using low-mana, low-threat Rank 1 Earth Shock.",
                    code = "#showtooltip Earth Shock(Rank 1)\n/stopcasting\n/cast [@mouseover,harm,nodead][harm,nodead] Earth Shock(Rank 1)"
                }
            }
        },

        ["ELEMENTAL"] = {
            specName = "Elemental (Caster DPS)",
            role = "DPS",
            order = 3,
            statPriority = "Spell Hit (to 16% Cap) > Nature Spell Damage > Spell Crit > Intellect > MP5",
            phaseGuidance = {
                [1] = {
                    name = "Phase 1: Levels 1â€“20",
                    summary = "Lightning Bolt casts, Flame Shock, and Searing Totem.",
                    zones = {
                        { name = "Durotar / Barrens", range = "1â€“20", notes = "Leveling as Enhancement until 35-40 is faster; switch to Elemental at 39-40 when Lightning Mastery unlocks!" }
                    },
                    abilities = {
                        { level = 1, name = "Lightning Bolt", desc = "Primary Nature spell nuke." }
                    },
                    rules = {
                        "If leveling Elemental early, pull with 2 Lightning Bolts, drop Searing Totem, and finish with Flametongue melee swings."
                    }
                },
                [2] = {
                    name = "Phase 2: Levels 20â€“40",
                    summary = "Elemental Fury (+100% Crit Damage), Chain Lightning at 32, and Lightning Mastery (-1.0s cast time) at 39!",
                    zones = {
                        { name = "SM / Arathi / STV", range = "20â€“40", notes = "Hypnotic Blade + Shield from Scarlet Monastery." }
                    },
                    abilities = {
                        { level = 32, name = "Chain Lightning", desc = "1.5s cast (talented) arcing Nature nuke hitting 3 targets." },
                        { level = 39, name = "Lightning Mastery (Talent)", desc = "Reduces cast time of Lightning Bolt and Chain Lightning by a full 1.0 second!" }
                    },
                    rules = {
                        "Level 39â€“40 is the massive Elemental power spike: 2.0s Lightning Bolts and 1.5s Chain Lightnings melt enemies before they reach you.",
                        "Always wear a Shield for +1,500â€“2,000 bonus armor while casting."
                    }
                },
                [3] = {
                    name = "Phase 3: Levels 40â€“52",
                    summary = "Elemental Mastery (guaranteed free crit!), Clearcasting procs, and Nature's Guidance.",
                    zones = {
                        { name = "Tanaris / Hinterlands / Feralas", range = "40â€“52", notes = "Embrace of the Wind Serpent or Nature's Wrath gear." }
                    },
                    abilities = {
                        { level = 40, name = "Elemental Mastery (Talent)", desc = "Guarantees your next Lightning Bolt, Chain Lightning, or Shock is a 100% Critical Strike and costs 0 Mana!" }
                    },
                    rules = {
                        "Combo Elemental Mastery + Chain Lightning + Earth Shock in a single global cooldown window for devastating instant burst."
                    }
                },
                [4] = {
                    name = "Phase 4: Levels 52â€“60",
                    summary = "Endgame Nature spell crit cannon, Bloodvine Set, and Deep Earth / Coagulated Blood.",
                    zones = {
                        { name = "BRD / UBRS / Strat / Scholo", range = "52â€“60", notes = "Briarwood Reed, Skyshroud Leggings, Bloodvine Set." }
                    },
                    abilities = {
                        { level = 60, name = "Max Rank Lightning Bolt & Chain Lightning", desc = "Explosive multi-target and single-target Nature burst." }
                    },
                    rules = {
                        "Bring Major Mana Potions and Dark Runes; downrank Lightning Bolt (Rank 4) on long raid boss encounters when mana is tight."
                    }
                }
            },
            macros = {
                {
                    category = "Burst / DPS",
                    title = "Ele: Elemental Mastery + Chain Lightning",
                    desc = "Pops Elemental Mastery and fires a 0-mana 100% crit Chain Lightning.",
                    code = "#showtooltip Chain Lightning\n/cast Elemental Mastery\n/use 13\n/cast Chain Lightning"
                }
            }
        },

        ["RESTORATION"] = {
            specName = "Restoration (Healer)",
            role = "HEALER",
            order = 4,
            statPriority = "Healing Power > MP5 > Intellect > Spell Crit > Stamina",
            phaseGuidance = {
                [1] = {
                    name = "Phase 1: Levels 1â€“20",
                    summary = "Healing Wave ranks, Cure Poison/Disease, and Healing Stream Totem.",
                    zones = {
                        { name = "Durotar / Mulgore / Barrens", range = "1â€“20", notes = "Water Totem quest at level 20." }
                    },
                    abilities = {
                        { level = 1, name = "Healing Wave", desc = "Large single-target heal." },
                        { level = 20, name = "Lesser Healing Wave", desc = "Fast 1.5s emergency triage heal." }
                    },
                    rules = {
                        "Keep a dedicated Intellect/Spirit gear set in your bags to heal RFC and Wailing Caverns effortlessly."
                    }
                },
                [2] = {
                    name = "Phase 2: Levels 20â€“40",
                    summary = "Mana Spring Totem (lvl 26), Reincarnation (Ankh), and Nature's Swiftness at 30.",
                    zones = {
                        { name = "Hillsbrad / SM / RFK", range = "20â€“40", notes = "Scarlet Monastery Cathedral healing mace and shield." }
                    },
                    abilities = {
                        { level = 26, name = "Mana Spring Totem", desc = "Restores mana to your entire party every 2 seconds." },
                        { level = 30, name = "Reincarnation", desc = "Self-resurrect upon death using an Ankhâ€”ultimate wipe recovery!" }
                    },
                    rules = {
                        "Always carry 5+ Ankhs in your bags so you can self-resurrect after a wipe and resurrect the party.",
                        "Drop Poison Cleansing Totem in Wailing Caverns, RFK, and Maraudon to automatically strip party poisons."
                    }
                },
                [3] = {
                    name = "Phase 3: Levels 40â€“52",
                    summary = "Chain Heal unlocked at level 40! Mana Tide Totem at 40!",
                    zones = {
                        { name = "Tanaris / Hinterlands / Maraudon", range = "40â€“52", notes = "Zul'Farrak and Maraudon +Healing mail/leather." }
                    },
                    abilities = {
                        { level = 40, name = "Chain Heal", desc = "Iconic smart-bounce heal jumping across 3 friendly targets within 12.5yd!" },
                        { level = 40, name = "Mana Tide Totem (Talent)", desc = "Restores 1,160 Mana over 12 seconds to all 5 party members!" }
                    },
                    rules = {
                        "Bounce Chain Heal off the melee tank: it automatically jumps to injured melee DPS standing near the boss.",
                        "Rank 1 Chain Heal is one of the most mana-efficient raid healing spells in World of Warcraft."
                    }
                },
                [4] = {
                    name = "Phase 4: Levels 52â€“60",
                    summary = "Endgame Raid Healer MVP: Chain Heal Rank 1/3, Windfury Totem support, and Pre-Raid BIS.",
                    zones = {
                        { name = "BRD / Dire Maul / Strat / Scholo", range = "52â€“60", notes = "Robes of the Exalted, Wild Growth Spaulders, Hide of the Wild." }
                    },
                    abilities = {
                        { level = 60, name = "Chain Heal + Healing Way", desc = "Sustained group healing and +18% Healing Wave amplification on tanks." }
                    },
                    rules = {
                        "Stack 3 stacks of Healing Way (Rank 1 Healing Wave) on the Main Tank before pull so all subsequent Healing Waves heal for +18% more.",
                        "Keep Windfury Totem down for your melee group while spamming Chain Heal Rank 1."
                    }
                }
            },
            macros = {
                {
                    category = "Healing / Mouseover",
                    title = "Resto: Mouseover Chain Heal",
                    desc = "Casts Chain Heal on friendly mouseover frame or unit.",
                    code = "#showtooltip Chain Heal\n/cast [@mouseover,help,nodead][help,nodead][@player] Chain Heal"
                },
                {
                    category = "Healing / Mouseover",
                    title = "Resto: Panic NS + Healing Wave",
                    desc = "Stops casting, activates Nature's Swiftness, and fires an instant Max Rank Healing Wave.",
                    code = "#showtooltip Nature's Swiftness\n/stopcasting\n/cast Nature's Swiftness\n/cast [@mouseover,help,nodead][help,nodead][@player] Healing Wave"
                },
                {
                    category = "Healing / Mouseover",
                    title = "Resto: Mouseover Lesser Healing Wave",
                    desc = "Fast 1.5s emergency heal on friendly mouseover.",
                    code = "#showtooltip Lesser Healing Wave\n/cast [@mouseover,help,nodead][help,nodead][@player] Lesser Healing Wave"
                }
            }
        }
    }
}

FTG:RegisterClassModule("SHAMAN", ShamanModule)
