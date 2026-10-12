--[[
    ForeverTankGuide - Modules/Races/Alliance/SkyborneAlliance.lua
    Skyborne (Alliance) Cross-Faction Race Module: Racials, Faction-Routed Zones, Class Availability & Macros
]]

local ADDON_NAME, FTG = ...

local SkyborneAllianceModule = {
    name = "Skyborne (Alliance)",
    token = "SKYBORNE_ALLIANCE",
    faction = "Alliance",
    availableClasses = { "WARRIOR", "HUNTER", "ROGUE", "DRUID", "MAGE" },
    description = "Avian high-altitude vanguard aligned with the Alliance. Unmatched vertical mobility with Aerial Glide, emergency AoE/peel via Gale Gust, and native Altitude Acclimation avoidance/resistance.",
    brackets = {
        [1] = {
            zones = {
                { name = "Skyborne Aerie (Alliance Sanctuary)", range = "1–10", notes = "High-altitude starting aerie. Complete wind-trial rites and gather initial copper/herbs along the peaks." },
                { name = "Darkshore (Auberdine)", range = "10–20", notes = "Primary northern Alliance coastal hub. Dense quest chains and Blackfathom Deeps preparation." },
                { name = "Westfall (Sentinel Hill) & Redridge", range = "10–20", notes = "Eastern Kingdoms branch option. Defias Brotherhood questline leading directly into The Deadmines." }
            },
            racials = {
                { name = "Aerial Glide / Featherfall", desc = "Reduces falling speed dramatically, negating fall damage and enabling unique cliff pulls and dungeon ledge skips." },
                { name = "Gale Gust / Wind Surge", desc = "Unleashes a sudden wind blast (minor knockback/peel or burst movement speed). Ideal for Tank/Healer emergency peels or Mage/Hunter kiting." },
                { name = "Altitude Acclimation / Gust Ward", desc = "Grants passive +10 Nature/Frost Resistance and +1% Dodge / Wind-borne agility." },
                { name = "Avian Keen-Sight", desc = "Enhanced scouting and gathering awareness across elevated terrain." }
            },
            tankTips = {
                "Use Aerial Glide during vertical dungeon drops (Deadmines ship cavern, Gnomeregan, Blackrock Depths) to bypass fall damage completely.",
                "Gale Gust gives Alliance Tanks, Healers, and Mages an instant wind peel when swarmed by melee enemies."
            }
        },
        [2] = {
            zones = {
                { name = "Duskwood (Darkshire)", range = "20–30", notes = "Iconic Alliance undead/worgen storyline; Mor'Ladim and Stitches." },
                { name = "Hillsbrad Foothills (Southshore)", range = "22–32", notes = "Alliance coastal base; Syndicate, murlocs, and Alterac yeti caves." },
                { name = "Arathi Highlands (Refuge Pointe)", range = "30–40", notes = "Stromgarde Keep elite quests and rich Iron/Mithril mining nodes." },
                { name = "Stranglethorn Vale (Rebel Camp)", range = "30–40", notes = "Northern STV jungle hub and Nesingwary hunting mastery." }
            },
            tankTips = {
                "Use Aerial Glide from Lumber Mill or cliff ridges in Arathi and STV to traverse terrain rapidly."
            }
        },
        [3] = {
            zones = {
                { name = "Tanaris (Gadgetzan)", range = "40–48", notes = "Wastewander bandits, pirates, and Zul'Farrak dungeon runs." },
                { name = "Feralas (Feathermoon Stronghold)", range = "42–50", notes = "Island stronghold hub; Naga, ogre ruins, and Maraudon/Dire Maul prep." },
                { name = "The Hinterlands (Aerie Peak)", range = "43–52", notes = "Natural Wildhammer gryphon aerie hub—complete Troll cages and Jintha'Alor elite quests!" }
            },
            tankTips = {
                "Altitude Acclimation (+Nature/Frost resist) mitigates poison and cold damage spikes in Maraudon and Zul'Farrak."
            }
        },
        [4] = {
            zones = {
                { name = "Un'Goro Crater (Marshal's Refuge)", range = "50–55", notes = "Dense xp circuit, Devilsaur leather, and Rich Thorium Veins." },
                { name = "Western Plaguelands (Chillwind Camp)", range = "51–58", notes = "Alliance forward base for Cauldron quests and Scholomance key chain." },
                { name = "Winterspring (Everlook)", range = "54–60", notes = "High-level Furbolg E'ko buffs and Rich Thorium routing." },
                { name = "Eastern Plaguelands (Light's Hope Chapel)", range = "55–60", notes = "Argent Dawn reputation, Stratholme, and Scholomance endgame prep." }
            },
            tankTips = {
                "In Blackrock Mountain and LBRS/UBRS, use Aerial Glide over balcony drops for safe dungeon routing and wipe recovery."
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

FTG:RegisterRaceModule("SKYBORNE_ALLIANCE", SkyborneAllianceModule)
