--[[
    Heathen's Forever Guide - Core.lua
    Main Lifecycle, Event Router, Character Auto-Detector, Minimap & Slash Commands
]]

local ADDON_NAME, HFG = ...
_G.HFG = HFG

HFG_CharDB = HFG_CharDB or {}

local DEFAULT_CONFIG = {
    minimapPos = 45,
    selectedBracket = 1,
    currentView = "overview",
    completedTasks = {},
    tankGuideMode = true,
    overrideClass = nil,
    overrideSpec = nil,
    overrideRace = nil,
    overrideProf = nil
}

-- Print helper with addon prefix
function HFG:Print(msg)
    DEFAULT_CHAT_FRAME:AddMessage("|cffffd200[Heathen's Forever Guide]|r " .. tostring(msg))
end

-- Get bracket index corresponding to player's current level
function HFG:GetCurrentPlayerBracket()
    local level = UnitLevel("player") or 1
    if level < 20 then
        return 1
    elseif level < 40 then
        return 2
    elseif level < 52 then
        return 3
    else
        return 4
    end
end

-- Task completion tracking (per character)
function HFG:IsTaskCompleted(taskKey)
    if not HFG_CharDB or not HFG_CharDB.completedTasks then return false end
    return HFG_CharDB.completedTasks[taskKey] == true
end

function HFG:SetTaskCompleted(taskKey, isDone)
    if not HFG_CharDB then HFG_CharDB = {} end
    if not HFG_CharDB.completedTasks then HFG_CharDB.completedTasks = {} end
    HFG_CharDB.completedTasks[taskKey] = (isDone == true or isDone == 1)
end

-- Tab & View Switching Handlers
function HFG:SetSelectedBracket(bracketId)
    self.selectedBracket = bracketId
    if HFG_CharDB then HFG_CharDB.selectedBracket = bracketId end
    if self.UI and self.UI.MainFrame and self.UI.MainFrame:IsShown() then
        self.UI:UpdateView()
    end
end

function HFG:SetViewTab(tabId)
    self.currentView = tabId
    if HFG_CharDB then HFG_CharDB.currentView = tabId end
    if self.UI and self.UI.MainFrame and self.UI.MainFrame:IsShown() then
        self.UI:UpdateView()
    end
end

-- Toggle Main UI Window
function HFG:ToggleUI()
    local frame = self.UI:CreateMainFrame()
    if frame:IsShown() then
        frame:Hide()
    else
        frame:Show()
        self.UI:UpdateView()
    end
end

-- Safe in-game Macro Creation Helper
function HFG:InstallMacro(name, body)
    if InCombatLockdown and InCombatLockdown() then
        self:Print("|cffff2020Cannot create macro while in combat!|r")
        return
    end

    local macroIndex = GetMacroIndexByName(name)
    if macroIndex and macroIndex > 0 then
        EditMacro(macroIndex, name, nil, body)
        self:Print("Updated existing macro: |cff00ff00" .. name .. "|r")
    else
        local numGlobal, numPerChar = GetNumMacros()
        if numPerChar < 18 then
            CreateMacro(name, "INV_MISC_QUESTIONMARK", body, 1)
            self:Print("Created character macro: |cff00ff00" .. name .. "|r (Check /macro menu)")
        elseif numGlobal < 36 then
            CreateMacro(name, "INV_MISC_QUESTIONMARK", body, nil)
            self:Print("Created account macro: |cff00ff00" .. name .. "|r (Check /macro menu)")
        else
            self:Print("|cffff2020Macro slots are full! Please copy from the editbox manually.|r")
        end
    end
end

-- Minimap Button Construction
function HFG:CreateMinimapButton()
    local btn = CreateFrame("Button", "HFG_MinimapButton", Minimap)
    btn:SetSize(31, 31)
    btn:SetFrameStrata("MEDIUM")
    btn:SetFrameLevel(8)
    btn:EnableMouse(true)
    btn:SetMovable(true)

    -- Background (dark circular backdrop behind icon)
    local background = btn:CreateTexture(nil, "BACKGROUND")
    background:SetSize(20, 20)
    background:SetTexture("Interface\\Minimap\\UI-Minimap-Background")
    background:SetPoint("TOPLEFT", btn, "TOPLEFT", 7, -5)
    btn.Background = background

    -- Main Icon
    local icon = btn:CreateTexture(nil, "ARTWORK")
    icon:SetSize(17, 17)
    icon:SetTexture("Interface\\Icons\\Spell_Holy_DevotionAura")
    icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    icon:SetPoint("TOPLEFT", btn, "TOPLEFT", 7, -6)
    btn.Icon = icon

    -- Circular Gold Border Overlay (standard Blizzard 53x53 texture anchored at TOPLEFT)
    local overlay = btn:CreateTexture(nil, "OVERLAY")
    overlay:SetSize(53, 53)
    overlay:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
    overlay:SetPoint("TOPLEFT", btn, "TOPLEFT", 0, 0)
    btn.Overlay = overlay

    -- Mouseover Highlight
    btn:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")

    local isDragging = false
    local function UpdatePosition(angle)
        local rad = math.rad(angle)
        local cos = math.cos(rad)
        local sin = math.sin(rad)
        local cx = (Minimap:GetWidth() / 2) + 10
        local cy = (Minimap:GetHeight() / 2) + 10
        btn:ClearAllPoints()
        btn:SetPoint("CENTER", Minimap, "CENTER", cos * cx, sin * cy)
    end

    btn:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    btn:RegisterForDrag("LeftButton")

    btn:SetScript("OnDragStart", function(self)
        self:LockHighlight()
        isDragging = true
        self:SetScript("OnUpdate", function()
            local mx, my = Minimap:GetCenter()
            local px, py = GetCursorPosition()
            local scale = UIParent:GetEffectiveScale()
            px, py = px / scale, py / scale
            local angle = math.deg(math.atan2(py - my, px - mx))
            if angle < 0 then angle = angle + 360 end
            HFG_CharDB.minimapPos = angle
            UpdatePosition(angle)
        end)
    end)

    btn:SetScript("OnDragStop", function(self)
        self:UnlockHighlight()
        isDragging = false
        self:SetScript("OnUpdate", nil)
    end)

    btn:SetScript("OnClick", function(self, button)
        if not isDragging then
            HFG:ToggleUI()
        end
    end)

    btn:SetScript("OnEnter", function(self)
        local prof = HFG:GetActiveProfile()
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:AddLine("|cffffd200Heathen's Forever Guide|r", 1, 1, 1)
        GameTooltip:AddLine(string.format("|cff40ff40[%s] %s %s|r", prof.role or "TANK", prof.raceName, prof.specName), 0.8, 0.8, 0.8)
        GameTooltip:AddLine("Left-Click: Toggle Heathen's Forever Guide", 0.9, 0.9, 0.9)
        GameTooltip:AddLine("Left-Click & Drag: Move Icon", 0.6, 0.6, 0.6)
        GameTooltip:Show()
    end)

    btn:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    UpdatePosition(HFG_CharDB.minimapPos or 45)
    self.MinimapButton = btn
