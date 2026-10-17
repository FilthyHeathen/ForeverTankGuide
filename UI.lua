--[[
    Heathen's Forever Guide - UI.lua
    Dynamic Rendering Engine: All Roles (Tank/Healer/DPS), Specs, Dropdowns, Checklists & Categorized Macro Vault
]]

local ADDON_NAME, HFG = ...

HFG.UI = {}

local BACKDROP_TEMPLATE = (BackdropTemplateMixin and "BackdropTemplate") or nil

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

-- Role Badge Formatter
local function FormatRoleBadge(role)
    role = string.upper(role or "TANK")
    if role == "TANK" then
        return "|cff33aaff[TANK]|r"
    elseif role == "HEALER" or role == "HEAL" then
        return "|cff33ff66[HEAL]|r"
    elseif role == "DPS" then
        return "|cffff5555[DPS]|r"
    else
        return "|cffffd200[ALL]|r"
    end
end

function HFG.UI:CreateMainFrame()
    if self.MainFrame then return self.MainFrame end

    local f = CreateFrame("Frame", "HFG_MainFrame", UIParent, BACKDROP_TEMPLATE)
    f:SetSize(840, 560)
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
    titleText:SetText("|cffffd200Heathen's Forever Guide|r")
    ApplyDropShadow(titleText)
    f.TitleText = titleText

    -- Player Level / Role Badge / Active status subtitle
    local levelText = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    levelText:SetPoint("RIGHT", titleBg, "RIGHT", -36, 0)
    levelText:SetTextColor(0.9, 0.9, 0.9, 1)
    ApplyDropShadow(levelText)
    f.LevelText = levelText

    -- Close Button
    local closeBtn = CreateFrame("Button", nil, f, "UIPanelCloseButton")
    closeBtn:SetPoint("TOPRIGHT", f, "TOPRIGHT", -4, -4)
    closeBtn:SetScript("OnClick", function() f:Hide() end)

    -- Top Profile Selection Bar (Class | Spec | Race | Profession | Detect Player)
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

-- Profile Bar with Interactive Selectors (Class, Spec, Race, Profession, Detect Player)
function HFG.UI:CreateProfileBar(parent)
    local bar = CreateFrame("Frame", nil, parent, BACKDROP_TEMPLATE)
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

    -- 1. Class Selector Button
    local classBtn = CreateFrame("Button", "HFG_ClassDropdownBtn", bar, "UIPanelButtonTemplate")
    classBtn:SetSize(110, 20)
    classBtn:SetPoint("LEFT", label, "RIGHT", 6, 0)
    classBtn:SetText("Class")
    ApplyDropShadow(classBtn:GetFontString())

    -- 2. Spec Selector Button
    local specBtn = CreateFrame("Button", "HFG_SpecDropdownBtn", bar, "UIPanelButtonTemplate")
    specBtn:SetSize(175, 20)
    specBtn:SetPoint("LEFT", classBtn, "RIGHT", 6, 0)
    specBtn:SetText("Specialization")
    ApplyDropShadow(specBtn:GetFontString())

    -- 3. Race Selector Button
    local raceBtn = CreateFrame("Button", "HFG_RaceDropdownBtn", bar, "UIPanelButtonTemplate")
    raceBtn:SetSize(120, 20)
    raceBtn:SetPoint("LEFT", specBtn, "RIGHT", 6, 0)
    raceBtn:SetText("Race")
    ApplyDropShadow(raceBtn:GetFontString())

    -- 4. Profession Selector Button
    local profBtn = CreateFrame("Button", "HFG_ProfDropdownBtn", bar, "UIPanelButtonTemplate")
    profBtn:SetSize(125, 20)
    profBtn:SetPoint("LEFT", raceBtn, "RIGHT", 6, 0)
    profBtn:SetText("Profession")
    ApplyDropShadow(profBtn:GetFontString())

    -- 5. Active Role Badge Indicator
    local roleBadge = bar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    roleBadge:SetPoint("LEFT", profBtn, "RIGHT", 10, 0)
    roleBadge:SetText("|cff33aaff[TANK]|r")
    ApplyDropShadow(roleBadge)
    parent.RoleBadgeText = roleBadge

    -- 6. Auto-Detect / Reset Button
    local resetBtn = CreateFrame("Button", nil, bar, "UIPanelButtonTemplate")
    resetBtn:SetSize(105, 20)
    resetBtn:SetPoint("RIGHT", bar, "RIGHT", -6, 0)
    resetBtn:SetText("Detect Player")
    ApplyDropShadow(resetBtn:GetFontString())
    resetBtn:SetScript("OnClick", function()
        HFG:ResetProfileToPlayer()
        local prof = HFG:GetActiveProfile()
        HFG:Print(string.format("Auto-detected player profile: |cff40ff40[%s] %s %s (%s)|r.", prof.role or "TANK", prof.raceName, prof.specName, prof.profName))
        HFG.UI:UpdateView()
    end)

    -- Dropdown Menus Setup using UIDropDownMenu API
    local classDrop = CreateFrame("Frame", "HFG_ClassDropDown", bar, "UIDropDownMenuTemplate")
    UIDropDownMenu_Initialize(classDrop, function(self, level)
        local classes = HFG:GetRegisteredClasses()
        for _, c in ipairs(classes) do
            local info = UIDropDownMenu_CreateInfo()
            info.text = c.name
            info.value = c.token
            info.func = function()
                HFG_CharDB.overrideClass = c.token
                HFG_CharDB.overrideSpec = nil -- Reset spec to class default on class change
                HFG.UI:UpdateView()
            end
            UIDropDownMenu_AddButton(info, level)
        end
    end)
    classBtn:SetScript("OnClick", function()
        ToggleDropDownMenu(1, nil, classDrop, classBtn, 0, 0)
    end)

    local specDrop = CreateFrame("Frame", "HFG_SpecDropDown", bar, "UIDropDownMenuTemplate")
    UIDropDownMenu_Initialize(specDrop, function(self, level)
        local activeClass = (HFG_CharDB and HFG_CharDB.overrideClass) or HFG:GetPlayerClass()
        local specs = HFG:GetRegisteredSpecsForClass(activeClass)
        for _, s in ipairs(specs) do
            local info = UIDropDownMenu_CreateInfo()
            info.text = string.format("%s %s", FormatRoleBadge(s.role), s.name)
            info.value = s.token
            info.func = function()
                HFG_CharDB.overrideSpec = s.token
                HFG.UI:UpdateView()
            end
            UIDropDownMenu_AddButton(info, level)
        end
    end)
    specBtn:SetScript("OnClick", function()
        ToggleDropDownMenu(1, nil, specDrop, specBtn, 0, 0)
    end)

    local raceDrop = CreateFrame("Frame", "HFG_RaceDropDown", bar, "UIDropDownMenuTemplate")
    UIDropDownMenu_Initialize(raceDrop, function(self, level)
        local races = HFG:GetRegisteredRaces()
        for _, r in ipairs(races) do
            local info = UIDropDownMenu_CreateInfo()
            local color = (r.faction == "Horde" and "|cffff3333" or "|cff3388ff")
            info.text = string.format("%s[%s]|r %s", color, r.faction:sub(1,1), r.name)
            info.value = r.token
            info.func = function()
                HFG_CharDB.overrideRace = r.token
                HFG.UI:UpdateView()
            end
            UIDropDownMenu_AddButton(info, level)
        end
    end)
    raceBtn:SetScript("OnClick", function()
        ToggleDropDownMenu(1, nil, raceDrop, raceBtn, 0, 0)
    end)

    local profDrop = CreateFrame("Frame", "HFG_ProfDropDown", bar, "UIDropDownMenuTemplate")
    UIDropDownMenu_Initialize(profDrop, function(self, level)
        local profs = HFG:GetRegisteredProfessions()
        for _, p in ipairs(profs) do
            local info = UIDropDownMenu_CreateInfo()
            info.text = p.name
            info.value = p.token
            info.func = function()
                HFG_CharDB.overrideProf = p.token
                HFG.UI:UpdateView()
            end
            UIDropDownMenu_AddButton(info, level)
        end
    end)
    profBtn:SetScript("OnClick", function()
        ToggleDropDownMenu(1, nil, profDrop, profBtn, 0, 0)
    end)

    parent.ClassDropdownBtn = classBtn
    parent.SpecDropdownBtn  = specBtn
    parent.RaceDropdownBtn  = raceBtn
    parent.ProfDropdownBtn  = profBtn
    parent.ProfileBar = bar
