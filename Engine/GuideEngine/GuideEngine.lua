--[[
    Heathen's Forever Guide - Engine/GuideEngine/GuideEngine.lua
    Interactive Step-by-Step Leveling Guide Engine
    Manages linear guide routes, dynamic step auto-completion,
    zone/target waypoints, and HUD integration.
]]

local ADDON_NAME, HFG = ...
if not HFG then HFG = _G.HFG end
if not HFG then return end

HFG.GuideEngine = {
    guides = {},
    guideList = {},
    activeGuide = nil,
    activeStepIndex = 1,
}

local GE = HFG.GuideEngine

-- Register a step-by-step route guide
function HFG:RegisterGuide(guideData)
    if not guideData or not guideData.id then return end
    GE.guides[guideData.id] = guideData
    table.insert(GE.guideList, guideData)
end

-- Retrieve registered guides matching player profile
function HFG:GetAvailableGuides(profile)
    profile = profile or self:GetActiveProfile()
    local race = profile and profile.raceToken or self:GetPlayerRace()
    local faction = profile and profile.faction or self:GetPlayerFaction()
    local class = profile and profile.classToken or self:GetPlayerClass()

    local available = {}
    for _, g in ipairs(GE.guideList) do
        local match = true
        if g.faction and g.faction ~= "Both" and string.upper(g.faction) ~= string.upper(faction) then
            match = false
        end
        if match and g.races then
            local raceMatch = false
            for _, r in ipairs(g.races) do
                if string.upper(r) == string.upper(race) then raceMatch = true; break end
            end
            if not raceMatch then match = false end
        end
        if match and g.classes then
            local classMatch = false
            for _, c in ipairs(g.classes) do
                if string.upper(c) == string.upper(class) then classMatch = true; break end
            end
            if not classMatch then match = false end
        end

        if match then
            table.insert(available, g)
        end
    end

    -- If no race-specific guide matches, fallback to all guides of that faction
    if #available == 0 then
        for _, g in ipairs(GE.guideList) do
            if not g.faction or g.faction == "Both" or string.upper(g.faction) == string.upper(faction) then
                table.insert(available, g)
            end
        end
    end

    table.sort(available, function(a, b)
        if a.minLevel ~= b.minLevel then
            return a.minLevel < b.minLevel
        end
        return (a.order or 99) < (b.order or 99)
    end)
    return available
end

-- Select active guide
function HFG:SetActiveGuide(guideId, stepIndex)
    local guide = GE.guides[guideId]
    if not guide then return end

    GE.activeGuide = guide
    if not HFG_CharDB then HFG_CharDB = {} end
    if not HFG_CharDB.guideProgress then HFG_CharDB.guideProgress = {} end

    local savedStep = HFG_CharDB.guideProgress[guideId] or 1
    GE.activeStepIndex = stepIndex or savedStep

    if GE.activeStepIndex > #guide.steps then
        GE.activeStepIndex = #guide.steps
    end
    if GE.activeStepIndex < 1 then
        GE.activeStepIndex = 1
    end

    HFG_CharDB.activeGuideId = guideId
    HFG_CharDB.guideProgress[guideId] = GE.activeStepIndex

    self:EvaluateStepProgress()
    if self.UpdateGuideHUD then
        self:UpdateGuideHUD()
    end
    if self.UI and self.UI.MainFrame and self.UI.MainFrame:IsShown() and self.currentView == "steps" then
        self.UI:UpdateView()
    end
end

-- Advance to next step
function HFG:NextGuideStep()
    if not GE.activeGuide then return end
    if GE.activeStepIndex < #GE.activeGuide.steps then
        GE.activeStepIndex = GE.activeStepIndex + 1
        if HFG_CharDB and HFG_CharDB.guideProgress then
            HFG_CharDB.guideProgress[GE.activeGuide.id] = GE.activeStepIndex
        end
        self:EvaluateStepProgress()
        if self.UpdateGuideHUD then self:UpdateGuideHUD() end
        if self.UI and self.UI.MainFrame and self.UI.MainFrame:IsShown() and self.currentView == "steps" then
            self.UI:UpdateView()
        end
    end
