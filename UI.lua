--[[
    ForeverTankGuide - UI.lua
    Dynamic Rendering Engine, Dropdowns, Checklists, and Macro Installer
]]

local ADDON_NAME, FTG = ...

FTG.UI = {}

local BACKDROP_TEMPLATE = (BackdropTemplateMixin and "BackdropTemplate") or nil

local BACKDROP_DIALOG_DARK = {
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true,
    tileSize = 32,
    edgeSize = 24,
    insets = { left = 6, right = 6, top = 6, bottom = 6 }
}

local BACKDROP_TOOLTIP_STYLE = {
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true,
    tileSize = 16,
    edgeSize = 14,
    insets = { left = 3, right = 3, top = 3, bottom = 3 }
}

local BACKDROP_SLIDER_STYLE = {
    bgFile = "Interface\\Buttons\\UI-SliderBar-Background",
    edgeFile = "Interface\\Buttons\\UI-SliderBar-Border",
    tile = true,
    tileSize = 8,
    edgeSize = 8,
    insets = { left = 3, right = 3, top = 3, bottom = 3 }
}

-- Helper to apply shadow to FontStrings
local function ApplyDropShadow(fs)
    if fs and fs.SetShadowOffset then
        fs:SetShadowOffset(1, -1)
        fs:SetShadowColor(0, 0, 0, 1)
    end
    return fs
end

function FTG.UI:CreateMainFrame()
    if self.MainFrame then return self.MainFrame end

    local f = CreateFrame("Frame", "FTG_MainFrame", UIParent, BackdropTemplateMixin and "BackdropTemplate" or nil)
    f:SetSize(820, 560)
    f:SetPoint("CENTER", UIParent, "CENTER", 0, 20)
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetClampedToScreen(true)
    f:SetFrameStrata("FULLSCREEN_DIALOG")
    f:SetFrameLevel(500)
    f:SetToplevel(true)

    -- Dedicated solid color texture on main frame to guarantee 100% zero bleed-through
    local bg = f:CreateTexture(nil, "BACKGROUND", nil, -8)
    bg:SetAllPoints(f)
    if bg.SetColorTexture then
        bg:SetColorTexture(0.05, 0.05, 0.07, 1.0)
    else
        bg:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Background-Dark")
        bg:SetVertexColor(0.05, 0.05, 0.07, 1.0)
    end
    f.solidBg = bg

    -- Border outline
    if f.SetBackdrop then
        f:SetBackdrop({
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            edgeSize = 16,
            insets = { left = 4, right = 4, top = 4, bottom = 4 },
        })
        f:SetBackdropBorderColor(0.8, 0.7, 0.2, 1)
    end

    -- Drag Handlers
    f:SetScript("OnDragStart", function(self) self:StartMoving() end)
    f:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)

    -- Title Bar
    local titleBg = f:CreateTexture(nil, "ARTWORK")
    titleBg:SetPoint("TOPLEFT", f, "TOPLEFT", 10, -8)
    titleBg:SetPoint("TOPRIGHT", f, "TOPRIGHT", -10, -8)
    titleBg:SetHeight(38)
    titleBg:SetTexture("Interface\\Tooltips\\UI-Tooltip-Background")
    titleBg:SetVertexColor(0.10, 0.08, 0.12, 0.95)

    -- Icon
    local titleIcon = f:CreateTexture(nil, "OVERLAY")
    titleIcon:SetSize(28, 28)
    titleIcon:SetPoint("LEFT", titleBg, "LEFT", 10, 0)
    titleIcon:SetTexture("Interface\\Icons\\Spell_Holy_DevotionAura")
    f.TitleIcon = titleIcon

    -- Title Text
    local titleText = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    titleText:SetPoint("LEFT", titleIcon, "RIGHT", 10, 0)
    titleText:SetText("|cffffd200Forever Tank Guide|r |cff40ff40[Modular Registry Edition]|r")
    ApplyDropShadow(titleText)
    f.TitleText = titleText

    -- Player Level / Active status subtitle
    local levelText = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    levelText:SetPoint("RIGHT", titleBg, "RIGHT", -36, 0)
    levelText:SetTextColor(0.9, 0.9, 0.9, 1)
    ApplyDropShadow(levelText)
    f.LevelText = levelText

    -- Close Button
    local closeBtn = CreateFrame("Button", nil, f, "UIPanelCloseButton")
    closeBtn:SetPoint("TOPRIGHT", f, "TOPRIGHT", -4, -4)
    closeBtn:SetScript("OnClick", function() f:Hide() end)

    -- Top Profile Selection Bar (Class, Race, Profession, and Auto-Detect Reset)
    self:CreateProfileBar(f)

    -- Tab Bar (Top buttons: Bracket 1, Bracket 2, Bracket 3, Bracket 4)
    self:CreateTopBar(f)

    -- Navigation Left Menu (Overview, Profession, Dungeon Checklist, Macro Vault)
    self:CreateSideMenu(f)

    -- Content Scroll Area
    self:CreateContentArea(f)

    f:Hide()
    self.MainFrame = f
    return f
