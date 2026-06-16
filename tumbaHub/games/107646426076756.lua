-- games/107646426076756.lua
-- Auto-Roll and Auto-Upgrade features for Farming Friends (Place ID: 107646426076756)

local Mega, game, script = ...

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
    Mega.Localization.Strings["toggle_autoupgrade_rolls"] = { 
        ru = "Авто-прокачка количества рулетки", 
        language_russian = "Авто-прокачка количества рулетки", 
        en = "Auto-Upgrade Roll Count", 
        language_english = "Auto-Upgrade Roll Count", 
        uk = "Авто-прокачка кількості рулетки", 
        language_ukrainian = "Авто-прокачка кількості рулетки" 
    }
    Mega.Localization.Strings["toggle_autoupgrade_luck"] = { 
        ru = "Авто-прокачка удачи рулетки", 
        language_russian = "Авто-прокачка удачи рулетки", 
        en = "Auto-Upgrade Roll Luck", 
        language_english = "Auto-Upgrade Roll Luck", 
        uk = "Авто-прокачка удачі рулетки", 
        language_ukrainian = "Авто-прокачка удачі рулетки" 
    }
end

local function CreateElements(TabFrame)
    local UI = Mega.UI
    UI.CreateSection(TabFrame, "section_game_features")
    
    UI.CreateToggle(TabFrame, "toggle_autoroll_seeds", "Game.AutoRoll", function(state)
        Mega.States.Game.AutoRoll = state
    end)
    
    UI.CreateToggle(TabFrame, "toggle_autoupgrade_rolls", "Game.AutoUpgradeRolls", function(state)
        Mega.States.Game.AutoUpgradeRolls = state
    end)
    
    UI.CreateToggle(TabFrame, "toggle_autoupgrade_luck", "Game.AutoUpgradeLuck", function(state)
        Mega.States.Game.AutoUpgradeLuck = state
    end)
end

-- Initialize States
Mega.States.Game = Mega.States.Game or {}
if Mega.States.Game.AutoRoll == nil then Mega.States.Game.AutoRoll = false end
if Mega.States.Game.AutoUpgradeRolls == nil then Mega.States.Game.AutoUpgradeRolls = false end
if Mega.States.Game.AutoUpgradeLuck == nil then Mega.States.Game.AutoUpgradeLuck = false end

-- Start background loop to monitor GUI life cycle and recreate elements on reload
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
        
        -- Wait until this TabFrame is destroyed (e.g. on language change or manual reload)
        while TabFrame and TabFrame.Parent do
            task.wait(0.5)
        end
    end
end)

-- 1. Auto-Roll Loop
task.spawn(function()
    while true do
        task.wait(0.2)
        if Mega.States.Game and Mega.States.Game.AutoRoll then
            pcall(function()
                local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("remotes")
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
end)

-- 2. Auto-Upgrade Rolls Loop
task.spawn(function()
    while true do
        task.wait(1)
        if Mega.States.Game and Mega.States.Game.AutoUpgradeRolls then
            pcall(function()
                local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("remotes")
                local upgradeRemote = remotes and remotes:FindFirstChild("UpgradeSeedRolls")
                if upgradeRemote then
                    if upgradeRemote:IsA("RemoteEvent") then
                        upgradeRemote:FireServer()
                    elseif upgradeRemote:IsA("RemoteFunction") then
                        upgradeRemote:InvokeServer()
                    end
                end
            end)
        end
    end
end)

-- 3. Auto-Upgrade Luck Loop
task.spawn(function()
    while true do
        task.wait(1)
        if Mega.States.Game and Mega.States.Game.AutoUpgradeLuck then
            pcall(function()
                local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("remotes")
                local upgradeRemote = remotes and remotes:FindFirstChild("UpgradeSeedLuck")
                if upgradeRemote then
                    if upgradeRemote:IsA("RemoteEvent") then
                        upgradeRemote:FireServer()
                    elseif upgradeRemote:IsA("RemoteFunction") then
                        upgradeRemote:InvokeServer()
                    end
                end
            end)
        end
    end
end)
