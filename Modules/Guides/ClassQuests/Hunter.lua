--[[
    Heathen's Forever Guide - Modules/Guides/ClassQuests/Hunter.lua
    Full 1–60 Class Quest Progression Guide for Hunters
    Covers: Pet Taming (10), Sunken Temple (50), Epic Rhok'delar / Lok'delar (60).
]]

local ADDON_NAME, HFG = ...
if not HFG then HFG = _G.HFG end
if not HFG then return end

HFG:RegisterGuide({
    id = "ClassQuest_Hunter",
    title = "Hunter Class Progression (1–60: Pet Taming, Sunken Temple, Epic Rhok'delar)",
    category = "Class Quests",
    faction = "Both",
    classes = { "HUNTER" },
    minLevel = 10,
    maxLevel = 60,
    order = 206,
    steps = {
        {
            title = "1. Level 10: Taming the Beast (Pet Taming & Training)",
            zone = "Faction Starting Areas",
            coords = { x = 45.0, y = 50.0 },
            text = "Unlocks the core Hunter pet system: [Tame Beast], [Call Pet], [Dismiss Pet], [Feed Pet], and [Revive Pet].\n" ..
                   "• Speak to your Hunter trainer in your racial hub to accept [Taming the Beast].\n" ..
                   "• You will be given a Taming Rod to tame 3 specific local creatures in sequence:\n" ..
                   "    - Orc/Troll (Razor Hill): Dire Mottled Boar -> Armored Scorpid -> Surf Crawler.\n" ..
                   "    - Tauren (Bloodhoof): Adult Plainstrider -> Swoop -> Strigid Screecher.\n" ..
                   "    - Dwarf/Gnome (Kharanos): Large Crag Boar -> Snow Leopard -> Ice Claw Bear.\n" ..
                   "    - Night Elf (Dolanaar): Webwood Lurker -> Nightsaber Stalker -> Strigid Hunter.\n" ..
                   "• Return to the trainer to permanently master [Tame Beast] and receive the journey quest to your capital city to learn [Feed Pet] and [Beast Training]!",
            goals = {
                { type = "ACCEPT", text = "Accept [Taming the Beast] from Hunter Trainer" },
                { type = "COMPLETE", text = "Tame the 3 required trial beasts using the Taming Rod" },
                { type = "TURNIN", text = "Learn [Tame Beast], [Call Pet], and [Feed Pet]!" },
            }
        },
        {
            title = "2. Level 50: Sunken Temple Class Quest (Devilsaur Eye & Tooth)",
            zone = "Azshara & Sunken Temple",
            coords = { x = 41.0, y = 14.0 },
            text = "Endgame Hunter quest rewarding elite trinkets.\n" ..
                   "• Speak to your capital Hunter trainer to accept [Hunter's Charm].\n" ..
                   "• Travel to Ogtinc, an ancient hunter located atop the cliffs in northern Azshara.\n" ..
                   "• Complete [Courser Antlers] and [Waveshaker Teeth] by hunting elite beasts in Azshara.\n" ..
                   "• Enter Temple of Atal'Hakkar (Sunken Temple).\n" ..
                   "• Slay Morphaz and collect the [Green Drake Wings].\n" ..
                   "• Return to Ogtinc and choose your reward:\n" ..
                   "    - [Devilsaur Eye]: Iconic trinket (+2% Hit, +150 Attack Power for 20 sec on use).\n" ..
                   "    - [Devilsaur Tooth]: Guarantee your pet's next attack crits.\n" ..
                   "    - [Hunting Horn]: Summons a guardian pet to assist you in combat.",
            goals = {
                { type = "ACCEPT", questID = 8431, text = "Accept [Hunter's Charm] from Hunter Trainer" },
                { type = "COMPLETE", questID = 8432, text = "Complete beast hunting challenges in Azshara" },
                { type = "COMPLETE", questID = 8434, text = "Slay Morphaz in Sunken Temple for [Green Drake Wings]" },
                { type = "TURNIN", questID = 8434, text = "Turn in to Ogtinc and select [Devilsaur Eye]!" },
            }
        },
        {
            title = "3. Level 60: Epic Ancient Leaf (Rhok'delar & Lok'delar - Part 1)",
            zone = "Molten Core & Felwood",
            coords = { x = 60.0, y = 40.0 },
            text = "The ultimate Hunter achievement: [Rhok'delar, Longbow of the Ancient Keepers] and [Lok'delar, Stave of the Ancient Keepers].\n" ..
                   "• Defeat Majordomo Executus in Molten Core and loot the [Ancient Petrified Leaf] from the Cache of the Firelord.\n" ..
                   "• Equip the Leaf and travel to Irontree Woods in north Felwood.\n" ..
                   "• Stand on the central ancient islet to reveal the spirits of the three Ancients: Vartrus, Stoma, and Hastat.\n" ..
                   "• Accept [The Ancient Leaf] to receive the tasks for the bow string and staff staves.",
            goals = {
                { type = "ACCEPT", questID = 7633, text = "Loot Ancient Petrified Leaf from Majordomo Executus chest" },
                { type = "COMPLETE", text = "Summon the Ancients in Irontree Woods, Felwood" },
                { type = "ACCEPT", text = "Accept [A Proper String] and [Stave of the Ancients]" },
            }
        },
        {
            title = "4. Level 60: The Four Solitary Demons (Rhok'delar & Lok'delar - Part 2)",
            zone = "Silithus, Burning Steppes, Winterspring, Un'Goro",
            coords = { x = 50.0, y = 50.0 },
            text = "The legendary solo trial. You MUST fight each demon 1-on-1 without any player assistance or pet buffs:\n" ..
                   "    1. [Klinfran the Crazed] (Silithus): Enrages heavily. Keep distance with Wing Clip and Aspect of the Cheetah, use Scorpid Sting to dispel the enrage.\n" ..
                   "    2. [Artorius the Doombringer] (Winterspring): Transforms into a demon. Stay exactly in the 30-35 yard sweet spot and kite with Serpent Sting.\n" ..
                   "    3. [Simone the Seductress] (Un'Goro Crater): Casts Lightning and Silence. Slay her felhound first using Viper Sting, then melee-weave Simone with Aspect of the Wild.\n" ..
                   "    4. [Solenor the Slayer] (Burning Steppes): Casts creeping fear and spawns explosive bugs. Use Frost Traps, Wing Clip, and kite along the ramp.\n" ..
                   "• Slay all 4 demons and collect their heads.\n" ..
                   "• Slay Onyxia in Onyxia's Lair to obtain the [Mature Black Dragon Sinew].\n" ..
                   "• Return to the Ancients in Felwood to string [Rhok'delar] and craft [Lok'delar]!",
            goals = {
                { type = "COMPLETE", text = "Solo defeat Klinfran the Crazed in Silithus" },
                { type = "COMPLETE", text = "Solo defeat Artorius the Doombringer in Winterspring" },
                { type = "COMPLETE", text = "Solo defeat Simone the Seductress in Un'Goro Crater" },
                { type = "COMPLETE", text = "Solo defeat Solenor the Slayer in Burning Steppes" },
                { type = "COMPLETE", text = "Loot Mature Black Dragon Sinew from Onyxia" },
                { type = "TURNIN", questID = 7636, text = "Craft legendary [Rhok'delar] Bow and [Lok'delar] Staff!" },
            }
        },
    }
})