end

-- Profile Bar with Interactive Selectors
function FTG.UI:CreateProfileBar(parent)
    local bar = CreateFrame("Frame", nil, parent)
    bar:SetPoint("TOPLEFT", parent, "TOPLEFT", 14, -48)
    bar:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -14, -48)
    bar:SetHeight(30)

    if bar.SetBackdrop then
        bar:SetBackdrop(BACKDROP_TOOLTIP_STYLE)
        bar:SetBackdropColor(0.04, 0.04, 0.06, 0.95)
        bar:SetBackdropBorderColor(0.4, 0.4, 0.5, 0.8)
    end

    local label = bar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    label:SetPoint("LEFT", bar, "LEFT", 8, 0)
    label:SetText("|cffffcc00Profile:|r")
    ApplyDropShadow(label)

    -- Class Selector Button
    local classBtn = CreateFrame("Button", "FTG_ClassDropdownBtn", bar, "UIPanelButtonTemplate")
    classBtn:SetSize(140, 20)
    classBtn:SetPoint("LEFT", label, "RIGHT", 8, 0)
    classBtn:SetText("Class")
    ApplyDropShadow(classBtn:GetFontString())

    -- Race Selector Button
    local raceBtn = CreateFrame("Button", "FTG_RaceDropdownBtn", bar, "UIPanelButtonTemplate")
    raceBtn:SetSize(130, 20)
    raceBtn:SetPoint("LEFT", classBtn, "RIGHT", 6, 0)
    raceBtn:SetText("Race")
    ApplyDropShadow(raceBtn:GetFontString())

    -- Profession Selector Button
    local profBtn = CreateFrame("Button", "FTG_ProfDropdownBtn", bar, "UIPanelButtonTemplate")
    profBtn:SetSize(140, 20)
    profBtn:SetPoint("LEFT", raceBtn, "RIGHT", 6, 0)
    profBtn:SetText("Profession")
    ApplyDropShadow(profBtn:GetFontString())

    -- Auto-Detect / Reset Button
    local resetBtn = CreateFrame("Button", nil, bar, "UIPanelButtonTemplate")
    resetBtn:SetSize(110, 20)
    resetBtn:SetPoint("RIGHT", bar, "RIGHT", -6, 0)
    resetBtn:SetText("Detect Player")
    ApplyDropShadow(resetBtn:GetFontString())
    resetBtn:SetScript("OnClick", function()
        FTG:ResetProfileToPlayer()
        FTG:Print("Profile reset to live character auto-detection.")
        FTG.UI:UpdateView()
    end)

    -- Dropdown Menus Setup using UIDropDownMenu API
    local classDrop = CreateFrame("Frame", "FTG_ClassDropDown", bar, "UIDropDownMenuTemplate")
    UIDropDownMenu_Initialize(classDrop, function(self, level)
        local classes = FTG:GetRegisteredClasses()
        for _, c in ipairs(classes) do
            local info = UIDropDownMenu_CreateInfo()
            info.text = c.name
            info.value = c.token
            info.func = function()
                FTG_CharDB.overrideClass = c.token
                FTG.UI:UpdateView()
            end
            UIDropDownMenu_AddButton(info, level)
        end
    end)
    classBtn:SetScript("OnClick", function()
        ToggleDropDownMenu(1, nil, classDrop, classBtn, 0, 0)
    end)

    local raceDrop = CreateFrame("Frame", "FTG_RaceDropDown", bar, "UIDropDownMenuTemplate")
    UIDropDownMenu_Initialize(raceDrop, function(self, level)
        local races = FTG:GetRegisteredRaces()
        for _, r in ipairs(races) do
            local info = UIDropDownMenu_CreateInfo()
            local color = (r.faction == "Horde" and "|cffff3333" or "|cff3388ff")
            info.text = string.format("%s[%s]|r %s", color, r.faction:sub(1,1), r.name)
            info.value = r.token
            info.func = function()
                FTG_CharDB.overrideRace = r.token
                FTG.UI:UpdateView()
            end
            UIDropDownMenu_AddButton(info, level)
        end
    end)
    raceBtn:SetScript("OnClick", function()
        ToggleDropDownMenu(1, nil, raceDrop, raceBtn, 0, 0)
    end)

    local profDrop = CreateFrame("Frame", "FTG_ProfDropDown", bar, "UIDropDownMenuTemplate")
    UIDropDownMenu_Initialize(profDrop, function(self, level)
        local profs = FTG:GetRegisteredProfessions()
        for _, p in ipairs(profs) do
            local info = UIDropDownMenu_CreateInfo()
            info.text = p.name
            info.value = p.token
            info.func = function()
                FTG_CharDB.overrideProf = p.token
                FTG.UI:UpdateView()
            end
            UIDropDownMenu_AddButton(info, level)
        end
    end)
    profBtn:SetScript("OnClick", function()
        ToggleDropDownMenu(1, nil, profDrop, profBtn, 0, 0)
    end)

    parent.ClassDropdownBtn = classBtn
    parent.RaceDropdownBtn = raceBtn
    parent.ProfDropdownBtn = profBtn
    parent.ProfileBar = bar
