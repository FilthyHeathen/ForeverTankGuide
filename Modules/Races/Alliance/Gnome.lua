--[[
    ForeverTankGuide - Modules/Races/Alliance/Gnome.lua
    Gnome Racials, Passives, Synergies, and Macros
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
                { name = "Dun Morogh & Gnomeregan", range = "1–10", notes = "Kharanos to Brewnall Village." },
                { name = "Loch Modan", range = "10–20", notes = "Thelsamar and early excavation sites." }
            },
            racials = {
                { name = "Escape Artist", desc = "Removes any immobilization or movement slowing effect with a 0.5 sec cast on a 1 min cooldown (incredible for tank mobility)." },
                { name = "Engineering Specialization", desc = "+15 Engineering skill bonus! Unlocks craftable bombs, goggles, and gadgets 3-5 character levels ahead of any other race." },
                { name = "Expansive Mind", desc = "Increases Intellect by 5% passively, amplifying maximum mana pool and spell crit (benefits Paladin/Warlock tanks)." },
                { name = "Arcane Resistance", desc = "+10 Arcane Resistance passively." }
            },
            tankTips = {
                "Escape Artist is essential when tanking mobs with Frost Nova, Web, or Hamstring roots: break free instantly to prevent mobs running toward casters.",
                "Take full advantage of the +15 Engineering bonus to craft Iron Grenades, Target Dummies, and Sapper Charges far earlier than normal."
            }
        },
        [2] = {
            tankTips = {
                "In Gnomeregan and Scarlet Monastery, Escape Artist neutralizes net and slime slow debuffs immediately."
            }
        },
        [3] = {
            tankTips = {
                "In Maraudon, break Princess dust slow effects with Escape Artist to keep positioning boss away from the group."
            }
        },
        [4] = {
            tankTips = {
                "In Stratholme, Escape Artist breaks crypt fiend web wraps that would otherwise leave your group vulnerable."
            }
        }
    },
    macros = {
        {
            title = "Gnome: Escape Artist Break",
            desc = "Instantly casts Escape Artist to break roots and slows to regain tank positioning.",
            code = "#showtooltip Escape Artist\n/stopcasting\n/cast Escape Artist"
        }
    }
}

FTG:RegisterRaceModule("GNOME", GnomeModule)
