--[[
    ForeverTankGuide - Engine/Registry.lua
    Data Aggregation and Dynamic Module Registration API
]]

local ADDON_NAME, FTG = ...

FTG.Registry = {
    Classes = {},
    Races = {},
    Professions = {},
    Dungeons = {}
}

-- Module Registration Methods
function FTG:RegisterClassModule(classToken, moduleData)
    if not classToken or not moduleData then return end
    classToken = string.upper(classToken)
    self.Registry.Classes[classToken] = moduleData
end

function FTG:RegisterRaceModule(raceToken, moduleData)
    if not raceToken or not moduleData then return end
    raceToken = string.upper(raceToken)
    self.Registry.Races[raceToken] = moduleData
end

function FTG:RegisterProfModule(profName, moduleData)
    if not profName or not moduleData then return end
    profName = string.upper(profName)
    self.Registry.Professions[profName] = moduleData
end

function FTG:RegisterDungeonData(dungeonTable)
    if not dungeonTable then return end
    self.Registry.Dungeons = dungeonTable
end

-- Helper: Retrieve Registered Lists for UI Selectors
function FTG:GetRegisteredClasses()
    local list = {}
    for k, v in pairs(self.Registry.Classes) do
        table.insert(list, { token = k, name = v.name or k })
    end
    table.sort(list, function(a, b) return a.name < b.name end)
    return list
end

function FTG:GetRegisteredRaces()
    local list = {}
    for k, v in pairs(self.Registry.Races) do
        table.insert(list, { token = k, name = v.name or k, faction = v.faction or "Neutral" })
    end
    table.sort(list, function(a, b) return a.name < b.name end)
    return list
end

function FTG:GetRegisteredProfessions()
    local list = {}
    for k, v in pairs(self.Registry.Professions) do
        table.insert(list, { token = k, name = v.name or k })
    end
    table.sort(list, function(a, b) return a.name < b.name end)
    return list
end

-- Composite Profile Construction
function FTG:GetCompositeProfile(overrideClass, overrideRace, overrideProf)
    local classKey = string.upper(overrideClass or self:GetPlayerClass())
    local raceKey = string.upper(overrideRace or self:GetPlayerRace())
    local profKey = string.upper(overrideProf or self:GetPlayerProfession())

    local classMod = self.Registry.Classes[classKey] or self.Registry.Classes["PALADIN"] or {}
    local raceMod = self.Registry.Races[raceKey] or self.Registry.Races["SCOURGE"] or self.Registry.Races["UNDEAD"] or {}
    local profMod = self.Registry.Professions[profKey] or self.Registry.Professions["ENGINEERING"] or {}
    local dungMod = self.Registry.Dungeons or {}

    local composite = {
        classKey = classKey,
        className = classMod.name or classKey,
        raceKey = raceKey,
        raceName = raceMod.name or raceKey,
        profKey = profKey,
        profName = profMod.name or profKey,
        Brackets = {},
        Macros = {}
    }

    -- Aggregate 4 Brackets
    for b = 1, 4 do
        local cBracket = (classMod.brackets and classMod.brackets[b]) or {}
        local rBracket = (raceMod.brackets and raceMod.brackets[b]) or {}
        local pBracket = (profMod.brackets and profMod.brackets[b]) or {}
        local dBracket = (dungMod.brackets and dungMod.brackets[b]) or {}

        -- Zones: combine class recommendations and race starting/priority zones
        local combinedZones = {}
        if rBracket.zones then
            for _, z in ipairs(rBracket.zones) do table.insert(combinedZones, z) end
        end
        if cBracket.zones then
            for _, z in ipairs(cBracket.zones) do table.insert(combinedZones, z) end
        end
        if #combinedZones == 0 and dBracket.zones then
            for _, z in ipairs(dBracket.zones) do table.insert(combinedZones, z) end
        end

        -- Abilities
        local combinedAbilities = {}
        if cBracket.abilities then
            for _, ab in ipairs(cBracket.abilities) do table.insert(combinedAbilities, ab) end
        end
        if rBracket.racials and b == 1 then
            for _, rac in ipairs(rBracket.racials) do
                table.insert(combinedAbilities, 1, { level = 1, name = rac.name .. " (Racial)", desc = rac.desc })
            end
        end

        -- Tank Rules
        local combinedRules = {}
        if cBracket.tankRules then
            for _, rule in ipairs(cBracket.tankRules) do table.insert(combinedRules, rule) end
        end
        if rBracket.tankTips then
            for _, tip in ipairs(rBracket.tankTips) do table.insert(combinedRules, tip) end
        end

        -- Profession & Dungeons
        local professionData = {
            name = profMod.name or profKey,
            range = pBracket.range or "Skill 1–300",
            milestones = pBracket.milestones or {},
            shoppingList = pBracket.shoppingList or {},
            ahProfits = pBracket.ahProfits or nil
        }

        local dungeonList = dBracket.dungeons or {}

        composite.Brackets[b] = {
            id = b,
            name = cBracket.name or string.format("Phase %d", b),
            minLevel = cBracket.minLevel or (b == 1 and 1 or (b == 2 and 20 or (b == 3 and 40 or 52))),
            maxLevel = cBracket.maxLevel or (b == 1 and 20 or (b == 2 and 40 or (b == 3 and 52 or 60))),
            summary = cBracket.summary or (raceMod.name .. " " .. classMod.name .. " progression."),
            zones = combinedZones,
            abilities = combinedAbilities,
            tankRules = combinedRules,
            profession = professionData,
            dungeons = dungeonList
        }
    end

    -- Aggregate Macros: Class Macros + Race Macros + Profession Utility Macros
    if classMod.macros then
        for _, m in ipairs(classMod.macros) do table.insert(composite.Macros, m) end
    end
    if raceMod.macros then
        for _, m in ipairs(raceMod.macros) do table.insert(composite.Macros, m) end
    end
    if profMod.macros then
        for _, m in ipairs(profMod.macros) do table.insert(composite.Macros, m) end
    end

    return composite
end
