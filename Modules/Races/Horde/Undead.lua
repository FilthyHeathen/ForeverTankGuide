--[[
    ForeverTankGuide - Modules/Races/Horde/Undead.lua
    Forsaken (Undead) Racials, Passives, Synergies, Quest Routing, and Macros
]]

local ADDON_NAME, FTG = ...

local UndeadModule = {
    name = "Undead (Forsaken)",
    token = "UNDEAD",
    faction = "Horde",
    description = "Iconic Forsaken undead durability. Immune to fear/charm via Will of the Forsaken, out-of-combat regeneration with Cannibalize, and inherent Shadow Resistance.",
    brackets = {
        [1] = {
            zones = {
                { name = "Deathknell (Tirisfal Glades)", range = "1–6", notes = "Forsaken starting crypts. Complete Mindless Zombie, Night Web Spider, and Scarlet Convert quests." },
                { name = "Tirisfal Glades / Brill", range = "6–10", notes = "Brill quest hub: Agamand Mills, Solliden Farmstead, and Undercity delivery chains." },
                { name = "Silverpine Forest / The Sepulcher", range = "10–20", notes = "The Sepulcher hub, Ambermill mages, Pyrewood Village elites, and Shadowfang Keep dungeon quests." }
            },
            racials = {
                { name = "Will of the Forsaken", desc = "Removes and grants 5 sec immunity to Charm, Fear, and Sleep effects (2 min cooldown)." },
                { name = "Cannibalize", desc = "Regenerates 7% of total health every 2 sec for 10 sec by consuming a nearby humanoid or undead corpse." },
                { name = "Shadow Resistance", desc = "+10 Shadow Resistance passively. Mitigates warlock and undead caster dungeon spikes." },
                { name = "Underwater Breathing", desc = "Increases underwater breath duration by 300% (ideal for sunken chests and Wailing Caverns/dungeon transit)." }
            },
            tankTips = {
                "Keep Will of the Forsaken on an immediate panic keybind—breaking fear immediately prevents boss packs from wiping your group.",
                "Use Cannibalize between trash pulls to save healer mana and minimize food downtime."
            }
        },
        [2] = {
            zones = {
                { name = "Hillsbrad Foothills (Tarren Mill)", range = "20–30", notes = "Tarren Mill Horde quest hub: Battle of Hillsbrad, Durnholde Keep, and Southshore border skirmishes." },
                { name = "Thousand Needles (Freewind Post)", range = "25–35", notes = "Freewind Post cliff hub and Mirage Raceway (Shimmering Flats) high-density quest loop." },
                { name = "Arathi Highlands (Hammerfall)", range = "30–40", notes = "Hammerfall Horde outpost: Witherbark trolls, Syndicate, and Stromgarde Keep elite badges." },
                { name = "Stranglethorn Vale (Grom'gol Base Camp)", range = "30–40", notes = "Grom'gol Zeppelin hub + Nesingwary's Expedition beast hunting chains." }
            },
            tankTips = {
                "In Scarlet Monastery Graveyard, your native +10 Shadow Resistance significantly mitigates shadow bolt volleys from necromancers."
            }
        },
        [3] = {
            zones = {
                { name = "Badlands (Kargath)", range = "40–45", notes = "Kargath Horde outpost, Uldaman dungeon pre-quests, and elemental farming." },
                { name = "Feralas (Camp Mojache)", range = "42–50", notes = "Camp Mojache Horde hub: Gordunni ogres, Woodpaw gnolls, and Dire Maul / Maraudon prep." },
                { name = "Tanaris (Gadgetzan)", range = "42–50", notes = "Wastewander bandits, Dunemaul ogres, and Zul'Farrak dungeon quest stack." },
                { name = "The Hinterlands (Revantusk Village)", range = "45–52", notes = "Revantusk Village Horde coastal hub: Jintha'Alor elite troll city and ZF Mallet." }
            },
            tankTips = {
                "In Zul'Farrak and Maraudon, cannibalizing humanoid troll corpses keeps dungeon clear pacing ultra fast."
            }
        },
        [4] = {
            zones = {
                { name = "Felwood (Bloodvenom Post)", range = "50–55", notes = "Bloodvenom Post Horde hub: Timbermaw Hold reputation, Corrupt Sabers, and Felcloth." },
                { name = "Un'Goro Crater (Marshal's Refuge)", range = "51–56", notes = "Massive circular quest circuit, Power Crystals, and Devilsaur leather." },
                { name = "Western & Eastern Plaguelands (Bulwark / Light's Hope)", range = "52–60", notes = "The Bulwark (Tirisfal border) and Light's Hope Chapel: Argent Dawn, Scholomance, and Stratholme." },
                { name = "Winterspring (Everlook)", range = "55–60", notes = "Winterfall furbolg farming, Frostmaul giants, and pre-raid BIS preparation." }
            },
            tankTips = {
                "In Stratholme and Scholomance, Will of the Forsaken lets you ignore Baron Rivendare and Malor fear mechanics completely."
            }
        }
    },
    macros = {
        {
            category = "Defensive / Tank",
            title = "Forsaken: Will of the Forsaken Break",
            desc = "Instantly breaks charm, fear, and sleep effects and resumes auto attack immediately.",
            code = "#showtooltip Will of the Forsaken\n/stopcasting\n/cast Will of the Forsaken\n/startattack"
        },
        {
            category = "Racial / Utility",
            title = "Forsaken: Corpse Cannibalize",
            desc = "Consumes target corpse to rapidly restore 35% health without spending food items.",
            code = "#showtooltip Cannibalize\n/cast Cannibalize"
        }
    }
}

FTG:RegisterRaceModule("UNDEAD", UndeadModule)
FTG:RegisterRaceModule("SCOURGE", UndeadModule)
