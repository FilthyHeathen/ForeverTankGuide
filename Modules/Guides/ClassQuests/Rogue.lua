--[[
    Heathen's Forever Guide - Modules/Guides/ClassQuests/Rogue.lua
    Full 1–60 Class Quest Progression Guide for Rogues
    Covers: Thieves' Tools (10), Lockpicking (16), Poisons (20), Sunken Temple (50).
]]

local ADDON_NAME, HFG = ...
if not HFG then HFG = _G.HFG end
if not HFG then return end

HFG:RegisterGuide({
    id = "ClassQuest_Rogue",
    title = "Rogue Class Progression (1–60: Lockpicking, Poisons, Sunken Temple)",
    category = "Class Quests",
    faction = "Both",
    classes = { "ROGUE" },
    minLevel = 10,
    maxLevel = 60,
    order = 209,
    steps = {
        {
            title = "1. Level 10: Thieves' Tools & Pickpocketing",
            zone = "Faction Starting Areas",
            coords = { x = 40.0, y = 50.0 },
            text = "Unlocks [Thieves' Tools] and teaches the fundamental art of stealthy pickpocketing.\n" ..
                   "• Speak to your local Rogue trainer in your starting racial hub.\n" ..
                   "• Infiltrate a designated enemy camp using [Stealth].\n" ..
                   "• Use [Pickpocket] on the target patrol leader to loot the secret cipher without breaking stealth.\n" ..
                   "• Return to the trainer to receive your first set of [Thieves' Tools]!",
            goals = {
                { type = "ACCEPT", text = "Accept Pickpocketing assignment from Rogue Trainer" },
                { type = "COMPLETE", text = "Stealth into enemy camp and pickpocket the cipher" },
                { type = "TURNIN", text = "Receive [Thieves' Tools]!" },
            }
        },
        {
            title = "2. Level 16: The Art of Lockpicking",
            zone = "The Barrens (Horde) / Redridge (Alliance)",
            coords = { x = 60.0, y = 45.0 },
            text = "Unlocks the [Lockpicking] profession skill and introduces rapid lock skill leveling.\n" ..
                   "• Horde: Speak to Shenthul in Orgrimmar Cleft of Shadow to accept [The Zhevra Claw]. Travel to the pirate ship off the Merchant Coast in The Barrens. Practice picking the practice lockboxes on the bottom deck to level Lockpicking to 75-80.\n" ..
                   "• Alliance: Speak to Lucius in Stormwind Old Town. Travel to Alther's Mill in Redridge Mountains. Practice picking the practice lockboxes in the saw mill to level Lockpicking to 75-80.\n" ..
                   "• Open footlockers and doors throughout your leveling journey to keep skill maxed!",
            goals = {
                { type = "ACCEPT", text = "Accept Lockpicking training quest from Rogue Trainer" },
                { type = "COMPLETE", text = "Pick practice lockboxes on pirate ship / saw mill up to skill 75" },
                { type = "TURNIN", text = "Master [Lockpicking] skill!" },
            }
        },
        {
            title = "3. Level 20: The Poison Quest (Instant, Crippling, Mind-numbing)",
            zone = "Westfall (Alliance) / The Barrens & Silverpine (Horde)",
            coords = { x = 50.0, y = 50.0 },
            text = "Unlocks the critical [Poisons] skill—absolutely required for Rogue damage, PvP slow, and caster interruptions.\n" ..
                   "• Alliance:\n" ..
                   "    - Speak to Master Mathias Shaw at SI:7 in Stormwind to accept [Mathias and the Defias].\n" ..
                   "    - Travel to Klaven's Tower in northeast Westfall.\n" ..
                   "    - Stealth to the top floor, pickpocket Klaven Mortwake for the tower key, and unlock the chest for the Defias Poison sample.\n" ..
                   "    - You will contract [Touch of Zanzil] (7-day debuff); return to SI:7 and drink Doc Mixilpuk'z antidote to cure it and learn [Poisons]!\n" ..
                   "• Horde:\n" ..
                   "    - Speak to Shenthul in Orgrimmar or Hinur in Undercity to accept [The Shattered Hand].\n" ..
                   "    - Travel to Sludge Fen in north Barrens, stealth into the drill tower, pickpocket Foreman Silversmith for the key, and loot the poison cache.\n" ..
                   "    - Cure the Zanzil poison at the guild apothecary and learn [Poisons]!",
            goals = {
                { type = "ACCEPT", text = "Accept [The Poison Quest] from Rogue Trainer" },
                { type = "COMPLETE", text = "Stealth into tower, pickpocket key, and loot the Poison Cache" },
                { type = "TURNIN", text = "Drink antidote, cure Touch of Zanzil, and master [Poisons]!" },
            }
        },
        {
            title = "4. Level 50: Sunken Temple Class Quest (Duskbat Drape / Ebon Mask)",
            zone = "Azshara & Sunken Temple",
            coords = { x = 28.0, y = 50.0 },
            text = "Endgame Rogue class quest rewarding exceptional agility gear.\n" ..
                   "• Speak to your capital Rogue trainer to accept [A Simple Request].\n" ..
                   "• Travel to Archmage Xylem's apprentice Sanath Lim-yo in Azshara.\n" ..
                   "• Complete [A Decisive Strike] by stealing the Azure Key from the timbermaw furbolgs.\n" ..
                   "• Enter Temple of Atal'Hakkar (Sunken Temple).\n" ..
                   "• Slay Morphaz and collect the [Blood of Morphaz].\n" ..
                   "• Return to the questgiver and select your reward:\n" ..
                   "    - [Duskbat Drape]: Exceptional Agility and stealth cape.\n" ..
                   "    - [Ebon Mask]: Great pre-raid helm (+Agility and Hit).\n" ..
                   "    - [Whisperwalk Boots]: Stealth speed and dodge boots.",
            goals = {
                { type = "ACCEPT", questID = 8444, text = "Accept [A Simple Request] from Rogue Trainer" },
                { type = "COMPLETE", questID = 8445, text = "Retrieve Azure Key from Azshara furbolgs" },
                { type = "COMPLETE", questID = 8447, text = "Slay Morphaz in Sunken Temple for [Blood of Morphaz]" },
                { type = "TURNIN", questID = 8447, text = "Turn in for [Duskbat Drape] or [Ebon Mask]!" },
            }
        },
    }
})