end

-- Event Listener Frame
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_LEVEL_UP")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("UNIT_INVENTORY_CHANGED")
eventFrame:RegisterEvent("UNIT_AURA")
eventFrame:RegisterEvent("CHARACTER_POINTS_CHANGED")

eventFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" then
        local addon = ...
        if addon == ADDON_NAME then
            -- Migrate legacy FTG_CharDB if present
            if not HFG_CharDB and type(_G.FTG_CharDB) == "table" then
                HFG_CharDB = _G.FTG_CharDB
            end
            if not HFG_CharDB then HFG_CharDB = {} end
            for k, v in pairs(DEFAULT_CONFIG) do
                if HFG_CharDB[k] == nil then
                    HFG_CharDB[k] = v
                end
            end

            HFG.selectedBracket = HFG_CharDB.selectedBracket or HFG:GetCurrentPlayerBracket()
            HFG.currentView = HFG_CharDB.currentView or "overview"

            HFG:CreateMinimapButton()
            local prof = HFG:GetActiveProfile()
            HFG:Print(string.format("Loaded v1.3.1. Active: |cff40ff40[%s] %s %s (%s)|r. Type |cffffd200/hfg|r to toggle Heathen's Forever Guide.", prof.role or "TANK", prof.raceName, prof.specName, prof.profName))
        end

    elseif event == "PLAYER_LEVEL_UP" then
        local newLevel = ...
        local newBracket = HFG:GetCurrentPlayerBracket()
        local previousBracket = HFG.lastNotifiedBracket or HFG_CharDB.selectedBracket

        if newBracket ~= previousBracket then
            HFG.lastNotifiedBracket = newBracket
            HFG.selectedBracket = newBracket
            HFG_CharDB.selectedBracket = newBracket

            local prof = HFG:GetActiveProfile()
            local data = prof.Brackets[newBracket] or {}
            HFG:Print(string.format("|cff00ff00*** LEVEL UP! (%d) ***|r Welcome to |cffffd200%s|r!", newLevel, data.name or ("Phase " .. newBracket)))
            if data.profession and data.profession.range then
                HFG:Print(string.format("New %s focus: |cffffff00%s|r. Type /hfg to toggle Heathen's Forever Guide.", prof.profName, data.profession.range))
            end

            if HFG.UI and HFG.UI.MainFrame and HFG.UI.MainFrame:IsShown() then
                HFG.UI:UpdateView()
            end
        end

    elseif event == "PLAYER_ENTERING_WORLD" then
        HFG.lastNotifiedBracket = HFG:GetCurrentPlayerBracket()

    elseif event == "UNIT_INVENTORY_CHANGED" or event == "UNIT_AURA" or event == "CHARACTER_POINTS_CHANGED" then
        local unit = ...
        if (not unit or unit == "player") and HFG_CharDB and not HFG_CharDB.overrideSpec then
            if HFG.UI and HFG.UI.MainFrame and HFG.UI.MainFrame:IsShown() then
                HFG.UI:UpdateView()
            end
        end
    end
end)

-- Slash Command Registration
SLASH_HEATHENSFOREVERGUIDE1 = "/hfg"
SLASH_HEATHENSFOREVERGUIDE2 = "/heathen"
SLASH_HEATHENSFOREVERGUIDE3 = "/foreverguide"

SlashCmdList["HEATHENSFOREVERGUIDE"] = function(msg)
    msg = string.lower(string.trim and string.trim(msg) or msg:match("^%s*(.-)%s*$"))
    if msg == "reset" then
        if HFG.UI and HFG.UI.MainFrame then
            HFG.UI.MainFrame:ClearAllPoints()
            HFG.UI.MainFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 20)
            HFG:Print("Window position reset to center.")
        end
    elseif msg == "help" then
        HFG:Print("Type /hfg to toggle Heathen's Forever Guide.")
    else
        HFG:ToggleUI()
    end
end
