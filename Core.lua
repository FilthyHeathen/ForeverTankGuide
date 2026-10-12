--[[
    ForeverTankGuide - Core.lua
    Main Lifecycle, Event Router, Character Auto-Detector, Minimap & Slash Commands
]]

local ADDON_NAME, FTG = ...

FTG_CharDB = FTG_CharDB or {}

local DEFAULT_CONFIG = {
    minimapPos = 45,
    selectedBracket = 1,
    currentView = "overview",
    completedTasks = {},
    overrideClass = nil,
    overrideRace = nil,
    overrideProf = nil
}

-- Print helper with addon prefix
function FTG:Print(msg)
    DEFAULT_CHAT_FRAME:AddMessage("|cffffd200[ForeverTankGuide]|r " .. tostring(msg))
end

-- Get bracket index corresponding to player's current level
function FTG:GetCurrentPlayerBracket()
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
function FTG:IsTaskCompleted(taskKey)
    if not FTG_CharDB or not FTG_CharDB.completedTasks then return false end
    return FTG_CharDB.completedTasks[taskKey] == true
end

function FTG:SetTaskCompleted(taskKey, isDone)
    if not FTG_CharDB then FTG_CharDB = {} end
    if not FTG_CharDB.completedTasks then FTG_CharDB.completedTasks = {} end
    FTG_CharDB.completedTasks[taskKey] = (isDone == true or isDone == 1)
end

-- Tab & View Switching Handlers
function FTG:SetSelectedBracket(bracketId)
    self.selectedBracket = bracketId
    if FTG_CharDB then FTG_CharDB.selectedBracket = bracketId end
    if self.UI and self.UI.MainFrame and self.UI.MainFrame:IsShown() then
        self.UI:UpdateView()
    end
end

function FTG:SetViewTab(tabId)
    self.currentView = tabId
    if FTG_CharDB then FTG_CharDB.currentView = tabId end
    if self.UI and self.UI.MainFrame and self.UI.MainFrame:IsShown() then
        self.UI:UpdateView()
    end
end

-- Toggle Main UI Window
function FTG:ToggleUI()
    local frame = self.UI:CreateMainFrame()
    if frame:IsShown() then
        frame:Hide()
    else
        frame:Show()
        self.UI:UpdateView()
    end
end

-- Safe in-game Macro Creation Helper
function FTG:InstallMacro(name, body)
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
function FTG:CreateMinimapButton()
    local btn = CreateFrame("Button", "FTG_MinimapButton", Minimap)
    btn:SetSize(32, 32)
    btn:SetFrameStrata("MEDIUM")
    btn:SetFrameLevel(8)
    btn:EnableMouse(true)
    btn:SetMovable(true)

    local icon = btn:CreateTexture(nil, "BORDER")
    icon:ClearAllPoints()
    icon:SetPoint("CENTER", btn, "CENTER", 0, 0)
    icon:SetSize(20, 20)
    icon:SetTexture("Interface\\Icons\\Spell_Holy_DevotionAura")
    icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    btn.Icon = icon

    local border = btn:CreateTexture(nil, "OVERLAY")
    border:ClearAllPoints()
    border:SetPoint("CENTER", btn, "CENTER", 0, 0)
    border:SetSize(34, 34)
    border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")

    local highlight = btn:CreateTexture(nil, "HIGHLIGHT")
    highlight:ClearAllPoints()
    highlight:SetPoint("CENTER", btn, "CENTER", 0, 0)
    highlight:SetSize(32, 32)
    highlight:SetTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
    highlight:SetBlendMode("ADD")

    local isDragging = false
    local function UpdatePosition(angle)
        local rad = math.rad(angle)
        local cos = math.cos(rad)
        local sin = math.sin(rad)
        local cx = (Minimap:GetWidth() / 2) + 10
        local cy = (Minimap:GetHeight() / 2) + 10
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
            FTG_CharDB.minimapPos = angle
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
            FTG:ToggleUI()
        end
    end)

    btn:SetScript("OnEnter", function(self)
        local prof = FTG:GetActiveProfile()
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:AddLine("|cffffd200Forever Tank Guide|r", 1, 1, 1)
        GameTooltip:AddLine(string.format("|cff00ff00%s %s Tank|r", prof.raceName, prof.className), 0.8, 0.8, 0.8)
        GameTooltip:AddLine("Left-Click: Toggle Guide Window", 0.9, 0.9, 0.9)
        GameTooltip:AddLine("Left-Click & Drag: Move Icon", 0.6, 0.6, 0.6)
        GameTooltip:Show()
    end)

    btn:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    UpdatePosition(FTG_CharDB.minimapPos or 45)
    self.MinimapButton = btn
end

-- Event Listener Frame
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_LEVEL_UP")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")

eventFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" then
        local addon = ...
        if addon == ADDON_NAME then
            -- Initialize SavedVariables Database
            if not FTG_CharDB then FTG_CharDB = {} end
            for k, v in pairs(DEFAULT_CONFIG) do
                if FTG_CharDB[k] == nil then
                    FTG_CharDB[k] = v
                end
            end

            FTG.selectedBracket = FTG_CharDB.selectedBracket or FTG:GetCurrentPlayerBracket()
            FTG.currentView = FTG_CharDB.currentView or "overview"

            FTG:CreateMinimapButton()
            local prof = FTG:GetActiveProfile()
            FTG:Print(string.format("Loaded v1.1.0 Modular Edition. Active: |cff00ff00%s %s (%s)|r. Type |cffffd200/ftg|r or click minimap icon.", prof.raceName, prof.className, prof.profName))
        end

    elseif event == "PLAYER_LEVEL_UP" then
        local newLevel = ...
        local newBracket = FTG:GetCurrentPlayerBracket()
        local previousBracket = FTG.lastNotifiedBracket or FTG_CharDB.selectedBracket

        if newBracket ~= previousBracket then
            FTG.lastNotifiedBracket = newBracket
            FTG.selectedBracket = newBracket
            FTG_CharDB.selectedBracket = newBracket

            local prof = FTG:GetActiveProfile()
            local data = prof.Brackets[newBracket] or {}
            FTG:Print(string.format("|cff00ff00*** LEVEL UP! (%d) ***|r Welcome to |cffffd200%s|r!", newLevel, data.name or ("Phase " .. newBracket)))
            if data.profession and data.profession.range then
                FTG:Print(string.format("New %s focus: |cffffff00%s|r. Check /ftg for updated dungeon drops & tanking rules!", prof.profName, data.profession.range))
            end

            if FTG.UI and FTG.UI.MainFrame and FTG.UI.MainFrame:IsShown() then
                FTG.UI:UpdateView()
            end
        end

    elseif event == "PLAYER_ENTERING_WORLD" then
        FTG.lastNotifiedBracket = FTG:GetCurrentPlayerBracket()
    end
end)

-- Slash Command Registration
SLASH_FOREVERTANKGUIDE1 = "/ftg"
SLASH_FOREVERTANKGUIDE2 = "/tankguide"

SlashCmdList["FOREVERTANKGUIDE"] = function(msg)
    msg = string.lower(string.trim and string.trim(msg) or msg:match("^%s*(.-)%s*$"))
    if msg == "reset" then
        if FTG.UI and FTG.UI.MainFrame then
            FTG.UI.MainFrame:ClearAllPoints()
            FTG.UI.MainFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 20)
            FTG:Print("Window position reset to center.")
        end
    else
        FTG:ToggleUI()
    end
end
