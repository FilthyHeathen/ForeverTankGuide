--[[
    Heathen's Forever Guide - Engine/Profile.lua
    Dynamic Character State Detection, Classic Heuristic Role/Spec Resolver & Active Profile Manager
]]

local ADDON_NAME, FTG = ...

FTG.Profile = {}

-- Helper: Check if a specific buff/aura is active on the player (supports Modern AuraUtil & Classic UnitBuff)
local function HasPlayerAura(auraName)
    if not auraName then return false end
    local target = string.upper(auraName)

    -- 1. Modern AuraUtil.FindAuraByName (Interface 16001 / Retail-backed Classic client)
    if AuraUtil and AuraUtil.FindAuraByName then
        local ok, name = pcall(AuraUtil.FindAuraByName, auraName, "player", "HELPFUL")
        if ok and name then return true end
    end

    -- 2. C_UnitAuras API fallback
    if C_UnitAuras and C_UnitAuras.GetBuffDataByIndex then
        for i = 1, 40 do
            local aura = C_UnitAuras.GetBuffDataByIndex("player", i, "HELPFUL")
            if not aura then break end
            if aura.name and string.upper(aura.name):find(target, 1, true) then
                return true
            end
        end
    end

    -- 3. Classic UnitBuff fallback
    if UnitBuff then
        for i = 1, 40 do
            local name = UnitBuff("player", i)
            if not name then break end
            if string.upper(name):find(target, 1, true) then
                return true
            end
        end
    end

    return false
end

-- Helper: Inspect equipped Main-Hand (slot 16) and Off-Hand (slot 17) item equip locations
local function GetEquippedWeaponState()
    local state = {
        hasTwoHander = false,
        hasShield = false,
        hasOffHandWeapon = false,
        hasHeldInOffHand = false,
        mainHandID = GetInventoryItemID and GetInventoryItemID("player", 16) or nil,
        offHandID  = GetInventoryItemID and GetInventoryItemID("player", 17) or nil,
    }

    local function getEquipLoc(itemID)
        if not itemID then return nil end
        if C_Item and C_Item.GetItemInfoInstant then
            local _, _, _, equipLoc = C_Item.GetItemInfoInstant(itemID)
            if equipLoc then return equipLoc end
        end
        if GetItemInfoInstant then
            local _, _, _, equipLoc = GetItemInfoInstant(itemID)
            if equipLoc then return equipLoc end
        end
        if GetItemInfo then
            local _, _, _, _, _, _, _, _, equipLoc = GetItemInfo(itemID)
            if equipLoc then return equipLoc end
        end
        return nil
    end

    local mhLoc = getEquipLoc(state.mainHandID)
    local ohLoc = getEquipLoc(state.offHandID)

    if mhLoc == "INVTYPE_2HWEAPON" then
        state.hasTwoHander = true
    end

    if ohLoc == "INVTYPE_SHIELD" then
        state.hasShield = true
    elseif ohLoc == "INVTYPE_WEAPON" or ohLoc == "INVTYPE_WEAPONOFFHAND" then
        state.hasOffHandWeapon = true
    elseif ohLoc == "INVTYPE_HOLDABLE" then
        state.hasHeldInOffHand = true
    end

    return state
end

-- Helper: Tally Classic Talent Points across Tabs 1, 2, and 3
local function GetHighestTalentTree()
    local bestTabIndex = nil
    local bestTabName = nil
    local maxPoints = 0
    local tabPoints = { [1] = 0, [2] = 0, [3] = 0 }

    if GetNumTalentTabs and GetTalentTabInfo then
        local numTabs = GetNumTalentTabs() or 3
        for t = 1, numTabs do
            local name, _, pointsSpent = GetTalentTabInfo(t)
            -- Handle different client return signatures where pointsSpent may be arg 3 or arg 5
            if type(pointsSpent) ~= "number" then
                local _, _, _, _, altPoints = GetTalentTabInfo(t)
                pointsSpent = tonumber(altPoints) or 0
            else
                pointsSpent = tonumber(pointsSpent) or 0
            end
            tabPoints[t] = pointsSpent
            if pointsSpent > maxPoints then
                maxPoints = pointsSpent
                bestTabIndex = t
                bestTabName = name
            end
        end
    end

    return bestTabIndex, bestTabName, maxPoints, tabPoints
