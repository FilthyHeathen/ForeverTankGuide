--[[
    ForeverTankGuide - Modules/Races/Horde/SkyborneHorde.lua
    Skyborne (Horde) Cross-Faction Race Module: Racials, Faction-Routed Zones, Class Availability & Macros
]]

local ADDON_NAME, FTG = ...

local SkyborneHordeModule = {
    name = "Skyborne (Horde)",
    token = "SKYBORNE_HORDE",
    faction = "Horde",
    availableClasses = { "WARRIOR", "HUNTER", "ROGUE", "DRUID", "SHAMAN" },
    description = "Avian high-altitude vanguard aligned with the Horde. Unmatched vertical mobility with Aerial Glide, emergency AoE/peel via Gale Gust, and native Altitude Acclimation avoidance/resistance.",
    brackets = {
        [1] = {
            zones = {
                { name = "Skyborne Sanctuary (Horde Aerie)", range = "1–10", notes = "High-altitude starting sanctuary. Complete wind-trial rites and gather initial copper/herbs along the cliffside." },
                { name = "The Barrens (Crossroads & Camp Taurajo)", range = "10–20", notes = "Primary Horde transit hub. Central access to Wailing Caverns, Ragefire Chasm (Orgrimmar), and open plains." },
                { name = "Silverpine Forest (The Sepulcher)", range = "10–20", notes = "Alternative branch route. Dense undead/worggen quests and Shadowfang Keep preparation." }
            },
            racials = {
                { name = "Aerial Glide / Featherfall", desc = "Reduces falling speed dramatically, negating fall damage and enabling unique cliff pulls and dungeon ledge skips." },
                { name = "Gale Gust / Wind Surge", desc = "Unleashes a sudden wind blast (minor knockback/peel or burst movement speed). Ideal for Tank/Healer emergency peels or Melee gap-closing." },
                { name = "Altitude Acclimation / Gust Ward", desc = "Grants passive +10 Nature/Frost Resistance and +1% Dodge / Wind-borne agility." },
                { name = "Avian Keen-Sight", desc = "Enhanced scouting and gathering awareness across elevated terrain." }
            },
            tankTips = {
                "Use Aerial Glide during vertical dungeon drops (Wailing Caverns, Gnomeregan, Blackrock Depths) to bypass fall damage completely.",
                "Gale Gust serves as an instant emergency peel when caster or healer party members are swarmed by melee runners."
            }
        },
        [2] = {
            zones = {
                { name = "Hillsbrad Foothills (Tarren Mill)", range = "20–30", notes = "High-density Horde quest hub. Syndicate, yeti cave, and Southshore border skirmishes." },
                { name = "Thousand Needles (Freewind Post)", range = "25–35", notes = "Vertical mesa hub—Aerial Glide allows effortless descent from Freewind Post and Great Lift ledges!" },
                { name = "Arathi Highlands (Hammerfall)", range = "30–40", notes = "Troll, ogre, and Syndicate quests; rich Iron and Mithril deposits." },
                { name = "Stranglethorn Vale (Grom'gol Base Camp)", range = "30–40", notes = "Zeppelin access directly from Orgrimmar/Undercity; Nesingwary mastery quests." }
            },
            tankTips = {
                "In Thousand Needles and Arathi Highlands, use Aerial Glide to jump directly off Freewind Post or cliffs to engage quests without elevator wait times."
            }
        },
        [3] = {
            zones = {
                { name = "Tanaris (Gadgetzan)", range = "40–48", notes = "Wastewander bandits, pirates, and Zul'Farrak dungeon runs." },
                { name = "Feralas (Camp Mojache)", range = "42–50", notes = "Ogre ruins, yeti caves (leather/mining), and Dire Maul proximity." },
                { name = "The Hinterlands (Revantusk Village)", range = "45–52", notes = "Horde coastal troll hub! Elite Jintha'Alor quests reward top-tier dungeon trinkets and weapons." }
            },
            tankTips = {
                "Altitude Acclimation (+Nature/Frost resist) mitigates poison and cold damage spikes in Maraudon and Zul'Farrak."
            }
        },
        [4] = {
            zones = {
                { name = "Un'Goro Crater (Marshal's Refuge)", range = "50–55", notes = "Dense xp circuit, Devilsaur leather, and Rich Thorium Veins." },
                { name = "Felwood (Bloodvenom Post)", range = "50–56", notes = "Horde flight hub; Timbermaw Hold reputation and corrupted satyr farming." },
                { name = "Winterspring (Everlook)", range = "54–60", notes = "High-level Furbolg E'ko buffs and Rich Thorium routing." },
                { name = "Eastern Plaguelands (Light's Hope Chapel)", range = "55–60", notes = "Argent Dawn reputation, Stratholme, and Scholomance endgame prep." }
            },
            tankTips = {
                "In Blackrock Mountain and LBRS/UBRS, use Aerial Glide over lava/balcony drops for safe dungeon routing and wipe recovery."
            }
        }
    },
    macros = {
        {
            category = "Racial / Utility",
            title = "Skyborne: Disengage / Glide Escape",
            desc = "Casts Gale Gust in combat for an instant wind peel/surge, or Aerial Glide / Slow Fall out of combat.",
            code = "#showtooltip\n/stopcasting\n/cast [combat] Gale Gust\n/cast [nocombat] Slow Fall"
        },
        {
            category = "Racial / Utility",
            title = "Skyborne: Emergency Gale Gust Peel",
            desc = "Stops current cast and triggers Gale Gust immediately to peel melee attackers or burst forward.",
            code = "#showtooltip Gale Gust\n/stopcasting\n/cast Gale Gust"
        }
    }
}

FTG:RegisterRaceModule("SKYBORNE_HORDE", SkyborneHordeModule)
FTG:RegisterRaceModule("SKYBORNE", SkyborneHordeModule) -- Fallback if client returns "Skyborne"
