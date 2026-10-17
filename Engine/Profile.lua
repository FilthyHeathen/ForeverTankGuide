--[[
    Heathen's Forever Guide - Engine/Profile.lua
    Dynamic Character State Detection, Classic Heuristic Role/Spec Resolver & Active Profile Manager
]]

local ADDON_NAME, HFG = ...

HFG.Profile = {}

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
function HFG:GetPlayerClass()
    local _, classToken = UnitClass("player")
    return classToken or "PALADIN"
end

--[[
    Intelligent Classic Heuristic Role & Spec Resolver
    Returns: specKey, role
    Priority Order:
    1. Active Signature Class Auras (e.g., Righteous Fury, Sanctity Aura, Bear/Cat/Moonkin Form, Shadowform, Metamorphosis)
    2. Equipped Gear Heuristics (Slot 16 & Slot 17 via GetInventoryItemID: 2H -> DPS, Shield -> Tank/Buff check)
    3. Talent Tree Point Distribution (Tabs 1, 2, 3 via GetTalentTabInfo)
    4. Low-Level Tiebreakers (Levels 1-9: Paladin defaults to Protection (Tank) if tankGuideMode enabled)
]]
function HFG:DetectPlayerRoleAndSpec(classToken)
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
    local tankGuideMode = (not HFG_CharDB) or (HFG_CharDB.tankGuideMode ~= false)

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

        -- 3. Shield equipped -> Protection Tank
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
function HFG:GetPlayerSpec(classToken)
    local specKey = self:DetectPlayerRoleAndSpec(classToken)
    return specKey
end

-- Auto-detect player race token (including cross-faction Skyborne detection)
function HFG:GetPlayerRace()
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
function HFG:GetPlayerProfession()
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
function HFG:GetActiveProfile()
    local overrideClass = HFG_CharDB and HFG_CharDB.overrideClass
    local overrideSpec  = HFG_CharDB and HFG_CharDB.overrideSpec
    local overrideRace  = HFG_CharDB and HFG_CharDB.overrideRace
    local overrideProf  = HFG_CharDB and HFG_CharDB.overrideProf

    return self:GetCompositeProfile(overrideClass, overrideSpec, overrideRace, overrideProf)
end

function HFG:SetProfileOverrides(overrideClass, overrideSpec, overrideRace, overrideProf)
    if not HFG_CharDB then HFG_CharDB = {} end
    HFG_CharDB.overrideClass = overrideClass
    HFG_CharDB.overrideSpec  = overrideSpec
    HFG_CharDB.overrideRace  = overrideRace
    HFG_CharDB.overrideProf  = overrideProf

    if self.UI and self.UI.MainFrame and self.UI.MainFrame:IsShown() then
        self.UI:UpdateView()
    end
end

-- "Detect Player" button handler: clears manual overrides and runs live heuristic detection
function HFG:ResetProfileToPlayer()
    if not HFG_CharDB then HFG_CharDB = {} end
    HFG_CharDB.overrideClass = nil
    HFG_CharDB.overrideSpec  = nil
    HFG_CharDB.overrideRace  = nil
    HFG_CharDB.overrideProf  = nil

    local detectedSpec, detectedRole = self:DetectPlayerRoleAndSpec()
    if self.UI and self.UI.MainFrame and self.UI.MainFrame:IsShown() then
        self.UI:UpdateView()
    end
    return detectedSpec, detectedRole
end

---------------------------------------------------------------------------
-- Live Quest Log Scanning, Position Recovery & State Synchronization
---------------------------------------------------------------------------

local logEntryCache = {}
local activeQuestIDs = {}
local completedQuestIDs = {}
local trackerGeneration = 0
local lastScanTimestamp = 0
local SCAN_THROTTLE_SECONDS = 0.25

-- Safe read wrapper for protected or secret environment values
local function SafeVal(val)
    if val ~= nil and issecretvalue ~= nil and issecretvalue(val) then
        return nil
    end
    return val
end

