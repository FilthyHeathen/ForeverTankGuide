--[[
    ForeverTankGuide - Modules/Classes/Priest.lua
    Priest Multi-Spec Module: Holy / Discipline (Healer), Shadow (Caster DPS)
]]

local ADDON_NAME, FTG = ...

local PriestModule = {
    name = "Priest",
    token = "PRIEST",
    defaultSpec = "HOLY_DISC",
    specs = {
        ["HOLY_DISC"] = {
            specName = "Holy / Discipline (Healer)",
            role = "HEALER",
            order = 1,
            statPriority = "Healing Power > Spirit (Meditation / Spiritual Guidance) > MP5 > Intellect > Stamina",
            phaseGuidance = {
                [1] = {
                    name = "Phase 1: Levels 1–20",
                    summary = "Wand Specialization (5/5) + Spirit Tap (5/5) leveling, Power Word: Shield triage, and Renew.",
                    zones = {
                        { name = "Tirisfal / Elwynn / Dun Morogh / Barrens", range = "1–20", notes = "Buy Lesser Magic Wand at lvl 5 and Greater Magic Wand at lvl 13 (Enchanting)." }
                    },
                    abilities = {
                        { level = 6, name = "Power Word: Shield", desc = "Instant absorption shield. Prevents spell pushback and saves lives." },
                        { level = 8, name = "Renew", desc = "Instant Holy Heal-over-Time ticking every 3 seconds." },
                        { level = 16, name = "Lesser Heal / Heal", desc = "Slow, ultra-mana-efficient bread-and-butter single target heals." }
                    },
                    rules = {
                        "Do NOT bubble (Power Word: Shield) a Warrior or Bear Druid tank on pull unless it is an emergency—absorbed damage prevents them from generating Rage!",
                        "Master the 5-Second Rule (5SR): cast one big Heal + Renew, then wand for 8–10 seconds so your Spirit regenerates full mana in combat.",
                        "Use Fade immediately if healing aggro pulls loose dungeon mobs toward you."
                    }
                },
                [2] = {
                    name = "Phase 2: Levels 20–40",
                    summary = "Flash Heal emergency triage, Prayer of Healing group recovery, and Dispel Magic.",
                    zones = {
                        { name = "Hillsbrad / Scarlet Monastery / RFK", range = "20–40", notes = "Whitemane's Chapeau and Triune Amulet in Scarlet Monastery Cathedral." }
                    },
                    abilities = {
                        { level = 20, name = "Flash Heal", desc = "Fast 1.5s emergency heal. High mana cost—reserve for sudden damage spikes." },
                        { level = 20, name = "Inner Focus (Talent)", desc = "Makes your next spell cost 0 Mana and grants +25% Crit chance (pair with Prayer of Healing)!" },
                        { level = 30, name = "Prayer of Healing", desc = "Heals all 5 party members within 30yd simultaneously." }
                    },
                    rules = {
                        "Use Heal Rank 2 and Greater Heal Rank 1 as your main workhorse heals—Flash Heal will burn your mana bar if spammed.",
                        "Pair Inner Focus + Prayer of Healing to top off the entire 5-man party for zero mana.",
                        "Use Shackle Undead in Scarlet Monastery and Razorfen Downs to crowd-control dangerous undead casters."
                    }
                },
                [3] = {
                    name = "Phase 3: Levels 40–52",
                    summary = "Greater Heal mastery, Divine Spirit / Spiritual Guidance scaling, and Abolish Disease.",
                    zones = {
                        { name = "Tanaris / Hinterlands / Maraudon", range = "40–52", notes = "Zul'Farrak and Maraudon high-Spirit and +Healing cloth." }
                    },
                    abilities = {
                        { level = 40, name = "Greater Heal", desc = "Massive 2.5s (talented) single-target heal." },
                        { level = 40, name = "Power Infusion / Spiritual Guidance", desc = "Either +20% spell damage/healing cooldown (Disc) or +25% of Spirit converted into +Healing (Holy)." }
                    },
                    rules = {
                        "Stopcasting discipline: start casting Greater Heal Rank 1 on the tank proactively; if no damage lands, press Escape or move slightly at 80% cast to spend 0 mana.",
                        "Proactively cast Fear Ward (if Dwarf) on your tank before any boss with fear mechanics."
                    }
                },
                [4] = {
                    name = "Phase 4: Levels 52–60",
                    summary = "Endgame downranking (Heal Rank 2/4, Greater Heal Rank 1, Flash Heal Rank 1/4) and Pre-Raid BIS.",
                    zones = {
                        { name = "BRD / Dire Maul / Strat / Scholo", range = "52–60", notes = "Truefaith Vestments (Tailoring), Robes of the Exalted (Strat), Padre's Trousers." }
                    },
                    abilities = {
                        { level = 60, name = "Prayer of Fortitude & Prayer of Spirit", desc = "Raid-wide stamina and spirit buffs." }
                    },
                    rules = {
                        "With +400 Healing Power, Heal Rank 2 becomes your infinite-mana filler spell.",
                        "Craft Truefaith Vestments (300 Tailoring)—it is better than Tier 1 and Tier 2 chest pieces!",
                        "Keep Mind Control ready in Blackrock Spire and Stratholme to turn powerful humanoids into party allies."
                    }
                }
            },
            macros = {
                {
                    category = "Healing / Mouseover",
                    title = "Priest: Mouseover Heal / Greater Heal",
                    desc = "Casts Heal on friendly mouseover frame or unit, falling back to target or player.",
                    code = "#showtooltip Heal\n/cast [@mouseover,help,nodead][help,nodead][@player] Heal"
                },
                {
                    category = "Healing / Mouseover",
                    title = "Priest: Mouseover Flash Heal",
                    desc = "Fast 1.5s emergency heal on friendly mouseover.",
                    code = "#showtooltip Flash Heal\n/cast [@mouseover,help,nodead][help,nodead][@player] Flash Heal"
                },
                {
                    category = "Healing / Mouseover",
                    title = "Priest: Mouseover Power Word: Shield",
                    desc = "Instantly shields friendly mouseover target without dropping current selection.",
                    code = "#showtooltip Power Word: Shield\n/cast [@mouseover,help,nodead][help,nodead][@player] Power Word: Shield"
                },
                {
                    category = "Healing / Mouseover",
                    title = "Priest: Inner Focus + Prayer of Healing",
                    desc = "Activates Inner Focus for 0 mana cost and casts Prayer of Healing on your party.",
                    code = "#showtooltip Prayer of Healing\n/cast Inner Focus\n/cast Prayer of Healing"
                }
            }
        },

        ["SHADOW"] = {
            specName = "Shadow (Caster DPS)",
            role = "DPS",
            order = 2,
            statPriority = "Spell Hit (16% Cap / 6% w/ Shadow Focus) > Shadow Damage > Intellect > MP5 > Spirit",
            phaseGuidance = {
                [1] = {
                    name = "Phase 1: Levels 1–20",
                    summary = "Spirit Tap (5/5) + Wand Specialization (5/5) for zero-downtime leveling.",
                    zones = {
                        { name = "Tirisfal / Elwynn / Silverpine / Westfall", range = "1–20", notes = "Get Greater Magic Wand at level 13—it out-DPSes all spells until level 24!" }
                    },
                    abilities = {
                        { level = 4, name = "Shadow Word: Pain", desc = "High total damage Shadow DoT over 18–24 seconds." },
                        { level = 10, name = "Mind Blast", desc = "1.5s high-burst Shadow nuke (generates high threat in dungeons—use carefully)." },
                        { level = 20, name = "Mind Flay (Talent)", desc = "3-second channeled Shadow beam that slows enemy movement speed by 50%." }
                    },
                    rules = {
                        "Solo Pull Rotation: Power Word: Shield -> Mind Blast -> Shadow Word: Pain -> Wand to death -> Spirit Tap triggers for 100% mana & HP recovery.",
                        "Max out Shadow Focus (5/5) early: it grants +10% Spell Hit with all Shadow spells!"
                    }
                },
                [2] = {
                    name = "Phase 2: Levels 20–40",
                    summary = "Shadow Weaving (+15% Shadow Damage debuff), Vampiric Embrace group healing, and Shadowform at 40!",
                    zones = {
                        { name = "Hillsbrad / Arathi / STV / SM", range = "20–40", notes = "Hypnotic Blade + Orb of Lorica in Scarlet Monastery." }
                    },
                    abilities = {
                        { level = 30, name = "Vampiric Embrace (Talent)", desc = "Heals all party members for 20% of all Shadow spell damage you deal!" },
                        { level = 30, name = "Silence (Talent)", desc = "Instant 5-second ranged caster silence on a 45s cooldown." },
                        { level = 40, name = "Shadowform (Talent)", desc = "Increases all Shadow damage dealt by 15% and reduces physical damage taken by 15%!" }
                    },
                    rules = {
                        "Once you unlock Shadowform at level 40, respec out of Wand Specialization and put all 31 points straight into Shadow.",
                        "Mind Blast has an innate 2x threat modifier—wait for your tank to establish threat before casting Mind Blast in dungeons."
                    }
                },
                [3] = {
                    name = "Phase 3: Levels 40–52",
                    summary = "Shadowform power spike, Shadow Weaving 5-stack management, and PvP/Dungeon dominance.",
                    zones = {
                        { name = "Tanaris / Hinterlands / Felwood", range = "40–52", notes = "Shadoweave Tailoring set (Boots, Pants, Robe, Shoulders, Mask)." }
                    },
                    abilities = {
                        { level = 40, name = "Shadow Weaving (5 Stacks)", desc = "Increases Shadow damage taken by the target by 15% (boosts Warlocks too!)." }
                    },
                    rules = {
                        "Stack pure +Shadow Spell Damage gear (Shadoweave Set): Mind Flay and SW:P cannot crit, so raw Shadow Power is king.",
                        "Rank 1 Mind Flay can be tapped quickly to stack Shadow Weaving to 5 for minimal mana."
                    }
                },
                [4] = {
                    name = "Phase 4: Levels 52–60",
                    summary = "Endgame Shadow Weaving raid amplifier, Anathema Staff, and Felcloth/Bloodvine sets.",
                    zones = {
                        { name = "BRD / Scholo / Strat / Dire Maul", range = "52–60", notes = "Felcloth items, Briarwood Reed, Eye of the Beast." }
                    },
                    abilities = {
                        { level = 60, name = "Max Rank SW:Pain & Mind Flay", desc = "Sustained Shadow DPS and Warlock raid buffing." }
                    },
                    rules = {
                        "With 5/5 Shadow Focus (+10% Hit), you only need 6% Spell Hit from gear to reach the 16% raid boss hit cap!",
                        "Bring Major Mana Potions and Dark Runes—Shadow Priests are mana-hungry on long raid encounters."
                    }
                }
            },
            macros = {
                {
                    category = "Burst / DPS",
                    title = "Shadow: No-Channel-Clip Mind Flay",
                    desc = "Casts Mind Flay without clipping an already active Mind Flay channel.",
                    code = "#showtooltip Mind Flay\n/cast [nochanneling:Mind Flay] Mind Flay"
                },
                {
                    category = "Burst / DPS",
                    title = "Shadow: Mouseover Silence",
                    desc = "Instantly silences mouseover enemy caster or current target.",
                    code = "#showtooltip Silence\n/stopcasting\n/cast [@mouseover,harm,nodead][harm,nodead] Silence"
                },
                {
                    category = "Burst / DPS",
                    title = "Shadow: Mouseover Shadow Word: Pain",
                    desc = "Applies Shadow Word: Pain on mouseover target for multi-DoT spreading.",
                    code = "#showtooltip Shadow Word: Pain\n/cast [@mouseover,harm,nodead][harm,nodead] Shadow Word: Pain"
                }
            }
        }
    }
}

FTG:RegisterClassModule("PRIEST", PriestModule)
