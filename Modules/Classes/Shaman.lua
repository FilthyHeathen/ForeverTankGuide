--[[
    ForeverTankGuide - Modules/Classes/Shaman.lua
    Way of Earth / Enhancement Shaman Tank Skeleton & Mechanics
]]

local ADDON_NAME, FTG = ...

local ShamanModule = {
    name = "Shaman (Way of Earth)",
    token = "SHAMAN",
    description = "Elemental and Enhancement hybrid tanking using Rockbiter Weapon high threat, Earth Shock peels, and Shield Master block mitigation.",
    brackets = {
        [1] = {
            name = "Phase 1: Levels 1–20",
            minLevel = 1,
            maxLevel = 20,
            summary = "Rockbiter Weapon imbues (+threat), Earth Shock ranged peels, and Stoneskin Totem physical reduction.",
            zones = {
                { name = "Durotar / Barrens", range = "1–20", notes = "Totem questlines (Earth, Fire, Water) and RFC runs." }
            },
            abilities = {
                { level = 1, name = "Rockbiter Weapon", desc = "Imbues your melee weapon with high bonus attack power and extreme Holy/Physical threat multiplier." },
                { level = 4, name = "Earth Shock", desc = "20yd high threat shock and caster spell interrupt." },
                { level = 4, name = "Stoneskin Totem", desc = "Reduces incoming physical damage for all nearby party members." }
            },
            tankRules = {
                "Always keep Rockbiter Weapon active on your main hand weapon for steady high threat.",
                "Use Earth Shock Rank 1 as a fast interrupt, or highest rank for ranged snap taunting.",
                "Drop Stoneskin Totem and Searing Totem before engaging melee packs."
            }
        },

        [2] = {
            name = "Phase 2: Levels 20–40",
            minLevel = 20,
            maxLevel = 40,
            summary = "Shield Specialization block value, Molten Blast AoE threat, and Ghost Wolf repositioning.",
            zones = {
                { name = "Thousand Needles / Hillsbrad / RFK", range = "20–40", notes = "Enhancement talent tree push down to Parry and Shield spec." }
            },
            abilities = {
                { level = 20, name = "Ghost Wolf", desc = "Instant 40% movement speed for quick positioning and dungeon corpse runs." },
                { level = 28, name = "Grounding Totem", desc = "Absorbs one harmful spell targeted at nearby party members every 15 seconds." }
            },
            tankRules = {
                "Drop Grounding Totem on caster packs to absorb shadow bolts and fireballs meant for your healer.",
                "Equip high armor Mail and heavy shields with high block value.",
                "Manage your mana pool: Shaman spells consume mana quickly; conserve shocks for interrupts and peeling."
            }
        },

        [3] = {
            name = "Phase 3: Levels 40–52",
            minLevel = 40,
            maxLevel = 52,
            summary = "Windfury vs Rockbiter threat balancing, Chain Lightning openers, and Zul'Farrak / Maraudon tanking.",
            zones = {
                { name = "Tanaris / Hinterlands", range = "40–52", notes = "Mail armor upgrades and Air totem questline." }
            },
            abilities = {
                { level = 30, name = "Windfury Totem", desc = "Massive melee attack power and extra attack buff for physical group members." },
                { level = 32, name = "Chain Lightning", desc = "Tri-target nature damage burst opener." }
            },
            tankRules = {
                "Pre-cast Chain Lightning into Earth Shock for an explosive ranged pull on 3 targets.",
                "Twist Windfury Totem and Grace of Air Totem for high group DPS when threat is secure.",
                "Use Tremor Totem against fear-heavy dungeon encounters."
            }
        },

        [4] = {
            name = "Phase 4: Levels 52–60",
            minLevel = 52,
            maxLevel = 60,
            summary = "Endgame elemental warding, high Nature resist aura swapping, and BRD/Stratholme tanking.",
            zones = {
                { name = "Eastern Plaguelands / BRD / Scholo", range = "52–60", notes = "Pre-raid defense mail and high intellect gear." }
            },
            abilities = {
                { level = 60, name = "Mana Spring & Healing Stream Totems", desc = "Passive sustain for dungeon parties." }
            },
            tankRules = {
                "Communicate with your healer when dropping Stoneclaw Totem as an emergency secondary taunt.",
                "Maintain Purge on enemy bosses to strip shields and dangerous attack power buffs.",
                "Keep Nature Resistance Totem active in Scholomance and Stratholme against poison and nature ticks."
            }
        }
    },
    macros = {
        {
            title = "Shaman: Earth Shock Interrupt / Peel",
            desc = "Casts Earth Shock on mouseover enemy or current hostile target.",
            code = "#showtooltip Earth Shock\n/cast [@mouseover,harm,nodead][harm,nodead] Earth Shock"
        },
        {
            title = "Shaman: Emergency Grounding Totem",
            desc = "Drops Grounding Totem and stops casting immediately to absorb incoming caster spells.",
            code = "#showtooltip Grounding Totem\n/stopcasting\n/cast Grounding Totem"
        }
    }
}

FTG:RegisterClassModule("SHAMAN", ShamanModule)