-- Retrieve player's world map and subzone position
function HFG:GetPlayerPositionInfo()
    local zone = (GetZoneText and GetZoneText()) or (GetRealZoneText and GetRealZoneText()) or "Unknown"
    local subzone = (GetSubZoneText and GetSubZoneText()) or ""
    local uiMapID = nil

    if C_Map and C_Map.GetBestMapForUnit then
        local ok, mid = pcall(C_Map.GetBestMapForUnit, "player")
        if ok and type(mid) == "number" then
            uiMapID = mid
        end
    end

    local x, y = 0, 0
    if uiMapID and C_Map and C_Map.GetPlayerMapPosition then
        local ok, pos = pcall(C_Map.GetPlayerMapPosition, uiMapID, "player")
        if ok and pos and pos.GetXY then
            local px, py = pos:GetXY()
            x = (px and px * 100) or 0
            y = (py and py * 100) or 0
        end
    end

    return {
        zone = zone,
        subzone = subzone,
        uiMapID = uiMapID,
        x = x,
        y = y
    }
end

-- Refresh completed quest flags into memory using bulk API or individual checks
function HFG:SyncCompletedQuestFlags()
    for qid in pairs(completedQuestIDs) do
        completedQuestIDs[qid] = nil
    end

    -- 1. Modern bulk lookup via C_QuestLog.GetAllCompletedQuestIDs
    if C_QuestLog and C_QuestLog.GetAllCompletedQuestIDs then
        local ok, list = pcall(C_QuestLog.GetAllCompletedQuestIDs)
        if ok and type(list) == "table" then
            for i = 1, #list do
                local qid = SafeVal(list[i])
                if type(qid) == "number" and qid > 0 then
                    completedQuestIDs[qid] = true
                    if HFG_CharDB and HFG_CharDB.completedQuests then
                        HFG_CharDB.completedQuests[qid] = true
                    end
                end
            end
            return true
        end
    end

    -- 2. Classic GetQuestsCompleted(tbl)
    if type(GetQuestsCompleted) == "function" then
        local nativeTable = {}
        local ok = pcall(GetQuestsCompleted, nativeTable)
        if ok and type(nativeTable) == "table" then
            for qid, done in pairs(nativeTable) do
                if done then
                    completedQuestIDs[qid] = true
                    if HFG_CharDB and HFG_CharDB.completedQuests then
                        HFG_CharDB.completedQuests[qid] = true
                    end
                end
            end
            return true
        end
    end

    -- 3. Individual verification for known quest database entries
    if HFG.QuestDB then
        for qid, _ in pairs(HFG.QuestDB) do
            if self:CheckQuestFlaggedCompleted(qid) then
                completedQuestIDs[qid] = true
                if HFG_CharDB and HFG_CharDB.completedQuests then
                    HFG_CharDB.completedQuests[qid] = true
                end
            end
        end
    end

    return false
end

-- Check whether a specific quest ID is flagged complete by the client
function HFG:CheckQuestFlaggedCompleted(questID)
    if not questID or questID <= 0 then return false end

    if C_QuestLog and C_QuestLog.IsQuestFlaggedCompleted then
        local ok, done = pcall(C_QuestLog.IsQuestFlaggedCompleted, questID)
        if ok and done then return true end
    elseif IsQuestFlaggedCompleted then
        local ok, done = pcall(IsQuestFlaggedCompleted, questID)
        if ok and done then return true end
    end

    if completedQuestIDs[questID] then return true end
    if HFG_CharDB and HFG_CharDB.completedQuests and HFG_CharDB.completedQuests[questID] then
        return true
    end

    return false
end