end

function FTG.UI:CreateTopBar(parent)
    local bar = CreateFrame("Frame", nil, parent)
    bar:SetPoint("TOPLEFT", parent, "TOPLEFT", 180, -82)
    bar:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -15, -82)
    bar:SetHeight(30)
    parent.TopBar = bar

    local bracketButtons = {}
    local tabs = {
        { id = 1, label = "L1–20 (Start)" },
        { id = 2, label = "L20–40 (Mid)" },
        { id = 3, label = "L40–52 (Deep)" },
        { id = 4, label = "L52–60 (Endgame)" },
    }

    local prevBtn = nil
    for idx, t in ipairs(tabs) do
        local btn = CreateFrame("Button", nil, bar, "UIPanelButtonTemplate")
        btn:SetSize(135, 24)
        if prevBtn then
            btn:SetPoint("LEFT", prevBtn, "RIGHT", 8, 0)
        else
            btn:SetPoint("LEFT", bar, "LEFT", 0, 0)
        end
        btn:SetText(t.label)
        ApplyDropShadow(btn:GetFontString())

        btn:SetScript("OnClick", function()
            FTG:SetSelectedBracket(t.id)
        end)

        bracketButtons[t.id] = btn
        prevBtn = btn
    end

    parent.BracketButtons = bracketButtons
end

function FTG.UI:CreateSideMenu(parent)
    local menu = CreateFrame("Frame", nil, parent)
    menu:SetPoint("TOPLEFT", parent, "TOPLEFT", 12, -82)
    menu:SetPoint("BOTTOMLEFT", parent, "BOTTOMLEFT", 12, 12)
    menu:SetWidth(160)

    if menu.SetBackdrop then
        menu:SetBackdrop(BACKDROP_TOOLTIP_STYLE)
        menu:SetBackdropColor(0.04, 0.04, 0.06, 0.95)
        menu:SetBackdropBorderColor(0.4, 0.4, 0.5, 0.8)
    end

    local items = {
        { id = "overview", text = "Bracket Overview", icon = "Interface\\Icons\\Spell_Holy_AuraMastery" },
        { id = "profession", text = "Prof. Roadmap", icon = "Interface\\Icons\\Trade_Engineering" },
        { id = "dungeons", text = "Dungeon Checklist", icon = "Interface\\Icons\\Spell_Holy_PurifyingPower" },
        { id = "macros", text = "Macro Vault", icon = "Interface\\Icons\\Spell_Holy_InnerFire" },
    }

    local navButtons = {}
    local prev = nil
    for idx, item in ipairs(items) do
        local btn = CreateFrame("Button", nil, menu, "UIPanelButtonTemplate")
        btn:SetSize(144, 34)
        if prev then
            btn:SetPoint("TOP", prev, "BOTTOM", 0, -8)
        else
            btn:SetPoint("TOP", menu, "TOP", 0, -10)
        end
        btn:SetText(item.text)
        local fs = btn:GetFontString()
        fs:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
        ApplyDropShadow(fs)

        btn:SetScript("OnClick", function()
            FTG:SetViewTab(item.id)
        end)

        navButtons[item.id] = btn
        prev = btn
    end

    -- Bottom status widget
    local statusBox = CreateFrame("Frame", nil, menu)
    statusBox:SetPoint("BOTTOMLEFT", menu, "BOTTOMLEFT", 6, 6)
    statusBox:SetPoint("BOTTOMRIGHT", menu, "BOTTOMRIGHT", -6, 6)
    statusBox:SetHeight(85)
    if statusBox.SetBackdrop then
        statusBox:SetBackdrop(BACKDROP_TOOLTIP_STYLE)
        statusBox:SetBackdropColor(0.02, 0.02, 0.02, 0.85)
    end

    local statusText = statusBox:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    statusText:SetPoint("TOPLEFT", statusBox, "TOPLEFT", 6, -6)
    statusText:SetPoint("BOTTOMRIGHT", statusBox, "BOTTOMRIGHT", -6, 6)
    statusText:SetJustifyH("LEFT")
    statusText:SetJustifyV("TOP")
    statusText:SetText("|cffffcc00Modular Engine:|r\nActive\n|cffccccccUse profile bar above to preview other classes/races.|r")
    ApplyDropShadow(statusText)
    parent.StatusBoxText = statusText

    parent.NavButtons = navButtons
