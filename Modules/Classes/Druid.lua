--[[
    ForeverTankGuide - Modules/Classes/Druid.lua
    Feral Bear Druid Progression, Armor Multipliers, Maul & Swipe Rotations
]]

local ADDON_NAME, FTG = ...

local DruidModule = {
    name = "Druid (Feral Bear)",
    token = "DRUID",
    description = "Colossal health pools and immense armor scaling from Dire Bear Form. Reliable hybrid survivability and high threat Maul.",
    brackets = {
        [1] = {
            name = "Phase 1: Levels 1–20",
            minLevel = 1,
            maxLevel = 20,
            summary = "Unlock Bear Form at level 10 through Moonglade quest, then Growl and Maul mechanics.",
            zones = {
                { name = "Mulgore / Darkshore / Barrens", range = "10–20", notes = "Bear Form class questline and Moonglade teleports." }
            },
            abilities = {
                { level = 10, name = "Bear Form & Growl", desc = "Base bear form providing +60% armor, increased stamina, and 8yd Growl taunt." },
                { level = 10, name = "Maul", desc = "Converts next melee swing into high-threat physical strike." },
                { level = 16, name = "Swipe", desc = "AoE physical swipe hitting up to 3 front targets." }
            },
            tankRules = {
                "Shift into Bear Form before starting combat to guarantee starting rage from Furor talents.",
                "Enrage before pulling: generates 20 instant rage at the cost of slight armor loss.",
                "Maul replaces regular attacks and does not generate rage; watch rage pool so you don't starve Swipe."
            }
        },

        [2] = {
            name = "Phase 2: Levels 20–40",
            minLevel = 20,
            maxLevel = 40,
            summary = "Dire Bear Form at level 40 (+360% armor), Faerie Fire (Feral), and Challenging Roar.",
            zones = {
                { name = "Ashenvale / Hillsbrad / STV", range = "20–40", notes = "Leveling Feral talents down to Heart of the Wild." }
            },
            abilities = {
                { level = 28, name = "Challenging Roar", desc = "10-minute AoE taunt forcing nearby foes to attack you for 6 sec." },
                { level = 30, name = "Faerie Fire (Feral)", desc = "Ranged 30yd armor reduction and high initial ranged pull threat with zero rage cost." },
                { level = 40, name = "Dire Bear Form", desc = "Huge survival milestone: armor value multiplied by 460% and stamina increased by 25%." }
            },
            tankRules = {
                "Always initiate ranged pulls with Faerie Fire (Feral)—it costs no mana/rage and provides immediate snapshot threat.",
                "Bash is your primary caster interrupt and 4 sec stun; use it to stop lethal heals or shadow bolts.",
                "Stack high armor leather: items with bonus armor scale massively under Dire Bear Form's 360% multiplier."
            }
        },

        [3] = {
            name = "Phase 3: Levels 40–52",
            minLevel = 40,
            maxLevel = 52,
            summary = "Feral Instinct threat amplification, Heart of the Wild stamina boosts, and Maraudon Mark of the Chosen.",
            zones = {
                { name = "Feralas / Tanaris / Maraudon", range = "40–52", notes = "Centaur questline for Mark of the Chosen trinket." }
            },
            abilities = {
                { level = 40, name = "Leader of the Pack (Talent)", desc = "+3% crit aura for all melee and physical party members." },
                { level = 40, name = "Frenzied Regeneration", desc = "Converts 10 rage per second into substantial self-healing." }
            },
            tankRules = {
                "Use Frenzied Regeneration when incoming healer is stunned or running low on mana.",
                "Tab-target Maul + Swipe: rotate targets constantly to keep threat ahead of high AoE DPS classes.",
                "Never let enemies get behind you—Druids cannot parry or block, relying heavily on Dodge and Armor."
            }
        },

        [4] = {
            name = "Phase 4: Levels 52–60",
            minLevel = 52,
            maxLevel = 60,
            summary = "Armor cap pursuit (75% physical damage reduction = ~17,265 Armor) and pre-raid tank gear.",
            zones = {
                { name = "Winterspring / Un'Goro / Stratholme / Scholo", range = "52–60", notes = "Warden Staff, Smoking Heart of the Mountain, and Devilsaur/Shadowcraft." }
            },
            abilities = {
                { level = 60, name = "Max Rank Dire Bear & Maul", desc = "Extreme damage soak ceiling." }
            },
            tankRules = {
                "Acquire Warden Staff (+260 Armor, +10 Defense) or Unyielding Maul for massive armor amplification.",
                "Craft or purchase Smoking Heart of the Mountain (Enchanting trinket with +150 Armor & +7 all resists).",
                "Stack Agility and Dodge to avoid crushing and critical strikes."
            }
        }
    },
    macros = {
        {
            title = "Druid: Growl / Taunt",
            desc = "Shifts into Dire Bear Form if not already shifted, and casts Growl on mouseover or target.",
            code = "#showtooltip Growl\n/cast [noform:1] Dire Bear Form\n/cast [@mouseover,harm,nodead][harm,nodead] Growl"
        },
        {
            title = "Druid: Ranged Pull Faerie Fire",
            desc = "Casts Faerie Fire (Feral) on mouseover or current enemy target without leaving Bear Form.",
            code = "#showtooltip Faerie Fire (Feral)\n/cast [@mouseover,harm,nodead][harm,nodead] Faerie Fire (Feral)"
        },
        {
            title = "Druid: Emergency Frenzied Regen",
            desc = "Activates Enrage for instant rage and immediately channels Frenzied Regeneration.",
            code = "#showtooltip Frenzied Regeneration\n/cast Enrage\n/cast Frenzied Regeneration"
        }
    }
}

FTG:RegisterClassModule("DRUID", DruidModule)
