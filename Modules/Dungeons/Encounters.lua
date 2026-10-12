--[[
    ForeverTankGuide - Modules/Dungeons/Encounters.lua
    Universal Dungeon Progression, Drop Tables, and Checklist Keys
]]

local ADDON_NAME, FTG = ...

local EncountersModule = {
    brackets = {
        [1] = {
            dungeons = {
                {
                    key = "rfc",
                    name = "Ragefire Chasm",
                    level = "13–16",
                    location = "Orgrimmar",
                    notes = "Basic positioning test. Pull shamans away from packs with ranged explosives.",
                    drops = {
                        { id = "rfc_1", name = "Crystalline Cuffs", slot = "Wrists", boss = "Taragaman", notes = "Solid stamina/intellect boost." },
                        { id = "rfc_2", name = "Subterranean Band", slot = "Finger", boss = "Maur Grimtotem", notes = "Early armor/stamina ring." }
                    }
                },
                {
                    key = "wc",
                    name = "Wailing Caverns",
                    level = "18–22",
                    location = "The Barrens",
                    notes = "Watch for sleep effects. Keep mobs bundled away from slumbered healers.",
                    drops = {
                        { id = "wc_1", name = "Mutant Breastplate", slot = "Chest (Mail)", boss = "Kresh", notes = "Top tier early tank armor." },
                        { id = "wc_2", name = "Crescent Staff / Kresh's Back", slot = "Shield / Weapon", boss = "Kresh", notes = "Kresh's Back is an outstanding +stamina shield." },
                        { id = "wc_3", name = "Leggings of the Fang", slot = "Legs (Leather/Mail)", boss = "Lord Cobrahn", notes = "Excellent agility/strength stats." }
                    }
                },
                {
                    key = "dm",
                    name = "The Deadmines",
                    level = "17–21",
                    location = "Westfall",
                    notes = "Defias cannon door and boat event. Watch patrolling stealthed Defias shadows.",
                    drops = {
                        { id = "dm_1", name = "Commander's Crest / Smite's Mighty Hammer", slot = "Weapon", boss = "Mr. Smite", notes = "High physical damage hammer." },
                        { id = "dm_2", name = "Cookie's Meat Mallet", slot = "One-Hand Mace", boss = "Cookie", notes = "Fast tanking swing speed." }
                    }
                }
            }
        },

        [2] = {
            dungeons = {
                {
                    key = "sfk",
                    name = "Shadowfang Keep",
                    level = "22–26",
                    location = "Silverpine Forest",
                    notes = "Watch for mind control and silence. Cleanse curses and magic rapidly.",
                    drops = {
                        { id = "sfk_1", name = "Commander's Crest", slot = "Shield", boss = "Commander Springvale", notes = "Iconic tank shield with block & stamina." },
                        { id = "sfk_2", name = "Silverlaine's Family Seal", slot = "Finger", boss = "Baron Silverlaine", notes = "Great stats for hybrid mana pools." }
                    }
                },
                {
                    key = "rfk",
                    name = "Razorfen Kraul",
                    level = "29–34",
                    location = "Southern Barrens",
                    notes = "Quilboar geometry. Pull casters back behind pillars before dropping AoE threat.",
                    drops = {
                        { id = "rfk_1", name = "Heart of Agamaggan", slot = "Shield", boss = "Charlga Razorflank", notes = "Solid armor and stamina." },
                        { id = "rfk_2", name = "Swine Fists", slot = "Hands (Mail)", boss = "Charlga Razorflank", notes = "High strength piece." }
                    }
                },
                {
                    key = "sm",
                    name = "Scarlet Monastery (GY / Lib / Arm / Cath)",
                    level = "32–42",
                    location = "Tirisfal Glades",
                    notes = "Peak tank proving grounds. Heavy undead in Graveyard; humanoid runners in Arms/Cath.",
                    drops = {
                        { id = "sm_1", name = "Herod's Shoulder", slot = "Shoulder (Mail)", boss = "Herod (Armory)", notes = "Massive stats for 37-40 leveling." },
                        { id = "sm_2", name = "Aegis of the Scarlet Commander", slot = "Shield", boss = "Mograine (Cathedral)", notes = "Pre-raid tier block rating and defense." },
                        { id = "sm_3", name = "Scarlet Leggings / Boots", slot = "Mail Set", boss = "Multiple Bosses", notes = "Incredible mail armor set bonus." }
                    }
                }
            }
        },

        [3] = {
            dungeons = {
                {
                    key = "zf",
                    name = "Zul'Farrak",
                    level = "43–47",
                    location = "Tanaris",
                    notes = "The iconic Pyramid stairs event. AoE threat + explosives shines here.",
                    drops = {
                        { id = "zf_1", name = "The Rockpounder", slot = "Two-Hand Mace", boss = "Chief Ukorz Sandscalp", notes = "Solid stat weapon." },
                        { id = "zf_2", name = "Bad Mojo Mask", slot = "Head", boss = "Witch Doctor Zum'rah", notes = "Decent stats/spirit." },
                        { id = "zf_3", name = "Jinxed Hoodoo Skin", slot = "Chest (Mail/Plate)", boss = "Shadowpriest Sezz'ziz", notes = "High defensive stats." }
                    }
                },
                {
                    key = "mara",
                    name = "Maraudon",
                    level = "46–52",
                    location = "Desolace",
                    notes = "Princess Theradras & Rotgrip. High poison and physical damage encounters.",
                    drops = {
                        { id = "mara_1", name = "Mark of the Chosen", slot = "Trinket", boss = "Centaur Quest / Maraudon", notes = "MUST-HAVE: 2% chance when hit to gain +25 to all stats for 1 min. Incredible for tanks." },
                        { id = "mara_2", name = "Gatorbite Axe", slot = "One-Hand Axe", boss = "Rotgrip", notes = "Fast weapon speed for steady proc generation." },
                        { id = "mara_3", name = "Blackstone Ring", slot = "Finger", boss = "Princess Theradras", notes = "1% Hit + +20 AP." }
                    }
                }
            }
        },

        [4] = {
            dungeons = {
                {
                    key = "brd",
                    name = "Blackrock Depths",
                    level = "52–58",
                    location = "Blackrock Mountain",
                    notes = "Massive sprawling complex. Key tank items from Emperor and General Angerforge.",
                    drops = {
                        { id = "brd_1", name = "Force of Will", slot = "Trinket", boss = "General Angerforge", notes = "Top pre-raid defensive trinket (extra armor on proc + defense)." },
                        { id = "brd_2", name = "Naglering", slot = "Finger", boss = "Golem Lord Argelmach", notes = "Reflects 3 Arcane damage on hit, triggers additional threat interactions." },
                        { id = "brd_3", name = "Ironfoe", slot = "One-Hand Mace", boss = "Emperor Thaurissan", notes = "Legendary multi-attack weapon for high proc generation." }
                    }
                },
                {
                    key = "strat",
                    name = "Stratholme (Live & Undead)",
                    level = "58–60",
                    location = "Eastern Plaguelands",
                    notes = "Undead side has dense ghoul and skeleton packs. Holy damage and AoE interrupts shine.",
                    drops = {
                        { id = "strat_1", name = "Skullplate Shield", slot = "Shield", boss = "Malor the Zealous", notes = "High armor, high block value." },
                        { id = "strat_2", name = "Medallion of the Grand Crusader", slot = "Trinket", boss = "Balnazzar", notes = "Great hybrid mana/defense." },
                        { id = "strat_3", name = "Deathbone Set (5pc)", slot = "Plate Set", boss = "Multiple Undead Bosses", notes = "Premier pre-raid Protection tank set (+Defense and +MP5)." }
                    }
                },
                {
                    key = "scholo",
                    name = "Scholomance",
                    level = "58–60",
                    location = "Western Plaguelands",
                    notes = "Cultist caster packs require LOS (Line of Sight) pulls behind doorways.",
                    drops = {
                        { id = "scholo_1", name = "Deathbone Legguards / Chest", slot = "Plate Set", boss = "Doctor Theolen Krastinov / Bosses", notes = "Essential defense set pieces." },
                        { id = "scholo_2", name = "Bonechill Hammer", slot = "One-Hand Mace", boss = "Ras Frostwhisper", notes = "High stamina cold proc mace." }
                    }
                },
                {
                    key = "ubrs",
                    name = "Upper Blackrock Spire (UBRS)",
                    level = "58–60",
                    location = "Blackrock Mountain",
                    notes = "10-man raid dungeon. Rend Blackhand and General Drakkisath.",
                    drops = {
                        { id = "ubrs_1", name = "Draconian Deflector", slot = "Shield", boss = "General Drakkisath", notes = "Best pre-raid mitigation shield in vanilla (+15 Defense, high block)." },
                        { id = "ubrs_2", name = "Blackstone Ring", slot = "Finger", boss = "Maraudon / UBRS drops", notes = "Key threat stat piece." }
                    }
                }
            }
        }
    }
}

FTG:RegisterDungeonData(EncountersModule)