end

function FTG.UI:CreateContentArea(parent)
    local content = CreateFrame("Frame", nil, parent, BackdropTemplateMixin and "BackdropTemplate" or nil)
    content:SetPoint("TOPLEFT", parent, "TOPLEFT", 180, -116)
    content:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -14, 14)

    -- Separate nested opaque background behind text/scroll area for ultra-dark reading surface
    local contentBg = content:CreateTexture(nil, "BACKGROUND", nil, -7)
    contentBg:SetAllPoints(content)
    if contentBg.SetColorTexture then
        contentBg:SetColorTexture(0.02, 0.02, 0.03, 1.0)
    else
        contentBg:SetTexture("Interface\\Tooltips\\UI-Tooltip-Background")
        contentBg:SetVertexColor(0.02, 0.02, 0.03, 1.0)
    end
    content.solidBg = contentBg

    if content.SetBackdrop then
        content:SetBackdrop(BACKDROP_TOOLTIP_STYLE)
        content:SetBackdropColor(0.02, 0.02, 0.03, 1.0)
        content:SetBackdropBorderColor(0.6, 0.5, 0.35, 0.9)
    end

    local scrollFrame = CreateFrame("ScrollFrame", "FTG_ContentScrollFrame", content)
    scrollFrame:SetPoint("TOPLEFT", content, "TOPLEFT", 8, -8)
    scrollFrame:SetPoint("BOTTOMRIGHT", content, "BOTTOMRIGHT", -26, 8)

    local scrollChild = CreateFrame("Frame", "FTG_ContentScrollChild", scrollFrame)
    scrollChild:SetSize(580, 600)
    scrollFrame:SetScrollChild(scrollChild)

    local slider = CreateFrame("Slider", "FTG_ContentSlider", content)
    slider:SetPoint("TOPRIGHT", content, "TOPRIGHT", -8, -24)
    slider:SetPoint("BOTTOMRIGHT", content, "BOTTOMRIGHT", -8, 24)
    slider:SetWidth(14)
    if slider.SetBackdrop then
        slider:SetBackdrop(BACKDROP_SLIDER_STYLE)
    end

    local thumb = slider:CreateTexture(nil, "OVERLAY")
    thumb:SetTexture("Interface\\Buttons\\UI-SliderBar-Button-Vertical")
    thumb:SetSize(18, 26)
    slider:SetThumbTexture(thumb)

    slider:SetOrientation("VERTICAL")
    slider:SetMinMaxValues(0, 100)
    slider:SetValue(0)
    slider:SetValueStep(10)

    slider:SetScript("OnValueChanged", function(self, val)
        scrollFrame:SetVerticalScroll(val)
    end)

    scrollFrame:EnableMouseWheel(true)
    scrollFrame:SetScript("OnMouseWheel", function(self, delta)
        local cur = slider:GetValue()
        local minV, maxV = slider:GetMinMaxValues()
        local step = 30
        if delta > 0 then
            slider:SetValue(math.max(minV, cur - step))
        else
            slider:SetValue(math.min(maxV, cur + step))
        end
    end)

    parent.ScrollFrame = scrollFrame
    parent.ScrollChild = scrollChild
    parent.ContentSlider = slider
    parent.ContentArea = content
end

