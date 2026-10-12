--[[
    ForeverTankGuide - Modules/Classes/Warlock.lua
    Metamorphosis / Demonology Warlock Tank Skeleton & Threat Mechanics
]]

local ADDON_NAME, FTG = ...

local WarlockModule = {
    name = "Warlock (Metamorphosis)",
    token = "WARLOCK",
    description = "Demon-form shadow and fire spell-tank. Extreme armor scaling (+500%), Searing Pain high threat generation, and self-sustaining Drain Life.",
    brackets = {
        [1] = {
            name = "Phase 1: Levels 1–20",
            minLevel = 1,
            maxLevel = 20,
            summary = "Voidwalker sacrifice shields, Corruption dot spread, and early Searing Pain threat.",
            zones = {
                { name = "Tirisfal / Silverpine / Barrens", range = "1–20", notes = "Voidwalker questline at level 10; Succubus at 20." }
            },
            abilities = {
                { level = 10, name = "Voidwalker (Torment)", desc = "Demon pet provides initial distraction and emergency sacrifice shield." },
                { level = 18, name = "Searing Pain", desc = "Primary high-threat single-target fire spell with double base threat multiplier." },
                { level = 14, name = "Drain Life", desc = "Continuous shadow channel providing reliable health sustain while tanking." }
            },
            tankRules = {
                "Searing Pain is your core single-target threat generator: spam it consistently on your primary target.",
                "Apply Corruption and Curse of Agony to secondary targets to maintain a baseline threat lead over healers.",
                "Use Life Tap between pulls rather than during combat to prevent spiking your own health downward."
            }
        },

        [2] = {
            name = "Phase 2: Levels 20–40",
            minLevel = 20,
            maxLevel = 40,
            summary = "Metamorphosis demon form activation (+500% armor, instant cast abilities), Shadow Cleave, and Hellfire AoE.",
            zones = {
                { name = "Hillsbrad / Arathi / Thousand Needles", range = "20–40", notes = "Felhunter questline at level 30." }
            },
            abilities = {
                { level = 20, name = "Demon Armor", desc = "Increases armor by hundreds and boosts shadow resistance and passive health regeneration." },
                { level = 30, name = "Hellfire", desc = "Channeled fire AoE pulse around the warlock. Extreme group snap threat." },
                { level = 40, name = "Soul Link (Talent)", desc = "Transfers 30% of all damage taken directly to your active demon pet." }
            },
            tankRules = {
                "While in demon form, use Shadow Cleave on multi-target packs to maintain solid AoE threat.",
                "Pair Hellfire pulses with defensive potions or Healer pre-hots to sustain through self-damage.",
                "Keep Soul Link active at all times with an Imp or Voidwalker hidden safely in the background."
            }
        },

        [3] = {
            name = "Phase 3: Levels 40–52",
            minLevel = 40,
            maxLevel = 52,
            summary = "Shadow Ward mitigation against magic bosses, Death Coil emergency peel, and Maraudon Mark of the Chosen.",
            zones = {
                { name = "Tanaris / Felwood / ZF", range = "40–52", notes = "Stamina and spell damage cloth gear acquisition." }
            },
            abilities = {
                { level = 42, name = "Death Coil", desc = "Instant shadow bolt healing you for 100% of damage dealt and causing 3 sec horror effect." },
                { level = 46, name = "Shadow Ward", desc = "Absorbs substantial shadow damage; vital against dungeon necromancers and warlocks." }
            },
            tankRules = {
                "Death Coil is an outstanding emergency ranged taunt peel when a mob runs toward a healer.",
                "Stack high Stamina and Spell Damage: your threat scales directly with spell power, while stamina keeps you alive.",
                "Maintain Healthstones crafted for yourself and distributed to party members before every dungeon run."
            }
        },

        [4] = {
            name = "Phase 4: Levels 52–60",
            minLevel = 52,
            maxLevel = 60,
            summary = "Endgame cloth tanking with Dreadmist / Felcloth, high fire resistance, and Stratholme / Scholo tanking.",
            zones = {
                { name = "EPL / Strat / Scholo / BRD", range = "52–60", notes = "Pre-raid spell hit, stamina, and defense cloth gear." }
            },
            abilities = {
                { level = 60, name = "Max Rank Searing Pain & Shadow Cleave", desc = "Peak spell threat output." }
            },
            tankRules = {
                "Use Curse of Elements on bosses to boost your fire and frost spell threat along with group mages.",
                "Pre-shield yourself with Voidwalker Sacrifice before pulling dangerous burst trash packs.",
                "Communicate with your healer when casting Life Tap so they can prepare efficient heal-over-time spells."
            }
        }
    },
    macros = {
        {
            title = "Warlock: Searing Pain Threat",
            desc = "Casts Searing Pain on mouseover enemy or current target.",
            code = "#showtooltip Searing Pain\n/cast [@mouseover,harm,nodead][harm,nodead] Searing Pain"
        },
        {
            title = "Warlock: Emergency Death Coil",
            desc = "Instant peel and self-heal casting Death Coil on hostile target.",
            code = "#showtooltip Death Coil\n/stopcasting\n/cast [@mouseover,harm,nodead][harm,nodead] Death Coil"
        }
    }
}

FTG:RegisterClassModule("WARLOCK", WarlockModule)
