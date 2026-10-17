--[[
    Heathen's Forever Guide - Engine/GuideEngine/GuideHUD.lua
    Compact Floating On-Screen Guide Runner & Objective HUD
]]

local ADDON_NAME, HFG = ...
if not HFG then HFG = _G.HFG end
if not HFG then return end

local BACKDROP_TOOLTIP_STYLE = {
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 14,
    insets = { left = 3, right = 3, top = 3, bottom = 3 }
}

local function ApplyDropShadow(fontString)
    if not fontString then return end
    fontString:SetShadowOffset(1, -1)
    fontString:SetShadowColor(0, 0, 0, 1)
end

function HFG:CreateGuideHUD()
    if self.GuideHUD then return self.GuideHUD end

    local hud = CreateFrame("Frame", "HFG_GuideHUD", UIParent, "BackdropTemplate")
    hud:SetSize(280, 125)
    hud:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -220, -180)
    hud:SetMovable(true)
    hud:EnableMouse(true)
    hud:RegisterForDrag("LeftButton")
    hud:SetClampedToScreen(true)
    hud:SetFrameStrata("MEDIUM")

    if hud.SetBackdrop then
        hud:SetBackdrop(BACKDROP_TOOLTIP_STYLE)
        hud:SetBackdropColor(0.04, 0.04, 0.06, 0.90)
        hud:SetBackdropBorderColor(0.8, 0.7, 0.2, 0.8)
    end

    hud:SetScript("OnDragStart", function(self) self:StartMoving() end)
    hud:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)

    -- Header Title
    local title = hud:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    title:SetPoint("TOPLEFT", hud, "TOPLEFT", 10, -8)
    title:SetText("|cffffd200Heathen's Guide Runner|r")
    ApplyDropShadow(title)
    hud.Title = title

    -- Step Indicator
    local stepCounter = hud:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    stepCounter:SetPoint("TOPRIGHT", hud, "TOPRIGHT", -10, -8)
    stepCounter:SetText("Step 1/10")
    ApplyDropShadow(stepCounter)
    hud.StepCounter = stepCounter

    -- Step Title
    local stepTitle = hud:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    stepTitle:SetPoint("TOPLEFT", hud, "TOPLEFT", 10, -26)
    stepTitle:SetWidth(260)
    stepTitle:SetJustifyH("LEFT")
    stepTitle:SetText("Loading guide...")
    ApplyDropShadow(stepTitle)
    hud.StepTitle = stepTitle

    -- Goals Container Frame
    local goalsFrame = CreateFrame("Frame", nil, hud)
    goalsFrame:SetPoint("TOPLEFT", hud, "TOPLEFT", 10, -44)
    goalsFrame:SetPoint("BOTTOMRIGHT", hud, "BOTTOMRIGHT", -10, 26)
    hud.GoalsFrame = goalsFrame
    hud.GoalLines = {}

    -- Navigation Button Bar
    local prevBtn = CreateFrame("Button", nil, hud, "UIPanelButtonTemplate")
    prevBtn:SetSize(40, 20)
    prevBtn:SetPoint("BOTTOMLEFT", hud, "BOTTOMLEFT", 8, 5)
    prevBtn:SetText("<")
    prevBtn:SetScript("OnClick", function() HFG:PrevGuideStep() end)

    local skipBtn = CreateFrame("Button", nil, hud, "UIPanelButtonTemplate")
    skipBtn:SetSize(60, 20)
    skipBtn:SetPoint("LEFT", prevBtn, "RIGHT", 4, 0)
    skipBtn:SetText("Skip")
    skipBtn:SetScript("OnClick", function() HFG:SkipGuideStep() end)

    local nextBtn = CreateFrame("Button", nil, hud, "UIPanelButtonTemplate")
    nextBtn:SetSize(40, 20)
    nextBtn:SetPoint("LEFT", skipBtn, "RIGHT", 4, 0)
    nextBtn:SetText(">")
    nextBtn:SetScript("OnClick", function() HFG:NextGuideStep() end)

    local openBtn = CreateFrame("Button", nil, hud, "UIPanelButtonTemplate")
    openBtn:SetSize(60, 20)
    openBtn:SetPoint("BOTTOMRIGHT", hud, "BOTTOMRIGHT", -8, 5)
    openBtn:SetText("Guide")
    openBtn:SetScript("OnClick", function()
        HFG:SetViewTab("steps")
        if not HFG.UI.MainFrame:IsShown() then
            HFG.UI.MainFrame:Show()
        end
    end)

    self.GuideHUD = hud
    self:UpdateGuideHUD()
    return hud
end

-- Refresh Guide HUD State
function HFG:UpdateGuideHUD()
    local hud = self.GuideHUD
    if not hud then return end

    local GE = self.GuideEngine
    if not GE or not GE.activeGuide then
        hud.StepTitle:SetText("No active guide selected. Type /hfg to choose a route.")
        hud.StepCounter:SetText("")
        return
    end

    local guide = GE.activeGuide
    local stepIndex = GE.activeStepIndex or 1
    local step = guide.steps[stepIndex]

    if not step then return end

    hud.Title:SetText(string.format("|cffffd200%s|r", guide.title))
    hud.StepCounter:SetText(string.format("Step %d/%d", stepIndex, #guide.steps))
    hud.StepTitle:SetText(string.format("|cffffffff%s|r", step.title or ("Step " .. stepIndex)))

    -- Clear existing goal text lines
    for _, line in ipairs(hud.GoalLines) do
        line:Hide()
    end

    local yPos = 0
    for idx, goal in ipairs(step.goals or {}) do
        local line = hud.GoalLines[idx]
        if not line then
            line = hud.GoalsFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            line:SetJustifyH("LEFT")
            hud.GoalLines[idx] = line
        end

        line:ClearAllPoints()
        line:SetPoint("TOPLEFT", hud.GoalsFrame, "TOPLEFT", 0, yPos)
        line:SetWidth(260)

        local checkMark = goal.isDone and "|cff00ff00[✓]|r " or "|cff888888[ ]|r "
        local textColor = goal.isDone and "|cff666666" or "|cffffd200"
        line:SetText(checkMark .. textColor .. (goal.text or goal.type) .. "|r")
        ApplyDropShadow(line)
        line:Show()

        yPos = yPos - (line:GetStringHeight() + 4)
    end

    -- Dynamically resize HUD height based on number of goals
    local dynamicHeight = math.max(115, 65 + (-yPos) + 30)
    hud:SetHeight(dynamicHeight)
end

-- Toggle Guide HUD on/off
function HFG:ToggleGuideHUD()
    local hud = self.GuideHUD or self:CreateGuideHUD()
    if hud:IsShown() then
        hud:Hide()
        self:Print("Guide HUD hidden. Type /hfg hud to show.")
    else
        hud:Show()
        self:UpdateGuideHUD()
        self:Print("Guide HUD shown.")
    end
end
