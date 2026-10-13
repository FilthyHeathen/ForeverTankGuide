--[[
    Heathen's Forever Guide - Modules/Classes/Hunter.lua
    Hunter Multi-Spec Module: Beast Mastery (Leveling & Solo King), Marksmanship (Raid Ranged DPS)
]]

local ADDON_NAME, FTG = ...

local HunterModule = {
    name = "Hunter",
    token = "HUNTER",
    defaultSpec = "BEAST_MASTERY",
    specs = {
        ["BEAST_MASTERY"] = {
            specName = "Beast Mastery (Leveling & Pet DPS)",
            role = "DPS",
            order = 1,
            statPriority = "Ranged Weapon DPS > Hit (to 9% Cap) > Agility > Crit > Intellect",
            phaseGuidance = {
                [1] = {
                    name = "Phase 1: Levels 1–20",
                    summary = "Tame Pet quest at level 10, Growl Rank 1-3 training, and Aspect of the Hawk.",
                    zones = {
                        { name = "Durotar / Mulgore / Teldrassil / Dun Morogh / Barrens", range = "1–20", notes = "Tame a Boar (Charge) or Cat (Claw + Bite) at level 10!" }
                    },
                    abilities = {
                        { level = 10, name = "Tame Beast & Pet Growl", desc = "Unlocks your personal tank companion. Train Growl for free at any Pet Trainer." },
                        { level = 10, name = "Aspect of the Hawk", desc = "Increases Ranged Attack Power significantly." },
                        { level = 12, name = "Mend Pet", desc = "Channeled heal restoring pet health over 5 seconds." }
                    },
                    rules = {
                        "CRITICAL DUNGEON RULE: Always right-click 'Growl' on your Pet Bar to turn OFF auto-cast inside dungeons so your pet doesn't steal aggro from the tank!",
                        "Dismiss your pet BEFORE jumping off ledges in Wailing Caverns, Gnomeregan, or Blackrock Depths—otherwise your pet will run through the whole dungeon and pull 50 mobs!"
                    }
                },
                [2] = {
                    name = "Phase 2: Levels 20–40",
                    summary = "Aspect of the Cheetah (+30% speed) at 20, Feign Death at 30, and Bestial Wrath at 40!",
                    zones = {
                        { name = "Hillsbrad / STV / Arathi / Badlands", range = "20–40", notes = "Tame Broken Tooth (Badlands, 1.0s attack speed cat) at level 37 or King Bangalash (STV)!" }
                    },
                    abilities = {
                        { level = 20, name = "Freezing Trap", desc = "Freezes 1 approaching enemy in ice for up to 20 seconds—premier dungeon CC!" },
                        { level = 30, name = "Feign Death", desc = "100% complete threat wipe and out-of-combat reset (allows in-combat Freezing Traps!)." },
                        { level = 40, name = "Bestial Wrath (Talent)", desc = "Sends your pet into a rage dealing +50% damage and becoming immune to Fear/CC for 18 sec!" }
                    },
                    rules = {
                        "Feign Death + Freezing Trap Combo: Drop a Freezing Trap before pull; once that trap expires mid-fight, press Feign Death (drops combat) + Freezing Trap macro to instantly re-trap a mob!",
                        "Never leave Aspect of the Cheetah or Aspect of the Pack on during combat—any hit causes a 4-second Daze!"
                    }
                },
                [3] = {
                    name = "Phase 3: Levels 40–52",
                    summary = "Frenzy (+30% Pet Attack Speed), Mail Armor at 40, and Maraudon solo farming.",
                    zones = {
                        { name = "Tanaris / Hinterlands / Maraudon", range = "40–52", notes = "Verdant Keeper's Aim (Maraudon bow) and Blackstone Ring." }
                    },
                    abilities = {
                        { level = 40, name = "Mail Armor Training", desc = "Upgrades from Leather to Mail armor." }
                    },
                    rules = {
                        "Keep your pet's Bite and Claw ranks updated by taming higher-level beasts temporarily to learn new ranks.",
                        "Use Distracting Shot + Kiting to peel dangerous enraged mobs off your healer if the tank is stunned."
                    }
                },
                [4] = {
                    name = "Phase 4: Levels 52–60",
                    summary = "Dire Maul Tribute soloing, Pre-Raid BIS Agility gear, and transition to Marksmanship for Raids.",
                    zones = {
                        { name = "Dire Maul / Winterspring / BRD / UBRS", range = "52–60", notes = "Tarnished Elven Rings (DM North), Carapace Spine Crossbow (Strat), Blackcrow (LBRS)." }
                    },
                    abilities = {
                        { level = 60, name = "Tranquilizing Shot (Lucifron Drop)", desc = "Removes 1 Frenzy effect from enemy raid bosses (Magmadar, Chromaggus, Princess Huhuran)." }
                    },
                    rules = {
                        "Use Eyes of the Beast or Long-Range Pulling to cleanly pull single bosses in UBRS and Molten Core.",
                        "Keep Thorium Headed Arrows / Doomshot stocked and a +7 Damage Sniper Scope on your bow/gun."
                    }
                }
            },
            macros = {
                {
                    category = "Burst / DPS",
                    title = "Hunter: Hunter's Mark + Pet Attack",
                    desc = "Applies Hunter's Mark and sends your pet to attack the target.",
                    code = "#showtooltip Hunter's Mark\n/cast Hunter's Mark\n/petattack"
                },
                {
                    category = "Burst / DPS",
                    title = "Hunter: Feign Death + Freezing Trap",
                    desc = "Stops attacking, recalls pet passive, drops combat with Feign Death, and places Freezing Trap.",
                    code = "#showtooltip Freezing Trap\n/stopattack\n/petfollow\n/cast Feign Death\n/cast Freezing Trap"
                },
                {
                    category = "Burst / DPS",
                    title = "Hunter: Auto Shot (No-Clip Toggle)",
                    desc = "Starts Auto Shot without accidentally toggling it off if pressed repeatedly.",
                    code = "#showtooltip Auto Shot\n/cast !Auto Shot"
                }
            }
        },

        ["MARKSMANSHIP"] = {
            specName = "Marksmanship (Aimed Shot Raid DPS)",
            role = "DPS",
            order = 2,
            statPriority = "Hit (to 9% Cap!) > Slow Ranged Weapon (3.0s+ Crossbow/Bow) > Agility (1 Agi = 2 RAP + Crit) > Crit",
            phaseGuidance = {
                [1] = {
                    name = "Phase 1: Levels 1–20",
                    summary = "Lethal Shots (+5% Crit) and Aimed Shot unlock at level 20.",
                    zones = {
                        { name = "Barrens / Westfall / Loch Modan", range = "1–20", notes = "Aimed Shot unlocks at 11 points in Marksmanship." }
                    },
                    abilities = {
                        { level = 20, name = "Aimed Shot (Talent)", desc = "3.0-second windup shot that adds massive bonus damage and reduces target healing by 50%." }
                    },
                    rules = {
                        "Always use a Ranged Weapon Swing Timer so you never clip your Auto Shot while casting Aimed Shot!"
                    }
                },
                [2] = {
                    name = "Phase 2: Levels 20–40",
                    summary = "Mortal Shots (+30% Ranged Crit Damage), Scatter Shot (lvl 30), and Rapid Fire.",
                    zones = {
                        { name = "STV / Hillsbrad / Badlands", range = "20–40", notes = "Master Hunter's Bow / Rifle from Nesingwary STV quests!" }
                    },
                    abilities = {
                        { level = 26, name = "Rapid Fire", desc = "Increases ranged attack speed by 40% for 15 seconds." },
                        { level = 30, name = "Scatter Shot (Talent)", desc = "Instant 4-second disorient at 15yd range—breaks enemy casts and buys time to drop a trap!" }
                    },
                    rules = {
                        "Shot Rotation: Auto Shot lands -> immediately cast Aimed Shot -> Auto Shot lands -> immediately cast Multi-Shot -> Auto Shot."
                    }
                },
                [3] = {
                    name = "Phase 3: Levels 40–52",
                    summary = "Trueshot Aura (+100 AP to entire party!) at level 40, and Ranged Weapon Specialization.",
                    zones = {
                        { name = "Tanaris / Hinterlands / Maraudon", range = "40–52", notes = "Blackstone Ring (+1% Hit) from Maraudon." }
                    },
                    abilities = {
                        { level = 40, name = "Trueshot Aura (Talent)", desc = "Increases Ranged and Melee Attack Power of all party members within 45yd by 50–100!" }
                    },
                    rules = {
                        "Every melee physical group wants a Marksmanship Hunter for Trueshot Aura (+100 Attack Power)!"
                    }
                },
                [4] = {
                    name = "Phase 4: Levels 52–60",
                    summary = "9% Ranged Hit Cap, Rhok'delar / Ashjre'thul, and Clip-Free Auto/Aimed/Multi Rotation.",
                    zones = {
                        { name = "Dire Maul / Strat / UBRS", range = "52–60", notes = "Carapace Spine Crossbow (Strat UD), Tarnished Elven Rings x2 (DM North)." }
                    },
                    abilities = {
                        { level = 60, name = "Clip-Free Shot Weaving", desc = "Weaving 3.0s Aimed Shot and 0.5s Multi-Shot cleanly between Auto Shots." }
                    },
                    rules = {
                        "Hit Cap (9% via gear or 6% with 3/3 Surefooted in Survival) is your #1 stat priority: a missed Aimed Shot or Tranquilizing Shot is devastating.",
                        "Press Feign Death every 30 seconds on raid bosses to reset your threat to zero and drink a Mana Potion out of combat if needed!"
                    }
                }
            },
            macros = {
                {
                    category = "Burst / DPS",
                    title = "MM: Aimed Shot + Auto Shot",
                    desc = "Ensures Auto Shot is active and begins casting Aimed Shot right after.",
                    code = "#showtooltip Aimed Shot\n/cast !Auto Shot\n/cast Aimed Shot"
                },
                {
                    category = "Burst / DPS",
                    title = "MM: Rapid Fire + Trinket Burst",
                    desc = "Activates Rapid Fire and top Attack Power trinket.",
                    code = "#showtooltip Rapid Fire\n/use 13\n/cast Rapid Fire\n/cast !Auto Shot"
                },
                {
                    category = "Burst / DPS",
                    title = "MM: Mouseover Scatter Shot Peel",
                    desc = "Disorients a charging melee mob on mouseover for 4 seconds.",
                    code = "#showtooltip Scatter Shot\n/stopcasting\n/cast [@mouseover,harm,nodead][harm,nodead] Scatter Shot"
                }
            }
        },

        ["SURVIVAL"] = {
            specName = "Survival (Agility / Trap & Hybrid DPS)",
            role = "DPS",
            order = 3,
            statPriority = "Agility (Lightning Reflexes +15% Agi!) > Hit (Surefooted +3% Hit -> 6% Gear Cap) > Crit > Stamina",
            phaseGuidance = {
                [1] = {
                    name = "Phase 1: Levels 1–20",
                    summary = "Savage Strikes (+20% Raptor/Mongoose Crit), Entrapment, and Wing Clip kiting.",
                    zones = {},
                    abilities = {
                        { level = 12, name = "Wing Clip", desc = "Instant melee hamstring slowing enemy movement speed by 50–60% for 10 seconds." },
                        { level = 16, name = "Immolation & Explosive Traps", desc = "High-damage fire traps boosted by Clever Traps (+30% trap damage)." }
                    },
                    rules = {
                        "Weave Raptor Strike + Wing Clip whenever an enemy closes into melee range, then step out or Aerial Glide (Skyborne) back to Auto Shot range!"
                    }
                },
                [2] = {
                    name = "Phase 2: Levels 20–40",
                    summary = "Deterrence (+25% Dodge/Parry cooldown), Surefooted (+3% Hit & +15% Trap Resist), and Counterattack.",
                    zones = {},
                    abilities = {
                        { level = 20, name = "Deterrence (Talent)", desc = "Increases Dodge and Parry chance by 25% for 10 seconds—turns you into an emergency melee tank!" },
                        { level = 30, name = "Counterattack (Talent)", desc = "Triggered after a parry: deals damage and immobilizes the target for 5 seconds (cannot be blocked/dodged/parried)!" }
                    },
                    rules = {
                        "3/3 Surefooted gives you +3% Melee and Ranged Hit passively, lowering your endgame Hit gear requirement from 9% down to just 6%!"
                    }
                },
                [3] = {
                    name = "Phase 3: Levels 40–52",
                    summary = "Killer Instinct (+3% Crit to all attacks) and Wyvern Sting (lvl 40 CC).",
                    zones = {},
                    abilities = {
                        { level = 40, name = "Wyvern Sting (Talent)", desc = "Puts target to sleep for 12 seconds (usable out of combat for double-CC alongside Freezing Trap)." }
                    },
                    rules = {
                        "In dungeons, you can CC two separate mobs by opening with Wyvern Sting on one target and pulling another into your Freezing Trap!"
                    }
                },
                [4] = {
                    name = "Phase 4: Levels 52–60",
                    summary = "Lightning Reflexes (+15% Total Agility!) at ~450+ base Agility and Melee-Weaving mastery.",
                    zones = {},
                    abilities = {
                        { level = 60, name = "Lightning Reflexes (5/5 Talent)", desc = "Multiplies your total Agility by 15%, scaling massively with high-end Agility gear and ZG buffs." }
                    },
                    rules = {
                        "Once your unbuffed Agility exceeds 425+, 0/21/30 Survival/Marksmanship outscales pure Marksmanship in personal DPS!",
                        "Melee-Weaving: Run in between Auto Shots to land a 2H Raptor Strike, then step back out (or Skyborne Gale Gust / Aerial Glide) before your next Auto Shot timer!"
                    }
                }
            },
            macros = {
                {
                    category = "Burst / DPS",
                    title = "Survival: Raptor Strike + Mongoose Bite + Counterattack",
                    desc = "Executes Counterattack/Mongoose Bite procs and queues Raptor Strike in melee.",
                    code = "#showtooltip Raptor Strike\n/startattack\n/cast Counterattack\n/cast Mongoose Bite\n/cast Raptor Strike"
                },
                {
                    category = "Defensive / Tank",
                    title = "Survival: Deterrence + Monkey Aspect",
                    desc = "Pops Deterrence (+25% Dodge/Parry) and shifts to Aspect of the Monkey (+8% Dodge) for survival.",
                    code = "#showtooltip Deterrence\n/cast Aspect of the Monkey\n/cast Deterrence"
                }
            }
        }
    }
}

FTG:RegisterClassModule("HUNTER", HunterModule)
