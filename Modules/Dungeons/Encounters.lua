--[[
    Heathen's Forever Guide - Modules/Dungeons/Encounters.lua
    Universal Dungeon Progression, Multi-Role Drop Tables ([Tank], [Heal], [DPS]), and Checklist Keys
]]

local ADDON_NAME, FTG = ...

local EncountersModule = {
    brackets = {
        [1] = {
            dungeons = {
                {
                    key = "rfc",
                    name = "Ragefire Chasm",
                    level = "13â€“16",
                    location = "Orgrimmar",
                    notes = "Basic positioning test. Pull shamans away from packs; interrupt Healing Wave.",
                    drops = {
                        { id = "rfc_1", role = "HEAL", name = "Crystalline Cuffs", slot = "Wrists (Cloth)", boss = "Taragaman", notes = "Solid intellect/spirit boost for healers and casters." },
                        { id = "rfc_2", role = "TANK", name = "Subterranean Cape", slot = "Back", boss = "Taragaman", notes = "Early armor and stamina cloak." },
                        { id = "rfc_3", role = "DPS", name = "Chanting Blade", slot = "Dagger", boss = "Bazzalan", notes = "Fast early melee weapon." }
                    }
                },
                {
                    key = "wc",
                    name = "Wailing Caverns",
                    level = "18â€“22",
                    location = "The Barrens",
                    notes = "Watch for Druid of the Fang sleep casts. Keep mobs bundled and interrupt Naralex's Nightmare.",
                    drops = {
                        { id = "wc_1", role = "TANK", name = "Mutant Breastplate", slot = "Chest (Mail)", boss = "Mutanus", notes = "Top tier early tank armor and stamina." },
                        { id = "wc_2", role = "TANK", name = "Kresh's Back", slot = "Shield", boss = "Kresh", notes = "Outstanding high-armor early shield." },
                        { id = "wc_3", role = "ALL", name = "Crescent Staff", slot = "Staff (Quest)", boss = "Leaders of the Fang", notes = "Massive weapon damage & stats for Druids, Warriors, Shamans, Priests, Mages!" },
                        { id = "wc_4", role = "DPS", name = "Leggings of the Fang", slot = "Legs (Leather)", boss = "Lord Cobrahn", notes = "Best agility/strength leather pants in Phase 1." },
                        { id = "wc_5", role = "HEAL", name = "Robe of the Moccasin", slot = "Chest (Cloth)", boss = "Lord Pythas", notes = "High Spirit/Intellect healer robe." }
                    }
                },
                {
                    key = "dm",
                    name = "The Deadmines",
                    level = "17â€“21",
                    location = "Westfall",
                    notes = "Watch patrolling stealthed Defias cutthroats behind your party after clearing each room.",
                    drops = {
                        { id = "dm_1", role = "DPS", name = "Smite's Mighty Hammer", slot = "Two-Hand Mace", boss = "Mr. Smite", notes = "Incredible slow 2H mace for Ret Paladins, Warriors, Feral Druids." },
                        { id = "dm_2", role = "DPS", name = "Cruel Barb", slot = "One-Hand Sword", boss = "Edwin VanCleef", notes = "+12 Attack Power sword for Rogues, Warriors, Hunters." },
                        { id = "dm_3", role = "HEAL", name = "Emberstone Staff", slot = "Staff", boss = "Captain Greenskin", notes = "Huge Intellect/Spirit staff for Healers and Casters." },
                        { id = "dm_4", role = "TANK", name = "Cape of the Brotherhood", slot = "Back", boss = "Edwin VanCleef", notes = "Agility and Stamina cloak." }
                    }
                }
            }
        },

        [2] = {
            dungeons = {
                {
                    key = "sfk",
                    name = "Shadowfang Keep",
                    level = "22â€“26",
                    location = "Silverpine Forest",
                    notes = "Watch for Arugal Mind Control and Veil of Shadow (-75% healing reduction curse!).",
                    drops = {
                        { id = "sfk_1", role = "TANK", name = "Commander's Crest", slot = "Shield", boss = "Commander Springvale", notes = "Iconic tank/healer shield with block, stamina & spirit." },
                        { id = "sfk_2", role = "HEAL", name = "Feline Mantle & Robes of Arugal", slot = "Shoulders / Chest", boss = "Wolf Master Nandos / Arugal", notes = "Best-in-bracket Intellect/Spirit cloth until level 35!" },
                        { id = "sfk_3", role = "DPS", name = "Meteor Shard", slot = "Dagger", boss = "Archmage Arugal", notes = "High DPS fire-proc dagger." }
                    }
                },
                {
                    key = "rfk",
                    name = "Razorfen Kraul",
                    level = "29â€“34",
                    location = "Southern Barrens",
                    notes = "Pull quilboar casters back behind corners; destroy Earthgrab and Healing totems immediately.",
                    drops = {
                        { id = "rfk_1", role = "TANK", name = "Heart of Agamaggan", slot = "Shield", boss = "Charlga Razorflank", notes = "High armor, stamina, and spirit shield." },
                        { id = "rfk_2", role = "DPS", name = "Corpsemaker", slot = "Two-Hand Axe", boss = "Overlord Ramtusk", notes = "Massive 3.80 speed 2H Axe for Warriors, Enhancement Shamans, Ret Paladins." },
                        { id = "rfk_3", role = "DPS", name = "Swine Fists", slot = "Hands (Mail)", boss = "Charlga Razorflank", notes = "High strength gauntlets." }
                    }
                },
                {
                    key = "sm",
                    name = "Scarlet Monastery (GY / Lib / Arm / Cath)",
                    level = "32â€“42",
                    location = "Tirisfal Glades",
                    notes = "Clear surrounding rooms before engaging Mograine; stun fleeing Scarlet humanoids at 15% HP.",
                    drops = {
                        { id = "sm_1", role = "TANK", name = "Aegis of the Scarlet Commander", slot = "Shield", boss = "Mograine (Cathedral)", notes = "Premier tanking shield with high armor and block." },
                        { id = "sm_2", role = "DPS", name = "Ravager & Herod's Shoulder", slot = "2H Axe / Shoulder", boss = "Herod (Armory)", notes = "Iconic AoE bladestorm axe and mail shoulders." },
                        { id = "sm_3", role = "HEAL", name = "Whitemane's Chapeau & Triune Amulet", slot = "Head / Neck", boss = "High Inquisitor Whitemane", notes = "Massive Intellect/Spirit headpiece and neck for Healers/Casters." },
                        { id = "sm_4", role = "DPS", name = "Hypnotic Blade & Illusionary Rod", slot = "Dagger / Staff", boss = "Arcanist Doan (Library)", notes = "Top spell damage weapons." }
                    }
                }
            }
        },

        [3] = {
            dungeons = {
                {
                    key = "zf",
                    name = "Zul'Farrak",
                    level = "43â€“47",
                    location = "Tanaris",
                    notes = "Kill Witch Doctor Zum'rah totems immediately; use AoE control on the Pyramid stairs event.",
                    drops = {
                        { id = "zf_1", role = "DPS", name = "Sang'thraze / Jang'thraze (Sul'thraze)", slot = "Swords", boss = "Antu'sul / Chief Ukorz", notes = "High DPS swords." },
                        { id = "zf_2", role = "HEAL", name = "Bad Mojo Mask & Jinxed Hoodoo Kilt", slot = "Head / Legs", boss = "Zum'rah / Sezz'ziz", notes = "Intellect and Spell/Healing power." },
                        { id = "zf_3", role = "TANK", name = "Jinxed Hoodoo Skin", slot = "Chest (Leather)", boss = "Shadowpriest Sezz'ziz", notes = "Stamina and agility chest." }
                    }
                },
                {
                    key = "mara",
                    name = "Maraudon",
                    level = "46â€“52",
                    location = "Desolace",
                    notes = "Princess Theradras drops an AoE fear + dust field; ranged DPS and Healers must stand at max 30yd range.",
                    drops = {
                        { id = "mara_1", role = "TANK", name = "Mark of the Chosen", slot = "Trinket (Quest)", boss = "Pariah's Instructions", notes = "MUST-HAVE TANK TRINKET: 2% chance when hit to gain +25 to ALL stats for 1 min!" },
                        { id = "mara_2", role = "DPS", name = "Blackstone Ring", slot = "Finger", boss = "Princess Theradras", notes = "PRE-RAID BIS: +20 Attack Power and +1% Melee/Ranged Hit!" },
                        { id = "mara_3", role = "DPS", name = "Thrash Blade", slot = "One-Hand Sword (Quest)", boss = "Corruption of Earth and Seed", notes = "Extra-attack proc sword for Warriors, Rogues, Hunters!" },
                        { id = "mara_4", role = "HEAL", name = "Charstone Dirk", slot = "Dagger", boss = "Princess Theradras", notes = "Intellect and MP5 caster/healer dagger." }
                    }
                }
            }
        },

        [4] = {
            dungeons = {
                {
                    key = "brd",
                    name = "Blackrock Depths (BRD)",
                    level = "52â€“58",
                    location = "Blackrock Mountain",
                    notes = "Arena, Angerforge, Golem Lord, and Emperor runs provide foundational Pre-Raid BIS for all 3 roles.",
                    drops = {
                        { id = "brd_1", role = "TANK", name = "Force of Will & Naglering", slot = "Trinket / Finger", boss = "Angerforge / Golem Lord", notes = "Top pre-raid defensive proc trinket and thorny threat ring." },
                        { id = "brd_2", role = "DPS", name = "Hand of Justice & Savage Gladiator Chain", slot = "Trinket / Chest", boss = "Emperor / Arena", notes = "FOREVER BIS melee proc trinket (+20 AP, 2% extra swing) and +2% Crit chest!" },
                        { id = "brd_3", role = "HEAL", name = "Second Wind & Ban'thok Sash", slot = "Trinket / Waist", boss = "Golem Lord / Arena", notes = "+22 Healing + 300 Mana restore trinket (Healers) and +1% Spell Hit belt (Casters)!" }
                    }
                },
                {
                    key = "strat",
                    name = "Stratholme (Live & Undead)",
                    level = "58â€“60",
                    location = "Eastern Plaguelands",
                    notes = "Line-of-Sight (LOS) pull caster gargoyles and skeleton mages around gate corners.",
                    drops = {
                        { id = "strat_1", role = "TANK", name = "Deathbone Set & Skullplate Shield", slot = "Plate / Shield", boss = "Undead Bosses / Malor", notes = "High Defense and MP5 plate tank set." },
                        { id = "strat_2", role = "HEAL", name = "Robes of the Exalted & Tooth of Gnarr", slot = "Chest / Neck", boss = "Baron Rivendare / Balnazzar", notes = "+68 Healing chestâ€”Pre-Raid BIS for Priests, Druids, Shamans, Paladins!" },
                        { id = "strat_3", role = "DPS", name = "Mask of the Unforgiven & Carapace Spine Crossbow", slot = "Head / Ranged", boss = "The Unforgiven / Nerub'enkan", notes = "+2% Hit/+1% Crit helm (Melee) and Pre-Raid BIS Crossbow (Hunters)!" }
                    }
                },
                {
                    key = "scholo",
                    name = "Scholomance",
                    level = "58â€“60",
                    location = "Western Plaguelands",
                    notes = "Silence and LOS pull Necromancers; keep tanks topped before Rattlegore thrash strikes.",
                    drops = {
                        { id = "scholo_1", role = "TANK", name = "Deathbone Legguards & Bonechill Hammer", slot = "Plate / Mace", boss = "Krastinov / Ras Frostwhisper", notes = "Core pre-raid Defense pieces." },
                        { id = "scholo_2", role = "DPS", name = "Mirah's Song & Star of Mystaria", slot = "Sword / Neck", boss = "Kirtonos Quest / Balnazzar", notes = "Pre-Raid BIS off-hand sword (Melee) and +1% Spell Hit neck (Casters)." },
                        { id = "scholo_3", role = "HEAL", name = "Animated Chain Necklace", slot = "Neck", boss = "Rammers", notes = "+33 Healing neck." }
                    }
                },
                {
                    key = "ubrs",
                    name = "Upper Blackrock Spire (UBRS)",
                    level = "58â€“60",
                    location = "Blackrock Mountain",
                    notes = "10-man raid dungeon. Jed Runewatcher (rare spawn!), Rend Blackhand, and General Drakkisath.",
                    drops = {
                        { id = "ubrs_1", role = "TANK", name = "Draconian Deflector", slot = "Shield", boss = "General Drakkisath", notes = "Best pre-raid mitigation shield in vanilla (+10 Defense, +7 Stamina, Fire Resist)." },
                        { id = "ubrs_2", role = "DPS", name = "Blackhand's Breadth & Dal'Rend's Sacred Charge", slot = "Trinket / Swords", boss = "Drakkisath Quest / Rend", notes = "+2% Crit trinket (ALL Melee/Hunters) and iconic dual-wield sword set!" },
                        { id = "ubrs_3", role = "HEAL", name = "Briarwood Reed & Tooth of Gnarr", slot = "Trinket / Neck", boss = "Jed Runewatcher / Drakkisath", notes = "+29 Spell Damage & Healing trinket (Pre-Raid BIS for ALL Casters & Healers)!" },
                        { id = "ubrs_4", role = "DPS", name = "Truestrike Shoulders", slot = "Shoulders (Leather)", boss = "Pyroguard Emberseer", notes = "+2% Hit and +24 AP shoulders for Warriors, Rogues, Hunters, Ferals, Ret!" }
                    }
                }
            }
        }
    }
}

FTG:RegisterDungeonData(EncountersModule)
