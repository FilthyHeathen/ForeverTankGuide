--[[
    ForeverTankGuide - Engine/Profile.lua
    Dynamic Character State Detection (Class, Spec, Role, Race, Profession) & Active Profile Manager
]]

local ADDON_NAME, FTG = ...

FTG.Profile = {}

-- Auto-detect player class token (PALADIN, WARRIOR, DRUID, PRIEST, SHAMAN, MAGE, WARLOCK, ROGUE, HUNTER)
function FTG:GetPlayerClass()
    local _, classToken = UnitClass("player")
    return classToken or "PALADIN"
end

-- Auto-detect active specialization via Talent Point distribution or Modern GetSpecialization API
function FTG:GetPlayerSpec(classToken)
    classToken = string.upper(classToken or self:GetPlayerClass())
    local classMod = self.Registry.Classes[classToken]
    if not classMod or not classMod.specs then
        return "PROTECTION"
    end

    -- 1. Check Modern API GetSpecialization if present
    if GetSpecialization and GetSpecializationInfo then
        local specIndex = GetSpecialization()
        if specIndex then
            local _, specName = GetSpecializationInfo(specIndex)
            if specName then
                local upName = string.upper(specName)
                for k, v in pairs(classMod.specs) do
                    if string.upper(v.specName or ""):find(upName) or k:find(upName) then
                        return k
                    end
                end
            end
        end
    end

    -- 2. Check Classic Talent Tabs (GetNumTalentTabs / GetTalentTabInfo)
    if GetNumTalentTabs and GetTalentTabInfo then
        local maxPoints = 0
        local bestTabName = nil
        local numTabs = GetNumTalentTabs()
        for t = 1, numTabs do
            local name, _, pointsSpent = GetTalentTabInfo(t)
            pointsSpent = tonumber(pointsSpent) or 0
            if pointsSpent > maxPoints then
                maxPoints = pointsSpent
                bestTabName = name
            end
        end

        if bestTabName and maxPoints > 0 then
            local upTab = string.upper(bestTabName)
            for k, v in pairs(classMod.specs) do
                if k:find(upTab) or string.upper(v.specName or ""):find(upTab) then
                    return k
                end
            end
        end
    end

    -- 3. Fallback to class default spec
    return classMod.defaultSpec or "PROTECTION"
end

-- Auto-detect player race token (including cross-faction Skyborne detection)
function FTG:GetPlayerRace()
    local raceName, raceToken = UnitRace("player")
    local token = string.upper(raceToken or raceName or "UNDEAD")
    if token == "SCOURGE" then
        return "UNDEAD"
    end
    if token:find("SKYBORNE") or string.upper(raceName or ""):find("SKYBORNE") then
        local faction = UnitFactionGroup and UnitFactionGroup("player") or "Horde"
        if faction == "Alliance" then
            return "SKYBORNE_ALLIANCE"
        else
            return "SKYBORNE_HORDE"
        end
    end
    return token
end

-- Auto-detect primary profession (Engineering, Blacksmithing, Alchemy, Leatherworking, Tailoring)
function FTG:GetPlayerProfession()
    local function matchProf(name)
        if not name then return nil end
        local n = string.upper(name)
        if n:find("ENGIN") then return "ENGINEERING" end
        if n:find("BLACK") or n:find("SMITH") then return "BLACKSMITHING" end
        if n:find("ALCH") then return "ALCHEMY" end
        if n:find("LEATH") then return "LEATHERWORKING" end
        if n:find("TAILOR") then return "TAILORING" end
        return nil
    end

    if GetProfessions then
        local prof1, prof2 = GetProfessions()
        local function checkIndex(idx)
            if idx then
                local name = GetProfessionInfo(idx)
                return matchProf(name)
            end
            return nil
        end
        local found = checkIndex(prof1) or checkIndex(prof2)
        if found then return found end
    end

    if GetNumSkillLines then
        for i = 1, GetNumSkillLines() do
            local skillName = GetSkillLineInfo(i)
            local found = matchProf(skillName)
            if found then return found end
        end
    end

    return "ENGINEERING"
end

-- Active selection states with manual overrides
function FTG:GetActiveProfile()
    local overrideClass = FTG_CharDB and FTG_CharDB.overrideClass
    local overrideSpec  = FTG_CharDB and FTG_CharDB.overrideSpec
    local overrideRace  = FTG_CharDB and FTG_CharDB.overrideRace
    local overrideProf  = FTG_CharDB and FTG_CharDB.overrideProf

    return self:GetCompositeProfile(overrideClass, overrideSpec, overrideRace, overrideProf)
end

function FTG:SetProfileOverrides(overrideClass, overrideSpec, overrideRace, overrideProf)
    if not FTG_CharDB then FTG_CharDB = {} end
    FTG_CharDB.overrideClass = overrideClass
    FTG_CharDB.overrideSpec  = overrideSpec
    FTG_CharDB.overrideRace  = overrideRace
    FTG_CharDB.overrideProf  = overrideProf

    if self.UI and self.UI.MainFrame and self.UI.MainFrame:IsShown() then
        self.UI:UpdateView()
    end
end

function FTG:ResetProfileToPlayer()
    self:SetProfileOverrides(nil, nil, nil, nil)
end
