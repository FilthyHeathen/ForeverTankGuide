--[[
    Heathen's Forever Guide - Modules/Guides/ClassQuests/Priest.lua
    Full 1–60 Class Quest Progression Guide for Priests
    Covers: Racial Spells (10/20), Sunken Temple (50), Epic Benediction & Anathema (60).
]]

local ADDON_NAME, HFG = ...
if not HFG then HFG = _G.HFG end
if not HFG then return end

HFG:RegisterGuide({
    id = "ClassQuest_Priest",
    title = "Priest Class Progression (1–60: Racial Spells, Sunken Temple, Epic Benediction)",
    category = "Class Quests",
    faction = "Both",
    classes = { "PRIEST" },
    minLevel = 10,
    maxLevel = 60,
    order = 207,
    steps = {
        {
            title = "1. Level 10 & 20: Priest Racial Spells",
            zone = "Faction Capital Temples",
            coords = { x = 40.0, y = 30.0 },
            text = "Priests possess unique racial abilities unlocked via specific trainer quests:\n" ..
                   "• Forsaken Priests:\n" ..
                   "    - Level 10: [Touch of Weakness] (retaliatory shadow damage & attack power debuff).\n" ..
                   "    - Level 20: [Devouring Plague] (immensely powerful shadow damage-over-time disease).\n" ..
                   "• Troll Priests:\n" ..
                   "    - Level 10: [Hex of Weakness] (reduces enemy damage and healing received).\n" ..
                   "    - Level 20: [Shadowguard] (charges that strike attackers with shadow damage).\n" ..
                   "• Human Priests:\n" ..
                   "    - Level 10: [Desperate Prayer] (instant self-heal with zero mana cost).\n" ..
                   "    - Level 20: [Feedback] (burns enemy mana on successful physical attacks).\n" ..
                   "• Dwarf Priests:\n" ..
                   "    - Level 10: [Desperate Prayer] (instant self-heal with zero mana cost).\n" ..
                   "    - Level 20: [Fear Ward] (wards target against fear effects—extremely prized in raids!).\n" ..
                   "• Night Elf Priests:\n" ..
                   "    - Level 10: [Starshards] (channeled arcane damage).\n" ..
                   "    - Level 20: [Elune's Grace] (reduces ranged damage taken and increases dodge).",
            goals = {
                { type = "ACCEPT", text = "Accept Level 10 Priest racial quest from your capital trainer" },
                { type = "TURNIN", text = "Learn your Level 10 Racial ability" },
                { type = "ACCEPT", text = "Accept Level 20 Priest racial quest from your capital trainer" },
                { type = "TURNIN", text = "Learn your Level 20 Racial ability (e.g. Fear Ward / Devouring Plague)" },
            }
        },
        {
            title = "2. Level 50: Sunken Temple Class Quest (Cassock of the Crescent Moon)",
            zone = "Azshara & Sunken Temple",
            coords = { x = 28.0, y = 38.0 },
            text = "Endgame Priest quest providing outstanding healing and shadow gear.\n" ..
                   "• Speak to your capital Priest trainer to accept [Cenarion Aid].\n" ..
                   "• Travel to Ogtinc in Azshara to accept [Of Verse and Fable].\n" ..
                   "• Collect materials from the forest creatures in Azshara.\n" ..
                   "• Enter Temple of Atal'Hakkar (Sunken Temple).\n" ..
                   "• Slay Morphaz and collect the [Blood of Morphaz].\n" ..
                   "• Return to Ogtinc and select your reward:\n" ..
                   "    - [Cassock of the Crescent Moon]: Superb healing robe with spirit and intellect.\n" ..
                   "    - [Woestave]: Powerful caster wand.\n" ..
                   "    - [Blessed Prayer Beads]: Exceptional trinket (+190 Healing for 20 sec on use).",
            goals = {
                { type = "ACCEPT", questID = 8435, text = "Accept [Cenarion Aid] from Priest Trainer" },
                { type = "COMPLETE", questID = 8436, text = "Collect verse reagents in Azshara" },
                { type = "COMPLETE", questID = 8438, text = "Slay Morphaz in Sunken Temple for [Blood of Morphaz]" },
                { type = "TURNIN", questID = 8438, text = "Turn in for [Blessed Prayer Beads] or [Cassock of the Crescent Moon]!" },
            }
        },
        {
            title = "3. Level 60: Epic Benediction / Anathema (The Two Eyes)",
            zone = "Molten Core, Winterspring & Blasted Lands",
            coords = { x = 50.0, y = 50.0 },
            text = "The most revered Priest weapon in World of Warcraft: [Benediction] (Holy) / [Anathema] (Shadow).\n" ..
                   "• Defeat Majordomo Executus in Molten Core and loot [The Eye of Divinity] from the Cache of the Firelord (equip it in your trinket slot).\n" ..
                   "• Obtain [The Eye of Shadow]: drops from Lord Kazzak or elite demons in Darkwhisper Gorge (Winterspring) and the Tainted Scar (Blasted Lands).\n" ..
                   "• Equip [The Eye of Divinity] and travel to the ruins of Stratholme's service entrance in Eastern Plaguelands (near the border of Stratholme and Ghostlands).\n" ..
                   "• With the Eye of Divinity equipped, the spectral spirit of [Earis Needlesign] becomes visible.\n" ..
                   "• Speak to Earis to begin the legendary solo trial: [The Balance of Light and Shadow]!",
            goals = {
                { type = "ACCEPT", questID = 7626, text = "Loot [The Eye of Divinity] from Majordomo Executus chest" },
                { type = "COMPLETE", text = "Acquire [The Eye of Shadow] from Winterspring elite demons" },
                { type = "COMPLETE", text = "Equip Eye of Divinity and speak to the spirit of Earis Needlesign in EPL" },
            }
        },
        {
            title = "4. Level 60: The Balance of Light and Shadow (Benediction / Anathema)",
            zone = "Eastern Plaguelands (Stratholme Ruins)",
            coords = { x = 22.0, y = 18.0 },
            text = "The ultimate test of healing, cleansing, and situational awareness.\n" ..
                   "• You MUST solo this event—any external buff, heal, or player intervention will summon the Cleaner and wipe the encounter.\n" ..
                   "• Groups of frightened spectral peasants will flee across the path toward safety.\n" ..
                   "• Skeletal archers and infectious spirits spawn to attack and disease the peasants.\n" ..
                   "• Strategy:\n" ..
                   "    - Keep Abolish Disease active on diseased peasants immediately.\n" ..
                   "    - Use Renew (Rank 3/4) and Flash Heal on damaged refugees.\n" ..
                   "    - Use Holy Nova and Holy Fire / Shadow Word: Pain to pick off the skeletal archers.\n" ..
                   "    - Bring Major Mana Potions, Demonic Runes, and Oil of Immolation to assist with passive damage.\n" ..
                   "• Save at least 50 peasants while allowing fewer than 15 to perish.\n" ..
                   "• Upon victory, Earis rewards you with the [Splinter of Nordrassil].\n" ..
                   "• Combine the Splinter with The Eye of Divinity and The Eye of Shadow to forge [Benediction] / [Anathema]!",
            goals = {
                { type = "COMPLETE", questID = 7626, text = "Survive the solo cleansing event and save 50 peasants" },
                { type = "COMPLETE", text = "Loot the [Splinter of Nordrassil] from Earis Needlesign" },
                { type = "TURNIN", questID = 7626, text = "Combine the Eye of Divinity, Eye of Shadow, and Splinter to forge [Benediction]!" },
            }
        },
    }
})