-- Read objectives and readiness for a single quest log entry
local function ParseQuestProgress(questID)
    local isComplete = false
    local isReady = false
    local objectives = {}

    if C_QuestLog and C_QuestLog.IsComplete then
        local ok, res = pcall(C_QuestLog.IsComplete, questID)
        if ok and res then isComplete = true; isReady = true end
    end
    if not isReady and C_QuestLog and C_QuestLog.ReadyForTurnIn then
        local ok, res = pcall(C_QuestLog.ReadyForTurnIn, questID)
        if ok and res then isReady = true end
    end

    if C_QuestLog and C_QuestLog.GetQuestObjectives then
        local ok, rawObjs = pcall(C_QuestLog.GetQuestObjectives, questID)
        if ok and type(rawObjs) == "table" then
            for i = 1, #rawObjs do
                local o = rawObjs[i]
                if o then
                    local req = tonumber(o.numRequired) or 0
                    local cur = tonumber(o.numFulfilled) or 0
                    local finished = (o.finished == true)
                    if req <= 0 then
                        req = 1
                        cur = finished and 1 or 0
                    end
                    table.insert(objectives, {
                        text = o.text or "",
                        finished = finished,
                        current = cur,
                        required = req
                    })
                end
            end
        end
    end

    return {
        isComplete = isComplete,
        isReady = isReady,
        objectives = objectives
    }
end

-- Scan the player's active quest log with throttling and auto-synchronization
function HFG:ScanActiveQuestLog(force)
    local now = (GetTime and GetTime()) or 0
    if not force and (now - lastScanTimestamp) < SCAN_THROTTLE_SECONDS then
        return activeQuestIDs
    end
    lastScanTimestamp = now
    trackerGeneration = trackerGeneration + 1

    for i = #activeQuestIDs, 1, -1 do
        activeQuestIDs[i] = nil
    end

    -- Primary: Modern C_QuestLog traversal
    if C_QuestLog and C_QuestLog.GetNumQuestLogEntries and C_QuestLog.GetInfo then
        local total = C_QuestLog.GetNumQuestLogEntries() or 0
        for i = 1, total do
            local info = C_QuestLog.GetInfo(i)
            if info and not info.isHeader then
                local qid = SafeVal(info.questID)
                if type(qid) == "number" and qid > 0 then
                    table.insert(activeQuestIDs, qid)

                    local progress = ParseQuestProgress(qid)
                    logEntryCache[qid] = {
                        questID = qid,
                        title = info.title or ("Quest " .. qid),
                        level = info.level or 1,
                        isComplete = (info.isComplete == true) or progress.isComplete,
                        isReady = progress.isReady,
                        objectives = progress.objectives,
                        generation = trackerGeneration
                    }
                end
            end
        end
    -- Fallback: Classic GetNumQuestLogEntries & GetQuestLogTitle
    elseif GetNumQuestLogEntries and GetQuestLogTitle then
        local total = GetNumQuestLogEntries() or 0
        for i = 1, total do
            local title, level, questTag, isHeader, isCollapsed, isComplete, frequency, qid = GetQuestLogTitle(i)
            if not isHeader and title then
                qid = SafeVal(qid)
                if type(qid) == "number" and qid > 0 then
                    table.insert(activeQuestIDs, qid)
                    logEntryCache[qid] = {
                        questID = qid,
                        title = title,
                        level = level or 1,
                        isComplete = (isComplete == 1 or isComplete == true),
                        isReady = (isComplete == 1 or isComplete == true),
                        objectives = {},
                        generation = trackerGeneration
                    }
                end
            end
        end
    end

    -- Purge stale log entries no longer present
    for qid, entry in pairs(logEntryCache) do
        if entry.generation ~= trackerGeneration then
            logEntryCache[qid] = nil
        end
    end

    -- Keep QuestEngine in sync
    if HFG.QuestEngine then
        HFG.QuestEngine.activeQuests = {}
        for qid, entry in pairs(logEntryCache) do
            HFG.QuestEngine.activeQuests[qid] = entry
            if entry.title then
                HFG.QuestEngine.activeQuests[string.lower(entry.title)] = entry
            end
        end
    end

    return activeQuestIDs
end

-- Query live state of a quest in the player's active log
function HFG:GetActiveQuestEntry(questID)
    if not questID then return nil end
    return logEntryCache[questID]
end

-- Refresh and auto-sync active guide view on quest events
function HFG:SyncQuestProgression()
    self:ScanActiveQuestLog(true)
    self:SyncCompletedQuestFlags()

    if self.UI and self.UI.MainFrame and self.UI.MainFrame:IsShown() then
        if self.currentView == "recommendations" or self.currentView == "overview" or self.currentView == "bagquests" then
            self.UI:UpdateView()
        end
    end
end
