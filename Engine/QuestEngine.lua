--[[
    Heathen's Forever Guide - Engine/QuestEngine.lua
    Dynamic Quest Evaluation and Recommendation Engine
    Queries completed quest flags via native client APIs, evaluates quest rewards
    against heuristic role specializations ([TANK], [HEAL], [DPS]), and surfaces
    unfinished quests with high XP or spec-appropriate loot upgrades.
]]

local ADDON_NAME, HFG = ...
if not HFG then HFG = _G.HFG end
if not HFG then return end

HFG.QuestEngine = {
    cachedCompletedQuests = {},
    lastScanTime = 0,
    activeQuests = {}
}

-- Native Client API Scan for Completed Quests
function HFG:ScanCompletedQuests()
    if not HFG_CharDB then HFG_CharDB = {} end
    if not HFG_CharDB.completedQuests then HFG_CharDB.completedQuests = {} end

    local foundCount = 0

    -- 1. Check native 3.3.0+ / custom client API GetQuestsCompleted(tbl)
    if type(GetQuestsCompleted) == "function" then
        local nativeList = {}
        local ok = pcall(GetQuestsCompleted, nativeList)
        if ok and type(nativeList) == "table" then
            for qid, isDone in pairs(nativeList) do
                if isDone then
                    HFG_CharDB.completedQuests[qid] = true
                    HFG.QuestEngine.cachedCompletedQuests[qid] = true
                    foundCount = foundCount + 1
                end
            end
        end
    end

    -- 2. Check native IsQuestFlaggedCompleted(questID)
    if type(IsQuestFlaggedCompleted) == "function" and HFG.QuestDB then
        for qid, _ in pairs(HFG.QuestDB) do
            local ok, completed = pcall(IsQuestFlaggedCompleted, qid)
            if ok and completed then
                HFG_CharDB.completedQuests[qid] = true
                HFG.QuestEngine.cachedCompletedQuests[qid] = true
                foundCount = foundCount + 1
            end
        end
    end

    -- 3. Cache from saved variables
    for qid, isDone in pairs(HFG_CharDB.completedQuests) do
        if isDone then
            HFG.QuestEngine.cachedCompletedQuests[qid] = true
        end
    end

    -- 4. Scan active Quest Log entries to detect in-progress quests
    self:UpdateActiveQuestLog()

    HFG.QuestEngine.lastScanTime = time and time() or 0
    return foundCount
end

-- Update In-Progress Quest Log Cache
function HFG:UpdateActiveQuestLog()
    HFG.QuestEngine.activeQuests = {}
    if not GetNumQuestLogEntries or not GetQuestLogTitle then return end

    local numEntries = GetNumQuestLogEntries()
    for i = 1, numEntries do
        local title, level, questTag, isHeader, isCollapsed, isComplete, frequency, questID = GetQuestLogTitle(i)
        if not isHeader and title then
            -- In older clients, questID might be nil, so we index by title and questID
            if questID and questID > 0 then
                HFG.QuestEngine.activeQuests[questID] = { title = title, level = level, isComplete = (isComplete == 1 or isComplete == true) }
            end
            -- Also index by lowercase title for fallback
            local lowerTitle = string.lower(title)
            HFG.QuestEngine.activeQuests[lowerTitle] = { title = title, level = level, isComplete = (isComplete == 1 or isComplete == true) }
        end
    end
end

-- Check if a quest is completed
function HFG:IsQuestCompleted(questId)
    if not questId then return false end

    -- Check native function if available
    if type(IsQuestFlaggedCompleted) == "function" then
        local ok, done = pcall(IsQuestFlaggedCompleted, questId)
        if ok and done then return true end
    end

    -- Check runtime cache
    if HFG.QuestEngine.cachedCompletedQuests[questId] then
        return true
    end

    -- Check SavedVariables
    if HFG_CharDB and HFG_CharDB.completedQuests and HFG_CharDB.completedQuests[questId] then
        return true
    end

    return false
end

-- Check if a quest is currently active in the quest log
function HFG:IsQuestActive(questId, questTitle)
    if questId and HFG.QuestEngine.activeQuests[questId] then
        return true, HFG.QuestEngine.activeQuests[questId].isComplete
    end
    if questTitle then
        local lower = string.lower(questTitle)
        if HFG.QuestEngine.activeQuests[lower] then
            return true, HFG.QuestEngine.activeQuests[lower].isComplete
        end
    end
    return false, false
end

-- Mark quest manually completed
function HFG:SetQuestCompleted(questId, isDone)
    if not HFG_CharDB then HFG_CharDB = {} end
    if not HFG_CharDB.completedQuests then HFG_CharDB.completedQuests = {} end
    HFG_CharDB.completedQuests[questId] = (isDone == true or isDone == 1)
    HFG.QuestEngine.cachedCompletedQuests[questId] = (isDone == true or isDone == 1)
end

-- Role Formatter Helper
function HFG:NormalizeRole(role)
    role = string.upper(role or "TANK")
    if role == "HEALER" or role == "HEAL" then
        return "HEAL"
    elseif role == "DPS" then
        return "DPS"
    else
        return "TANK"
    end
end

