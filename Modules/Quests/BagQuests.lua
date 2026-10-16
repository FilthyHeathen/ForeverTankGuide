-- Modules/Quests/BagQuests.lua
local ADDON_NAME, HFG = ...
if not HFG then HFG = _G.HFG end
if not HFG then return end

HFG.BagQuests = {
    -- Starting Zone 6-Slot Bag Quests (Level 1-10)
    { id = 1001, name = "Book Return", race = "Human", level = 1, slots = 6, zone = "Elwynn Forest", starter = "Marshal Dughan" },
    { id = 1002, name = "Grund and Gozwin", race = {"Dwarf", "Gnome", "SkyborneAlliance"}, level = 1, slots = 6, zone = "Dun Morogh", starter = "Anvilmar" },
    { id = 1003, name = "Soft Saber Pelts", race = "NightElf", level = 1, slots = 6, zone = "Teldrassil", starter = "Aldria" },
    { id = 1004, name = "Sticks and Bones", race = "Undead", level = 1, slots = 6, zone = "Tirisfal Glades", starter = "Eleanor Shackleton" },
    { id = 1005, name = "Carry Your Weight", race = {"Orc", "Troll"}, level = 1, slots = 6, zone = "Durotar", starter = "Furl Scornbrow" },
    { id = 1006, name = "Grace of An'she and Mu'sha", race = "Tauren", level = 1, slots = 6, zone = "Mulgore", starter = "Red Cloud Mesa" },
    { id = 1007, name = "The Problem With Prideclaws", race = "SkyborneHorde", level = 1, slots = 6, zone = "Zephras Isle", starter = "Shen'dar Highlands" },

    -- Early/Mid Level Upgrades (Level 10-40)
    { id = 1008, name = "Poor Old Blanchy", faction = "Alliance", level = 10, slots = 8, zone = "Westfall", reward = "Old Blanchy's Feed Pouch" },
    { id = 1009, name = "Captain Sander's Hidden Treasure", faction = "Alliance", level = 14, slots = 8, zone = "Westfall", reward = "Captain Sander's Booty Bag" },
    { id = 1010, name = "Deviate Hides", faction = "Both", level = 17, slots = 10, zone = "The Barrens", reward = "Deviate Hide Pack" },
    { id = 1011, name = "The Binding", class = "Warlock", level = 20, slots = 12, zone = "The Barrens", reward = "Small Soul Pouch" },
    { id = 1012, name = "Spidersilk Pouch Task", faction = "Horde", level = 23, slots = 12, zone = "Stonetalon / Ashenvale", reward = "Spidersilk Pouch" },
    { id = 1013, name = "The Platinum Discs", faction = "Both", level = 40, slots = 14, zone = "Uldaman", reward = "Thawpelt Sack" },
}

function HFG:GetBagQuestsForProfile(profile)
    if not self.BagQuests then return {} end
    local list = {}
    local race = profile and profile.raceToken or self:GetPlayerRace()
    local faction = profile and profile.faction or self:GetPlayerFaction()
    local class = profile and profile.classToken or self:GetPlayerClass()

    for _, q in ipairs(self.BagQuests) do
        local match = true

        -- Match Class if specified
        if q.class then
            if type(q.class) == "table" then
                local found = false
                for _, c in ipairs(q.class) do
                    if string.upper(c) == string.upper(class) then found = true; break end
                end
                if not found then match = false end
            elseif string.upper(q.class) ~= string.upper(class) then
                match = false
            end
        end

        -- Match Race if specified
        if match and q.race then
            if type(q.race) == "table" then
                local found = false
                for _, r in ipairs(q.race) do
                    if string.upper(r) == string.upper(race) then found = true; break end
                end
                if not found then match = false end
            elseif string.upper(q.race) ~= string.upper(race) then
                match = false
            end
        end

        -- Match Faction if specified
        if match and q.faction and q.faction ~= "Both" then
            if string.upper(q.faction) ~= string.upper(faction) then
                match = false
            end
        end

        if match then
            table.insert(list, q)
        end
    end

    table.sort(list, function(a, b) return (a.level or 0) < (b.level or 0) end)
    return list
end