-- Refresh UI with Current Selected Bracket & View Tab
function FTG.UI:UpdateView()
    local f = self.MainFrame
    if not f or not f:IsShown() then return end

    local profile = FTG:GetActiveProfile()
    local currentBracketId = FTG.selectedBracket or FTG:GetCurrentPlayerBracket()
    local currentView = FTG.currentView or "overview"
    local bracketData = profile.Brackets[currentBracketId] or {}

    -- Update Dropdown Button Titles
    f.ClassDropdownBtn:SetText(profile.className)
    f.RaceDropdownBtn:SetText(profile.raceName)
    f.ProfDropdownBtn:SetText(profile.profName)

    -- Update Top Title / Level
    local playerLevel = UnitLevel("player") or 1
    f.LevelText:SetText(string.format("Player Lvl: |cff40ff40%d|r | Active: |cffffd200%s %s|r", playerLevel, profile.raceName, profile.className))

    -- Highlight Bracket Buttons
    for id, btn in pairs(f.BracketButtons) do
        if id == currentBracketId then
            btn:LockHighlight()
        else
            btn:UnlockHighlight()
        end
    end

    -- Highlight Navigation Buttons
    for id, btn in pairs(f.NavButtons) do
        if id == currentView then
            btn:LockHighlight()
        else
            btn:UnlockHighlight()
        end
    end

    -- Clear scroll child elements
    local child = f.ScrollChild
    if child.elements then
        for _, elem in ipairs(child.elements) do
            elem:Hide()
            elem:SetParent(nil)
        end
    end
    child.elements = {}

    -- Render specific view
    local totalHeight = 0
    if currentView == "overview" then
        totalHeight = self:RenderOverview(child, bracketData, profile)
    elseif currentView == "profession" then
        totalHeight = self:RenderProfession(child, bracketData, profile)
    elseif currentView == "dungeons" then
        totalHeight = self:RenderDungeons(child, bracketData)
    elseif currentView == "macros" then
        totalHeight = self:RenderMacros(child, profile)
    end

    child:SetHeight(math.max(totalHeight + 40, 400))
    local maxScroll = math.max(0, child:GetHeight() - f.ScrollFrame:GetHeight())
    f.ContentSlider:SetMinMaxValues(0, maxScroll)
    f.ContentSlider:SetValue(0)
    f.ScrollFrame:SetVerticalScroll(0)
end

-- 1. RENDER OVERVIEW TAB
function FTG.UI:RenderOverview(child, bracket, profile)
    local yOffset = -10
    local width = child:GetWidth() - 20

    -- Section Title
    local title = child:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", child, "TOPLEFT", 10, yOffset)
    title:SetText(string.format("|cffffcc00%s|r - |cffffffff%s %s|r", bracket.name or "Phase", profile.raceName, profile.className))
    ApplyDropShadow(title)
    table.insert(child.elements, title)
    yOffset = yOffset - 24

    -- Summary
    if bracket.summary then
        local summary = child:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        summary:SetPoint("TOPLEFT", child, "TOPLEFT", 10, yOffset)
        summary:SetWidth(width)
        summary:SetJustifyH("LEFT")
        summary:SetTextColor(0.9, 0.9, 0.9, 1)
        summary:SetText(bracket.summary)
        ApplyDropShadow(summary)
        table.insert(child.elements, summary)
        yOffset = yOffset - (summary:GetStringHeight() + 14)
    end

    -- Section: Recommended Leveling Zones
    if bracket.zones and #bracket.zones > 0 then
        local zoneHeader = child:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        zoneHeader:SetPoint("TOPLEFT", child, "TOPLEFT", 10, yOffset)
        zoneHeader:SetTextColor(0.3, 1.0, 0.3, 1) -- Bright lime green
        zoneHeader:SetText(string.format("Recommended Leveling & Farming Zones (%s)", profile.raceName))
        ApplyDropShadow(zoneHeader)
        table.insert(child.elements, zoneHeader)
        yOffset = yOffset - 18

        for _, z in ipairs(bracket.zones) do
            local line = child:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            line:SetPoint("TOPLEFT", child, "TOPLEFT", 20, yOffset)
            line:SetWidth(width - 20)
            line:SetJustifyH("LEFT")
            line:SetTextColor(0.9, 0.9, 0.9, 1)
            line:SetText(string.format("• |cffffd200%s|r (|cff40ff40Lvl %s|r): %s", z.name, z.range, z.notes))
            ApplyDropShadow(line)
            table.insert(child.elements, line)
            yOffset = yOffset - (line:GetStringHeight() + 6)
        end
        yOffset = yOffset - 10
    end

    -- Section: Key Ability Milestones & Racials
    if bracket.abilities and #bracket.abilities > 0 then
        local abHeader = child:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        abHeader:SetPoint("TOPLEFT", child, "TOPLEFT", 10, yOffset)
        abHeader:SetTextColor(0.3, 1.0, 0.3, 1) -- Bright lime green
        abHeader:SetText(string.format("Abilities & Racials (%s)", profile.className))
        ApplyDropShadow(abHeader)
        table.insert(child.elements, abHeader)
        yOffset = yOffset - 18

        for _, ab in ipairs(bracket.abilities) do
            local line = child:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            line:SetPoint("TOPLEFT", child, "TOPLEFT", 20, yOffset)
            line:SetWidth(width - 20)
            line:SetJustifyH("LEFT")
            line:SetTextColor(0.9, 0.9, 0.9, 1)
            line:SetText(string.format("• |cffffd200Level %d: %s|r - %s", ab.level, ab.name, ab.desc))
            ApplyDropShadow(line)
            table.insert(child.elements, line)
            yOffset = yOffset - (line:GetStringHeight() + 6)
        end
        yOffset = yOffset - 10
    end

    -- Section: Core Tank Rules
    if bracket.tankRules and #bracket.tankRules > 0 then
        local tankHeader = child:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        tankHeader:SetPoint("TOPLEFT", child, "TOPLEFT", 10, yOffset)
        tankHeader:SetTextColor(1.0, 0.8, 0.2, 1) -- Bright amber / gold
        tankHeader:SetText(string.format("Tactical Tanking Rules (%s)", profile.className))
        ApplyDropShadow(tankHeader)
        table.insert(child.elements, tankHeader)
        yOffset = yOffset - 18

        for idx, rule in ipairs(bracket.tankRules) do
            local line = child:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            line:SetPoint("TOPLEFT", child, "TOPLEFT", 20, yOffset)
            line:SetWidth(width - 20)
            line:SetJustifyH("LEFT")
            line:SetTextColor(0.9, 0.9, 0.9, 1)
            line:SetText(string.format("|cffffcc00[%d]|r %s", idx, rule))
            ApplyDropShadow(line)
            table.insert(child.elements, line)
            yOffset = yOffset - (line:GetStringHeight() + 6)
        end
    end

    return -yOffset
