-- games/107646426076756.lua
-- Auto-Buy features for Farming Friends (Place ID: 107646426076756)

local Mega, game, script = ...

local function GetSeedList()
    local seeds = {}
    local success, err = pcall(function()
        local registry = game:GetService("ReplicatedStorage"):FindFirstChild("Shared")
        registry = registry and registry:FindFirstChild("Registry")
        local plants = registry and registry:FindFirstChild("Plants")
        if plants and plants:IsA("ModuleScript") then
            local data = require(plants)
            for k, v in pairs(data) do
                table.insert(seeds, k)
            end
        end
    end)
    if not success or #seeds == 0 then
        -- Fallback common list of seeds in Farming Friends
        seeds = {"Carrot", "Beetroot", "Wheat", "Pumpkin", "Onion", "Cabbage", "Blueberry", "Bamboo", "Peach", "Cauliflower", "Melon", "Citrus", "Corn", "Potato", "Tomato", "Sunflower", "Watermelon", "Banana", "Apple", "Mango", "Durian", "Strawberry"}
    end
    table.sort(seeds)
    return seeds
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
    Mega.Localization.Strings["toggle_autobuy_seeds"] = { 
        ru = "Авто-покупка семян", 
        language_russian = "Авто-покупка семян", 
        en = "Auto-Buy Seeds", 
        language_english = "Auto-Buy Seeds", 
        uk = "Авто-купівля насіння", 
        language_ukrainian = "Авто-купівля насіння" 
    }
    Mega.Localization.Strings["dropdown_select_seed"] = { 
        ru = "Выбор семян", 
        language_russian = "Выбор семян", 
        en = "Select Seed", 
        language_english = "Select Seed", 
        uk = "Вибір насіння", 
        language_ukrainian = "Вибір насіння" 
    }
    Mega.Localization.Strings["slider_buy_amount"] = { 
        ru = "Количество для покупки", 
        language_russian = "Количество для покупки", 
        en = "Purchase Amount", 
        language_english = "Purchase Amount", 
        uk = "Кількість для покупки", 
        language_ukrainian = "Кількість для покупки" 
    }
end

local function CreateElements(TabFrame)
    local UI = Mega.UI
    UI.CreateSection(TabFrame, "section_game_features")
    
    local seeds = GetSeedList()
    
    UI.CreateToggle(TabFrame, "toggle_autobuy_seeds", "Game.AutoBuySeeds", function(state)
        Mega.States.Game.AutoBuySeeds = state
    end)
    
    UI.CreateDropdown(TabFrame, "dropdown_select_seed", "Game.SelectedSeed", seeds, function(val)
        Mega.States.Game.SelectedSeed = val
    end, false)
    
    UI.CreateSlider(TabFrame, "slider_buy_amount", "Game.BuyAmount", 1, 100, function(val)
        Mega.States.Game.BuyAmount = val
    end)
end

-- Initialize States
Mega.States.Game = Mega.States.Game or {}
if Mega.States.Game.AutoBuySeeds == nil then Mega.States.Game.AutoBuySeeds = false end
if Mega.States.Game.SelectedSeed == nil then Mega.States.Game.SelectedSeed = "Carrot" end
if Mega.States.Game.BuyAmount == nil then Mega.States.Game.BuyAmount = 10 end

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

-- Start AutoBuy Loop (Runs once globally)
task.spawn(function()
    while true do
        task.wait(1)
        if Mega.States.Game and Mega.States.Game.AutoBuySeeds then
            local seed = Mega.States.Game.SelectedSeed
            local amount = Mega.States.Game.BuyAmount or 10
            if seed and seed ~= "" then
                pcall(function()
                    local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("remotes")
                    local buySeedRemote = remotes and remotes:FindFirstChild("BuySeed")
                    if buySeedRemote then
                        if buySeedRemote:IsA("RemoteEvent") then
                            buySeedRemote:FireServer(seed, amount)
                        elseif buySeedRemote:IsA("RemoteFunction") then
                            buySeedRemote:InvokeServer(seed, amount)
                        end
                    end
                end)
            end
        end
    end
end)
