--[[
    ForeverTankGuide - Modules/Races/Horde/Undead.lua
    Forsaken (Undead) Racials, Passives, Synergies, and Macros
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
                { name = "Tirisfal Glades", range = "1–10", notes = "Deathknell to Brill. Copper and tin veins, early undead quests." },
                { name = "Silverpine Forest", range = "10–20", notes = "Sepulcher base. Shadowfang Keep access and Ambermill syndicate camps." }
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
            tankTips = {
                "In Scarlet Monastery Graveyard, your native +10 Shadow Resistance significantly mitigates shadow bolt volleys from necromancers."
            }
        },
        [3] = {
            tankTips = {
                "In Zul'Farrak and Maraudon, cannibalizing humanoid troll corpses keeps dungeon clear pacing ultra fast."
            }
        },
        [4] = {
            tankTips = {
                "In Stratholme and Scholomance, Will of the Forsaken lets you ignore Baron Rivendare and Malor fear mechanics completely."
            }
        }
    },
    macros = {
        {
            title = "Forsaken: Will of the Forsaken Break",
            desc = "Instantly breaks charm, fear, and sleep effects and resumes auto attack immediately.",
            code = "#showtooltip Will of the Forsaken\n/stopcasting\n/cast Will of the Forsaken\n/startattack"
        },
        {
            title = "Forsaken: Corpse Cannibalize",
            desc = "Consumes target corpse to rapidly restore 35% health without spending food items.",
            code = "#showtooltip Cannibalize\n/cast Cannibalize"
        }
    }
}

FTG:RegisterRaceModule("UNDEAD", UndeadModule)
FTG:RegisterRaceModule("SCOURGE", UndeadModule)
