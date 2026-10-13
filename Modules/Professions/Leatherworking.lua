--[[
    Heathen's Forever Guide - Modules/Professions/Leatherworking.lua
    Leatherworking Progression: Armor Kits, Wolfshead Helm, Devilsaur Set, and Hide of the Wild
]]

local ADDON_NAME, HFG = ...

local LeatherworkingModule = {
    name = "Leatherworking",
    token = "LEATHERWORKING",
    description = "Essential leather & mail crafting for Feral Tanks/Cats, Rogues, Hunters, and Healers. Craft Armor Kits, Wolfshead Helm, the +2% Hit Devilsaur Set, and Hide of the Wild.",
    brackets = {
        [1] = {
            range = "Skill 1–100",
            milestones = {
                { skill = 1, name = "Light Armor Kit", mats = "Light Leather x1", notes = "Permanently adds +8 Armor to chest, boots, gloves, or pants." },
                { skill = 40, name = "Medium Armor Kit", mats = "Medium Leather x1", notes = "Permanently adds +16 Armor to an armor slot." },
                { skill = 85, name = "Fine Leather Belt / Deviate Scale Belt", mats = "Medium Leather / Deviate Scale", notes = "High Agility/Stamina belt for early dungeons." }
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
                { skill = 100, name = "Heavy Armor Kit", mats = "Heavy Leather x5, Fine Thread x1", notes = "Permanently adds +24 Armor to an armor slot." },
                { skill = 150, name = "Thick Armor Kit", mats = "Thick Leather x5, Silken Thread x1", notes = "Permanently adds +32 Armor to an armor slot." },
                { skill = 175, name = "Barbaric Shoulders & Nightscape Tunic", mats = "Heavy/Thick Leather, Silken Thread", notes = "Agility and Attack Power leather for Rogues, Hunters, and Ferals." },
                { skill = 205, name = "Turtle Scale Mail Set", mats = "Thick Leather, Turtle Scale", notes = "High Armor/Stamina/Spirit mail for Shamans and Hunters." }
            },
            shoppingList = {
                "Heavy Leather x 80-100",
                "Thick Leather x 80-100",
                "Silken Thread x 30-40",
                "Turtle Scale x 30-40"
            }
        },

        [3] = {
            range = "Skill 200–260 (Tribal / Elemental / Dragonscale)",
            milestones = {
                { skill = 200, name = "Rugged Armor Kit", mats = "Rugged Leather x5", notes = "Permanently adds +40 Armor to chest, legs, hands, or feet." },
                { skill = 225, name = "Wolfshead Helm (Tribal Specialization!)", mats = "Thick Leather x18, Wicked Claw x8, Wildvine x2", notes = "FOREVER BIS FOR FERAL DRUIDS: Grants +20 Energy every time you shift into Cat Form!" },
                { skill = 250, name = "Cured Rugged Hide (3-Day Cooldown!)", mats = "Rugged Hide x1, Deeprock Salt x1 (Salt Shaker)", notes = "Refined hide passive gold maker required for Hide of the Wild and Corehound." }
            },
            shoppingList = {
                "Rugged Leather x 120-150",
                "Wildvine x 10-15",
                "Deeprock Salt x 10-20"
            }
        },

        [4] = {
            range = "Skill 260–300",
            milestones = {
                { skill = 290, name = "Devilsaur Gauntlets & Leggings (2pc Set)", mats = "Devilsaur Leather x22, Rugged Leather x42", notes = "GOD-TIER MELEE SET: +2% Melee Hit, +28 Crit/Agi, and +74 Attack Power! BIS for Warriors, Rogues, Ferals, Hunters!" },
                { skill = 295, name = "Corehound Belt (Molten Core)", mats = "Corehound Leather x12, Cured Rugged Hide x2", notes = "+62 Healing & +1% Crit (Healers) or high Fire Resist." },
                { skill = 300, name = "Hide of the Wild (Tribal)", mats = "Cured Rugged Hide x3, Larval Acid x8, Essence of Water x10", notes = "+42 Healing, +10 Int, +8 Stamina—Best-in-Slot Healer Cloak for Priests, Druids, Shamans, Paladins!" }
            },
            shoppingList = {
                "Rugged Leather x 150-200",
                "Devilsaur Leather x 22 (Un'Goro Crater)",
                "Cured Rugged Hide x 3-6",
                "Essence of Water / Fire x 6-10"
            },
            ahProfits = {
                { item = "Devilsaur Gauntlets & Leggings Set", notes = "Every physical DPS class buys this set at level 53–60." },
                { item = "Hide of the Wild", notes = "Highest-selling crafted Healer cloak in the game." },
                { item = "Cured Rugged Hides (Salt Shaker Cooldown)", notes = "Passive gold every 3 days from your Salt Shaker." }
            }
        }
    },
    macros = {
        {
            category = "Defensive / Tank",
            title = "LW: Apply Rugged Armor Kit",
            desc = "Applies a +40 Armor Rugged Armor Kit to your chest piece.",
            code = "#showtooltip Rugged Armor Kit\n/use Rugged Armor Kit\n/use 5"
        }
    }
}

HFG:RegisterProfModule("LEATHERWORKING", LeatherworkingModule)
