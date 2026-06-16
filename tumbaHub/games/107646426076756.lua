-- games/107646426076756.lua
-- Auto-Roll and Auto-Buy features with Rarity Selection for Farming Friends (Place ID: 107646426076756)

local SeedRarityMap = {
    ["Promise Lily"] = "Uncommon",
    ["Twinflame Tulip"] = "Epic",
    ["Amulet Anemone"] = "Legendary",
    ["Duoheart Daisy"] = "Prismatic",
    ["Heartvine Bloom"] = "Exotic",
    ["Soulbound Orchid"] = "Transcended"
}

local RarityPriority = {
    ["Uncommon"] = 1,
    ["Epic"] = 2,
    ["Legendary"] = 3,
    ["Prismatic"] = 4,
    ["Exotic"] = 5,
    ["Transcended"] = 6
}

local function GetPendingSeed()
    local player = game:GetService("Players").LocalPlayer
    
    -- Try reading FriendOTron PendingSeedKey from player
    local friendOTron = player:FindFirstChild("FriendOTron")
    local pending = friendOTron and friendOTron:FindFirstChild("PendingSeedKey")
    if pending then
        return pending.Value
    end
    
    -- Fallback: check general children in player
    for _, child in ipairs(player:GetChildren()) do
        if child:IsA("Folder") or child:IsA("Configuration") then
            local p = child:FindFirstChild("PendingSeedKey")
            if p then return p.Value end
        end
    end
    
    -- Fallback 2: check stats
    local stats = player:FindFirstChild("leaderstats") or player:FindFirstChild("Stats")
    local p = stats and stats:FindFirstChild("PendingSeed")
    if p then return p.Value end
    
    return nil
end

local function RegisterTranslations()
    Mega.Localization.Strings["section_game_features"] = { 
        ru = "🌾 ФУНКЦИИ ИГРЫ", 
        language_russian = "🌾 ФУНКЦИИ ИГРЫ", 
        en = "🌾 GAME FEATURES", 
        language_english = "🌾 GAME FEATURES", 
        uk = "🌾 ФУНКЦІЇ ГРИ", 
        language_ukrainian = "🌾 ФУНКЦІЇ ГРИ" 
    }
    Mega.Localization.Strings["toggle_autoroll_seeds"] = { 
        ru = "Авто-рулетка семян (Auto-Roll)", 
        language_russian = "Авто-рулетка семян (Auto-Roll)", 
        en = "Auto-Roll Seeds", 
        language_english = "Auto-Roll Seeds", 
        uk = "Авто-рулетка насіння (Auto-Roll)", 
        language_ukrainian = "Авто-рулетка насіння (Auto-Roll)" 
    }
    Mega.Localization.Strings["toggle_autobuy_seeds"] = { 
        ru = "Авто-покупка выпавших семян", 
        language_russian = "Авто-покупка выпавших семян", 
        en = "Auto-Buy Rolled Seeds", 
        language_english = "Auto-Buy Rolled Seeds", 
        uk = "Авто-купівля випавшого насіння", 
        language_ukrainian = "Авто-купівля випавшого насіння" 
    }
    Mega.Localization.Strings["dropdown_min_rarity"] = { 
        ru = "Мин. редкость для покупки", 
        language_russian = "Мин. редкость для покупки", 
        en = "Min Rarity to Buy", 
        language_english = "Min Rarity to Buy", 
        uk = "Мін. рідкість для купівлі", 
        language_ukrainian = "Мін. рідкість для купівлі" 
    }
end

local function CreateElements(TabFrame)
    local UI = Mega.UI
    UI.CreateSection(TabFrame, "section_game_features")
    
    UI.CreateToggle(TabFrame, "toggle_autoroll_seeds", "Game.AutoRoll", function(state)
        Mega.States.Game.AutoRoll = state
    end)
    
    UI.CreateToggle(TabFrame, "toggle_autobuy_seeds", "Game.AutoBuy", function(state)
        Mega.States.Game.AutoBuy = state
    end)

    UI.CreateDropdown(TabFrame, "dropdown_min_rarity", "Game.MinRarity", {"All", "Uncommon", "Epic", "Legendary", "Prismatic", "Exotic", "Transcended"}, function(val)
        Mega.States.Game.MinRarity = val
    end, false)
