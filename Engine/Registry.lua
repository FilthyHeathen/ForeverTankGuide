--[[
    Heathen's Forever Guide - Engine/Registry.lua
    Data Aggregation and Dynamic Module Registration API (All Roles & Specs Edition)
]]

local ADDON_NAME, HFG = ...
_G.HFG = HFG

HFG.Registry = {
    Classes = {},
    Races = {},
    Professions = {},
    Dungeons = {}
}

-- Module Registration Methods
function HFG:RegisterClassModule(classToken, moduleData)
    if not classToken or not moduleData then return end
    classToken = string.upper(classToken)
    self.Registry.Classes[classToken] = moduleData
end

function HFG:RegisterRaceModule(raceToken, moduleData)
    if not raceToken or not moduleData then return end
    raceToken = string.upper(raceToken)
    self.Registry.Races[raceToken] = moduleData
end

function HFG:RegisterProfModule(profName, moduleData)
    if not profName or not moduleData then return end
    profName = string.upper(profName)
    self.Registry.Professions[profName] = moduleData
end

function HFG:RegisterDungeonData(dungeonTable)
    if not dungeonTable then return end
    self.Registry.Dungeons = dungeonTable
end

-- Helper: Retrieve Registered Lists for UI Selectors
function HFG:GetRegisteredClasses()
    local list = {}
    for k, v in pairs(self.Registry.Classes) do
        table.insert(list, { token = k, name = v.name or k })
    end
    table.sort(list, function(a, b) return a.name < b.name end)
    return list
end

function HFG:GetRegisteredSpecsForClass(classToken)
    classToken = string.upper(classToken or "PALADIN")
    local classMod = self.Registry.Classes[classToken]
    local list = {}
    if classMod and classMod.specs then
        for specKey, specData in pairs(classMod.specs) do
            table.insert(list, {
                token = specKey,
                name = specData.specName or specKey,
                role = specData.role or "DPS",
                order = specData.order or 99
            })
        end
        table.sort(list, function(a, b)
            if a.order ~= b.order then return a.order < b.order end
            return a.name < b.name
        end)
    end
    return list
end

function HFG:GetRegisteredRaces()
    local list = {}
    for k, v in pairs(self.Registry.Races) do
        if k ~= "SCOURGE" and k ~= "UNDEAD" and k ~= "SKYBORNE" then -- prevent duplicate alias entries in dropdown
            table.insert(list, { token = k, name = v.name or k, faction = v.faction or "Neutral" })
        end
    end
    table.sort(list, function(a, b) return a.name < b.name end)
    return list
end

function HFG:GetRegisteredProfessions()
    local list = {}
    for k, v in pairs(self.Registry.Professions) do
        table.insert(list, { token = k, name = v.name or k })
    end
    table.sort(list, function(a, b) return a.name < b.name end)
    return list
end

