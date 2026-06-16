-- games/107646426076756.lua
-- Auto-Buy features for Farming Friends (Place ID: 107646426076756)

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

task.spawn(function()
    -- Wait for the Utilities Tab to be registered in the UI
    local TabFrame = nil
    for i = 1, 10 do
        if Mega.Objects and Mega.Objects.TabFrames and Mega.Objects.TabFrames["tab_utils"] then
            TabFrame = Mega.Objects.TabFrames["tab_utils"]
            break
        end
        task.wait(1)
    end
    
    if not TabFrame then
        warn("TumbaHub [Game Script]: Utilities tab not found.")
        return
    end

    -- 1. Register Translations
    local ruStrings = {
        ["section_game_features"] = "🌾 ФУНКЦИИ ИГРЫ",
        ["toggle_autobuy_seeds"] = "Авто-покупка семян",
        ["dropdown_select_seed"] = "Выбор семян",
        ["slider_buy_amount"] = "Количество для покупки",
    }
    local enStrings = {
        ["section_game_features"] = "🌾 GAME FEATURES",
        ["toggle_autobuy_seeds"] = "Auto-Buy Seeds",
        ["dropdown_select_seed"] = "Select Seed",
        ["slider_buy_amount"] = "Purchase Amount",
    }
    local ukStrings = {
        ["section_game_features"] = "🌾 ФУНКЦІЇ ГРИ",
        ["toggle_autobuy_seeds"] = "Авто-купівля насіння",
        ["dropdown_select_seed"] = "Вибір насіння",
        ["slider_buy_amount"] = "Кількість для покупки",
    }
    for k, v in pairs(ruStrings) do
        Mega.Localization.Strings[k] = { ru = v, en = enStrings[k], uk = ukStrings[k] }
    end

    -- 2. Initialize States
    Mega.States.Game = Mega.States.Game or {}
    if Mega.States.Game.AutoBuySeeds == nil then Mega.States.Game.AutoBuySeeds = false end
    if Mega.States.Game.SelectedSeed == nil then Mega.States.Game.SelectedSeed = "Carrot" end
    if Mega.States.Game.BuyAmount == nil then Mega.States.Game.BuyAmount = 10 end

    -- 3. Create UI elements
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
    
    -- 4. Start AutoBuy Loop
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
end)
