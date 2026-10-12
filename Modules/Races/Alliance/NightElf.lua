--[[
    ForeverTankGuide - Modules/Races/Alliance/NightElf.lua
    Night Elf Racials, Passives, Synergies, Quest Routing, and Macros
]]

local ADDON_NAME, FTG = ...

local NightElfModule = {
    name = "Night Elf",
    token = "NIGHTELF",
    faction = "Alliance",
    description = "Passive avoidance master. Quickness grants a permanent +1% Dodge bonus. Shadowmeld enables unique ambushes and safe out-of-combat drop tricks.",
    brackets = {
        [1] = {
            zones = {
                { name = "Shadowglen (Teldrassil)", range = "1–6", notes = "Night Elf starting glade: Nightsabers, Webwood Spiders, and Grellkin quests." },
                { name = "Teldrassil / Dolanaar", range = "6–10", notes = "Dolanaar hub: Starbreeze Village, Ban'ethil Barrow Den, and Darnassus transition." },
                { name = "Darkshore (Auberdine) & Ashenvale", range = "10–20", notes = "Auberdine long coastline quest chains, Moonkin caves, and Astranaar (Ashenvale) border." }
            },
            racials = {
                { name = "Quickness", desc = "Increases chance to dodge melee and ranged attacks by 1% passively. Pure mitigation." },
                { name = "Shadowmeld", desc = "Blend into shadows while motionless. Out-of-combat stealth allowing stealth pulls or safe eating/drinking." },
                { name = "Nature Resistance", desc = "+10 Nature Resistance passively. Great against poison and nature spells." },
                { name = "Wisp Spirit", desc = "Increases speed while dead by 50% (makes inevitable dungeon corpse runs much faster)." }
            },
            tankTips = {
                "Quickness contributes directly to pushing crushing and critical strikes off the combat table for Warriors, Paladins, and Druids.",
                "Use Shadowmeld while waiting for mana or healer bio breaks to avoid wandering patrol agro."
            }
        },
        [2] = {
            zones = {
                { name = "Ashenvale (Astranaar) & Stonetalon Peak", range = "20–28", notes = "Astranaar Sentinel quests, Blackfathom Deeps dungeon runs, and Stonetalon Peak." },
                { name = "Duskwood (Darkshire) & Wetlands (Menethil)", range = "24–32", notes = "Eastern Kingdoms crossover for dense Darkshire and Menethil Harbor quest chains." },
                { name = "Hillsbrad Foothills (Southshore) & Arathi (Refuge Pointe)", range = "28–38", notes = "Southshore and Refuge Pointe Alliance hubs." },
                { name = "Stranglethorn Vale (Rebel Camp) & Desolace (Nijel's Point)", range = "32–40", notes = "Nijel's Point Night Elf outpost in Desolace + STV Rebel Camp." }
            },
            tankTips = {
                "In Blackfathom Deeps, Nature Resistance mitigates naga and hydra poison spit."
            }
        },
        [3] = {
            zones = {
                { name = "Feralas (Feathermoon Stronghold)", range = "40–48", notes = "Feathermoon Stronghold Night Elf sentinel fortress: Gordunni ogres, Yetis, and Maraudon." },
                { name = "Tanaris (Gadgetzan)", range = "42–50", notes = "Wastewander bandits, Southsea pirates, and Zul'Farrak dungeon quest stack." },
                { name = "The Hinterlands (Aerie Peak)", range = "43–50", notes = "Aerie Peak Alliance hub: Witherbark trolls and Jintha'Alor elite quests." },
                { name = "Azshara (Talrendis Point) & Searing Gorge", range = "48–52", notes = "Highborne ruins in Azshara and Thorium Point in Searing Gorge." }
            },
            tankTips = {
                "As a Night Elf Feral Druid or Rogue Tank, Quickness stacks directly with high Agility for extreme Dodge percentages."
            }
        },
        [4] = {
            zones = {
                { name = "Felwood (Emerald Sanctuary) & Un'Goro Crater", range = "50–55", notes = "Emerald Sanctuary Night Elf quests, Timbermaw Hold rep, and Un'Goro circuit." },
                { name = "Western Plaguelands (Chillwind Camp)", range = "52–58", notes = "Chillwind Camp Alliance hub: Scourge cauldrons and Scholomance key chain." },
                { name = "Winterspring (Everlook & Starfall Village)", range = "54–60", notes = "Starfall Village Night Elf hub, Winterfall furbolgs, and Frostsaber trainers." },
                { name = "Eastern Plaguelands & Burning Steppes", range = "55–60", notes = "Morgan's Vigil (Onyxia attunement), Blackrock Depths, and Stratholme." }
            },
            tankTips = {
                "In endgame dungeons (Strat, Scholo, BRD), +1% passive Dodge provides consistent damage avoidance across hundreds of melee swings."
            }
        }
    },
    macros = {
        {
            category = "Racial / Utility",
            title = "Night Elf: Shadowmeld Rest",
            desc = "Activates Shadowmeld to stealth and eat/drink without aggroing wandering dungeon patrols.",
            code = "#showtooltip Shadowmeld\n/stopattack\n/cast Shadowmeld"
        }
    }
}

FTG:RegisterRaceModule("NIGHTELF", NightElfModule)
