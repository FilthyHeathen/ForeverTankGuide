--[[
    ForeverTankGuide - Modules/Professions/Tailoring.lua
    Tailoring Progression: Cloth Gear, Bag Upgrades, Shadoweave, Truefaith Vestments, and Bloodvine Set
]]

local ADDON_NAME, FTG = ...

local TailoringModule = {
    name = "Tailoring",
    token = "TAILORING",
    description = "Premier cloth crafting profession for Healers and Caster DPS/Tanks. Provides 6-to-18 slot bags, Shadoweave/Dreamweave sets, Truefaith Vestments, and the +4% Spell Hit Bloodvine Set.",
    brackets = {
        [1] = {
            range = "Skill 1–100",
            milestones = {
                { skill = 1, name = "Bolt of Linen Cloth & Linen Bag (6-Slot)", mats = "Linen Cloth x6, Coarse Thread x3", notes = "Equip full 6-slot bags immediately for early questing." },
                { skill = 60, name = "Red Linen Robe / Heavy Linen Gloves", mats = "Bolt of Linen Cloth, Red Dye", notes = "Early Spirit and Intellect upgrades." },
                { skill = 80, name = "Woolen Bag (8-Slot)", mats = "Bolt of Woolen Cloth x3, Fine Thread x1", notes = "Upgrade all inventory slots to 8-slot bags." },
                { skill = 95, name = "Gray Woolen Robe", mats = "Bolt of Woolen Cloth x4, Fine Thread", notes = "Solid Stamina/Spirit leveling chest." }
            },
            shoppingList = {
                "Linen Cloth x 80-100",
                "Wool Cloth x 60-80",
                "Coarse Thread x 20-30",
                "Fine Thread x 20-30"
            }
        },

        [2] = {
            range = "Skill 100–225",
            milestones = {
                { skill = 125, name = "Spidersilk Boots", mats = "Silk Cloth, Thick Spider's Silk x2", notes = "+4 Stamina, +4 Intellect, +7 Spirit." },
                { skill = 150, name = "Small Silk Pack (10-Slot)", mats = "Bolt of Silk Cloth x3, Heavy Leather x2", notes = "High-demand 10-slot bag." },
                { skill = 175, name = "Crimson Silk Set (Vest, Pantaloons, Gloves)", mats = "Bolt of Silk Cloth, Red Dye, Silken Thread", notes = "High Intellect & Fire Spell Damage for leveling Mages/Warlocks." },
                { skill = 215, name = "Shadoweave Set (Pants, Robe, Boots, Shoulders)", mats = "Bolt of Mageweave, Shadow Oil", notes = "MUST-HAVE for Shadow Priests and Warlocks (+Shadow Spell Damage)!" }
            },
            shoppingList = {
                "Silk Cloth x 160-200",
                "Mageweave Cloth x 100-140",
                "Silken Thread x 30-40",
                "Shadow Oil x 8-12 (for Shadoweave)"
            }
        },

        [3] = {
            range = "Skill 200–260",
            milestones = {
                { skill = 225, name = "Mageweave Bag (12-Slot)", mats = "Bolt of Mageweave x4, Silken Thread x2", notes = "Standard mid-level inventory expansion." },
                { skill = 225, name = "Dreamweave Vest, Gloves & Circlet", mats = "Bolt of Mageweave, Wildvine, Heart of the Wild", notes = "Massive +Spell Damage and +Healing pieces at levels 40–45!" },
                { skill = 250, name = "Mooncloth Transmute (4-Day Cooldown!)", mats = "Felcloth x2 (at any Moonwell)", notes = "UNLOCK AT 250 IMMEDIATELY! Passive gold generator and crafting reagent." },
                { skill = 260, name = "Runecloth Bag (14-Slot)", mats = "Bolt of Runecloth x5, Rugged Leather x2", notes = "Best standard 14-slot inventory bag." }
            },
            shoppingList = {
                "Mageweave Cloth x 120-160",
                "Wildvine x 8-12",
                "Runecloth x 100-140",
                "Felcloth x 4-8 (for Mooncloth cooldowns)"
            }
        },

        [4] = {
            range = "Skill 260–300",
            milestones = {
                { skill = 275, name = "Felcloth Pants, Hood & Shoulders", mats = "Bolt of Runecloth, Felcloth, Demonic Rune", notes = "High Shadow Spell Damage pre-raid BIS for Warlocks/Shadow Priests." },
                { skill = 300, name = "Truefaith Vestments / Robe of the Archmage / Robe of the Void", mats = "Mooncloth, Essence of Fire/Mana/Undeath", notes = "BoP Masterpiece Chests: Pre-Raid and Tier-1 BIS for Priests, Mages, and Warlocks!" },
                { skill = 300, name = "Bloodvine Set (Vest, Leggings, Boots)", mats = "Bloodvine, Mooncloth, Enchanted Leather", notes = "GOD-TIER CASTER SET: +4% Spell Hit and +2% Spell Crit (with 300 Tailoring set bonus)!" }
            },
            shoppingList = {
                "Runecloth x 200-260",
                "Mooncloth x 6-12",
                "Felcloth x 12-20",
                "Bloodvine x 11 (for 3pc Bloodvine Set)"
            },
            ahProfits = {
                { item = "Mooncloth (Every 4 Days)", notes = "Transmute 2 Felcloth into 1 Mooncloth at any Moonwell for steady passive profit." },
                { item = "14-Slot Runecloth Bags & 16-Slot Mooncloth Bags", notes = "Continuous demand from every player and alt on the server." },
                { item = "Bloodvine Set Pieces", notes = "Every raid Mage, Warlock, Elemental Shaman, and Balance Druid buys this set." }
            }
        }
    },
    macros = {
        {
            category = "Profession / Utility",
            title = "First Aid / Cloth: Heavy Runecloth Bandage",
            desc = "Applies Heavy Runecloth Bandage on friendly mouseover or yourself without losing target.",
            code = "#showtooltip Heavy Runecloth Bandage\n/use [@mouseover,help,nodead][@player] Heavy Runecloth Bandage"
        }
    }
}

FTG:RegisterProfModule("TAILORING", TailoringModule)
