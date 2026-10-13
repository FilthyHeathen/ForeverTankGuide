--[[
    Heathen's Forever Guide - Modules/Races/Alliance/Gnome.lua
    Gnome Racials, Passives, Synergies, Quest Routing, and Macros
]]

local ADDON_NAME, FTG = ...

local GnomeModule = {
    name = "Gnome",
    token = "GNOME",
    faction = "Alliance",
    description = "Root break mobility king and Engineering specialist. Escape Artist removes immobilizing effects. Engineering Specialization (+15 skill) unlocks high-tier explosives early.",
    brackets = {
        [1] = {
            zones = {
                { name = "Coldridge Valley (Dun Morogh)", range = "1–6", notes = "Gnome & Dwarf starting valley: Rockjaw Troggs, Frostmane Troll cave, and Boar hunting." },
                { name = "Dun Morogh / Kharanos", range = "6–10", notes = "Kharanos hub, Brewnall Village, Gnomeregan outskirts, and Gol'Bolar Quarry." },
                { name = "Loch Modan (Thelsamar) & Wetlands", range = "10–20", notes = "Thelsamar & Ironband's Excavation quests, plus Westfall/Deadmines via Deeprun Tram." }
            },
            racials = {
                { name = "Escape Artist", desc = "Removes any immobilization or movement slowing effect with a 0.5 sec cast on a 1 min cooldown (incredible for tank/DPS mobility)." },
                { name = "Engineering Specialization", desc = "+15 Engineering skill bonus! Unlocks craftable bombs, goggles, and gadgets 3-5 character levels ahead of any other race." },
                { name = "Expansive Mind", desc = "Increases Intellect by 5% passively, amplifying maximum mana pool and spell crit." },
                { name = "Arcane Resistance", desc = "+10 Arcane Resistance passively." }
            },
            tankTips = {
                "Escape Artist is essential when tanking mobs with Frost Nova, Web, or Hamstring roots: break free instantly to prevent mobs running toward casters.",
                "Take full advantage of the +15 Engineering bonus to craft Iron Grenades, Target Dummies, and Sapper Charges far earlier than normal."
            }
        },
        [2] = {
            zones = {
                { name = "Wetlands (Menethil Harbor) & Duskwood (Darkshire)", range = "20–30", notes = "Menethil Harbor, Darkshire undead chains, and Gnomeregan racial dungeon quests!" },
                { name = "Hillsbrad Foothills (Southshore)", range = "25–33", notes = "Southshore Alliance hub: Durnholde Syndicate and Yeti cave." },
                { name = "Arathi Highlands (Refuge Pointe)", range = "30–40", notes = "Refuge Pointe Alliance hub: Stromgarde Keep and Boulderfist ogres." },
                { name = "Stranglethorn Vale (Rebel Camp) & Shimmering Flats", range = "30–40", notes = "Mirage Raceway Gnome engineering quests in Thousand Needles + STV Rebel Camp." }
            },
            tankTips = {
                "In Gnomeregan and Scarlet Monastery, Escape Artist neutralizes net and slime slow debuffs immediately."
            }
        },
        [3] = {
            zones = {
                { name = "Badlands & Uldaman", range = "38–44", notes = "Badlands gizmo/engineering quests and Uldaman dungeon runs." },
                { name = "Feralas (Feathermoon Stronghold)", range = "42–48", notes = "Feathermoon Stronghold Alliance hub: Gordunni ogres, Yetis, and Maraudon prep." },
                { name = "Tanaris (Gadgetzan) & Hinterlands (Aerie Peak)", range = "43–50", notes = "Gadgetzan engineering traders, Zul'Farrak quests, and Aerie Peak." },
                { name = "Searing Gorge (Thorium Point)", range = "48–52", notes = "Thorium Point quests and Blackrock Depths preparation." }
            },
            tankTips = {
                "In Maraudon, break Princess dust slow effects with Escape Artist to keep positioning boss away from the group."
            }
        },
        [4] = {
            zones = {
                { name = "Un'Goro Crater (Marshal's Refuge)", range = "51–55", notes = "Linken's boomerang chain, Power Crystals, and dense Thorium veins." },
                { name = "Western Plaguelands (Chillwind Camp)", range = "52–58", notes = "Chillwind Camp Alliance hub: Scourge cauldrons and Scholomance key chain." },
                { name = "Eastern Plaguelands (Light's Hope) & Burning Steppes", range = "54–60", notes = "Morgan's Vigil (Onyxia attunement), Blackrock Depths, and Stratholme." },
                { name = "Winterspring (Everlook)", range = "55–60", notes = "Everlook Goblin/Gnome engineering schematics and endgame pre-raid BIS preparation." }
            },
            tankTips = {
                "In Stratholme, Escape Artist breaks crypt fiend web wraps that would otherwise leave your group vulnerable."
            }
        }
    },
    macros = {
        {
            category = "Defensive / Tank",
            title = "Gnome: Escape Artist Break",
            desc = "Instantly casts Escape Artist to break roots and slows to regain positioning.",
            code = "#showtooltip Escape Artist\n/stopcasting\n/cast Escape Artist"
        }
    }
}

FTG:RegisterRaceModule("GNOME", GnomeModule)
