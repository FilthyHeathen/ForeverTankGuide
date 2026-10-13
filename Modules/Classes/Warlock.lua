--[[
    Heathen's Forever Guide - Modules/Classes/Warlock.lua
    Warlock Multi-Spec Module: Metamorphosis (Tank), Affliction (Drain Tank / DoT DPS), Destruction (Shadowbolt Crit DPS)
]]

local ADDON_NAME, FTG = ...

local WarlockModule = {
    name = "Warlock",
    token = "WARLOCK",
    defaultSpec = "METAMORPHOSIS",
    specs = {
        ["METAMORPHOSIS"] = {
            specName = "Metamorphosis (Tank)",
            role = "TANK",
            order = 1,
            statPriority = "Stamina > Armor > Spell Hit (to 16% Cap) > Spell Power (Shadow/Fire) > Defense",
            phaseGuidance = {
                [1] = {
                    name = "Phase 1: Levels 1–20",
                    summary = "Voidwalker sacrifice shields, Corruption DoT spread, and early Searing Pain threat.",
                    zones = {
                        { name = "Tirisfal / Silverpine / Elwynn / Barrens", range = "1–20", notes = "Voidwalker questline at level 10; Succubus at 20." }
                    },
                    abilities = {
                        { level = 10, name = "Voidwalker (Torment)", desc = "Demon pet provides initial distraction and emergency sacrifice shield." },
                        { level = 18, name = "Searing Pain", desc = "Primary high-threat single-target fire spell with double base threat multiplier." },
                        { level = 14, name = "Drain Life", desc = "Continuous shadow channel providing reliable health sustain while tanking." }
                    },
                    rules = {
                        "Searing Pain is your core single-target threat generator: spam it consistently on your primary target.",
                        "Apply Corruption and Curse of Agony to secondary targets to maintain a baseline threat lead over healers.",
                        "Use Life Tap between pulls rather than during combat to prevent spiking your own health downward."
                    }
                },
                [2] = {
                    name = "Phase 2: Levels 20–40",
                    summary = "Metamorphosis demon form activation (+500% armor, instant cast abilities), Shadow Cleave, and Hellfire AoE.",
                    zones = {
                        { name = "Hillsbrad / Arathi / Thousand Needles", range = "20–40", notes = "Felhunter questline at level 30." }
                    },
                    abilities = {
                        { level = 20, name = "Demon Armor", desc = "Increases armor by hundreds and boosts shadow resistance and passive health regeneration." },
                        { level = 30, name = "Hellfire", desc = "Channeled fire AoE pulse around the warlock. Extreme group snap threat." },
                        { level = 40, name = "Soul Link (Talent)", desc = "Transfers 30% of all damage taken directly to your active demon pet." }
                    },
                    rules = {
                        "While in demon form, use Shadow Cleave on multi-target packs to maintain solid AoE threat.",
                        "Pair Hellfire pulses with defensive potions or Healer pre-HoTs to sustain through self-damage.",
                        "Keep Soul Link active at all times with an Imp or Voidwalker positioned safely."
                    }
                },
                [3] = {
                    name = "Phase 3: Levels 40–52",
                    summary = "Shadow Ward mitigation against magic bosses, Death Coil emergency peel, and Maraudon Mark of the Chosen.",
                    zones = {
                        { name = "Tanaris / Felwood / ZF", range = "40–52", notes = "Stamina and spell damage cloth gear acquisition." }
                    },
                    abilities = {
                        { level = 42, name = "Death Coil", desc = "Instant shadow bolt healing you for 100% of damage dealt and causing 3 sec horror effect." },
                        { level = 32, name = "Shadow Ward", desc = "Absorbs substantial shadow damage; vital against dungeon necromancers and warlocks." }
                    },
                    rules = {
                        "Death Coil is an outstanding emergency ranged taunt peel when a mob runs toward a healer.",
                        "Stack high Stamina and Spell Damage: your threat scales directly with spell power, while stamina keeps you alive.",
                        "Maintain Healthstones crafted for yourself and distributed to party members before every dungeon run."
                    }
                },
                [4] = {
                    name = "Phase 4: Levels 52–60",
                    summary = "Endgame cloth tanking with Dreadmist / Felcloth, high fire/shadow resistance, and Stratholme / Scholo tanking.",
                    zones = {
                        { name = "EPL / Strat / Scholo / BRD", range = "52–60", notes = "Pre-raid spell hit, stamina, and defense cloth gear." }
                    },
                    abilities = {
                        { level = 60, name = "Max Rank Searing Pain & Shadow Cleave", desc = "Peak spell threat output." }
                    },
                    rules = {
                        "Use Curse of Elements on bosses to boost your fire spell threat along with group mages.",
                        "Pre-shield yourself with Voidwalker Sacrifice before pulling dangerous burst trash packs.",
                        "Communicate with your healer when casting Life Tap so they can prepare efficient heal-over-time spells."
                    }
                }
            },
            macros = {
                {
                    category = "Defensive / Tank",
                    title = "Lock Tank: Mouseover Searing Pain",
                    desc = "Casts Searing Pain on mouseover enemy or current target for instant ranged snap threat.",
                    code = "#showtooltip Searing Pain\n/cast [@mouseover,harm,nodead][harm,nodead] Searing Pain"
                },
                {
                    category = "Defensive / Tank",
                    title = "Lock Tank: Emergency Death Coil Peel",
                    desc = "Instant peel and self-heal casting Death Coil on hostile mouseover or target.",
                    code = "#showtooltip Death Coil\n/stopcasting\n/cast [@mouseover,harm,nodead][harm,nodead] Death Coil"
                }
            }
        },

        ["AFFLICTION"] = {
            specName = "Affliction (Drain Tank / DoT DPS)",
            role = "DPS",
            order = 2,
            statPriority = "Shadow Spell Damage > Spell Hit (to 16% Cap) > Stamina > Intellect",
            phaseGuidance = {
                [1] = {
                    name = "Phase 1: Levels 1–20",
                    summary = "Improved Corruption (5/5 instant cast), Curse of Agony, and Imp/Voidwalker multi-dotting.",
                    zones = {
                        { name = "Tirisfal / Elwynn / Barrens", range = "1–20", notes = "Make Corruption instant cast (5/5) immediately at levels 10–14!" }
                    },
                    abilities = {
                        { level = 4, name = "Corruption", desc = "Core Shadow DoT. Becomes 100% instant cast with 5/5 Improved Corruption." },
                        { level = 8, name = "Curse of Agony & Fear", desc = "Ramping 24s Shadow DoT and 1-target fear control." }
                    },
                    rules = {
                        "Multi-dot 2–3 mobs simultaneously with Corruption + Curse of Agony, Fear one, and wand the other."
                    }
                },
                [2] = {
                    name = "Phase 2: Levels 20–40",
                    summary = "Drain Tanking breakthrough: Fel Concentration (5/5) + Succubus + Nightfall instant Shadow Bolts!",
                    zones = {
                        { name = "Hillsbrad / STV / Arathi / SM", range = "20–40", notes = "Shadoweave Tailoring gear starts at level 37!" }
                    },
                    abilities = {
                        { level = 25, name = "Fel Concentration (Talent)", desc = "Gives you a 70% chance to avoid interruption caused by damage while channeling Drain Life!" },
                        { level = 30, name = "Siphon Life (Talent)", desc = "Instant 30s DoT that transfers health from every afflicted enemy directly to you." },
                        { level = 35, name = "Nightfall (Talent)", desc = "Corruption and Drain Life ticks have a 4% chance to make your next Shadow Bolt 100% instant cast!" }
                    },
                    rules = {
                        "Stop using Voidwalker at level 30+ for soloing: use Succubus (or Imp in Dark Pact) and TANK MOBS YOURSELF using Siphon Life + Corruption + Agony + Drain Life!",
                        "You have zero downtime: Drain Life heals you while Life Tap refills your mana."
                    }
                },
                [3] = {
                    name = "Phase 3: Levels 40–52",
                    summary = "Dark Pact infinite mana battery (draining passive Imp mana), Shadow Mastery (+10% Shadow Damage).",
                    zones = {
                        { name = "Tanaris / Hinterlands / Felwood", range = "40–52", notes = "Full Shadoweave Set crafts." }
                    },
                    abilities = {
                        { level = 40, name = "Dark Pact (Talent)", desc = "Drains 150–200 mana from your passive Imp (in Phase Shift) with zero health loss to you!" }
                    },
                    rules = {
                        "Keep your Imp in Phase Shift and press Dark Pact between pulls—your Imp regenerates mana 5x faster than you!"
                    }
                },
                [4] = {
                    name = "Phase 4: Levels 52–60",
                    summary = "SM/Ruin Raid Spec (30 Affliction / 21 Destruction): Nightfall procs + +100% Crit Damage Shadow Bolts!",
                    zones = {
                        { name = "BRD / Strat / Scholo / Dire Maul", range = "52–60", notes = "Felcloth gear and Bloodvine Set." }
                    },
                    abilities = {
                        { level = 60, name = "SM/Ruin Hybrid", desc = "Combines Shadow Mastery (+10% Shadow Damage) with Ruin (+100% Crit Damage bonus)." }
                    },
                    rules = {
                        "Maintain your assigned raid Curse (Curse of Elements, Curse of Shadow, or Curse of Recklessness) on every boss before casting Shadow Bolt.",
                        "Farm Soul Shards before raid/dungeon start so you are ready for Summons, Healthstones, and Soulstones."
                    }
                }
            },
            macros = {
                {
                    category = "Burst / DPS",
                    title = "Affliction: No-Clip Drain Life",
                    desc = "Channels Drain Life without clipping an existing Drain Life channel.",
                    code = "#showtooltip Drain Life\n/cast [nochanneling:Drain Life] Drain Life"
                },
                {
                    category = "Burst / DPS",
                    title = "Affliction: Mouseover Corruption",
                    desc = "Instantly applies Corruption to mouseover enemy for rapid multi-DoT spreading.",
                    code = "#showtooltip Corruption\n/cast [@mouseover,harm,nodead][harm,nodead] Corruption"
                },
                {
                    category = "Healing / Mouseover",
                    title = "Warlock: Mouseover Soulstone",
                    desc = "Applies Soulstone Resurrection to friendly healer/tank.",
                    code = "#showtooltip Major Soulstone\n/use Major Soulstone\n/cast [@mouseover,help][help] Major Soulstone"
                }
            }
        },

        ["DESTRUCTION"] = {
            specName = "Destruction (Shadowbolt / Ruin Burst)",
            role = "DPS",
            order = 3,
            statPriority = "Spell Hit (to 16% Cap!) > Spell Crit (Improved Shadow Bolt) > Shadow/Fire Spell Damage > Intellect",
            phaseGuidance = {
                [1] = {
                    name = "Phase 1: Levels 1–20",
                    summary = "Improved Shadow Bolt (5/5) and Bane (-0.5s Shadow Bolt / Immolate cast time).",
                    zones = {
                        { name = "Tirisfal / Elwynn / Barrens", range = "1–20", notes = "Bane (5/5) reduces Shadow Bolt cast time to 2.5 seconds." }
                    },
                    abilities = {
                        { level = 1, name = "Shadow Bolt & Immolate", desc = "Primary Shadow nuke and Fire DoT." },
                        { level = 16, name = "Shadowburn (Talent)", desc = "Instant Shadow blast costing 1 Soul Shard (refunded if target dies within 5s)!" }
                    },
                    rules = {
                        "Use Shadowburn as a lethal instant finisher on low-health dungeon mobs—as long as the mob dies within 5 seconds, your Soul Shard is refunded!"
                    }
                },
                [2] = {
                    name = "Phase 2: Levels 20–40",
                    summary = "Devastation (+5% Crit) and Ruin (+100% Crit Damage Bonus) at level 30!",
                    zones = {
                        { name = "Hillsbrad / STV / SM", range = "20–40", notes = "Ruin makes your crits deal 200% damage instead of 150%." }
                    },
                    abilities = {
                        { level = 30, name = "Ruin (Talent)", desc = "Increases the critical strike damage bonus of your Destruction spells by 100%!" }
                    },
                    rules = {
                        "Pair Curse of Agony + Immolate + Shadow Bolt -> finish with Shadowburn."
                    }
                },
                [3] = {
                    name = "Phase 3: Levels 40–52",
                    summary = "Conflagrate instant Fire burst at 40, Soul Fire 6s nuke, and Hellfire/Rain of Fire AoE.",
                    zones = {
                        { name = "Tanaris / Hinterlands / Searing Gorge", range = "40–52", notes = "Spell Crit and Shadow/Fire gear." }
                    },
                    abilities = {
                        { level = 40, name = "Conflagrate (Talent)", desc = "Consumes an Immolate effect on the target to deal instant heavy Fire burst!" }
                    },
                    rules = {
                        "Wait until the final 2 seconds of Immolate before casting Conflagrate so you get both full DoT ticks and the instant explosion."
                    }
                },
                [4] = {
                    name = "Phase 4: Levels 52–60",
                    summary = "DS/Ruin Raid Spec (Demonic Sacrifice Succubus for +15% Shadow Damage + Ruin)!",
                    zones = {
                        { name = "BRD / Strat / Scholo / Dire Maul", range = "52–60", notes = "Bloodvine Set (+4% Spell Hit, +2% Spell Crit) is essential because Destruction has 0% Hit in talents!" }
                    },
                    abilities = {
                        { level = 60, name = "Demonic Sacrifice + Ruin", desc = "Sacrifice your Succubus for a 30-minute +15% Shadow Damage buff and spam 2.5s Shadow Bolts!" }
                    },
                    rules = {
                        "Prioritize Spell Hit (Bloodvine Set, Ban'thok Sash, Star of Mystaria) above all else—Warlocks have no talent hit for Shadow Bolt!",
                        "Watch your threat closely when landing back-to-back 3,000+ Shadow Bolt crits—Warlocks have no threat drop."
                    }
                }
            },
            macros = {
                {
                    category = "Burst / DPS",
                    title = "Destro: Mouseover Shadowburn Execute",
                    desc = "Fires instant Shadowburn on dying mouseover or target to snipe kills and refund Soul Shard.",
                    code = "#showtooltip Shadowburn\n/stopcasting\n/cast [@mouseover,harm,nodead][harm,nodead] Shadowburn"
                }
            }
        }
    }
}

FTG:RegisterClassModule("WARLOCK", WarlockModule)