end

-- Step back to previous step
function HFG:PrevGuideStep()
    if not GE.activeGuide then return end
    if GE.activeStepIndex > 1 then
        GE.activeStepIndex = GE.activeStepIndex - 1
        if HFG_CharDB and HFG_CharDB.guideProgress then
            HFG_CharDB.guideProgress[GE.activeGuide.id] = GE.activeStepIndex
        end
        self:EvaluateStepProgress()
        if self.UpdateGuideHUD then self:UpdateGuideHUD() end
        if self.UI and self.UI.MainFrame and self.UI.MainFrame:IsShown() and self.currentView == "steps" then
            self.UI:UpdateView()
        end
    end
end

-- Skip current step manually
function HFG:SkipGuideStep()
    self:NextGuideStep()
end

-- Automatic objective and goal validation loop
function HFG:EvaluateStepProgress()
    if not GE.activeGuide then return false end
    local step = GE.activeGuide.steps[GE.activeStepIndex]
    if not step or not step.goals then return false end

    local allGoalsComplete = true

    for _, goal in ipairs(step.goals) do
        local isComplete = false

        -- Goal: ACCEPT quest
        if goal.type == "ACCEPT" and goal.questID then
            local active = self:IsQuestActive(goal.questID)
            local turnedIn = self:CheckQuestFlaggedCompleted(goal.questID)
            if active or turnedIn then
                isComplete = true
            end

        -- Goal: COMPLETE / OBJECTIVES
        elseif goal.type == "COMPLETE" and goal.questID then
            local active, isObjDone = self:IsQuestActive(goal.questID)
            local turnedIn = self:CheckQuestFlaggedCompleted(goal.questID)
            if turnedIn or (active and isObjDone) then
                isComplete = true
            end

        -- Goal: TURNIN quest
        elseif goal.type == "TURNIN" and goal.questID then
            if self:CheckQuestFlaggedCompleted(goal.questID) then
                isComplete = true
            end

        -- Goal: REACH LEVEL
        elseif goal.type == "LEVEL" and goal.level then
            local lvl = (UnitLevel and UnitLevel("player")) or 1
            if lvl >= goal.level then
                isComplete = true
            end

        -- Goal: SET HEARTHSTONE
        elseif goal.type == "HEARTH" and goal.location then
            local bind = GetBindLocation and GetBindLocation()
            if bind and string.find(string.lower(bind), string.lower(goal.location), 1, true) then
                isComplete = true
            end

        -- Goal: DISCOVER FLIGHT PATH
        elseif goal.type == "FLY" or goal.type == "EXPLORE" then
            isComplete = false
        end

        goal.isDone = isComplete
        if not isComplete then
            allGoalsComplete = false
        end
    end

    -- If all goals achieved on current step, auto-advance forward!
    if allGoalsComplete and #step.goals > 0 and step.autoAdvance ~= false then
        if GE.activeStepIndex < #GE.activeGuide.steps then
            self:NextGuideStep()
            return true
        end
    end

    return allGoalsComplete
end

-- Auto-select recommended guide for character on load
function HFG:AutoSelectDefaultGuide()
    if HFG_CharDB and HFG_CharDB.activeGuideId and GE.guides[HFG_CharDB.activeGuideId] then
        self:SetActiveGuide(HFG_CharDB.activeGuideId)
        return
    end

    local available = self:GetAvailableGuides()
    if #available > 0 then
        local playerLevel = (UnitLevel and UnitLevel("player")) or 1
        local bestGuide = available[1]
        for _, g in ipairs(available) do
            if playerLevel >= g.minLevel and playerLevel <= (g.maxLevel or 60) then
                bestGuide = g
                break
            end
        end
        self:SetActiveGuide(bestGuide.id)
    end
end
