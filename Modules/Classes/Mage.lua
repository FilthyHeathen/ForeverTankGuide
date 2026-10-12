--[[
    ForeverTankGuide - Modules/Classes/Mage.lua
    Mage Multi-Spec Module: Frost (AoE / Leveling / Dungeon DPS), Fire (Endgame Burst DPS), Arcane (Burst / Utility)
]]

local ADDON_NAME, FTG = ...

local MageModule = {
    name = "Mage",
    token = "MAGE",
    defaultSpec = "FROST",
    specs = {
        ["FROST"] = {
            specName = "Frost (Control & AoE DPS)",
            role = "DPS",
            order = 1,
            statPriority = "Spell Hit (6% w/ Elemental Precision) > Frost Spell Damage > Spell Crit (Shatter +100%) > Intellect",
            phaseGuidance = {
                [1] = {
                    name = "Phase 1: Levels 1–20",
                    summary = "Frostbolt kiting, Polymorph crowd control, Conjure Water/Food, and Frost Nova.",
                    zones = {
                        { name = "Tirisfal / Elwynn / Dun Morogh / Barrens", range = "1–20", notes = "Pick up Elemental Precision (3/3) and Improved Frostbolt (5/5) first." }
                    },
                    abilities = {
                        { level = 4, name = "Frostbolt", desc = "Core Frost nuke that chills and slows enemy movement by 40–50%." },
                        { level = 8, name = "Polymorph", desc = "Transforms a Beast, Humanoid, or Critter into a sheep—premier dungeon crowd control!" },
                        { level = 10, name = "Frost Nova", desc = "Freezes all nearby enemies in place for 8 seconds." }
                    },
                    rules = {
                        "Always conjure 2–3 stacks of water for your party's Healer and Paladin tank at the start of every dungeon!",
                        "Keep Rank 1 Frostbolt on your bar as a 1.0-second cast emergency slow for kiting dangerous runners."
                    }
                },
                [2] = {
                    name = "Phase 2: Levels 20–40",
                    summary = "Improved Blizzard AoE grinding (3/3), Shatter (+50% Crit on frozen targets), and Ice Block at 30.",
                    zones = {
                        { name = "Hillsbrad / Arathi / Dustwallow / SM", range = "20–40", notes = "Open-world AoE farming camps (Hillsbrad Farmers, Arathi Syndicate)." }
                    },
                    abilities = {
                        { level = 20, name = "Blizzard (with Improved Blizzard 3/3)", desc = "Channeled AoE frost rain that applies a 65–75% movement slow!" },
                        { level = 20, name = "Evocation", desc = "Increases Spirit mana regeneration by 1500% for 8 seconds." },
                        { level = 30, name = "Ice Block (Talent)", desc = "10 seconds of complete immunity to all damage and spells; drops temporary aggro." }
                    },
                    rules = {
                        "Shatter Combo: Frost Nova -> step back -> cast Frostbolt + Cone of Cold at the exact same moment so both hit while frozen (+50% Crit)!",
                        "In dungeons, use Ice Block if you pull AoE aggro on a huge pack so the tank can pick them back up right outside your block."
                    }
                },
                [3] = {
                    name = "Phase 3: Levels 40–52",
                    summary = "Ice Barrier at level 40, Zul'Farrak grave AoE farming, and Remove Lesser Curse.",
                    zones = {
                        { name = "Tanaris (Zul'Farrak) / Hinterlands / Searing Gorge", range = "40–52", notes = "Solo/Duo Zul'Farrak zombie graves for massive XP and gold." }
                    },
                    abilities = {
                        { level = 40, name = "Ice Barrier (Talent)", desc = "Instant shield absorbing heavy physical/magic damage and preventing spell pushback." }
                    },
                    rules = {
                        "Always keep Ice Barrier active before pulling or casting Blizzard in dungeons.",
                        "Use Counterspell to lock out enemy healers and pull ranged casters around corners to your tank."
                    }
                },
                [4] = {
                    name = "Phase 4: Levels 52–60",
                    summary = "Winter's Chill (+10% Frost Crit raid debuff), Bloodvine Set, and Molten Core / BWL mastery.",
                    zones = {
                        { name = "BRD / Dire Maul / Strat / Scholo", range = "52–60", notes = "Briarwood Reed, Boreal Mantle, Bloodvine Set." }
                    },
                    abilities = {
                        { level = 60, name = "Max Rank Frostbolt & Arcane Power", desc = "Top-tier Molten Core and BWL raid DPS where bosses are Fire-immune." }
                    },
                    rules = {
                        "Proactively decurse party members with Remove Lesser Curse—an uncursed tank or healer prevents raid wipes.",
                        "Keep Mana Agate, Mana Jade, Mana Citrine, and Mana Ruby conjured before boss pulls for 2,000+ free mana."
                    }
                }
            },
            macros = {
                {
                    category = "Burst / DPS",
                    title = "Mage: Mouseover Polymorph",
                    desc = "Polymorphs mouseover enemy or current target without losing primary focus.",
                    code = "#showtooltip Polymorph\n/cast [@mouseover,harm,nodead][harm,nodead] Polymorph"
                },
                {
                    category = "Burst / DPS",
                    title = "Mage: Panic Ice Block (Toggle)",
                    desc = "Stops casting immediately and enters Ice Block; press again to cancel early.",
                    code = "#showtooltip Ice Block\n/stopcasting\n/cancelaura Ice Block\n/cast Ice Block"
                },
                {
                    category = "Burst / DPS",
                    title = "Mage: Mouseover Counterspell",
                    desc = "Stops current cast and instantly Counterspells mouseover caster.",
                    code = "#showtooltip Counterspell\n/stopcasting\n/cast [@mouseover,harm,nodead][harm,nodead] Counterspell"
                },
                {
                    category = "Healing / Mouseover",
                    title = "Mage: Mouseover Decurse",
                    desc = "Removes curses from friendly mouseover target.",
                    code = "#showtooltip Remove Lesser Curse\n/cast [@mouseover,help,nodead][help,nodead][@player] Remove Lesser Curse"
                }
            }
        },

        ["FIRE"] = {
            specName = "Fire (Ignite Burst DPS)",
            role = "DPS",
            order = 2,
            statPriority = "Spell Hit (to 10% w/ Elemental Precision) > Spell Crit (Ignite Rolling!) > Fire Spell Damage > Intellect",
            phaseGuidance = {
                [1] = {
                    name = "Phase 1: Levels 1–20",
                    summary = "Fireball heavy nukes, Fire Blast instant finishers, and Ignite crits.",
                    zones = {
                        { name = "Tirisfal / Elwynn / Barrens", range = "1–20", notes = "Impact (5/5) gives all fire spells a 10% chance to stun!" }
                    },
                    abilities = {
                        { level = 1, name = "Fireball & Fire Blast", desc = "High base damage Fire nuke and instant 20yd finisher." },
                        { level = 20, name = "Pyroblast (Talent)", desc = "6-second massive opener fireball." }
                    },
                    rules = {
                        "Open from max 35–41yd range with Pyroblast -> immediately follow with Fireball -> finish with Fire Blast."
                    }
                },
                [2] = {
                    name = "Phase 2: Levels 20–40",
                    summary = "Ignite (+40% rolling crit burn), Scorch stacking (+15% Fire Damage), and Blast Wave at 30.",
                    zones = {
                        { name = "Hillsbrad / STV / SM", range = "20–40", notes = "Fire Spell Damage gear (Tailoring Phoenix Gear)." }
                    },
                    abilities = {
                        { level = 22, name = "Scorch", desc = "Fast 1.5s Fire spell that stacks Fire Vulnerability up to +15% Fire damage!" },
                        { level = 30, name = "Blast Wave (Talent)", desc = "Instant AoE fire explosion that dazes all surrounding enemies by 50% for 6 sec!" }
                    },
                    rules = {
                        "Flame Strike -> Blast Wave -> Cone of Cold is the highest instant AoE burst combo in 5-man dungeons.",
                        "Watch your threat when Ignite crits roll—keep Limited Invulnerability Potions handy."
                    }
                },
                [3] = {
                    name = "Phase 3: Levels 40–52",
                    summary = "Combustion cooldown (+Crit stacking until 3 crits land), Critical Mass (+6% Fire Crit).",
                    zones = {
                        { name = "Tanaris / Hinterlands / Feralas", range = "40–52", notes = "Note: Avoid Fire spec inside Blackrock Depths due to Fire-immune elementals." }
                    },
                    abilities = {
                        { level = 40, name = "Combustion (Talent)", desc = "Each Fire spell increases your Fire Crit chance by 10% until you land 3 critical strikes!" }
                    },
                    rules = {
                        "Stack 5 Scorches on dungeon bosses before popping Combustion + Fireball."
                    }
                },
                [4] = {
                    name = "Phase 4: Levels 52–60",
                    summary = "AQ40 / Naxxramas / Non-MC Raid King: Rolling Ignite ticks for 3,000–5,000+ damage every 2 seconds!",
                    zones = {
                        { name = "Strat / Scholo / Dire Maul / ZG", range = "52–60", notes = "Bloodvine Set (+4% Hit, +2% Crit) is mandatory." }
                    },
                    abilities = {
                        { level = 60, name = "Rolling Ignite Mastery", desc = "Shared Mage Ignite pool fed by consecutive Fireball/Scorch crits." }
                    },
                    rules = {
                        "Coordinate with fellow Fire Mages to maintain 5 stacks of Improved Scorch at 100% uptime.",
                        "If you own a massive Rolling Ignite and pull threat, press Ice Block or LIP immediately!"
                    }
                }
            },
            macros = {
                {
                    category = "Burst / DPS",
                    title = "Fire: Combustion + Trinket",
                    desc = "Activates Combustion and top spell damage trinket for guaranteed Ignite crits.",
                    code = "#showtooltip Combustion\n/cast Combustion\n/use 13\n/cast Fireball"
                }
            }
        },

        ["ARCANE"] = {
            specName = "Arcane (Presence of Mind & Arcane Power Burst)",
            role = "DPS",
            order = 3,
            statPriority = "Spell Hit (Arcane Focus +10% Arcane Hit!) > Spell Damage & Crit > Intellect (Arcane Mind +15% Int) > MP5",
            phaseGuidance = {
                [1] = {
                    name = "Phase 1: Levels 1–20",
                    summary = "Arcane Subtlety (-40% Arcane Threat), Arcane Focus (+10% Arcane Hit), and Arcane Concentration (Clearcasting!).",
                    zones = {},
                    abilities = {
                        { level = 8, name = "Arcane Missiles", desc = "5-wave channeled Arcane nuke that cannot be interrupted by damage with Improved Arcane Missiles (5/5)." },
                        { level = 14, name = "Arcane Explosion", desc = "Spam-friendly instant AoE arcane blast (becomes instant with 5/5 Improved Arcane Explosion)." }
                    },
                    rules = {
                        "Arcane Concentration (5/5) gives every damaging spell a 10% chance to proc Clearcasting (100% free next spell)—spend Clearcasting on high-mana Arcane Missiles or Flamestrike!"
                    }
                },
                [2] = {
                    name = "Phase 2: Levels 20–40",
                    summary = "Arcane Meditation (15% in-combat Spirit mana regen), Presence of Mind (lvl 30 Instant Cast!).",
                    zones = {},
                    abilities = {
                        { level = 30, name = "Presence of Mind (Talent)", desc = "Makes your next Mage spell with a cast time below 10 sec an INSTANT cast (3 min cooldown)!" }
                    },
                    rules = {
                        "Use Presence of Mind + Polymorph to instantly sheep a dangerous runner or healer, or Presence of Mind + Pyroblast/Frostbolt for instant burst!"
                    }
                },
                [3] = {
                    name = "Phase 3: Levels 40–52",
                    summary = "Arcane Instability (+3% Damage & +3% Crit to ALL spells) and Arcane Power (+30% Spell Damage!).",
                    zones = {},
                    abilities = {
                        { level = 40, name = "Arcane Power (Talent)", desc = "Increases all spell damage by 30% while spells cost 30% more mana for 15 seconds!" }
                    },
                    rules = {
                        "Skyborne Alliance Mages can pair Aerial Glide + Presence of Mind + Arcane Explosion from elevated ledges for devastating mobile AoE clears."
                    }
                },
                [4] = {
                    name = "Phase 4: Levels 52–60",
                    summary = "31/0/20 AP-Frost Raid Spec: +30% Arcane Power + Presence of Mind + Trinket Burst.",
                    zones = {},
                    abilities = {
                        { level = 60, name = "AP + PoM + Trinket Macro", desc = "Combines Arcane Power (+30% dmg), Talisman of Ephemeral Power / ZHC, and Presence of Mind." }
                    },
                    rules = {
                        "Once a fellow Frost Mage in your raid provides 5/5 Winter's Chill, respec to 31/0/20 Arcane/Frost to gain Arcane Instability (+3% dmg/crit) and Arcane Power (+30% burst)!"
                    }
                }
            },
            macros = {
                {
                    category = "Burst / DPS",
                    title = "Arcane: AP + PoM + Trinket Instant Nuke",
                    desc = "Pops Arcane Power (+30% damage), activates Spell Damage Trinket, and fires an instant Frostbolt/Pyroblast via Presence of Mind.",
                    code = "#showtooltip Arcane Power\n/cast Arcane Power\n/use 13\n/cast Presence of Mind\n/cast Frostbolt"
                }
            }
        }
    }
}

FTG:RegisterClassModule("MAGE", MageModule)