end

function HFG.UI:CreateTopBar(parent)
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
        btn:SetSize(140, 24)
        if prevBtn then
            btn:SetPoint("LEFT", prevBtn, "RIGHT", 8, 0)
        else
            btn:SetPoint("LEFT", bar, "LEFT", 0, 0)
        end
        btn:SetText(t.label)
        ApplyDropShadow(btn:GetFontString())

        btn:SetScript("OnClick", function()
            HFG:SetSelectedBracket(t.id)
        end)

        bracketButtons[t.id] = btn
        prevBtn = btn
    end

    parent.BracketButtons = bracketButtons
end

function HFG.UI:CreateSideMenu(parent)
    local menu = CreateFrame("Frame", nil, parent, BACKDROP_TEMPLATE)
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
        { id = "steps", text = "Leveling Route", icon = "Interface\\Icons\\INV_Misc_Map02" },
        { id = "recommendations", text = "Quest Upgrades", icon = "Interface\\Icons\\INV_Misc_Book_07" },
        { id = "bagquests", text = "Bag Quests", icon = "Interface\\Icons\\INV_Misc_Bag_08" },
        { id = "profession", text = "Prof. Roadmap", icon = "Interface\\Icons\\Trade_Engineering" },
        { id = "dungeons", text = "Dungeon Checklist", icon = "Interface\\Icons\\Spell_Holy_PurifyingPower" },
        { id = "macros", text = "Macro Vault", icon = "Interface\\Icons\\Spell_Holy_InnerFire" },
    }

    local navButtons = {}
    local prev = nil
    for idx, item in ipairs(items) do
        local btn = CreateFrame("Button", nil, menu, "UIPanelButtonTemplate")
        btn:SetSize(144, 28)
        if prev then
            btn:SetPoint("TOP", prev, "BOTTOM", 0, -5)
        else
            btn:SetPoint("TOP", menu, "TOP", 0, -8)
        end
        btn:SetText(item.text)
        local fs = btn:GetFontString()
        fs:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
        ApplyDropShadow(fs)

        btn:SetScript("OnClick", function()
            HFG:SetViewTab(item.id)
        end)

        navButtons[item.id] = btn
        prev = btn
    end

    -- Bottom status widget
    local statusBox = CreateFrame("Frame", nil, menu, BACKDROP_TEMPLATE)
    statusBox:SetPoint("BOTTOMLEFT", menu, "BOTTOMLEFT", 6, 6)
    statusBox:SetPoint("BOTTOMRIGHT", menu, "BOTTOMRIGHT", -6, 6)
    statusBox:SetHeight(95)
    if statusBox.SetBackdrop then
        statusBox:SetBackdrop(BACKDROP_TOOLTIP_STYLE)
        statusBox:SetBackdropColor(0.02, 0.02, 0.02, 0.85)
    end

    local statusText = statusBox:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    statusText:SetPoint("TOPLEFT", statusBox, "TOPLEFT", 6, -6)
    statusText:SetPoint("BOTTOMRIGHT", statusBox, "BOTTOMRIGHT", -6, 6)
    statusText:SetJustifyH("LEFT")
    statusText:SetJustifyV("TOP")
    statusText:SetText("|cffffcc00All-Role Engine:|r\nTank / Heal / DPS\n|cffccccccSelect Class, Spec, Race, or Profession above.|r")
    ApplyDropShadow(statusText)
    parent.StatusBoxText = statusText

    parent.NavButtons = navButtons
end