-- Dynamic Quest & Loot Recommendation Engine
function HFG:GetRecommendedQuests(options)
    options = options or {}
    if not HFG.QuestDB then return {} end

    -- Ensure active log cache is fresh
    self:UpdateActiveQuestLog()

    local profile = self:GetActiveProfile()
    local targetRole = self:NormalizeRole(options.role or profile.role or "TANK")
    local playerLevel = options.playerLevel or (UnitLevel and UnitLevel("player")) or 1
    local bracketId = options.bracket or self.selectedBracket or 1
    local sortBy = options.sortBy or "BEST" -- "BEST", "LOOT", "XP"
    local onlyUnfinished = (options.onlyUnfinished ~= false) -- default true
    local roleFilter = options.roleFilter or "SPEC" -- "SPEC" or "ALL"

    -- Determine level range based on bracket
    local minLvl, maxLvl = 1, 60
    if bracketId == 1 then
        minLvl, maxLvl = 1, 20
    elseif bracketId == 2 then
        minLvl, maxLvl = 20, 40
    elseif bracketId == 3 then
        minLvl, maxLvl = 40, 52
    elseif bracketId == 4 then
        minLvl, maxLvl = 52, 60
    end

    -- Allow wider search around player's active level if option set
    if options.usePlayerLevel then
        minLvl = math.max(1, playerLevel - 4)
        maxLvl = math.min(60, playerLevel + 4)
    end

    local recommendations = {}

    for qid, q in pairs(HFG.QuestDB) do
        local isDone = self:IsQuestCompleted(qid)
        local isActive, isObjectiveComplete = self:IsQuestActive(qid, q.title)

        -- Skip if user requests only unfinished and it's already completed
        if not (onlyUnfinished and isDone) then
            -- Check if quest level falls into bracket/target window
            if q.level >= minLvl and q.level <= maxLvl then
                local scores = q.scores or {}
                local roleScore = scores[targetRole] or 0
                local xpScore = scores.XP or 10

                -- Evaluate loot suitability for target role
                local bestLoot = nil
                local maxLootScore = 0
                local hasRoleUpgrade = false

                if q.loot and #q.loot > 0 then
                    for _, lootItem in ipairs(q.loot) do
                        local itemRole = lootItem.role or "[ALL]"
                        local isRoleMatch = (itemRole == "[" .. targetRole .. "]" or itemRole == "[ALL]")
                        
                        -- Calculate loot upgrade weight
                        local itemWeight = (lootItem.quality or 1) * 15
                        if lootItem.slot == "Shield" and targetRole == "TANK" then
                            itemWeight = itemWeight + 40
                        elseif (lootItem.slot == "One-Hand" or lootItem.slot == "Two-Hand") and targetRole == "DPS" then
                            itemWeight = itemWeight + (lootItem.dps or 0) * 1.5
                        elseif lootItem.slot == "Two-Hand" and targetRole == "HEAL" then
                            itemWeight = itemWeight + 25
                        end

                        if lootItem.stats then
                            if targetRole == "TANK" then
                                itemWeight = itemWeight + (lootItem.stats["Stamina"] or 0) * 3
                                itemWeight = itemWeight + (lootItem.stats["Defense Rating"] or 0) * 4
                                itemWeight = itemWeight + (lootItem.armor or 0) * 0.05
                            elseif targetRole == "HEAL" then
                                itemWeight = itemWeight + (lootItem.stats["Healing Power"] or 0) * 4
                                itemWeight = itemWeight + (lootItem.stats["Intellect"] or 0) * 2
                                itemWeight = itemWeight + (lootItem.stats["Spirit"] or 0) * 2
                            elseif targetRole == "DPS" then
                                itemWeight = itemWeight + (lootItem.stats["Attack Power"] or 0) * 2.5
                                itemWeight = itemWeight + (lootItem.stats["Agility"] or 0) * 3
                                itemWeight = itemWeight + (lootItem.stats["Strength"] or 0) * 2.5
                            end
                        end

                        if isRoleMatch and itemWeight > maxLootScore then
                            maxLootScore = itemWeight
                            bestLoot = lootItem
                            hasRoleUpgrade = true
                        elseif not bestLoot and itemWeight > maxLootScore then
                            maxLootScore = itemWeight
                            bestLoot = lootItem
                        end
                    end
                end

                -- Match role filter
                local passesFilter = true
                if roleFilter == "SPEC" and not hasRoleUpgrade and roleScore < 20 then
                    passesFilter = false
                end

                if passesFilter then
                    -- Compute Composite Score
                    local finalScore = 0
                    if sortBy == "LOOT" then
                        finalScore = (maxLootScore * 2.0) + (roleScore * 1.0) + (xpScore * 0.4)
                    elseif sortBy == "XP" then
                        finalScore = (xpScore * 2.5) + (maxLootScore * 0.8) + (roleScore * 0.5)
                    else -- "BEST"
                        finalScore = (maxLootScore * 1.4) + (roleScore * 1.0) + (xpScore * 0.8)
                    end

                    -- Bonus for in-progress quest (already accepted)
                    if isActive then
                        finalScore = finalScore + 15
                    end

                    table.insert(recommendations, {
                        quest = q,
                        isCompleted = isDone,
                        isActive = isActive,
                        isObjectiveComplete = isObjectiveComplete,
                        bestLoot = bestLoot,
                        hasRoleUpgrade = hasRoleUpgrade,
                        roleScore = roleScore,
                        lootScore = maxLootScore,
                        xpScore = xpScore,
                        finalScore = finalScore,
                        targetRole = targetRole
                    })
                end
            end
        end
    end

    -- Sort recommendations by final score descending
    table.sort(recommendations, function(a, b)
        if a.finalScore ~= b.finalScore then
            return a.finalScore > b.finalScore
        end
        return a.quest.level < b.quest.level
    end)

    return recommendations
end