end

-- 2. RENDER PROFESSION ROADMAP TAB
function FTG.UI:RenderProfession(child, bracket, profile)
    local yOffset = -10
    local width = child:GetWidth() - 20
    local prof = bracket.profession or {}

    local title = child:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", child, "TOPLEFT", 10, yOffset)
    title:SetText(string.format("|cffffcc00%s Roadmap - %s|r", prof.name or profile.profName, prof.range or "Skill 1–300"))
    ApplyDropShadow(title)
    table.insert(child.elements, title)
    yOffset = yOffset - 24

    -- Milestones
    if prof.milestones and #prof.milestones > 0 then
        local msHeader = child:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        msHeader:SetPoint("TOPLEFT", child, "TOPLEFT", 10, yOffset)
        msHeader:SetTextColor(0.3, 1.0, 0.3, 1) -- Bright lime green
        msHeader:SetText("Crafting Progression & Target Utilities")
        ApplyDropShadow(msHeader)
        table.insert(child.elements, msHeader)
        yOffset = yOffset - 18

        for _, m in ipairs(prof.milestones) do
            local box = CreateFrame("Frame", nil, child)
            box:SetPoint("TOPLEFT", child, "TOPLEFT", 15, yOffset)
            box:SetSize(width - 15, 46)
            if box.SetBackdrop then
                box:SetBackdrop(BACKDROP_TOOLTIP_STYLE)
                box:SetBackdropColor(0.08, 0.08, 0.10, 0.9)
                box:SetBackdropBorderColor(0.4, 0.4, 0.5, 0.7)
            end
            table.insert(child.elements, box)

            local t1 = box:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            t1:SetPoint("TOPLEFT", box, "TOPLEFT", 8, -6)
            t1:SetText(string.format("|cff40ff40[Skill %d]|r |cffffffff%s|r", m.skill, m.name))
            ApplyDropShadow(t1)

            local t2 = box:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            t2:SetPoint("TOPLEFT", box, "TOPLEFT", 8, -22)
            t2:SetWidth(width - 35)
            t2:SetJustifyH("LEFT")
            t2:SetTextColor(0.9, 0.9, 0.9, 1)
            t2:SetText(string.format("|cffccccccMats: %s|r  |  |cffffd200%s|r", m.mats, m.notes))
            ApplyDropShadow(t2)

            yOffset = yOffset - 50
        end
        yOffset = yOffset - 10
    end

    -- Shopping List
    if prof.shoppingList and #prof.shoppingList > 0 then
        local shopHeader = child:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        shopHeader:SetPoint("TOPLEFT", child, "TOPLEFT", 10, yOffset)
        shopHeader:SetTextColor(0.3, 1.0, 0.3, 1) -- Bright lime green
        shopHeader:SetText("Materials Shopping & Hoarding List")
        ApplyDropShadow(shopHeader)
        table.insert(child.elements, shopHeader)
        yOffset = yOffset - 18

        for _, item in ipairs(prof.shoppingList) do
            local line = child:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            line:SetPoint("TOPLEFT", child, "TOPLEFT", 25, yOffset)
            line:SetTextColor(0.9, 0.9, 0.9, 1)
            line:SetText(string.format("• |cffffffff%s|r", item))
            ApplyDropShadow(line)
            table.insert(child.elements, line)
            yOffset = yOffset - 18
        end
    end

    -- Auction House Profits (if available in Phase 4)
    if prof.ahProfits then
        yOffset = yOffset - 14
        local ahHeader = child:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        ahHeader:SetPoint("TOPLEFT", child, "TOPLEFT", 10, yOffset)
        ahHeader:SetTextColor(1.0, 0.8, 0.2, 1) -- Bright amber / gold
        ahHeader:SetText("Commercial Gold Making & AH Opportunities")
        ApplyDropShadow(ahHeader)
        table.insert(child.elements, ahHeader)
        yOffset = yOffset - 20

        for _, ah in ipairs(prof.ahProfits) do
            local line = child:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            line:SetPoint("TOPLEFT", child, "TOPLEFT", 20, yOffset)
            line:SetWidth(width - 20)
            line:SetJustifyH("LEFT")
            line:SetTextColor(0.9, 0.9, 0.9, 1)
            line:SetText(string.format("• |cffffd200%s|r: %s", ah.item, ah.notes))
            ApplyDropShadow(line)
            table.insert(child.elements, line)
            yOffset = yOffset - (line:GetStringHeight() + 6)
        end
    end

    return -yOffset