end

-- Initialize States
Mega.States.Game = Mega.States.Game or {}
if Mega.States.Game.AutoRoll == nil then Mega.States.Game.AutoRoll = false end
if Mega.States.Game.AutoBuy == nil then Mega.States.Game.AutoBuy = false end
if Mega.States.Game.MinRarity == nil then Mega.States.Game.MinRarity = "All" end

-- Monitor GUI life cycle and recreate elements on reload
task.spawn(function()
    while true do
        local TabFrame = nil
        while true do
            if Mega.Objects and Mega.Objects.TabFrames and Mega.Objects.TabFrames["tab_utils"] then
                TabFrame = Mega.Objects.TabFrames["tab_utils"]
                break
            end
            task.wait(0.5)
        end
        
        if not TabFrame:FindFirstChild("section_game_featuresSection") then
            pcall(function()
                RegisterTranslations()
                CreateElements(TabFrame)
            end)
        end
        
        -- Wait until this TabFrame is destroyed
        while TabFrame and TabFrame.Parent do
            task.wait(0.5)
        end
    end
end)

-- Helper to safely get the Remotes folder
local function GetRemotesFolder()
    local replicatedStorage = game:GetService("ReplicatedStorage")
    return replicatedStorage:FindFirstChild("Remotes") or replicatedStorage:FindFirstChild("remotes")
end

-- Helper to check if a pending seed should be bought based on user settings
local function ShouldBuySeed(pendingSeed)
    if not pendingSeed or pendingSeed == "" then return false end
    
    local selectedMinRarity = Mega.States.Game.MinRarity or "All"
    if selectedMinRarity == "All" then
        return true
    end
    
    local rarity = SeedRarityMap[pendingSeed] or "Uncommon"
    local seedPriority = RarityPriority[rarity] or 1
    local minPriority = RarityPriority[selectedMinRarity] or 1
    
    return seedPriority >= minPriority
end

-- 1. Auto-Roll Loop
task.spawn(function()
    while true do
        task.wait(0.2)
        if Mega.States.Game and Mega.States.Game.AutoRoll then
            local pendingSeed = GetPendingSeed()
            local canRoll = true
            
            -- If Auto-Buy is enabled and we rolled a seed that we WANT to buy, wait for the buy loop to claim it.
            -- If we do not want this seed, canRoll remains true, and we roll again to overwrite it.
            if Mega.States.Game.AutoBuy and pendingSeed and pendingSeed ~= "" then
                if ShouldBuySeed(pendingSeed) then
                    canRoll = false
                end
            end
            
            if canRoll then
                pcall(function()
                    local remotes = GetRemotesFolder()
                    local rollRemote = remotes and remotes:FindFirstChild("RollSeeds")
                    if rollRemote then
                        if rollRemote:IsA("RemoteEvent") then
                            rollRemote:FireServer()
                        elseif rollRemote:IsA("RemoteFunction") then
                            rollRemote:InvokeServer()
                        end
                    end
                end)
            end
        end
    end
end)

-- 2. Auto-Buy Rolled Seeds Loop
task.spawn(function()
    while true do
        task.wait(0.1)
        if Mega.States.Game and Mega.States.Game.AutoBuy then
            local pendingSeed = GetPendingSeed()
            if pendingSeed and pendingSeed ~= "" and ShouldBuySeed(pendingSeed) then
                pcall(function()
                    local remotes = GetRemotesFolder()
                    local buySeedRemote = remotes and remotes:FindFirstChild("BuySeed")
                    if buySeedRemote then
                        -- Fire remote for all slots (1 to 5) to claim the seeds
                        for slot = 1, 5 do
                            buySeedRemote:FireServer(slot)
                        end
                    end
                end)
            end
        end
    end
end)