function HFG.UI:CreateContentArea(parent)
    local content = CreateFrame("Frame", nil, parent, BACKDROP_TEMPLATE)
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

    local scrollFrame = CreateFrame("ScrollFrame", "HFG_ContentScrollFrame", content)
    scrollFrame:SetPoint("TOPLEFT", content, "TOPLEFT", 8, -8)
    scrollFrame:SetPoint("BOTTOMRIGHT", content, "BOTTOMRIGHT", -26, 8)

    local scrollChild = CreateFrame("Frame", "HFG_ContentScrollChild", scrollFrame)
    scrollChild:SetSize(600, 600)
    scrollFrame:SetScrollChild(scrollChild)

    local slider = CreateFrame("Slider", "HFG_ContentSlider", content, BACKDROP_TEMPLATE)
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
function HFG.UI:UpdateView()
    local f = self.MainFrame
    if not f or not f:IsShown() then return end

    local profile = HFG:GetActiveProfile()
    local currentBracketId = HFG.selectedBracket or HFG:GetCurrentPlayerBracket()
    local currentView = HFG.currentView or "overview"
    local bracketData = profile.Brackets[currentBracketId] or {}

    -- Update Dropdown Button Titles
    f.ClassDropdownBtn:SetText(profile.className)
    f.SpecDropdownBtn:SetText(profile.specName)
    f.RaceDropdownBtn:SetText(profile.raceName)
    f.ProfDropdownBtn:SetText(profile.profName)
    f.RoleBadgeText:SetText(FormatRoleBadge(profile.role))

    -- Update Top Title / Level / Role Badge
    local playerLevel = UnitLevel("player") or 1
    f.LevelText:SetText(string.format("Lvl |cff40ff40%d|r | %s |cffffd200%s %s|r", playerLevel, FormatRoleBadge(profile.role), profile.raceName, profile.specName))

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
    elseif currentView == "steps" then
        totalHeight = self:RenderGuideSteps(child, profile)
    elseif currentView == "recommendations" then
        totalHeight = self:RenderQuestRecommendations(child, bracketData, profile)
    elseif currentView == "bagquests" then
        totalHeight = self:RenderBagQuestList(child, profile)
    elseif currentView == "profession" then
        totalHeight = self:RenderProfession(child, bracketData, profile)
    elseif currentView == "dungeons" then
        totalHeight = self:RenderDungeons(child, bracketData, profile)
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
function HFG.UI:RenderOverview(child, bracket, profile)
    local yOffset = -10
    local width = child:GetWidth() - 20

    -- Section Title with Role Badge
    local title = child:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", child, "TOPLEFT", 10, yOffset)
    title:SetText(string.format("%s |cffffcc00%s|r - |cffffffff%s %s|r", FormatRoleBadge(profile.role), bracket.name or "Phase", profile.raceName, profile.specName))
    ApplyDropShadow(title)
    table.insert(child.elements, title)
    yOffset = yOffset - 22

    -- Stat Priority Banner
    if profile.statPriority then
        local statLine = child:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        statLine:SetPoint("TOPLEFT", child, "TOPLEFT", 10, yOffset)
        statLine:SetWidth(width)
        statLine:SetJustifyH("LEFT")
        statLine:SetText(string.format("|cffffd200Stat Priority:|r |cff40ff40%s|r", profile.statPriority))
        ApplyDropShadow(statLine)
        table.insert(child.elements, statLine)
        yOffset = yOffset - (statLine:GetStringHeight() + 8)
    end

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

    -- Section: Recommended Leveling Zones (Strictly Race & Faction Routed)
    if bracket.zones and #bracket.zones > 0 then
        local zoneHeader = child:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        zoneHeader:SetPoint("TOPLEFT", child, "TOPLEFT", 10, yOffset)
        zoneHeader:SetTextColor(0.3, 1.0, 0.3, 1) -- Bright lime green
        local factionColor = (profile.faction == "Alliance" and "|cff3388ffAlliance|r") or "|cffff3333Horde|r"
        zoneHeader:SetText(string.format("Recommended Leveling & Farming Zones (%s — %s Route)", profile.raceName, factionColor))
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
        abHeader:SetText(string.format("Abilities, Talents & Racials (%s)", profile.specName))
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

    -- Section: Tactical Role Rules
    if bracket.tankRules and #bracket.tankRules > 0 then
        local roleTitle = (profile.role == "TANK" and "Tactical Tanking Rules")
                       or (profile.role == "HEALER" and "Tactical Healing & Mana Rules")
                       or "Tactical Rotation & DPS Rules"

        local tankHeader = child:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        tankHeader:SetPoint("TOPLEFT", child, "TOPLEFT", 10, yOffset)
        tankHeader:SetTextColor(1.0, 0.8, 0.2, 1) -- Bright amber / gold
        tankHeader:SetText(string.format("%s (%s)", roleTitle, profile.specName))
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
        yOffset = yOffset - 10
    end

    -- Section: Bag Quest Progression (Relevant for current bracket & character)
    if HFG.GetBagQuestsForProfile then
        local bagQuests = HFG:GetBagQuestsForProfile(profile)
        local bracketBagQuests = {}
        local minLvl = bracket.minLevel or 1
        local maxLvl = bracket.maxLevel or 60

        for _, bq in ipairs(bagQuests) do
            if bq.level >= minLvl and bq.level <= maxLvl then
                table.insert(bracketBagQuests, bq)
            end
        end

        if #bracketBagQuests > 0 then
            local bagHeader = child:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            bagHeader:SetPoint("TOPLEFT", child, "TOPLEFT", 10, yOffset)
            bagHeader:SetTextColor(0.2, 0.8, 1.0, 1) -- Crisp cyan / teal
            bagHeader:SetText("Essential Inventory Bag Quests")
            ApplyDropShadow(bagHeader)
            table.insert(child.elements, bagHeader)
            yOffset = yOffset - 18

            for _, bq in ipairs(bracketBagQuests) do
                local line = child:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
                line:SetPoint("TOPLEFT", child, "TOPLEFT", 20, yOffset)
                line:SetWidth(width - 20)
                line:SetJustifyH("LEFT")
                line:SetTextColor(0.9, 0.9, 0.9, 1)

                local isDone = false
                if C_QuestLog and C_QuestLog.IsQuestFlaggedCompleted then
                    isDone = C_QuestLog.IsQuestFlaggedCompleted(bq.id)
                elseif IsQuestFlaggedCompleted then
                    isDone = IsQuestFlaggedCompleted(bq.id)
                end

                local statusStr = ""
                if isDone then
                    statusStr = " |cff555555[Completed]|r"
                else
                    local playerLvl = UnitLevel("player") or 1
                    if playerLvl >= bq.level and playerLvl <= (bq.level + 15) then
                        statusStr = " |cff00ff00[Available Now]|r"
                    end
                end

                local detailStr = string.format("• |cffffd200%s|r (|cff40ff40Lvl %d|r - |cffffffff%d-Slot Bag|r): |cff00ff00%s|r", bq.name, bq.level, bq.slots, bq.zone)
                if bq.starter then
                    detailStr = detailStr .. string.format(" (Starter: |cffffffff%s|r)", bq.starter)
                end
                if bq.reward then
                    detailStr = detailStr .. string.format(" [Reward: |cff1eff00%s|r]", bq.reward)
                end
                detailStr = detailStr .. statusStr

                line:SetText(detailStr)
                ApplyDropShadow(line)
                table.insert(child.elements, line)
                yOffset = yOffset - (line:GetStringHeight() + 6)
            end
            yOffset = yOffset - 10
        end
    end

    -- Section: Dynamic Spec-Loot & Quest Upgrades
    if HFG.GetRecommendedQuests then
        local recs = HFG:GetRecommendedQuests({
            bracket = bracket.id,
            role = profile.role,
            sortBy = "BEST",
            roleFilter = "SPEC",
            onlyUnfinished = true
        })

        if recs and #recs > 0 then
            local qHeader = child:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            qHeader:SetPoint("TOPLEFT", child, "TOPLEFT", 10, yOffset)
            qHeader:SetTextColor(1.0, 0.8, 0.2, 1) -- Golden yellow
            qHeader:SetText(string.format("Recommended Dynamic Quest Upgrades (%s Spec)", FormatRoleBadge(profile.role)))
            ApplyDropShadow(qHeader)
            table.insert(child.elements, qHeader)
            yOffset = yOffset - 18

            -- Display top 3 recommendations
            for i = 1, math.min(#recs, 3) do
                local rec = recs[i]
                local q = rec.quest
                local line = child:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
                line:SetPoint("TOPLEFT", child, "TOPLEFT", 20, yOffset)
                line:SetWidth(width - 20)
                line:SetJustifyH("LEFT")
                line:SetTextColor(0.9, 0.9, 0.9, 1)

                local detailStr = string.format("• |cffffd200%s|r (|cff40ff40Lvl %d|r - |cffffffff%s|r): |cff40ff40+%s XP|r", q.title, q.level, q.zone or "World", tostring(q.xp or 0))
                if rec.bestLoot then
                    detailStr = detailStr .. string.format(" [Upgrade: |cff0070dd%s|r - %s]", rec.bestLoot.name, rec.bestLoot.slot)
                end
                if rec.isActive then
                    detailStr = detailStr .. " |cff00ff00(In Progress)|r"
                end

                line:SetText(detailStr)
                ApplyDropShadow(line)
                table.insert(child.elements, line)
                yOffset = yOffset - (line:GetStringHeight() + 6)
            end
            yOffset = yOffset - 10
        end
    end

    return -yOffset
end

-- 2. RENDER PROFESSION ROADMAP TAB
function HFG.UI:RenderProfession(child, bracket, profile)
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
            local box = CreateFrame("Frame", nil, child, BACKDROP_TEMPLATE)
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

-- 3. RENDER DUNGEON CHECKLIST TAB (with Role Tagging & Highlighting)
function HFG.UI:RenderDungeons(child, bracket, profile)
    local yOffset = -10
    local width = child:GetWidth() - 20
    local dungeons = bracket.dungeons or {}
    local activeRole = profile and profile.role or "TANK"

    local title = child:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", child, "TOPLEFT", 10, yOffset)
    title:SetText(string.format("|cffffcc00Dungeon & Gear Checklist|r — Active Role: %s", FormatRoleBadge(activeRole)))
    ApplyDropShadow(title)
    table.insert(child.elements, title)
    yOffset = yOffset - 24

    local sub = child:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    sub:SetPoint("TOPLEFT", child, "TOPLEFT", 10, yOffset)
    sub:SetTextColor(0.9, 0.9, 0.9, 1)
    sub:SetText("Check off dungeons completed and key gear acquired (tagged by [TANK], [HEAL], [DPS]):")
    ApplyDropShadow(sub)
    table.insert(child.elements, sub)
    yOffset = yOffset - 20

    for _, d in ipairs(dungeons) do
        local dungBox = CreateFrame("Frame", nil, child, BACKDROP_TEMPLATE)
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
        local dungChecked = HFG:IsTaskCompleted("dung_" .. d.key)
        dungCheck:SetChecked(dungChecked)
        dungCheck:SetScript("OnClick", function(self)
            HFG:SetTaskCompleted("dung_" .. d.key, self:GetChecked())
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
        noteText:SetText(string.format("|cffffd200Dungeon Notes:|r %s", d.notes))
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
                local itemChecked = HFG:IsTaskCompleted("loot_" .. drop.id)
                dropCheck:SetChecked(itemChecked)
                dropCheck:SetScript("OnClick", function(self)
                    HFG:SetTaskCompleted("loot_" .. drop.id, self:GetChecked())
                end)

                local badge = FormatRoleBadge(drop.role or "TANK")
                local dropText = dropRow:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
                dropText:SetPoint("LEFT", dropCheck, "RIGHT", 4, 0)
                dropText:SetTextColor(0.9, 0.9, 0.9, 1)
                dropText:SetText(string.format("%s |cff00ffff%s|r (%s) - %s |cffaaaaaa[%s]|r", badge, drop.name, drop.slot, drop.notes, drop.boss))
                ApplyDropShadow(dropText)

                yOffset = yOffset - 24
            end
        end
        yOffset = yOffset - 12
    end

    return -yOffset
end

-- 4. RENDER MACRO VAULT TAB (Categorized by Role / Function)
function HFG.UI:RenderMacros(child, profile)
    local yOffset = -10
    local width = child:GetWidth() - 20
    local macros = profile.Macros or {}

    local title = child:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", child, "TOPLEFT", 10, yOffset)
    title:SetText(string.format("|cffffcc00Macro Vault (%s - %s / %s)|r", profile.specName, profile.raceName, profile.profName))
    ApplyDropShadow(title)
    table.insert(child.elements, title)
    yOffset = yOffset - 24

    local sub = child:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    sub:SetPoint("TOPLEFT", child, "TOPLEFT", 10, yOffset)
    sub:SetTextColor(0.9, 0.9, 0.9, 1)
    sub:SetText("Categorized into Defensive/Tank, Healing/Mouseover, Burst/DPS, and Utility. Click 'Save to WoW' or copy:")
    ApplyDropShadow(sub)
    table.insert(child.elements, sub)
    yOffset = yOffset - 22

    -- Group macros by category order
    local categories = {
        "Defensive / Tank",
        "Healing / Mouseover",
        "Burst / DPS",
        "Racial / Utility",
        "Profession / Utility"
    }

    local grouped = {}
    for _, cat in ipairs(categories) do grouped[cat] = {} end

    for _, m in ipairs(macros) do
        local cat = m.category or "Burst / DPS"
        if not grouped[cat] then
            grouped[cat] = {}
            table.insert(categories, cat)
        end
        table.insert(grouped[cat], m)
    end

    for _, cat in ipairs(categories) do
        local list = grouped[cat]
        if list and #list > 0 then
            -- Category Header
            local catHeader = child:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            catHeader:SetPoint("TOPLEFT", child, "TOPLEFT", 10, yOffset)
            catHeader:SetTextColor(1.0, 0.8, 0.2, 1)
            catHeader:SetText(string.format("=== %s ===", cat))
            ApplyDropShadow(catHeader)
            table.insert(child.elements, catHeader)
            yOffset = yOffset - 20

            for _, m in ipairs(list) do
                local box = CreateFrame("Frame", nil, child, BACKDROP_TEMPLATE)
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
                    HFG:InstallMacro(m.title, m.code)
                end)

                local editBox = CreateFrame("EditBox", nil, box, BACKDROP_TEMPLATE)
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

                yOffset = yOffset - 108
            end
            yOffset = yOffset - 6
        end
    end

    return -yOffset
end

-- 5. RENDER QUEST & LOOT RECOMMENDATIONS TAB
function HFG.UI:RenderQuestRecommendations(child, bracket, profile)
    local yOffset = -10
    local width = child:GetWidth() - 20

    local currentRole = profile.role or "TANK"
    local roleFilter = (HFG_CharDB and HFG_CharDB.questFilterRole) or "SPEC"
    local sortBy = (HFG_CharDB and HFG_CharDB.questSortBy) or "BEST"

    -- Title
    local title = child:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", child, "TOPLEFT", 10, yOffset)
    title:SetText(string.format("%s |cffffd200Dynamic Quest & Spec-Loot Upgrades|r", FormatRoleBadge(currentRole)))
    ApplyDropShadow(title)
    table.insert(child.elements, title)
    yOffset = yOffset - 22

    -- Subtitle
    local sub = child:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    sub:SetPoint("TOPLEFT", child, "TOPLEFT", 10, yOffset)
    sub:SetWidth(width)
    sub:SetJustifyH("LEFT")
    sub:SetTextColor(0.85, 0.85, 0.85, 1)
    sub:SetText("Scans native client completion flags and recommends high XP or role-appropriate gear upgrades.")
    ApplyDropShadow(sub)
    table.insert(child.elements, sub)
    yOffset = yOffset - (sub:GetStringHeight() + 10)

    -- Action Bar Container
    local bar = CreateFrame("Frame", nil, child, BACKDROP_TEMPLATE)
    bar:SetPoint("TOPLEFT", child, "TOPLEFT", 10, yOffset)
    bar:SetSize(width, 32)
    if bar.SetBackdrop then
        bar:SetBackdrop(BACKDROP_TOOLTIP_STYLE)
        bar:SetBackdropColor(0.04, 0.04, 0.06, 0.95)
        bar:SetBackdropBorderColor(0.5, 0.5, 0.6, 0.8)
    end
    table.insert(child.elements, bar)

    -- 1. Scan Completed Quests Button
    local scanBtn = CreateFrame("Button", nil, bar, "UIPanelButtonTemplate")
    scanBtn:SetSize(140, 22)
    scanBtn:SetPoint("LEFT", bar, "LEFT", 6, 0)
    scanBtn:SetText("Scan Completed")
    ApplyDropShadow(scanBtn:GetFontString())
    scanBtn:SetScript("OnClick", function()
        if HFG.ScanCompletedQuests then
            local count = HFG:ScanCompletedQuests()
            HFG:Print(string.format("Completed quest scan finished. Found |cff40ff40%d|r completed quests.", count))
            HFG.UI:UpdateView()
        end
    end)

    -- 2. Role Filter Button (SPEC vs ALL)
    local filterBtn = CreateFrame("Button", nil, bar, "UIPanelButtonTemplate")
    filterBtn:SetSize(130, 22)
    filterBtn:SetPoint("LEFT", scanBtn, "RIGHT", 8, 0)
    filterBtn:SetText(roleFilter == "SPEC" and "Filter: Spec Only" or "Filter: All Roles")
    ApplyDropShadow(filterBtn:GetFontString())
    filterBtn:SetScript("OnClick", function()
        if not HFG_CharDB then HFG_CharDB = {} end
        HFG_CharDB.questFilterRole = (roleFilter == "SPEC" and "ALL" or "SPEC")
        HFG.UI:UpdateView()
    end)

    -- 3. Sort Order Button
    local sortBtn = CreateFrame("Button", nil, bar, "UIPanelButtonTemplate")
    sortBtn:SetSize(120, 22)
    sortBtn:SetPoint("LEFT", filterBtn, "RIGHT", 8, 0)
    local sortLabel = (sortBy == "LOOT" and "Sort: Top Loot") or (sortBy == "XP" and "Sort: High XP") or "Sort: Best Match"
    sortBtn:SetText(sortLabel)
    ApplyDropShadow(sortBtn:GetFontString())
    sortBtn:SetScript("OnClick", function()
        if not HFG_CharDB then HFG_CharDB = {} end
        if sortBy == "BEST" then
            HFG_CharDB.questSortBy = "LOOT"
        elseif sortBy == "LOOT" then
            HFG_CharDB.questSortBy = "XP"
        else
            HFG_CharDB.questSortBy = "BEST"
        end
        HFG.UI:UpdateView()
    end)

    -- Completed Count Status Text
    local completedCount = 0
    if HFG_CharDB and HFG_CharDB.completedQuests then
        for _, v in pairs(HFG_CharDB.completedQuests) do
            if v then completedCount = completedCount + 1 end
        end
    end
    local countText = bar:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    countText:SetPoint("RIGHT", bar, "RIGHT", -10, 0)
    countText:SetText(string.format("Flags: |cff40ff40%d Done|r", completedCount))
    ApplyDropShadow(countText)

    yOffset = yOffset - 42

    -- Fetch Recommendations
    local recs = {}
    if HFG.GetRecommendedQuests then
        recs = HFG:GetRecommendedQuests({
            bracket = bracket.id,
            role = profile.role,
            sortBy = sortBy,
            roleFilter = roleFilter,
            onlyUnfinished = true
        })
    end

    if #recs == 0 then
        local emptyBox = CreateFrame("Frame", nil, child, BACKDROP_TEMPLATE)
        emptyBox:SetPoint("TOPLEFT", child, "TOPLEFT", 10, yOffset)
        emptyBox:SetSize(width, 90)
        if emptyBox.SetBackdrop then
            emptyBox.SetBackdrop(BACKDROP_TOOLTIP_STYLE)
            emptyBox:SetBackdropColor(0.04, 0.04, 0.06, 0.9)
            emptyBox:SetBackdropBorderColor(0.4, 0.4, 0.5, 0.8)
        end
        table.insert(child.elements, emptyBox)

        local msg = emptyBox:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        msg:SetPoint("CENTER", emptyBox, "CENTER", 0, 8)
        msg:SetText("|cffffcc00No pending recommendations found for this phase.|r")
        ApplyDropShadow(msg)

        local subMsg = emptyBox:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        subMsg:SetPoint("TOP", msg, "BOTTOM", 0, -6)
        subMsg:SetText("All known quests in this bracket are completed, or the filter is too restrictive. Try [Filter: All Roles].")
        ApplyDropShadow(subMsg)

        yOffset = yOffset - 100
        return -yOffset
    end

    -- Render Quest Recommendation Cards
    local QUALITY_COLORS = {
        [0] = "|cff9d9d9d",
        [1] = "|cffffffff",
        [2] = "|cff1eff00",
        [3] = "|cff0070dd",
        [4] = "|cffa335ee",
        [5] = "|cffff8000"
    }

    for _, rec in ipairs(recs) do
        local q = rec.quest
        local lootCount = (q.loot and #q.loot) or 0
        local cardHeight = 85 + (lootCount * 22)

        local card = CreateFrame("Frame", nil, child, BACKDROP_TEMPLATE)
        card:SetPoint("TOPLEFT", child, "TOPLEFT", 10, yOffset)
        card:SetSize(width, cardHeight)
        if card.SetBackdrop then
            card:SetBackdrop(BACKDROP_TOOLTIP_STYLE)
            card:SetBackdropColor(0.04, 0.04, 0.06, 0.95)
            if rec.isActive then
                card:SetBackdropBorderColor(0.2, 0.8, 0.3, 0.9) -- Green border for active
            elseif rec.hasRoleUpgrade then
                card:SetBackdropBorderColor(0.8, 0.7, 0.2, 0.9) -- Gold for role upgrade
            else
                card:SetBackdropBorderColor(0.4, 0.4, 0.5, 0.8)
            end
        end
        table.insert(child.elements, card)

        -- Header: Title, Level, Zone
        local titleLine = card:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        titleLine:SetPoint("TOPLEFT", card, "TOPLEFT", 12, -8)
        titleLine:SetText(string.format("|cffffd200%s|r (|cff40ff40Lvl %d|r — |cffffffff%s|r)", q.title, q.level, q.zone or "Unknown"))
        ApplyDropShadow(titleLine)

        -- Status Indicator
        local statusText = card:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        statusText:SetPoint("TOPRIGHT", card, "TOPRIGHT", -12, -8)
        if rec.isActive then
            if rec.isObjectiveComplete then
                statusText:SetText("|cff00ff00[Ready to Turn In]|r")
            else
                statusText:SetText("|cffffff00[In Progress]|r")
            end
        elseif rec.isCompleted then
            statusText:SetText("|cff555555[Completed]|r")
        else
            statusText:SetText("|cff888888[Available]|r")
        end
        ApplyDropShadow(statusText)

        -- XP & Role Upgrade Badges
        local badgeLine = card:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        badgeLine:SetPoint("TOPLEFT", card, "TOPLEFT", 12, -26)
        local roleBadgeStr = ""
        if rec.hasRoleUpgrade then
            roleBadgeStr = FormatRoleBadge(rec.targetRole) .. " |cff00ff00UPGRADE|r  "
        end
        local xpStr = string.format("|cff40ff40+%s XP|r", tostring(q.xp or 0))
        local moneyStr = ""
        if q.money and q.money > 0 then
            local g = math.floor(q.money / 10000)
            local s = math.floor((q.money % 10000) / 100)
            local c = q.money % 100
            if g > 0 then
                moneyStr = string.format(" |cffffd200%dg %ds %dc|r", g, s, c)
            elseif s > 0 then
                moneyStr = string.format(" |cffffffff%ds %dc|r", s, c)
            else
                moneyStr = string.format(" |cffeda55f%dc|r", c)
            end
        end
        badgeLine:SetText(roleBadgeStr .. xpStr .. moneyStr)
        ApplyDropShadow(badgeLine)

        -- Objectives
        local objLine = card:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        objLine:SetPoint("TOPLEFT", card, "TOPLEFT", 12, -42)
        objLine:SetWidth(width - 24)
        objLine:SetJustifyH("LEFT")
        objLine:SetTextColor(0.8, 0.8, 0.8, 1)
        objLine:SetText(string.format("|cffaaaaaaObjectives:|r %s", q.objectives or "See questgiver for instructions."))
        ApplyDropShadow(objLine)

        -- Loot Rewards Showcase
        local lootY = -60
        if q.loot and #q.loot > 0 then
            for lIdx, loot in ipairs(q.loot) do
                local qColor = QUALITY_COLORS[loot.quality or 1] or "|cffffffff"
                local lootFrame = CreateFrame("Button", nil, card)
                lootFrame:SetPoint("TOPLEFT", card, "TOPLEFT", 12, lootY)
                lootFrame:SetSize(width - 24, 20)
                lootFrame:EnableMouse(true)

                local itemText = lootFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
                itemText:SetPoint("LEFT", lootFrame, "LEFT", 0, 0)
                itemText:SetWidth(width - 60)
                itemText:SetJustifyH("LEFT")

                -- Build stats summary string
                local statParts = {}
                if loot.stats then
                    for sK, sV in pairs(loot.stats) do
                        table.insert(statParts, string.format("+%d %s", sV, sK))
                    end
                end
                if loot.armor and loot.armor > 0 then
                    table.insert(statParts, string.format("%d Armor", loot.armor))
                end
                if loot.blockValue and loot.blockValue > 0 then
                    table.insert(statParts, string.format("%d Block", loot.blockValue))
                end
                if loot.dps and loot.dps > 0 then
                    table.insert(statParts, string.format("%.1f DPS", loot.dps))
                end

                local statsDesc = table.concat(statParts, ", ")
                if statsDesc ~= "" then statsDesc = " (" .. statsDesc .. ")" end

                local tag = loot.isChoice and "[Choice]" or "[Guaranteed]"
                itemText:SetText(string.format("• %s%s %s|r - |cffffffff%s|r%s %s", qColor, tag, loot.name, loot.slot, statsDesc, FormatRoleBadge(loot.role:gsub("%[",""):gsub("%]",""))))
                ApplyDropShadow(itemText)

                -- Tooltip Handler
                lootFrame:SetScript("OnEnter", function(self)
                    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                    GameTooltip:ClearLines()
                    GameTooltip:AddLine(string.format("%s%s|r", qColor, loot.name), 1, 1, 1)
                    GameTooltip:AddLine(string.format("%s - %s", loot.slot, loot.role), 0.8, 0.8, 0.8)
                    if loot.itemLevel and loot.itemLevel > 0 then
                        GameTooltip:AddLine(string.format("Item Level %d", loot.itemLevel), 0.9, 0.9, 0.5)
                    end
                    if loot.armor and loot.armor > 0 then
                        GameTooltip:AddLine(string.format("%d Armor", loot.armor), 1, 1, 1)
                    end
                    if loot.blockValue and loot.blockValue > 0 then
                        GameTooltip:AddLine(string.format("%d Block", loot.blockValue), 1, 1, 1)
                    end
                    if loot.dps and loot.dps > 0 then
                        GameTooltip:AddLine(string.format("%.1f Damage Per Second", loot.dps), 1, 1, 1)
                    end
                    if loot.stats then
                        for sName, sVal in pairs(loot.stats) do
                            GameTooltip:AddLine(string.format("+%d %s", sVal, sName), 0.2, 1.0, 0.2)
                        end
                    end
                    GameTooltip:AddLine(" ")
                    GameTooltip:AddLine(loot.isChoice and "|cffffff00Choice Quest Reward|r" or "|cff00ff00Guaranteed Quest Reward|r", 0.7, 0.7, 0.7)
                    GameTooltip:Show()
                end)
                lootFrame:SetScript("OnLeave", function() GameTooltip:Hide() end)

                lootY = lootY - 20
            end
        end

        yOffset = yOffset - (cardHeight + 10)
    end

    return -yOffset
end


-- 6. RENDER BAG QUESTS TAB
function HFG.UI:RenderBagQuestList(child, profile)
    local yOffset = -10
    local width = child:GetWidth() - 20

    local title = child:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", child, "TOPLEFT", 10, yOffset)
    title:SetText("|cffffcc00Essential Inventory Bag Quests|r")
    ApplyDropShadow(title)
    table.insert(child.elements, title)
    yOffset = yOffset - 22

    local sub = child:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    sub:SetPoint("TOPLEFT", child, "TOPLEFT", 10, yOffset)
    sub:SetTextColor(0.9, 0.9, 0.9, 1)
    sub:SetText("Available bag upgrade quests matching your character's race, class, and faction:")
    ApplyDropShadow(sub)
    table.insert(child.elements, sub)
    yOffset = yOffset - 24

    local quests = HFG:GetAvailableBagQuests()

    if #quests == 0 then
        local emptyBox = CreateFrame("Frame", nil, child, BACKDROP_TEMPLATE)
        emptyBox:SetPoint("TOPLEFT", child, "TOPLEFT", 10, yOffset)
        emptyBox:SetSize(width, 70)
        if emptyBox.SetBackdrop then
            emptyBox:SetBackdrop(BACKDROP_TOOLTIP_STYLE)
            emptyBox:SetBackdropColor(0.06, 0.06, 0.08, 0.9)
            emptyBox:SetBackdropBorderColor(0.4, 0.4, 0.5, 0.6)
        end
        table.insert(child.elements, emptyBox)

        local msg = emptyBox:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        msg:SetPoint("CENTER", emptyBox, "CENTER", 0, 0)
        msg:SetText("|cff00ff00All relevant bag quests completed!|r")
        ApplyDropShadow(msg)

        yOffset = yOffset - 80
        return -yOffset
    end

    for _, q in ipairs(quests) do
        local card = CreateFrame("Frame", nil, child, BACKDROP_TEMPLATE)
        card:SetPoint("TOPLEFT", child, "TOPLEFT", 10, yOffset)
        card:SetSize(width, 68)
        if card.SetBackdrop then
            card:SetBackdrop(BACKDROP_TOOLTIP_STYLE)
            card:SetBackdropColor(0.04, 0.04, 0.06, 0.95)
            if q.isRelevantNow then
                card:SetBackdropBorderColor(0.2, 0.8, 0.3, 0.9) -- Green border for active/relevant
            else
                card:SetBackdropBorderColor(0.4, 0.4, 0.5, 0.7)
            end
        end
        table.insert(child.elements, card)

        -- Title line
        local statusColor = q.isRelevantNow and "|cffffd700" or "|cff808080"
        local titleLine = card:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        titleLine:SetPoint("TOPLEFT", card, "TOPLEFT", 12, -8)
        titleLine:SetText(string.format("%s[%d Slots]|r |cffffffff%s|r (|cff40ff40Lvl %d|r — |cffffd200%s|r)", statusColor, q.slots, q.name, q.level, q.zone))
        ApplyDropShadow(titleLine)

        -- Status tag
        local statusText = card:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        statusText:SetPoint("TOPRIGHT", card, "TOPRIGHT", -12, -8)
        if q.isRelevantNow then
            statusText:SetText("|cff00ff00[Available Now]|r")
        else
            statusText:SetText("|cff888888[Future / High Level]|r")
        end
        ApplyDropShadow(statusText)

        -- Reward line
        local rewardLine = card:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        rewardLine:SetPoint("TOPLEFT", card, "TOPLEFT", 12, -28)
        rewardLine:SetText(string.format("|cffaaaaaaReward:|r |cff1eff00%s|r", q.reward))
        ApplyDropShadow(rewardLine)

        -- Detail info
        local detailLine = card:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        detailLine:SetPoint("TOPLEFT", card, "TOPLEFT", 12, -44)
        detailLine:SetTextColor(0.8, 0.8, 0.8, 1)
        detailLine:SetText(string.format("Required Level: |cffffffff%d|r | Zone: |cffffffff%s|r", q.level, q.zone))
        ApplyDropShadow(detailLine)

        yOffset = yOffset - 76
    end

    return -yOffset
end

-- 7. RENDER STEP-BY-STEP LEVELING ROUTE TAB
function HFG.UI:RenderGuideSteps(child, profile)
    local yOffset = -10
    local width = child:GetWidth() - 20

    local GE = HFG.GuideEngine
    local availableGuides = HFG:GetAvailableGuides(profile)
    local activeGuide = GE and GE.activeGuide

    local isGuideValid = false
    if activeGuide then
        for _, g in ipairs(availableGuides) do
            if g.id == activeGuide.id then
                isGuideValid = true
                break
            end
        end
    end

    -- Auto-select level-appropriate matching guide if none active or invalid
    if (not activeGuide or not isGuideValid) and #availableGuides > 0 then
        local playerLevel = (UnitLevel and UnitLevel("player")) or 1
        local bestGuide = availableGuides[1]
        for _, g in ipairs(availableGuides) do
            if playerLevel >= g.minLevel and playerLevel <= (g.maxLevel or 60) then
                bestGuide = g
                break
            end
        end
        HFG:SetActiveGuide(bestGuide.id)
        activeGuide = GE.activeGuide
    end

    -- Section Title
    local title = child:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", child, "TOPLEFT", 10, yOffset)
    title:SetText("|cffffcc00Interactive Step-by-Step Leveling Guide|r")
    ApplyDropShadow(title)
    table.insert(child.elements, title)
    yOffset = yOffset - 24

    -- Route Selector Frame & HUD Toggle Button
    local routeSelectorFrame = CreateFrame("Frame", nil, child, BACKDROP_TEMPLATE)
    routeSelectorFrame:SetPoint("TOPLEFT", child, "TOPLEFT", 10, yOffset)
    routeSelectorFrame:SetSize(width, 36)
    if routeSelectorFrame.SetBackdrop then
        routeSelectorFrame:SetBackdrop(BACKDROP_TOOLTIP_STYLE)
        routeSelectorFrame:SetBackdropColor(0.04, 0.04, 0.06, 0.95)
        routeSelectorFrame:SetBackdropBorderColor(0.5, 0.5, 0.6, 0.8)
    end
    table.insert(child.elements, routeSelectorFrame)

    local selLabel = routeSelectorFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    selLabel:SetPoint("LEFT", routeSelectorFrame, "LEFT", 10, 0)
    selLabel:SetText("|cffffd200Active Route:|r")
    ApplyDropShadow(selLabel)

    local selBtn = CreateFrame("Button", "HFG_RouteDropdownBtn", routeSelectorFrame, "UIPanelButtonTemplate")
    selBtn:SetSize(280, 22)
    selBtn:SetPoint("LEFT", selLabel, "RIGHT", 8, 0)
    selBtn:SetText(activeGuide and activeGuide.title or "Select Guide Route...")
    ApplyDropShadow(selBtn:GetFontString())

    local routeDrop = CreateFrame("Frame", "HFG_RouteDropDown", routeSelectorFrame, "UIDropDownMenuTemplate")
    UIDropDownMenu_Initialize(routeDrop, function(self, level)
        for _, g in ipairs(availableGuides) do
            local info = UIDropDownMenu_CreateInfo()
            info.text = string.format("[%d–%d] %s", g.minLevel, g.maxLevel, g.title)
            info.value = g.id
            info.checked = (activeGuide and activeGuide.id == g.id)
            info.func = function()
                HFG:SetActiveGuide(g.id)
                HFG.UI:UpdateView()
            end
            UIDropDownMenu_AddButton(info, level)
        end
    end)
    selBtn:SetScript("OnClick", function()
        ToggleDropDownMenu(1, nil, routeDrop, selBtn, 0, 0)
    end)

    -- Toggle Floating HUD Button
    local hudBtn = CreateFrame("Button", nil, routeSelectorFrame, "UIPanelButtonTemplate")
    hudBtn:SetSize(120, 22)
    hudBtn:SetPoint("RIGHT", routeSelectorFrame, "RIGHT", -10, 0)
    hudBtn:SetText("Toggle HUD")
    ApplyDropShadow(hudBtn:GetFontString())
    hudBtn:SetScript("OnClick", function()
        HFG:ToggleGuideHUD()
    end)

    yOffset = yOffset - 44

    if not activeGuide then
        local noGuideText = child:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        noGuideText:SetPoint("TOPLEFT", child, "TOPLEFT", 15, yOffset)
        noGuideText:SetWidth(width - 30)
        noGuideText:SetJustifyH("LEFT")
        noGuideText:SetText("|cffff8080No route guides available for your current race and class selection.|r\nUse the Profile bar above to switch or reset to player.")
        ApplyDropShadow(noGuideText)
        table.insert(child.elements, noGuideText)
        return -yOffset + 50
    end

    local currentStepIdx = GE.activeStepIndex or 1
    local totalSteps = #activeGuide.steps
    local progressPct = math.floor((currentStepIdx / math.max(1, totalSteps)) * 100)

    -- Route Info & Navigation Control Panel
    local controlCard = CreateFrame("Frame", nil, child, BACKDROP_TEMPLATE)
    controlCard:SetPoint("TOPLEFT", child, "TOPLEFT", 10, yOffset)
    controlCard:SetSize(width, 42)
    if controlCard.SetBackdrop then
        controlCard:SetBackdrop(BACKDROP_TOOLTIP_STYLE)
        controlCard:SetBackdropColor(0.06, 0.05, 0.08, 0.95)
        controlCard:SetBackdropBorderColor(0.8, 0.7, 0.2, 0.9)
    end
    table.insert(child.elements, controlCard)

    local progressText = controlCard:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    progressText:SetPoint("LEFT", controlCard, "LEFT", 12, 0)
    progressText:SetText(string.format("|cffffd200Progress:|r Step |cff00ff00%d|r of |cffffffff%d|r (|cff40ff40%d%%|r)", currentStepIdx, totalSteps, progressPct))
    ApplyDropShadow(progressText)

    -- Prev / Skip / Next Buttons
    local prevBtn = CreateFrame("Button", nil, controlCard, "UIPanelButtonTemplate")
    prevBtn:SetSize(80, 22)
    prevBtn:SetPoint("RIGHT", controlCard, "RIGHT", -170, 0)
    prevBtn:SetText("< Previous")
    ApplyDropShadow(prevBtn:GetFontString())
    prevBtn:SetScript("OnClick", function()
        HFG:PrevGuideStep()
        HFG.UI:UpdateView()
    end)
    if currentStepIdx <= 1 then prevBtn:Disable() end

    local skipBtn = CreateFrame("Button", nil, controlCard, "UIPanelButtonTemplate")
    skipBtn:SetSize(75, 22)
    skipBtn:SetPoint("LEFT", prevBtn, "RIGHT", 6, 0)
    skipBtn:SetText("Skip Step")
    ApplyDropShadow(skipBtn:GetFontString())
    skipBtn:SetScript("OnClick", function()
        HFG:SkipGuideStep()
        HFG.UI:UpdateView()
    end)

    local nextBtn = CreateFrame("Button", nil, controlCard, "UIPanelButtonTemplate")
    nextBtn:SetSize(75, 22)
    nextBtn:SetPoint("LEFT", skipBtn, "RIGHT", 6, 0)
    nextBtn:SetText("Next >")
    ApplyDropShadow(nextBtn:GetFontString())
    nextBtn:SetScript("OnClick", function()
        HFG:NextGuideStep()
        HFG.UI:UpdateView()
    end)
    if currentStepIdx >= totalSteps then nextBtn:Disable() end

    yOffset = yOffset - 50

    -- Render Step Cards
    for sIdx, step in ipairs(activeGuide.steps) do
        local isActive = (sIdx == currentStepIdx)
        local isPast = (sIdx < currentStepIdx)

        local goalsCount = #(step.goals or {})
        local cardHeight = 44 + (goalsCount * 20)
        if step.text then
            cardHeight = cardHeight + 18
        end

        local card = CreateFrame("Frame", nil, child, BACKDROP_TEMPLATE)
        card:SetPoint("TOPLEFT", child, "TOPLEFT", 10, yOffset)
        card:SetSize(width, cardHeight)
        if card.SetBackdrop then
            card:SetBackdrop(BACKDROP_TOOLTIP_STYLE)
            if isActive then
                card:SetBackdropColor(0.08, 0.08, 0.03, 0.98)
                card:SetBackdropBorderColor(1.0, 0.85, 0.2, 1.0)
            elseif isPast then
                card:SetBackdropColor(0.03, 0.04, 0.03, 0.85)
                card:SetBackdropBorderColor(0.2, 0.5, 0.2, 0.7)
            else
                card:SetBackdropColor(0.03, 0.03, 0.05, 0.85)
                card:SetBackdropBorderColor(0.3, 0.3, 0.4, 0.7)
            end
        end
        table.insert(child.elements, card)

        -- Header text
        local stepNumColor = isActive and "|cffffd200" or (isPast and "|cff00ff00" or "|cff888888")
        local headerText = card:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        headerText:SetPoint("TOPLEFT", card, "TOPLEFT", 12, -8)

        local locStr = ""
        if step.zone then
            locStr = " — " .. step.zone
            if step.coords then
                locStr = locStr .. string.format(" (%.1f, %.1f)", step.coords.x, step.coords.y)
            end
        end
        headerText:SetText(string.format("%sStep %d:|r |cffffffff%s|r |cffaaaaaa%s|r", stepNumColor, sIdx, step.title or "", locStr))
        ApplyDropShadow(headerText)

        -- Active badge or Jump button
        if isActive then
            local activeBadge = card:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            activeBadge:SetPoint("TOPRIGHT", card, "TOPRIGHT", -12, -8)
            activeBadge:SetText("|cff00ff00[ACTIVE STEP]|r")
            ApplyDropShadow(activeBadge)
        else
            local jumpBtn = CreateFrame("Button", nil, card, "UIPanelButtonTemplate")
            jumpBtn:SetSize(72, 18)
            jumpBtn:SetPoint("TOPRIGHT", card, "TOPRIGHT", -10, -6)
            jumpBtn:SetText(isPast and "Revisit" or "Select")
            ApplyDropShadow(jumpBtn:GetFontString())
            jumpBtn:SetScript("OnClick", function()
                HFG:SetActiveGuide(activeGuide.id, sIdx)
                HFG.UI:UpdateView()
            end)
        end

        local curY = -28
        if step.text then
            local noteText = card:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            noteText:SetPoint("TOPLEFT", card, "TOPLEFT", 14, curY)
            noteText:SetWidth(width - 28)
            noteText:SetJustifyH("LEFT")
            noteText:SetTextColor(0.85, 0.85, 0.85, 1)
            noteText:SetText(step.text)
            ApplyDropShadow(noteText)
            curY = curY - 18
        end

        -- Goals list
        for _, goal in ipairs(step.goals or {}) do
            local goalLine = card:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            goalLine:SetPoint("TOPLEFT", card, "TOPLEFT", 22, curY)
            goalLine:SetWidth(width - 40)
            goalLine:SetJustifyH("LEFT")

            local checkStr = goal.isDone and "|cff00ff00[✓]|r " or "|cffffd200[ ]|r "
            local tagColor = "|cffffffff"
            if goal.type == "ACCEPT" then
                tagColor = "|cff33ff66[ACCEPT]|r "
            elseif goal.type == "TURNIN" then
                tagColor = "|cffffcc00[TURN IN]|r "
            elseif goal.type == "COMPLETE" then
                tagColor = "|cff3399ff[OBJECTIVE]|r "
            elseif goal.type == "LEVEL" then
                tagColor = "|cffff33ff[LEVEL]|r "
            elseif goal.type == "HEARTH" then
                tagColor = "|cff00ffff[HEARTH]|r "
            end

            local goalTextColor = goal.isDone and "|cff666666" or "|cffffffff"
            goalLine:SetText(checkStr .. tagColor .. goalTextColor .. (goal.text or goal.type) .. "|r")
            ApplyDropShadow(goalLine)

            curY = curY - 20
        end

        yOffset = yOffset - (cardHeight + 8)
    end

    return -yOffset
end

-- Direct Trigger Helper
function HFG:RenderBagQuestList()
    if self.UI and self.UI.MainFrame then
        self:SetViewTab("bagquests")
        if not self.UI.MainFrame:IsShown() then
            self.UI.MainFrame:Show()
        end
    end

    DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00[HFG]|r Scanning available bag upgrade quests for your character...")
    local quests = self:GetAvailableBagQuests()

    if #quests == 0 then
        DEFAULT_CHAT_FRAME:AddMessage(" -> All relevant bag quests completed!")
        return
    end

    for _, q in ipairs(quests) do
        local statusColor = q.isRelevantNow and "|cffffd700" or "|cff808080"
        DEFAULT_CHAT_FRAME:AddMessage(string.format(" • %s[%d Slots] %s (Zone: %s, Req Lvl: %d)|r", statusColor, q.slots, q.name, q.zone, q.level))
    end
end
