--[[
    ForeverTankGuide - Modules/Professions/Leatherworking.lua
    Leatherworking Progression, Armor Kits, and Feral Bear / Rogue Tank Sets
]]

local ADDON_NAME, FTG = ...

local LeatherworkingModule = {
    name = "Leatherworking",
    token = "LEATHERWORKING",
    description = "Armor kit reinforcements and feral/rogue avoidance armor. Core profession for Druid (Bear) and Rogue tanks wanting custom high armor pieces and Corehound sets.",
    brackets = {
        [1] = {
            range = "Skill 1–100",
            milestones = {
                { skill = 1, name = "Light Armor Kit", mats = "Light Leather x1", notes = "Permanently adds +8 Armor to chest, boots, gloves, or pants." },
                { skill = 40, name = "Medium Armor Kit", mats = "Medium Leather x1", notes = "Permanently adds +16 Armor to armor piece." },
                { skill = 85, name = "Fine Leather Belt / Tunic", mats = "Medium Leather, Coarse Thread", notes = "Early high agility/stamina pieces." }
            },
            shoppingList = {
                "Ruined Leather Scraps x 30-40",
                "Light Leather x 50-70",
                "Medium Leather x 40-60"
            }
        },

        [2] = {
            range = "Skill 100–225",
            milestones = {
                { skill = 100, name = "Heavy Armor Kit", mats = "Heavy Leather x3, Fine Thread x1", notes = "Permanently adds +24 Armor to an armor slot." },
                { skill = 150, name = "Thick Armor Kit", mats = "Thick Leather x4, Silken Thread x1", notes = "Permanently adds +32 Armor to an armor slot." },
                { skill = 175, name = "Barbaric Leggings & Shoulders", mats = "Heavy Leather, Moss Agate", notes = "High stamina mail/leather pieces." },
                { skill = 200, name = "Nightscape Set", mats = "Thick Leather, Silken Thread", notes = "Superb stealth, agility, and stamina stats for rogue/druid tanks." }
            },
            shoppingList = {
                "Heavy Leather x 80-100",
                "Thick Leather x 80-100",
                "Silken Thread x 30-40",
                "Moss Agate x 4-6"
            }
        },

        [3] = {
            range = "Skill 200–260 (Tribal / Dragonscale)",
            milestones = {
                { skill = 200, name = "Rugged Armor Kit", mats = "Rugged Leather x5", notes = "Permanently adds +40 Armor to chest, legs, hands, or feet." },
                { skill = 225, name = "Chimeric & Wild Leather Sets", mats = "Rugged Leather, Wildvine", notes = "High stamina and nature resistance." },
                { skill = 250, name = "Devilsaur Gauntlets & Leggings", mats = "Devilsaur Leather x30, Rugged Hide", notes = "Premier physical threat set: +2% Hit and +46 Attack Power!" }
            },
            shoppingList = {
                "Rugged Leather x 120-150",
                "Wildvine x 10-15",
                "Devilsaur Leather x 20-30"
            }
        },

        [4] = {
            range = "Skill 260–300",
            milestones = {
                { skill = 275, name = "Frostsaber & Stormshroud Sets", mats = "Rugged Leather, Essence of Water/Air", notes = "Extreme agility and dodge ratings." },
                { skill = 290, name = "Volcanic Leggings & Breastplate", mats = "Volcanic Hide, Core of Earth", notes = "High Fire Resistance gear for Molten Core preparation." },
                { skill = 300, name = "Corehound Belt / Hide of the Wild", mats = "Corehound Leather x12, Cured Rugged Hide x4", notes = "Best-in-slot stamina and survival belts for feral druids and rogues." }
            },
            shoppingList = {
                "Rugged Leather x 150-200",
                "Cured Rugged Hide x 10-15",
                "Corehound Leather x 12-20",
                "Essence of Fire / Water x 4-6"
            },
            ahProfits = {
                { item = "Devilsaur Armor Sets", notes = "High-margin crafts purchased by all physical classes reaching level 55-60." },
                { item = "Rugged Armor Kits", notes = "Continuous demand for tank leveling and gear enchantments." },
                { item = "Hide of the Wild", notes = "Top-selling healer/hybrid cloak in the entire game." }
            }
        }
    },
    macros = {
        {
            title = "Leatherworking: Apply Rugged Armor Kit",
            desc = "Applies your highest tier armor kit to chest armor.",
            code = "#showtooltip Rugged Armor Kit\n/use Rugged Armor Kit\n/use 5"
        }
    }
}

FTG:RegisterProfModule("LEATHERWORKING", LeatherworkingModule)