end

-- 3. RENDER DUNGEON CHECKLIST TAB
function FTG.UI:RenderDungeons(child, bracket)
    local yOffset = -10
    local width = child:GetWidth() - 20
    local dungeons = bracket.dungeons or {}

    local title = child:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", child, "TOPLEFT", 10, yOffset)
    title:SetText("|cffffcc00Dungeon Tanking & Gear Checklist|r")
    ApplyDropShadow(title)
    table.insert(child.elements, title)
    yOffset = yOffset - 24

    local sub = child:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    sub:SetPoint("TOPLEFT", child, "TOPLEFT", 10, yOffset)
    sub:SetTextColor(0.9, 0.9, 0.9, 1)
    sub:SetText("Check off dungeons completed and key gear acquired for this bracket:")
    ApplyDropShadow(sub)
    table.insert(child.elements, sub)
    yOffset = yOffset - 20

    for _, d in ipairs(dungeons) do
        local dungBox = CreateFrame("Frame", nil, child)
        dungBox:SetPoint("TOPLEFT", child, "TOPLEFT", 10, yOffset)
        dungBox:SetSize(width, 28)
        if dungBox.SetBackdrop then
            dungBox:SetBackdrop(BACKDROP_TOOLTIP_STYLE)
            dungBox:SetBackdropColor(0.12, 0.08, 0.16, 0.95)
            dungBox:SetBackdropBorderColor(0.7, 0.5, 0.9, 0.9)
        end
        table.insert(child.elements, dungBox)

        local dungCheck = CreateFrame("CheckButton", nil, dungBox, "UICheckButtonTemplate")
        dungCheck:SetPoint("LEFT", dungBox, "LEFT", 6, 0)
        dungCheck:SetSize(22, 22)
        local dungChecked = FTG:IsTaskCompleted("dung_" .. d.key)
        dungCheck:SetChecked(dungChecked)
        dungCheck:SetScript("OnClick", function(self)
            FTG:SetTaskCompleted("dung_" .. d.key, self:GetChecked())
        end)

        local dungLabel = dungBox:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        dungLabel:SetPoint("LEFT", dungCheck, "RIGHT", 4, 0)
        dungLabel:SetText(string.format("|cffffd200%s|r (|cff40ff40Lvl %s|r) - %s", d.name, d.level, d.location))
        ApplyDropShadow(dungLabel)

        yOffset = yOffset - 32

        local noteText = child:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        noteText:SetPoint("TOPLEFT", child, "TOPLEFT", 30, yOffset)
        noteText:SetWidth(width - 30)
        noteText:SetJustifyH("LEFT")
        noteText:SetTextColor(0.85, 0.85, 0.85, 1)
        noteText:SetText(string.format("|cffffd200Tank Strategy:|r %s", d.notes))
        ApplyDropShadow(noteText)
        table.insert(child.elements, noteText)
        yOffset = yOffset - (noteText:GetStringHeight() + 8)

        if d.drops then
            for _, drop in ipairs(d.drops) do
                local dropRow = CreateFrame("Frame", nil, child)
                dropRow:SetPoint("TOPLEFT", child, "TOPLEFT", 28, yOffset)
                dropRow:SetSize(width - 28, 24)
                table.insert(child.elements, dropRow)

                local dropCheck = CreateFrame("CheckButton", nil, dropRow, "UICheckButtonTemplate")
                dropCheck:SetPoint("LEFT", dropRow, "LEFT", 0, 0)
                dropCheck:SetSize(20, 20)
                local itemChecked = FTG:IsTaskCompleted("loot_" .. drop.id)
                dropCheck:SetChecked(itemChecked)
                dropCheck:SetScript("OnClick", function(self)
                    FTG:SetTaskCompleted("loot_" .. drop.id, self:GetChecked())
                end)

                local dropText = dropRow:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
                dropText:SetPoint("LEFT", dropCheck, "RIGHT", 4, 0)
                dropText:SetTextColor(0.9, 0.9, 0.9, 1)
                dropText:SetText(string.format("|cff00ffff%s|r (%s) - %s |cffaaaaaa[%s]|r", drop.name, drop.slot, drop.notes, drop.boss))
                ApplyDropShadow(dropText)

                yOffset = yOffset - 24
            end
        end
        yOffset = yOffset - 12
    end

    return -yOffset
