--[[
    Heathen's Forever Guide - Modules/Professions/Blacksmithing.lua
    Blacksmithing Progression: Shield Spikes, Sharpening Stones, Plate Sets, and Lionheart Helm
]]

local ADDON_NAME, HFG = ...

local BlacksmithingModule = {
    name = "Blacksmithing",
    token = "BLACKSMITHING",
    description = "Armorsmithing and Weaponsmithing powerhouse for Plate Tanks and Melee DPS. Craft reactive Shield Spikes, Elemental Sharpening Stones (+2% Crit), Dark Iron Plate, and the legendary Lionheart Helm.",
    brackets = {
        [1] = {
            range = "Skill 1–100",
            milestones = {
                { skill = 1, name = "Rough Sharpening Stone & Weightstone", mats = "Rough Stone x1, Linen Cloth", notes = "Flat +2 physical weapon damage for 30 minutes." },
                { skill = 65, name = "Coarse Sharpening Stone", mats = "Coarse Stone x1", notes = "Flat +3 physical weapon damage." },
                { skill = 100, name = "Silver Rod & Runed Copper Belt", mats = "Silver Bar, Copper Bar", notes = "Stamina and armor craftables; sell Silver Rods to Enchanters." }
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
                { skill = 165, name = "Green Iron & Golden Scale Mail Sets", mats = "Iron Bar, Steel Bar, Heavy Stone", notes = "High Stamina/Strength mail sets for 30-39 Warriors and Paladins." },
                { skill = 200, name = "Solid Sharpening Stone & Golden Rod", mats = "Solid Stone x1, Gold Bar", notes = "+6 weapon damage buff." },
                { skill = 215, name = "Mithril Shield Spike & Mithril Spurs", mats = "Mithril Bar x4, Dense Blasting Powder", notes = "16-20 block damage (Tank) or +4% Mount Speed on boots!" }
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
            range = "Skill 200–260 (Armorsmith / Weaponsmith)",
            milestones = {
                { skill = 210, name = "Glimmering Mithril Insignia (Armorsmith Quest)", mats = "Ornate Mithril Pants/Gloves/Shoulders", notes = "BoP Trinket: 30 seconds of complete Fear Immunity + +50 Armor!" },
                { skill = 250, name = "Dense Sharpening Stone & Dense Weightstone", mats = "Dense Stone x1, Runecloth", notes = "+8 physical weapon damage for 30 minutes!" },
                { skill = 255, name = "Thorium Shield Spike", mats = "Thorium Bar x4, Dense Grinding Stone x4", notes = "Inflicts 20-30 physical damage on every block. Core Paladin/Warrior tank threat!" }
            },
            shoppingList = {
                "Mithril Bar x 120-140",
                "Truesilver Bar x 20-30",
                "Dense Stone x 80-100",
                "Thorium Bar x 40-60"
            }
        },

        [4] = {
            range = "Skill 260–300",
            milestones = {
                { skill = 275, name = "Imperial Plate Set & Whitesoul Helm", mats = "Thorium Bar, Star Ruby", notes = "Entry level 60 tank/DPS plate and +35 Healing plate helm for Holy Paladins!" },
                { skill = 290, name = "Dark Iron Plate (Molten Core Fire Resist)", mats = "Dark Iron Bar, Blood of the Mountain, Fiery Core", notes = "Premier Fire Resistance plate set for Molten Core and BWL tanks." },
                { skill = 300, name = "Elemental Sharpening Stone", mats = "Elemental Earth x2, Dense Stone x3", notes = "RAID STAPLE: +2% Melee Critical Strike chance for 30 minutes!" },
                { skill = 300, name = "Lionheart Helm & Arcanite Reaper / Nightfall", mats = "Thorium Bar x80, Arcanite Bar x12, Wicked Claw, Blue Sapphire", notes = "Lionheart Helm (+18 Str, +2% Crit, +2% Hit) is FOREVER BIS for Warriors & Ret Paladins!" }
            },
            shoppingList = {
                "Thorium Bar x 160-200",
                "Dense Stone x 100-140",
                "Arcanite Bar x 12-20",
                "Elemental Earth x 20-30"
            },
            ahProfits = {
                { item = "Elemental Sharpening Stones (+2% Crit)", notes = "Massive weekly demand from every Warrior, Rogue, and Ret Paladin in raids." },
                { item = "Lionheart Helm / Titanic Leggings Crafting Fees", notes = "Huge crafting fee tips if you obtain the rare plans." },
                { item = "Thorium Shield Spikes & Mithril Spurs", notes = "Steady daily sales on the Auction House." }
            }
        }
    },
    macros = {
        {
            category = "Burst / DPS",
            title = "BS: Apply Main-Hand Sharpening Stone",
            desc = "Applies your Dense or Elemental Sharpening Stone directly to your Main-Hand weapon (Slot 16).",
            code = "#showtooltip Dense Sharpening Stone\n/use Dense Sharpening Stone\n/use 16"
        }
    }
}

HFG:RegisterProfModule("BLACKSMITHING", BlacksmithingModule)
