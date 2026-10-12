--[[
    ForeverTankGuide - Modules/Professions/Alchemy.lua
    Alchemy Progression: Stoneshield Potions, Mana Potions, Mongoose, Greater Arcane Elixirs, and Flasks
]]

local ADDON_NAME, FTG = ...

local AlchemyModule = {
    name = "Alchemy",
    token = "ALCHEMY",
    description = "Universal consumable engine for Tanks, Healers, and DPS. Craft Greater Stoneshield (+2000 Armor), Major Mana Potions, Elixir of the Mongoose, Greater Arcane Elixir, and Raid Flasks.",
    brackets = {
        [1] = {
            range = "Skill 1–100",
            milestones = {
                { skill = 1, name = "Minor Healing & Minor Armor Potion", mats = "Peacebloom, Silverleaf", notes = "+50 Armor for 1 hour + instant emergency HP." },
                { skill = 50, name = "Weak Troll's Blood & Elixir of Lion's Strength", mats = "Peacebloom, Earthroot", notes = "+4 Strength and passive HP regeneration." },
                { skill = 90, name = "Elixir of Wisdom & Minor Mana Potion", mats = "Mageroyal, Briarthorn, Stranglekelp", notes = "+6 Intellect and early mana recovery for Healers/Casters." }
            },
            shoppingList = {
                "Peacebloom x 30-40",
                "Silverleaf x 30-40",
                "Earthroot x 20-30",
                "Mageroyal x 20-30",
                "Briarthorn x 20-30"
            }
        },

        [2] = {
            range = "Skill 100–225",
            milestones = {
                { skill = 120, name = "Mana Potion & LesserMana Potion", mats = "Stranglekelp, Kingsblood", notes = "Essential mana sustain for dungeon Healers and Paladin tanks." },
                { skill = 150, name = "Free Action Potion (FAP)", mats = "Blackmouth Oil x2, Stranglekelp x1", notes = "30 seconds of complete Stun and Movement Impairment immunity!" },
                { skill = 175, name = "Elixir of Fortitude & Greater Mana Potion", mats = "Wild Steelbloom, Goldthorn, Khadgar's Whisker", notes = "+120 Max Health for 1 hour and 700-900 Mana restore." },
                { skill = 195, name = "Elixir of Greater Agility & Arcane Elixir", mats = "Goldthorn, Blindweed", notes = "+25 Agility (Melee/Hunter) or +20 Spell Damage (Caster)." }
            },
            shoppingList = {
                "Stranglekelp x 40-50",
                "Wild Steelbloom x 30-40",
                "Goldthorn x 30-40",
                "Kingsblood x 30-40",
                "Khadgar's Whisker x 20-30"
            }
        },

        [3] = {
            range = "Skill 200–260",
            milestones = {
                { skill = 205, name = "Limited Invulnerability Potion (LIP)", mats = "Blindweed x2, Ghost Mushroom x1", notes = "6 seconds of Physical Immunity! Saves DPS who pull aggro and Tanks on AoE pulls!" },
                { skill = 245, name = "Elixir of the Giants & Superior Mana Potion", mats = "Sungrass, Blindweed, Gromsblood", notes = "+25 Strength (1 hr) and 900–1,500 Mana restore." },
                { skill = 250, name = "Elixir of Superior Defense", mats = "Stonescale Oil x2, Sungrass x1", notes = "+450 Armor for 1 hour." }
            },
            shoppingList = {
                "Stonescale Eel x 40-60",
                "Sungrass x 40-50",
                "Blindweed x 40-50",
                "Ghost Mushroom x 15-20",
                "Gromsblood x 20-30"
            }
        },

        [4] = {
            range = "Skill 260–300",
            milestones = {
                { skill = 275, name = "Transmute: Arcanite (48-Hour Cooldown!)", mats = "Thorium Bar x1, Arcane Crystal x1", notes = "Passive gold maker and essential for Lionheart Helm / Force Reactive Disk." },
                { skill = 280, name = "Greater Stoneshield (+2000 Armor) & Elixir of the Mongoose", mats = "Thorium Ore / Mountain Silversage, Plaguebloom", notes = "Tank BIS (+2000 Armor) & Melee/Hunter BIS (+25 Agi, +2% Crit)!" },
                { skill = 285, name = "Greater Arcane Elixir & Mageblood Potion", mats = "Dreamfoil, Mountain Silversage, Plaguebloom", notes = "Caster BIS (+35 Spell Power) & Healer BIS (+12 MP5)!" },
                { skill = 295, name = "Major Mana Potion & Major Healing Potion", mats = "Dreamfoil x3, Icecap x2 / Golden Sansam", notes = "Restores 1,350 to 2,250 Mana! Mandatory for all Healers and Casters." },
                { skill = 300, name = "Flasks (Titans / Distilled Wisdom / Supreme Power)", mats = "Black Lotus x1 + 30x Herbs (Scholo / BWL Alchemy Lab)", notes = "+1,200 HP (Tanks), +2,000 Mana (Healers), or +150 Spell Damage (Casters)!" }
            },
            shoppingList = {
                "Dreamfoil x 60-80",
                "Mountain Silversage x 40-60",
                "Plaguebloom x 40-60",
                "Icecap x 40-50",
                "Black Lotus x 1-3"
            },
            ahProfits = {
                { item = "Elixir of the Mongoose & Greater Arcane Elixir", notes = "Every single melee, hunter, and caster DPS buys stacks of these every raid reset." },
                { item = "Major Mana Potions & Mageblood Potions", notes = "Healers and Mages/Warlocks consume 10–20 Major Mana Potions per raid." },
                { item = "Greater Stoneshield & Limited Invulnerability Potions (LIP)", notes = "High-margin tank and raid survival consumables." }
            }
        }
    },
    macros = {
        {
            category = "Defensive / Tank",
            title = "Alchemy: Panic Greater Stoneshield",
            desc = "Drinks a Greater Stoneshield Potion immediately for +2000 emergency armor.",
            code = "#showtooltip Greater Stoneshield Potion\n/use Greater Stoneshield Potion"
        },
        {
            category = "Healing / Mouseover",
            title = "Alchemy: Emergency Major Mana Potion",
            desc = "Drinks a Major Mana Potion immediately when running low on mana.",
            code = "#showtooltip Major Mana Potion\n/use Major Mana Potion"
        }
    }
}

FTG:RegisterProfModule("ALCHEMY", AlchemyModule)
