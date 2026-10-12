--[[
    ForeverTankGuide - Modules/Professions/Blacksmithing.lua
    Blacksmithing Progression, Shield Spikes, Sharpening Stones, and Plate Armor Sets
]]

local ADDON_NAME, FTG = ...

local BlacksmithingModule = {
    name = "Blacksmithing",
    token = "BLACKSMITHING",
    description = "Armorsmithing and Weaponsmithing physical power. Craft heavy mail/plate sets, attach reactive Mithril/Thorium Shield Spikes for return damage on block, and grind sharpening stones.",
    brackets = {
        [1] = {
            range = "Skill 1–100",
            milestones = {
                { skill = 1, name = "Rough Sharpening Stone", mats = "Rough Stone x1", notes = "Flat +2 physical weapon damage." },
                { skill = 65, name = "Coarse Sharpening Stone", mats = "Coarse Stone x1", notes = "Flat +3 physical weapon damage." },
                { skill = 75, name = "Coarse Weightstone", mats = "Coarse Stone, Wool Cloth", notes = "Increases blunt weapon damage." },
                { skill = 100, name = "Silver Rod & Runed Copper Belt", mats = "Silver Bar, Copper Bar", notes = "Stamina and armor craftables." }
            },
            shoppingList = {
                "Rough Stone x 50-70",
                "Copper Bar x 70-90",
                "Coarse Stone x 40-50",
                "Bronze Bar x 40-60",
                "Silver Bar x 4-6"
            }
        },

        [2] = {
            range = "Skill 100–225",
            milestones = {
                { skill = 125, name = "Heavy Sharpening Stone", mats = "Heavy Stone x1", notes = "+4 weapon damage buff lasting 30 minutes." },
                { skill = 150, name = "Iron Shield Spike", mats = "Iron Bar x4, Coarse Stone x2, Silver Bar x2", notes = "Attaches to shield: inflicts 8-12 physical damage every time you block!" },
                { skill = 175, name = "Solid Sharpening Stone", mats = "Solid Stone x1", notes = "+6 weapon damage buff." },
                { skill = 190, name = "Golden Scale Plate Set", mats = "Steel Bar, Heavy Stone, Gold Bar", notes = "Solid early tanking plate set crafted before level 40." },
                { skill = 215, name = "Mithril Shield Spike", mats = "Mithril Bar x4, Dense Blasting Powder x2", notes = "Attaches to shield: inflicts 16-20 physical damage every time you block!" }
            },
            shoppingList = {
                "Iron Bar x 80-100",
                "Heavy Stone x 60-80",
                "Steel Bar x 40-60",
                "Solid Stone x 50-70",
                "Mithril Bar x 80-100"
            }
        },

        [3] = {
            range = "Skill 200–260 (Armorsmithing)",
            milestones = {
                { skill = 230, name = "Dark Iron & Ornate Mithril Set", mats = "Mithril Bar, Truesilver, Aquamarine", notes = "High stamina, armor, and defense rating pieces." },
                { skill = 250, name = "Dense Sharpening Stone", mats = "Dense Stone x1", notes = "+8 weapon damage buff." },
                { skill = 255, name = "Thorium Shield Spike", mats = "Thorium Bar x4, Dense Blasting Powder x2", notes = "Attaches to shield: inflicts 20-30 physical damage on block. Outstanding passive threat engine!" }
            },
            shoppingList = {
                "Mithril Bar x 120-140",
                "Truesilver Bar x 20-30",
                "Dense Stone x 80-100",
                "Mageweave Cloth x 30-40"
            }
        },

        [4] = {
            range = "Skill 260–300",
            milestones = {
                { skill = 275, name = "Thorium Armor Set (Imperial Plate)", mats = "Thorium Bar, Star Ruby", notes = "Pre-raid defense plate set." },
                { skill = 285, name = "Dark Iron Mail / Plate (Molten Core Prep)", mats = "Dark Iron Ore, Blood of the Mountain", notes = "Extreme Fire Resistance gear required for high tier raid tanking." },
                { skill = 300, name = "Elemental Sharpening Stone", mats = "Elemental Earth x2, Dense Stone x3", notes = "Raid staple: +2% physical weapon critical strike chance!" }
            },
            shoppingList = {
                "Thorium Bar x 140-180",
                "Star Ruby x 10-15",
                "Dark Iron Bar x 40-60",
                "Arcanite Bar x 4-8"
            },
            ahProfits = {
                { item = "Elemental Sharpening Stones", notes = "Massive weekly demand from all raid melee DPS (Warriors, Rogues)." },
                { item = "Thorium Shield Spikes", notes = "Every leveling and raid tank purchases these for their shields." },
                { item = "Imperial Plate Sets", notes = "Sells consistently to fresh level 60 warriors and paladins." }
            }
        }
    },
    macros = {
        {
            title = "Blacksmithing: Apply Sharpening Stone",
            desc = "Applies your highest tier sharpening stone directly to your equipped main hand weapon.",
            code = "#showtooltip Dense Sharpening Stone\n/use Dense Sharpening Stone\n/use 16"
        }
    }
}

FTG:RegisterProfModule("BLACKSMITHING", BlacksmithingModule)