end

-- 4. RENDER MACRO VAULT TAB
function FTG.UI:RenderMacros(child, profile)
    local yOffset = -10
    local width = child:GetWidth() - 20
    local macros = profile.Macros or {}

    local title = child:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", child, "TOPLEFT", 10, yOffset)
    title:SetText(string.format("|cffffcc00Macro Vault (%s / %s / %s)|r", profile.className, profile.raceName, profile.profName))
    ApplyDropShadow(title)
    table.insert(child.elements, title)
    yOffset = yOffset - 24

    local sub = child:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    sub:SetPoint("TOPLEFT", child, "TOPLEFT", 10, yOffset)
    sub:SetTextColor(0.9, 0.9, 0.9, 1)
    sub:SetText("Select macro text to copy (Ctrl+C) or click 'Save to WoW' to write directly to your in-game macro book:")
    ApplyDropShadow(sub)
    table.insert(child.elements, sub)
    yOffset = yOffset - 22

    for idx, m in ipairs(macros) do
        local box = CreateFrame("Frame", nil, child)
        box:SetPoint("TOPLEFT", child, "TOPLEFT", 10, yOffset)
        box:SetSize(width, 100)
        if box.SetBackdrop then
            box:SetBackdrop(BACKDROP_TOOLTIP_STYLE)
            box:SetBackdropColor(0.06, 0.06, 0.08, 0.9)
            box:SetBackdropBorderColor(0.5, 0.5, 0.6, 0.8)
        end
        table.insert(child.elements, box)

        local t = box:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        t:SetPoint("TOPLEFT", box, "TOPLEFT", 10, -8)
        t:SetText(string.format("|cff40ff40%s|r", m.title))
        ApplyDropShadow(t)

        local d = box:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        d:SetPoint("TOPLEFT", box, "TOPLEFT", 10, -24)
        d:SetWidth(width - 150)
        d:SetJustifyH("LEFT")
        d:SetTextColor(0.85, 0.85, 0.85, 1)
        d:SetText(m.desc)
        ApplyDropShadow(d)

        local btn = CreateFrame("Button", nil, box, "UIPanelButtonTemplate")
        btn:SetSize(110, 22)
        btn:SetPoint("TOPRIGHT", box, "TOPRIGHT", -10, -8)
        btn:SetText("Save to WoW")
        ApplyDropShadow(btn:GetFontString())
        btn:SetScript("OnClick", function()
            FTG:InstallMacro(m.title, m.code)
        end)

        local editBox = CreateFrame("EditBox", nil, box)
        editBox:SetPoint("TOPLEFT", box, "TOPLEFT", 12, -44)
        editBox:SetPoint("BOTTOMRIGHT", box, "BOTTOMRIGHT", -12, 8)
        editBox:SetFontObject("GameFontHighlightSmall")
        editBox:SetTextColor(0.95, 0.95, 0.95, 1)
        editBox:SetMultiLine(true)
        editBox:SetMaxLetters(255)
        editBox:SetAutoFocus(false)
        editBox:SetText(m.code)

        if editBox.SetBackdrop then
            editBox:SetBackdrop(BACKDROP_TOOLTIP_STYLE)
            editBox:SetBackdropColor(0.02, 0.02, 0.02, 0.95)
            editBox:SetBackdropBorderColor(0.3, 0.3, 0.3, 0.9)
        end

        editBox:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
        editBox:SetScript("OnEditFocusGained", function(self) self:HighlightText() end)

        yOffset = yOffset - 110
    end

    return -yOffset
end