-- Composite Profile Construction (Class + Spec + Race + Profession + Dungeons)
function HFG:GetCompositeProfile(overrideClass, overrideSpec, overrideRace, overrideProf)
    local classKey = string.upper(overrideClass or self:GetPlayerClass())
    local raceKey = string.upper(overrideRace or self:GetPlayerRace())
    local profKey = string.upper(overrideProf or self:GetPlayerProfession())

    local classMod = self.Registry.Classes[classKey] or self.Registry.Classes["PALADIN"] or {}
    local raceMod = self.Registry.Races[raceKey] or self.Registry.Races["FORSAKEN"] or self.Registry.Races["UNDEAD"] or {}
    local profMod = self.Registry.Professions[profKey] or self.Registry.Professions["ENGINEERING"] or {}
    local dungMod = self.Registry.Dungeons or {}

    -- Resolve active spec: manual dropdown override ALWAYS takes priority over heuristic detection
    local specKey = nil
    local detectedRole = nil
    if overrideSpec and overrideSpec ~= "" then
        specKey = string.upper(overrideSpec)
    else
        specKey, detectedRole = self:DetectPlayerRoleAndSpec(classKey)
        specKey = string.upper(specKey or "PROTECTION")
    end

    local specMod = nil
    if classMod.specs then
        specMod = classMod.specs[specKey]
        if not specMod then
            -- Try matching by specName substring (e.g., "Protection", "Retribution", "Holy")
            for k, v in pairs(classMod.specs) do
                if k:find(specKey, 1, true) or string.upper(v.specName or ""):find(specKey, 1, true) then
                    specKey = k
                    specMod = v
                    break
                end
            end
        end
        if not specMod then
            -- Fallback to default spec or first available spec
            local defKey = classMod.defaultSpec
            if defKey and classMod.specs[defKey] then
                specKey = defKey
                specMod = classMod.specs[defKey]
            else
                for k, v in pairs(classMod.specs) do
                    specKey = k
                    specMod = v
                    break
                end
            end
        end
    end
    specMod = specMod or {}

    local role = specMod.role or detectedRole or "TANK"
    local statPriority = specMod.statPriority or "Stamina > Primary Stat > Mitigation / Crit"

    local composite = {
        classKey = classKey,
        className = classMod.name or classKey,
        specKey = specKey,
        specName = specMod.specName or specKey,
        role = role,
        statPriority = statPriority,
        raceKey = raceKey,
        raceName = raceMod.name or raceKey,
        faction = raceMod.faction or "Horde",
        availableClasses = raceMod.availableClasses,
        profKey = profKey,
        profName = profMod.name or profKey,
        Brackets = {},
        Macros = {}
    }

    -- Aggregate 4 Brackets
    for b = 1, 4 do
        local sBracket = (specMod.phaseGuidance and specMod.phaseGuidance[b])
                      or (classMod.brackets and classMod.brackets[b])
                      or {}
        local rBracket = (raceMod.brackets and raceMod.brackets[b]) or {}
        local pBracket = (profMod.brackets and profMod.brackets[b]) or {}
        local dBracket = (dungMod.brackets and dungMod.brackets[b]) or {}

        -- Zones: strictly populate based on active Race & Faction quest routing first
        local combinedZones = {}
        if rBracket.zones and #rBracket.zones > 0 then
            for _, z in ipairs(rBracket.zones) do table.insert(combinedZones, z) end
        elseif sBracket.zones and #sBracket.zones > 0 then
            for _, z in ipairs(sBracket.zones) do table.insert(combinedZones, z) end
        elseif dBracket.zones then
            for _, z in ipairs(dBracket.zones) do table.insert(combinedZones, z) end
        end

        -- Abilities
        local combinedAbilities = {}
        if rBracket.racials and b == 1 then
            for _, rac in ipairs(rBracket.racials) do
                table.insert(combinedAbilities, { level = 1, name = rac.name .. " (Racial)", desc = rac.desc })
            end
        end
        if sBracket.abilities then
            for _, ab in ipairs(sBracket.abilities) do table.insert(combinedAbilities, ab) end
        end

        -- Tactical / Role Rules
        local combinedRules = {}
        if sBracket.rules then
            for _, rule in ipairs(sBracket.rules) do table.insert(combinedRules, rule) end
        elseif sBracket.tankRules then
            for _, rule in ipairs(sBracket.tankRules) do table.insert(combinedRules, rule) end
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
            name = sBracket.name or (b == 1 and "Phase 1: Levels 1–20" or (b == 2 and "Phase 2: Levels 20–40" or (b == 3 and "Phase 3: Levels 40–52" or "Phase 4: Levels 52–60"))),
            minLevel = sBracket.minLevel or (b == 1 and 1 or (b == 2 and 20 or (b == 3 and 40 or 52))),
            maxLevel = sBracket.maxLevel or (b == 1 and 20 or (b == 2 and 40 or (b == 3 and 52 or 60))),
            summary = sBracket.summary or string.format("%s %s (%s) progression and tactical milestones.", raceMod.name or raceKey, specMod.specName or "", classMod.name or classKey),
            zones = combinedZones,
            abilities = combinedAbilities,
            tankRules = combinedRules,
            profession = professionData,
            dungeons = dungeonList
        }
    end

    -- Aggregate Macros with Role/Category metadata
    local defaultCategory = (role == "TANK" and "Defensive / Tank") or (role == "HEALER" and "Healing / Mouseover") or "Burst / DPS"

    if specMod.macros then
        for _, m in ipairs(specMod.macros) do
            table.insert(composite.Macros, {
                title = m.title,
                desc = m.desc,
                code = m.code,
                category = m.category or defaultCategory
            })
        end
    elseif classMod.macros then
        for _, m in ipairs(classMod.macros) do
            table.insert(composite.Macros, {
                title = m.title,
                desc = m.desc,
                code = m.code,
                category = m.category or defaultCategory
            })
        end
    end

    if raceMod.macros then
        for _, m in ipairs(raceMod.macros) do
            table.insert(composite.Macros, {
                title = m.title,
                desc = m.desc,
                code = m.code,
                category = m.category or "Racial / Utility"
            })
        end
    end

    if profMod.macros then
        for _, m in ipairs(profMod.macros) do
            table.insert(composite.Macros, {
                title = m.title,
                desc = m.desc,
                code = m.code,
                category = m.category or "Profession / Utility"
            })
        end
    end

    return composite
end