end

-- Auto-detect player class token (PALADIN, WARRIOR, DRUID, PRIEST, SHAMAN, MAGE, WARLOCK, ROGUE, HUNTER)
function FTG:GetPlayerClass()
    local _, classToken = UnitClass("player")
    return classToken or "PALADIN"
end

--[[
    Intelligent Classic Heuristic Role & Spec Resolver
    Returns: specKey, role
    Priority Order:
    1. Active Signature Class Auras (e.g., Righteous Fury, Sanctity Aura, Bear/Cat/Moonkin Form, Shadowform, Metamorphosis)
    2. Talent Tree Point Distribution (Tabs 1, 2, 3 via GetTalentTabInfo) combined with Equipped Gear (2H vs Shield)
    3. Equipped Gear Heuristics (Slot 16 & Slot 17 via GetInventoryItemID: 2H -> DPS, Shield -> Tank/Buff check)
    4. Low-Level Tiebreakers (Levels 1-9: Paladin defaults to Protection (Tank) if tankGuideMode enabled)
]]
function FTG:DetectPlayerRoleAndSpec(classToken)
    classToken = string.upper(classToken or self:GetPlayerClass())
    local classMod = self.Registry.Classes[classToken]
    if not classMod or not classMod.specs then
        return "PROTECTION", "TANK"
    end

    -- If checking a non-player preview class, return its default spec & role
    local actualPlayerClass = string.upper(self:GetPlayerClass())
    if classToken ~= actualPlayerClass then
        local defKey = classMod.defaultSpec or "PROTECTION"
        local defSpec = classMod.specs[defKey]
        return defKey, (defSpec and defSpec.role or "TANK")
    end

    local gear = GetEquippedWeaponState()
    local bestTabIndex, bestTabName, maxTalentPoints = GetHighestTalentTree()
    local playerLevel = UnitLevel and UnitLevel("player") or 1
    local tankGuideMode = (not FTG_CharDB) or (FTG_CharDB.tankGuideMode ~= false)

    -- =========================================================================
    -- PALADIN HEURISTICS
    -- =========================================================================
    if classToken == "PALADIN" then
        -- 1. Active Auras (AuraUtil)
        if HasPlayerAura("Righteous Fury") then
            return "PROTECTION", "TANK"
        end
        if HasPlayerAura("Sanctity Aura") then
            return "RETRIBUTION", "DPS"
        end

        -- 2. Equipped Gear: Two-Hander equipped -> Retribution (DPS)
        if gear.hasTwoHander then
            return "RETRIBUTION", "DPS"
        end

        -- 3. Equipped Gear: Shield equipped -> Check buffs & talents
        if gear.hasShield then
            if bestTabIndex == 1 and maxTalentPoints >= 10 then
                return "HOLY", "HEALER"
            end
            return "PROTECTION", "TANK"
        end

        -- 4. Talent Tree Distribution (Tab 1 = Holy, Tab 2 = Protection, Tab 3 = Retribution)
        if maxTalentPoints > 0 then
            if bestTabIndex == 1 then
                return "HOLY", "HEALER"
            elseif bestTabIndex == 2 then
                return "PROTECTION", "TANK"
            elseif bestTabIndex == 3 then
                return "RETRIBUTION", "DPS"
            end
        end

        -- 5. Low-level tiebreaker (Levels 1-9)
        if playerLevel <= 9 then
            if tankGuideMode then
                return "PROTECTION", "TANK"
            else
                return "RETRIBUTION", "DPS"
            end
        end

        return "PROTECTION", "TANK"
    end

    -- =========================================================================
    -- WARRIOR HEURISTICS
    -- =========================================================================
    if classToken == "WARRIOR" then
        -- 1. Equipped Gear: Two-Hander equipped -> Default to DPS (Arms or Fury based on talents)
        if gear.hasTwoHander then
            if bestTabIndex == 2 then
                return "FURY", "DPS"
            end
            return "ARMS", "DPS"
        end

        -- 2. Dual-Wielding -> Fury DPS
        if gear.hasOffHandWeapon then
            return "FURY", "DPS"
        end

        -- 3. Shield equipped -> Protection Tank (unless deep Arms/Fury leveling with temporary shield)
        if gear.hasShield then
            return "PROTECTION", "TANK"
        end

        -- 4. Talent Tree Distribution (Tab 1 = Arms, Tab 2 = Fury, Tab 3 = Protection)
        if maxTalentPoints > 0 then
            if bestTabIndex == 1 then
                return "ARMS", "DPS"
            elseif bestTabIndex == 2 then
                return "FURY", "DPS"
            elseif bestTabIndex == 3 then
                return "PROTECTION", "TANK"
            end
        end

        -- 5. Low-level tiebreaker (Levels 1-9)
        if playerLevel <= 9 and tankGuideMode then
            return "PROTECTION", "TANK"
        end

        return "PROTECTION", "TANK"
    end

    -- =========================================================================
    -- DRUID HEURISTICS
    -- =========================================================================
    if classToken == "DRUID" then
        if HasPlayerAura("Dire Bear Form") or HasPlayerAura("Bear Form") then
            return "FERAL_BEAR", "TANK"
        end
        if HasPlayerAura("Cat Form") then
            return "FERAL_CAT", "DPS"
        end
        if HasPlayerAura("Moonkin Form") then
            return "BALANCE", "DPS"
        end

        -- Talent Tabs (Tab 1 = Balance, Tab 2 = Feral Combat, Tab 3 = Restoration)
        if maxTalentPoints > 0 then
            if bestTabIndex == 1 then
                return "BALANCE", "DPS"
            elseif bestTabIndex == 3 then
                return "RESTORATION", "HEALER"
            elseif bestTabIndex == 2 then
                return (tankGuideMode and "FERAL_BEAR" or "FERAL_CAT"), (tankGuideMode and "TANK" or "DPS")
            end
        end

        return "FERAL_BEAR", "TANK"
    end

    -- =========================================================================
    -- SHAMAN HEURISTICS
    -- =========================================================================
    if classToken == "SHAMAN" then
        if HasPlayerAura("Way of Earth") or HasPlayerAura("Rockbiter Weapon") then
            if gear.hasShield then
                return "WARDEN_TANK", "TANK"
            end
        end
        if gear.hasTwoHander then
            return "ENHANCEMENT_DPS", "DPS"
        end

        -- Talent Tabs (Tab 1 = Elemental, Tab 2 = Enhancement, Tab 3 = Restoration)
        if maxTalentPoints > 0 then
            if bestTabIndex == 1 then
                return "ELEMENTAL", "DPS"
            elseif bestTabIndex == 3 then
                return "RESTORATION", "HEALER"
            elseif bestTabIndex == 2 then
                if gear.hasShield and tankGuideMode then
                    return "WARDEN_TANK", "TANK"
                end
                return "ENHANCEMENT_DPS", "DPS"
            end
        end

        if gear.hasShield and tankGuideMode then
            return "WARDEN_TANK", "TANK"
        end
        return "ENHANCEMENT_DPS", "DPS"
    end

    -- =========================================================================
    -- PRIEST HEURISTICS
    -- =========================================================================
    if classToken == "PRIEST" then
        if HasPlayerAura("Shadowform") then
            return "SHADOW", "DPS"
        end
        if maxTalentPoints > 0 and bestTabIndex == 3 then
            return "SHADOW", "DPS"
        end
        return "HOLY_DISC", "HEALER"
    end

    -- =========================================================================
    -- WARLOCK HEURISTICS
    -- =========================================================================
    if classToken == "WARLOCK" then
        if HasPlayerAura("Metamorphosis") then
            return "METAMORPHOSIS", "TANK"
        end
        if maxTalentPoints > 0 then
            if bestTabIndex == 1 then
                return "AFFLICTION", "DPS"
            elseif bestTabIndex == 3 then
                return "DESTRUCTION", "DPS"
            end
        end
        return (tankGuideMode and "METAMORPHOSIS" or "AFFLICTION"), (tankGuideMode and "TANK" or "DPS")
    end

    -- =========================================================================
    -- ROGUE HEURISTICS
    -- =========================================================================
    if classToken == "ROGUE" then
        if HasPlayerAura("Blade Dance") then
            return "BLADE_DANCE", "TANK"
        end
        if maxTalentPoints > 0 then
            if bestTabIndex == 1 then
                return "ASSASSINATION", "DPS"
            elseif bestTabIndex == 2 then
                return "COMBAT_DPS", "DPS"
            end
        end
        return (tankGuideMode and "BLADE_DANCE" or "COMBAT_DPS"), (tankGuideMode and "TANK" or "DPS")
    end

    -- =========================================================================
    -- HUNTER HEURISTICS
    -- =========================================================================
    if classToken == "HUNTER" then
        if HasPlayerAura("Trueshot Aura") then
            return "MARKSMANSHIP", "DPS"
        end
        if maxTalentPoints > 0 then
            if bestTabIndex == 1 then
                return "BEAST_MASTERY", "DPS"
            elseif bestTabIndex == 2 then
                return "MARKSMANSHIP", "DPS"
            elseif bestTabIndex == 3 then
                return "SURVIVAL", "DPS"
            end
        end
        return "BEAST_MASTERY", "DPS"
    end

    -- =========================================================================
    -- MAGE HEURISTICS
    -- =========================================================================
    if classToken == "MAGE" then
        if HasPlayerAura("Ice Barrier") or HasPlayerAura("Frost Armor") or HasPlayerAura("Ice Armor") then
            if bestTabIndex == 1 then
                return "ARCANE", "DPS"
            elseif bestTabIndex == 2 then
                return "FIRE", "DPS"
            end
            return "FROST", "DPS"
        end
        if maxTalentPoints > 0 then
            if bestTabIndex == 1 then
                return "ARCANE", "DPS"
            elseif bestTabIndex == 2 then
                return "FIRE", "DPS"
            elseif bestTabIndex == 3 then
                return "FROST", "DPS"
            end
        end
        return "FROST", "DPS"
    end

    -- Generic fallback via talent tab name matching
    if bestTabName and maxTalentPoints > 0 then
        local upTab = string.upper(bestTabName)
        for k, v in pairs(classMod.specs) do
            if k:find(upTab) or string.upper(v.specName or ""):find(upTab) then
                return k, (v.role or "DPS")
            end
        end
    end

    local defKey = classMod.defaultSpec or "PROTECTION"
    local defSpec = classMod.specs[defKey]
    return defKey, (defSpec and defSpec.role or "TANK")
end

-- Auto-detect active specialization (wraps DetectPlayerRoleAndSpec for Registry compatibility)
function FTG:GetPlayerSpec(classToken)
    local specKey = self:DetectPlayerRoleAndSpec(classToken)
    return specKey
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

-- Active selection states: manual top-bar dropdowns ALWAYS override automatic detection until "Detect Player" is clicked
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

-- "Detect Player" button handler: clears manual overrides and runs live heuristic detection
function FTG:ResetProfileToPlayer()
    if not FTG_CharDB then FTG_CharDB = {} end
    FTG_CharDB.overrideClass = nil
    FTG_CharDB.overrideSpec  = nil
    FTG_CharDB.overrideRace  = nil
    FTG_CharDB.overrideProf  = nil

    local detectedSpec, detectedRole = self:DetectPlayerRoleAndSpec()
    if self.UI and self.UI.MainFrame and self.UI.MainFrame:IsShown() then
        self.UI:UpdateView()
    end
    return detectedSpec, detectedRole
end
