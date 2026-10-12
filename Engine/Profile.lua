--[[
    ForeverTankGuide - Engine/Profile.lua
    Dynamic Character State Detection and Active Profile Manager
]]

local ADDON_NAME, FTG = ...

FTG.Profile = {}

-- Auto-detect player class token (e.g. PALADIN, WARRIOR, DRUID, SHAMAN, ROGUE, WARLOCK)
function FTG:GetPlayerClass()
    local _, classToken = UnitClass("player")
    return classToken or "PALADIN"
end

-- Auto-detect player race token (e.g. Scourge/Undead, Tauren, Orc, Troll, Human, Dwarf, NightElf, Gnome)
function FTG:GetPlayerRace()
    local _, raceToken = UnitRace("player")
    if raceToken == "Scourge" then raceToken = "UNDEAD" end
    return raceToken or "UNDEAD"
end

-- Auto-detect primary tank-relevant profession (Engineering, Blacksmithing, Alchemy, Leatherworking)
function FTG:GetPlayerProfession()
    if GetProfessions then
        local prof1, prof2 = GetProfessions()
        local function checkIndex(idx)
            if idx then
                local name = GetProfessionInfo(idx)
                if name then
                    local n = string.upper(name)
                    if n:find("ENGIN") then return "ENGINEERING" end
                    if n:find("BLACK") or n:find("SMITH") then return "BLACKSMITHING" end
                    if n:find("ALCH") then return "ALCHEMY" end
                    if n:find("LEATH") then return "LEATHERWORKING" end
                end
            end
            return nil
        end
        local found = checkIndex(prof1) or checkIndex(prof2)
        if found then return found end
    end

    -- Fallback to Skill inspection
    if GetNumSkillLines then
        for i = 1, GetNumSkillLines() do
            local skillName = GetSkillLineInfo(i)
            if skillName then
                local n = string.upper(skillName)
                if n:find("ENGIN") then return "ENGINEERING" end
                if n:find("BLACK") or n:find("SMITH") then return "BLACKSMITHING" end
                if n:find("ALCH") then return "ALCHEMY" end
                if n:find("LEATH") then return "LEATHERWORKING" end
            end
        end
    end

    return "ENGINEERING"
end

-- Active selection states with manual overrides
function FTG:GetActiveProfile()
    local overrideClass = FTG_CharDB and FTG_CharDB.overrideClass
    local overrideRace = FTG_CharDB and FTG_CharDB.overrideRace
    local overrideProf = FTG_CharDB and FTG_CharDB.overrideProf

    return self:GetCompositeProfile(overrideClass, overrideRace, overrideProf)
end

function FTG:SetProfileOverrides(overrideClass, overrideRace, overrideProf)
    if not FTG_CharDB then FTG_CharDB = {} end
    FTG_CharDB.overrideClass = overrideClass
    FTG_CharDB.overrideRace = overrideRace
    FTG_CharDB.overrideProf = overrideProf

    if self.UI and self.UI.MainFrame and self.UI.MainFrame:IsShown() then
        self.UI:UpdateView()
    end
end

function FTG:ResetProfileToPlayer()
    self:SetProfileOverrides(nil, nil, nil)
end
