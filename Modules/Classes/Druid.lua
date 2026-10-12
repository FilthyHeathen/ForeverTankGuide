--[[
    ForeverTankGuide - Modules/Classes/Druid.lua
    Druid Multi-Spec Module: Feral Bear (Tank), Feral Cat (Melee DPS), Restoration (Healer), Balance (Caster DPS)
]]

local ADDON_NAME, FTG = ...

local DruidModule = {
    name = "Druid",
    token = "DRUID",
    defaultSpec = "FERAL_BEAR",
    specs = {
        ["FERAL_BEAR"] = {
            specName = "Feral Bear (Tank)",
            role = "TANK",
            order = 1,
            statPriority = "Armor (Bonus Armor Items) > Stamina > Agility (Dodge/Crit) > Hit (9%) > Strength",
            phaseGuidance = {
                [1] = {
                    name = "Phase 1: Levels 1–20",
                    summary = "Unlock Bear Form at level 10 through Moonglade quest, then Growl and Maul mechanics.",
                    zones = {
                        { name = "Mulgore / Darkshore / Barrens", range = "10–20", notes = "Bear Form class questline and Moonglade teleports." }
                    },
                    abilities = {
                        { level = 10, name = "Bear Form & Growl", desc = "Base bear form providing +180% armor, increased stamina, and 8yd Growl taunt." },
                        { level = 10, name = "Maul", desc = "Converts next melee swing into high-threat physical strike." },
                        { level = 16, name = "Swipe", desc = "AoE physical swipe hitting up to 3 front targets." }
                    },
                    rules = {
                        "Shift into Bear Form before starting combat to guarantee starting rage from Furor talents.",
                        "Enrage before pulling: generates 20 instant rage at the cost of temporary armor reduction.",
                        "Maul replaces regular attacks and does not generate rage; watch rage pool so you don't starve Swipe."
                    }
                },
                [2] = {
                    name = "Phase 2: Levels 20–40",
                    summary = "Dire Bear Form at level 40 (+360% armor), Faerie Fire (Feral), and Challenging Roar.",
                    zones = {
                        { name = "Ashenvale / Hillsbrad / STV", range = "20–40", notes = "Leveling Feral talents down to Heart of the Wild." }
                    },
                    abilities = {
                        { level = 28, name = "Challenging Roar", desc = "10-minute AoE taunt forcing nearby foes to attack you for 6 sec." },
                        { level = 30, name = "Faerie Fire (Feral)", desc = "Ranged 30yd armor reduction and high initial ranged pull threat with zero rage cost." },
                        { level = 40, name = "Dire Bear Form", desc = "Huge survival milestone: armor value multiplied by 460% and stamina increased by 25%." }
                    },
                    rules = {
                        "Always initiate ranged pulls with Faerie Fire (Feral)—it costs no mana/rage and provides immediate snapshot threat.",
                        "Bash is your primary caster interrupt and 4 sec stun; use it to stop lethal heals or shadow bolts.",
                        "Stack high armor leather: items with bonus armor scale massively under Dire Bear Form's multiplier."
                    }
                },
                [3] = {
                    name = "Phase 3: Levels 40–52",
                    summary = "Feral Instinct threat amplification, Heart of the Wild stamina boosts, and Maraudon Mark of the Chosen.",
                    zones = {
                        { name = "Feralas / Tanaris / Maraudon", range = "40–52", notes = "Centaur questline for Mark of the Chosen trinket." }
                    },
                    abilities = {
                        { level = 40, name = "Leader of the Pack (Talent)", desc = "+3% crit aura for all melee and physical party members." },
                        { level = 40, name = "Frenzied Regeneration", desc = "Converts rage into substantial self-healing." }
                    },
                    rules = {
                        "Use Frenzied Regeneration when incoming healer is stunned or running low on mana.",
                        "Tab-target Maul + Swipe: rotate targets constantly to keep threat ahead of high AoE DPS classes.",
                        "Never let enemies get behind you—Druids cannot parry or block, relying heavily on Dodge and Armor."
                    }
                },
                [4] = {
                    name = "Phase 4: Levels 52–60",
                    summary = "Armor cap pursuit (75% physical damage reduction = ~17,265 Armor) and pre-raid tank gear.",
                    zones = {
                        { name = "Winterspring / Un'Goro / Stratholme / Scholo", range = "52–60", notes = "Warden Staff, Smoking Heart of the Mountain, and Devilsaur/Shadowcraft." }
                    },
                    abilities = {
                        { level = 60, name = "Max Rank Dire Bear & Maul", desc = "Extreme damage soak ceiling." }
                    },
                    rules = {
                        "Acquire Warden Staff (+260 Armor, +10 Defense) or Unyielding Maul for massive armor amplification.",
                        "Craft or purchase Smoking Heart of the Mountain (Enchanting trinket with +150 Armor & +7 all resists).",
                        "Use Manual Crowd Pummeler (Gnomeregan) on raid bosses for +50% attack speed and unmatched single-target threat!"
                    }
                }
            },
            macros = {
                {
                    category = "Defensive / Tank",
                    title = "Bear: Growl / Mouseover Taunt",
                    desc = "Shifts into Dire Bear Form if not already shifted, and casts Growl on mouseover or target.",
                    code = "#showtooltip Growl\n/cast [noform:1] Dire Bear Form\n/cast [@mouseover,harm,nodead][harm,nodead] Growl"
                },
                {
                    category = "Defensive / Tank",
                    title = "Bear: Ranged Pull Faerie Fire",
                    desc = "Casts Faerie Fire (Feral) on mouseover or current enemy target without leaving Bear Form.",
                    code = "#showtooltip Faerie Fire (Feral)\n/cast [@mouseover,harm,nodead][harm,nodead] Faerie Fire (Feral)"
                },
                {
                    category = "Defensive / Tank",
                    title = "Bear: Emergency Frenzied Regen",
                    desc = "Activates Enrage for instant rage and immediately channels Frenzied Regeneration.",
                    code = "#showtooltip Frenzied Regeneration\n/cast Enrage\n/cast Frenzied Regeneration"
                }
            }
        },

        ["FERAL_CAT"] = {
            specName = "Feral Cat (Melee DPS)",
            role = "DPS",
            order = 2,
            statPriority = "Hit (to 9% Cap) > Strength (2.4 AP) > Agility (1 AP + Crit) > Crit > Intellect (Powershifting)",
            phaseGuidance = {
                [1] = {
                    name = "Phase 1: Levels 1–20",
                    summary = "Bear Form until level 20, then Cat Form unlock and Feral Swiftness (+30% outdoor speed).",
                    zones = {
                        { name = "Mulgore / Darkshore / Barrens", range = "1–20", notes = "Unlock Cat Form at level 20 trainer." }
                    },
                    abilities = {
                        { level = 20, name = "Cat Form & Claw", desc = "1.0s fast attack speed melee form using Energy and Combo Points." }
                    },
                    rules = {
                        "Invest 2/2 Feral Swiftness at levels 20-21 for +30% outdoor movement speed in Cat Form.",
                        "Zero downtime leveling: kill mobs in Cat Form, shift out to cast Regrowth/Rejuvenation, and shift right back into Cat."
                    }
                },
                [2] = {
                    name = "Phase 2: Levels 20–40",
                    summary = "Ravage / Pounce stealth openers, Shred backstabbing, and Ferocious Bite at level 32.",
                    zones = {
                        { name = "Hillsbrad / STV / Desolace", range = "20–40", notes = "Manual Crowd Pummeler in Gnomeregan." }
                    },
                    abilities = {
                        { level = 22, name = "Shred", desc = "High-damage positional attack requiring you to stand behind the target." },
                        { level = 32, name = "Ferocious Bite", desc = "5-combo-point finisher converting extra energy into bonus damage." }
                    },
                    rules = {
                        "In dungeons, always stand behind the tank's target and spam Shred rather than Claw.",
                        "Keep Faerie Fire (Feral) applied to every target to reduce armor by 505."
                    }
                },
                [3] = {
                    name = "Phase 3: Levels 40–52",
                    summary = "Wolfshead Helm (Level 40 Leatherworking!) + Furor (5/5) Powershifting rotation.",
                    zones = {
                        { name = "Tanaris / Feralas / Hinterlands", range = "40–52", notes = "Acquire Wolfshead Helm immediately at level 40—it is your Best-in-Slot helm through level 60!" }
                    },
                    abilities = {
                        { level = 40, name = "Powershifting (Furor + Wolfshead)", desc = "Shifting out and immediately back into Cat Form grants 60 instant Energy (40 Furor + 20 Wolfshead)!" }
                    },
                    rules = {
                        "Master Powershifting: when Energy drops below 20 right after an energy tick, shift into Cat Form to instantly reset to 60–80 Energy.",
                        "Note that weapon damage on staves/maces does NOT affect Cat DPS—only raw stats (Str, Agi, Hit, AP) and attack speed buffs matter!"
                    }
                },
                [4] = {
                    name = "Phase 4: Levels 52–60",
                    summary = "Endgame Powershifting with Devilsaur Set, Wolfshead Helm, and Manual Crowd Pummeler.",
                    zones = {
                        { name = "Un'Goro / BRD / UBRS", range = "52–60", notes = "Devilsaur Gauntlets/Leggings, Blackhand's Breadth, Truestrike Shoulders." }
                    },
                    abilities = {
                        { level = 60, name = "Shred + Ferocious Bite Powershift", desc = "Top-tier single target physical DPS with +3% crit aura for melee group." }
                    },
                    rules = {
                        "Bring Major Mana Potions and Demonic Runes to sustain continuous Powershifting across boss fights.",
                        "Save Battle Rez (Rebirth) and Innervate for your primary raid healers."
                    }
                }
            },
            macros = {
                {
                    category = "Burst / DPS",
                    title = "Cat: Instant Powershift",
                    desc = "Shifts out and immediately back into Cat Form in a single GCD to generate 60 instant Energy.",
                    code = "#showtooltip Cat Form\n/cancelform\n/cast Cat Form"
                },
                {
                    category = "Burst / DPS",
                    title = "Cat: Prowl + Ravage / Shred",
                    desc = "Uses Ravage if stealthed, or Shred if in combat.",
                    code = "#showtooltip Shred\n/cast [stealth] Ravage; Shred\n/startattack"
                }
            }
        },

        ["RESTORATION"] = {
            specName = "Restoration (Healer)",
            role = "HEALER",
            order = 3,
            statPriority = "Healing Power > MP5 / Spirit > Intellect > Stamina > Spell Crit",
            phaseGuidance = {
                [1] = {
                    name = "Phase 1: Levels 1–20",
                    summary = "Healing Touch ranks, Rejuvenation HoT rolling, and Mark of the Wild buffs.",
                    zones = {
                        { name = "Mulgore / Darkshore / Barrens", range = "1–20", notes = "Heal Wailing Caverns and Deadmines with intellect gear set." }
                    },
                    abilities = {
                        { level = 1, name = "Healing Touch", desc = "Highest throughput single-target heal in the game across multiple ranks." },
                        { level = 4, name = "Rejuvenation", desc = "Instant Heal-over-Time ticking every 3 seconds for 12 seconds." }
                    },
                    rules = {
                        "Keep a dedicated Intellect/Spirit gear set in your bags so you can heal any dungeon while leveling as Feral.",
                        "Let Rejuvenation tick fully before recasting to maximize the 5-second Spirit mana regeneration rule."
                    }
                },
                [2] = {
                    name = "Phase 2: Levels 20–40",
                    summary = "Rebirth (Combat Rez) at level 20, Regrowth crits, and Nature's Swiftness at 30.",
                    zones = {
                        { name = "Hillsbrad / SM / RFK", range = "20–40", notes = "Scarlet Monastery Library/Cathedral caster drops." }
                    },
                    abilities = {
                        { level = 20, name = "Rebirth", desc = "In-combat resurrection on a 30-minute cooldown. Always carry Maple/Stranglethorn Seeds!" },
                        { level = 30, name = "Nature's Swiftness (Talent)", desc = "Makes your next Nature spell (Max Rank Healing Touch or Rebirth) 100% instant cast!" }
                    },
                    rules = {
                        "Bind Nature's Swiftness + Max Rank Healing Touch to a panic key: it instantly heals a dying tank for 1,500–2,500 HP.",
                        "Use Abolish Poison and Remove Curse proactively on melee and tanks."
                    }
                },
                [3] = {
                    name = "Phase 3: Levels 40–52",
                    summary = "Innervate at level 40 (+400% Spirit mana regen), Tranquility party recovery, and Downranking.",
                    zones = {
                        { name = "Tanaris / Hinterlands / Maraudon", range = "40–52", notes = "Zul'Farrak and Maraudon +Healing leather/cloth." }
                    },
                    abilities = {
                        { level = 40, name = "Innervate (Talent)", desc = "Increases target's Spirit-based mana regeneration by 400% and allows 100% regen while casting for 20 sec." }
                    },
                    rules = {
                        "Cast Innervate on yourself (or your Priest) when at 30% mana while equipping a high-Spirit weapon for a full mana bar refill.",
                        "Downrank Healing Touch (Rank 3 and Rank 4): Rank 4 has a 3.0s cast (2.5s talented) and extraordinary mana efficiency."
                    }
                },
                [4] = {
                    name = "Phase 4: Levels 52–60",
                    summary = "Swiftmend instant HoT consumption, Healing Touch Rank 4 spam, and Pre-Raid BIS +Healing.",
                    zones = {
                        { name = "BRD / Dire Maul / Strat / Scholo", range = "52–60", notes = "Wild Growth Spaulders, Hide of the Wild, Briarwood Reed." }
                    },
                    abilities = {
                        { level = 40, name = "Swiftmend (Talent)", desc = "Consumes a Rejuvenation or Regrowth on a friendly target to instantly heal them for 12s of Rejuv or 18s of Regrowth!" }
                    },
                    rules = {
                        "Heal primarily with Healing Touch Rank 4 + Rejuvenation on the tank, reserving Swiftmend and Nature's Swiftness for sudden spikes.",
                        "Maintain Gift of the Wild and Thorns across the entire group."
                    }
                }
            },
            macros = {
                {
                    category = "Healing / Mouseover",
                    title = "Resto: Panic NS + Healing Touch",
                    desc = "Stops current cast, triggers Nature's Swiftness, and fires an instant Max Rank Healing Touch on mouseover or target.",
                    code = "#showtooltip Nature's Swiftness\n/stopcasting\n/cast Nature's Swiftness\n/cast [@mouseover,help,nodead][help,nodead][@player] Healing Touch"
                },
                {
                    category = "Healing / Mouseover",
                    title = "Resto: Mouseover Rejuvenation",
                    desc = "Applies Rejuvenation HoT to friendly mouseover frame or unit.",
                    code = "#showtooltip Rejuvenation\n/cast [@mouseover,help,nodead][help,nodead][@player] Rejuvenation"
                },
                {
                    category = "Healing / Mouseover",
                    title = "Resto: Mouseover Abolish Poison",
                    desc = "Cleanses poison effects on friendly mouseover without changing target.",
                    code = "#showtooltip Abolish Poison\n/cast [@mouseover,help,nodead][help,nodead][@player] Abolish Poison"
                }
            }
        },

        ["BALANCE"] = {
            specName = "Balance (Moonkin DPS)",
            role = "DPS",
            order = 4,
            statPriority = "Spell Hit (to 16% Cap) > Arcane/Nature Spell Damage > Spell Crit > Intellect > MP5",
            phaseGuidance = {
                [1] = {
                    name = "Phase 1: Levels 1–20",
                    summary = "Wrath solar casts, Moonfire DoT ticking, and Entangling Roots outdoor control.",
                    zones = {
                        { name = "Mulgore / Darkshore / Barrens", range = "1–20", notes = "Stack Intellect and Spirit cloth/leather." }
                    },
                    abilities = {
                        { level = 1, name = "Wrath & Moonfire", desc = "Fast Nature nuke and instant Arcane nuke + DoT." },
                        { level = 8, name = "Entangling Roots", desc = "Roots outdoor enemies in place while you nuke from range." }
                    },
                    rules = {
                        "Open outdoor pulls with Starfire -> Entangling Roots -> Moonfire -> Wrath.",
                        "Finish low-health mobs with melee staff swings to let Spirit mana regeneration kick in early."
                    }
                },
                [2] = {
                    name = "Phase 2: Levels 20–40",
                    summary = "Starfire cast-time reduction, Vengeance (+100% crit damage bonus), and Moonkin Form at 40.",
                    zones = {
                        { name = "Hillsbrad / Arathi / SM", range = "20–40", notes = "Collect Illusionary Rod and spell damage cloth from Scarlet Monastery." }
                    },
                    abilities = {
                        { level = 20, name = "Starfire", desc = "Heavy 3.5s (3.0s talented) Arcane nuke with 100% spell power scaling." },
                        { level = 40, name = "Moonkin Form (Talent)", desc = "+360% Armor and grants +3% Spell Crit aura to all party members!" }
                    },
                    rules = {
                        "Every party caster loves a Moonkin for the +3% Spell Crit aura—stay within 30yd of your group's mages and warlocks.",
                        "Use Hurricane on 4+ clustered dungeon packs after the tank establishes Consecration or Thunder Clap."
                    }
                },
                [3] = {
                    name = "Phase 3: Levels 40–52",
                    summary = "Barkskin cast protection, Arcane/Nature damage itemization, and Maraudon / ZF.",
                    zones = {
                        { name = "Tanaris / Feralas / Hinterlands", range = "40–52", notes = "Zum'rah's Vexing Cane in Zul'Farrak." }
                    },
                    abilities = {
                        { level = 44, name = "Barkskin", desc = "Reduces physical damage taken by 20% and prevents spell pushback for 15 sec." }
                    },
                    rules = {
                        "Pair Barkskin + Hurricane to channel uninterrupted AoE nature damage even if a loose mob hits you.",
                        "Reserve your personal Innervate for yourself on long boss fights to sustain Starfire spam."
                    }
                },
                [4] = {
                    name = "Phase 4: Levels 52–60",
                    summary = "Bloodvine Set (+4% Spell Hit), Starfire raid rotation, and hybrid off-healing utility.",
                    zones = {
                        { name = "BRD / Scholo / Strat / UBRS", range = "52–60", notes = "Briarwood Reed, Ban'thok Sash (+1% Hit), Rod of the Ogre Magi." }
                    },
                    abilities = {
                        { level = 60, name = "Max Rank Starfire & Moonfire", desc = "High burst Arcane damage when paired with Warlock Curse of Shadow." }
                    },
                    rules = {
                        "Ask a Warlock in your raid to apply Curse of Shadow on bosses—it boosts your Starfire and Moonfire damage by 10% and reduces resists.",
                        "Bring Major Mana Potions and Dark/Demonic Runes to maintain peak Arcane output."
                    }
                }
            },
            macros = {
                {
                    category = "Burst / DPS",
                    title = "Balance: Moonkin Starfire",
                    desc = "Enters Moonkin Form if unshifted and casts Starfire on target.",
                    code = "#showtooltip Starfire\n/cast [noform:5] Moonkin Form\n/cast Starfire"
                },
                {
                    category = "Burst / DPS",
                    title = "Balance: Barkskin + Hurricane AoE",
                    desc = "Pops Barkskin for zero spell pushback and channels Hurricane.",
                    code = "#showtooltip Hurricane\n/cast Barkskin\n/cast Hurricane"
                }
            }
        }
    }
}

FTG:RegisterClassModule("DRUID", DruidModule)
