--[[
    ForeverTankGuide - Modules/Professions/Alchemy.lua
    Alchemy Progression, Stoneshield Potions, Defense Elixirs, and Flasks
]]

local ADDON_NAME, FTG = ...

local AlchemyModule = {
    name = "Alchemy",
    token = "ALCHEMY",
    description = "Consumable durability engine. Craft Greater Stoneshield Potions (+2000 Armor), Elixir of Superior Defense, Troll's Blood regeneration, and Flask of the Titans.",
    brackets = {
        [1] = {
            range = "Skill 1–100",
            milestones = {
                { skill = 1, name = "Minor Healing & Minor Armor Potion", mats = "Peacebloom, Silverleaf", notes = "+25 Armor for 1 hour." },
                { skill = 50, name = "Weak Troll's Blood Potion", mats = "Peacebloom, Earthroot", notes = "Regenerates 2 HP every 5 seconds for 1 hour." },
                { skill = 90, name = "Elixir of Wisdom & Lesser Armor", mats = "Mageroyal, Briarthorn", notes = "Stamina, armor, and intellect boost." }
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
                { skill = 130, name = "Lesser Stoneshield Potion", mats = "Mithril Ore / Stranglekelp", notes = "+1000 Armor for 90 seconds. Life-saver during boss enrages." },
                { skill = 150, name = "Elixir of Defense", mats = "Wild Steelbloom, Stranglekelp", notes = "+150 Armor buff for 1 hour." },
                { skill = 175, name = "Elixir of Fortitude", mats = "Wild Steelbloom, Goldthorn", notes = "+120 Max Health for 1 hour." },
                { skill = 215, name = "Greater Stoneshield Potion (Recipe Drop)", mats = "Thorium Ore x2, Stranglekelp x1", notes = "HOLY GRAIL: +2000 Armor for 2 minutes! Slashes incoming physical damage in half!" }
            },
            shoppingList = {
                "Stranglekelp x 40-50",
                "Wild Steelbloom x 30-40",
                "Goldthorn x 30-40",
                "Kingsblood x 30-40",
                "Fadeleaf x 20-30"
            }
        },

        [3] = {
            range = "Skill 200–260",
            milestones = {
                { skill = 235, name = "Elixir of Greater Intellect", mats = "Khada's Whiskers, Blindweed", notes = "Generates bigger mana pool for Paladin/Shaman tanking." },
                { skill = 245, name = "Elixir of the Giants", mats = "Ghost Mushroom, Gromsblood", notes = "+25 Strength for 1 hour. Increases block value and AP." },
                { skill = 250, name = "Elixir of Superior Defense", mats = "Stonescale Eel x2, Sungrass x1", notes = "+450 Armor for 1 hour." }
            },
            shoppingList = {
                "Stonescale Eel x 40-60",
                "Sungrass x 30-40",
                "Ghost Mushroom x 15-20",
                "Gromsblood x 20-30"
            }
        },

        [4] = {
            range = "Skill 260–300",
            milestones = {
                { skill = 280, name = "Major Healing Potion", mats = "Golden Sansam x2, Mountain Silversage x1", notes = "Instant 1050-1750 health recovery." },
                { skill = 290, name = "Mageblood Potion", mats = "Dreamfoil x1, Plaguebloom x2", notes = "Regenerates 12 mana every 5 seconds for 1 hour. Mandatory for Paladin tanks." },
                { skill = 300, name = "Flask of the Titans (Scholo Drop)", mats = "Gromsblood x30, Stonescale Eel x10, Black Lotus x1", notes = "Increases maximum health by 1,200 for 2 hours! Persists through death!" }
            },
            shoppingList = {
                "Golden Sansam x 40-60",
                "Mountain Silversage x 30-40",
                "Plaguebloom x 40-50",
                "Dreamfoil x 30-40",
                "Black Lotus x 1-2"
            },
            ahProfits = {
                { item = "Greater Stoneshield Potions", notes = "Continuous top-seller for every progression raid night." },
                { item = "Mageblood Potions", notes = "Healers and paladins consume dozens of these every week." },
                { item = "Elixir of the Mongoose", notes = "All physical tanks and melee DPS buy these (+25 Agility, +2% Crit)." }
            }
        }
    },
    macros = {
        {
            title = "Alchemy: Panic Stoneshield Potion",
            desc = "Drinks a Greater Stoneshield Potion immediately for +2000 emergency armor.",
            code = "#showtooltip Greater Stoneshield Potion\n/use Greater Stoneshield Potion"
        }
    }
}

FTG:RegisterProfModule("ALCHEMY", AlchemyModule)
