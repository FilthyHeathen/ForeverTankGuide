--[[
    Heathen's Forever Guide - Modules/Professions/Engineering.lua
    Engineering Progression, Bombs, Sappers, Target Dummies, Goggles, and Commercial AH Tips
]]

local ADDON_NAME, FTG = ...

local EngineeringModule = {
    name = "Engineering",
    token = "ENGINEERING",
    description = "Undisputed champion profession for dungeon and raid tanking. Ranged pulls with dynamite, instant AoE snap threat with sappers, and clutch crowd control with target dummies.",
    brackets = {
        [1] = {
            range = "Skill 1â€“100",
            milestones = {
                { skill = 1, name = "Rough Copper Powder / Rough Dynamite", mats = "Rough Stone, Copper Bar", notes = "Quickly craft dynamite to unlock early ranged pulling." },
                { skill = 30, name = "Handful of Copper Bolts", mats = "Copper Bar", notes = "Save at least 20-30 for future crafts." },
                { skill = 75, name = "Coarse Dynamite / Small Bronze Bombs", mats = "Coarse Stone, Bronze Bar, Wool Cloth", notes = "Essential 30yd pull tool with small AoE disorient/stun." },
                { skill = 85, name = "Target Dummy", mats = "Copper Modulator, Bronze Bar, Wool Cloth", notes = "Absolute lifesaver for dropping emergency pack threat when healer pulls aggro." }
            },
            shoppingList = {
                "Rough Stone x 40-60",
                "Copper Bar x 60-80",
                "Coarse Stone x 30-40",
                "Bronze Bar x 30-50",
                "Wool Cloth x 20-30",
                "Silver Bar x 2 (optional trinket)"
            }
        },

        [2] = {
            range = "Skill 100â€“225",
            milestones = {
                { skill = 150, name = "Green Tinted Goggles", mats = "Medium Leather, Moss Agate", notes = "Great headpiece before high level dungeon helms." },
                { skill = 175, name = "Iron Grenades", mats = "Iron Bar x1, Heavy Blasting Powder x1, Silk Cloth x1", notes = "Cheap, lethal AoE incapacitate. Your core grouping tool for the next 20 levels!" },
                { skill = 185, name = "Advanced Target Dummy", mats = "Iron Strut, Bronze Framework, Gyrochronatom", notes = "High HP taunt totem. Survives boss auto-attacks during wipe recovery." }
            },
            shoppingList = {
                "Heavy Stone x 60-80",
                "Iron Bar x 80-100",
                "Silk Cloth x 40-50",
                "Solid Stone x 40-60",
                "Gold / Moss Agate x 4-6"
            }
        },

        [3] = {
            range = "Skill 200â€“260 (Goblin Specialization)",
            milestones = {
                { skill = 205, name = "Goblin Engineering Specialization", mats = "Gadgetzan Questline", notes = "Unlocks high-impact explosive recipes: Sapper Charges and The Big One." },
                { skill = 215, name = "Mithril Frag Bomb", mats = "Mithril Bar x3, Dense Blasting Powder x1", notes = "Huge AoE damage + 2 sec stun on up to 5 targets." },
                { skill = 215, name = "Goblin Sapper Charge", mats = "Mithril Casing, Solid Blasting Powder, Unstable Trigger", notes = "Instant 450-750 burst fire damage. Unlocks instantaneous AoE snap threat!" },
                { skill = 230, name = "The Big One", mats = "Mithril Casing, Goblin Rocket Fuel, Dense Powder", notes = "Massive 5 sec disorient radius." }
            },
            shoppingList = {
                "Mithril Bar x 100-140",
                "Solid Stone x 80-100",
                "Dense Stone x 60-80",
                "Mageweave Cloth x 40-50",
                "Goblin Rocket Fuel x 10-15"
            }
        },

        [4] = {
            range = "Skill 260â€“300",
            milestones = {
                { skill = 260, name = "Thorium Grenades", mats = "Thorium Bar x2, Dense Blasting Powder x1, Runecloth x1", notes = "Peak level ranged interrupt & AoE disorient." },
                { skill = 275, name = "Masterwork Target Dummy", mats = "Thorium Widget, Mithril Casing, Truesilver Bar", notes = "Extreme health pool dummy capable of holding raid trash packs." },
                { skill = 300, name = "Force Reactive Disk (Recipe Pursuit)", mats = "Thorium Bar, Arcanite Bar, Globe of Water, Essence of Air", notes = "HOLY GRAIL: Shield emits AoE electrical shockwave on every block, generating immense AoE threat!" }
            },
            shoppingList = {
                "Thorium Bar x 120-160",
                "Dense Stone x 100-120",
                "Runecloth x 60-80",
                "Truesilver Bar x 10-15",
                "Arcanite Bar x 2-4 (for Force Reactive Disk)"
            },
            ahProfits = {
                { item = "Goblin Sapper Charges", notes = "Raid staple for all melee and tanks. Consistently sells at high margins on raid reset nights." },
                { item = "Thorium Headed Arrows", notes = "Hunters pay top dollar for highest non-reputation ammunition." },
                { item = "Bronze Frameworks & Supply Crates", notes = "Essential for leveling other crafters and Darkmoon Faire turn-ins." },
                { item = "Sniper & Deadly Scopes", notes = "Always in demand by leveling hunters and rogue weapon buffs." }
            }
        }
    },
    macros = {
        {
            title = "Engineering: @cursor Grenades",
            desc = "Throws grenade instantly at cursor position without waiting for the ground reticle.",
            code = "#showtooltip Thorium Grenade\n/stopcasting\n/use [@cursor] Thorium Grenade"
        },
        {
            title = "Engineering: Snap Sapper Opener",
            desc = "Triggers defensive trinket 1, detonates Goblin Sapper Charge, and initiates attack for instant AoE snap agro.",
            code = "#showtooltip Goblin Sapper Charge\n/use 13\n/use Goblin Sapper Charge\n/startattack"
        }
    }
}

FTG:RegisterProfModule("ENGINEERING", EngineeringModule)
