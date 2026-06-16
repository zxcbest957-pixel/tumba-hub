-- tumbaHub.lua
-- Main entry point & module loader for TumbaHub Games (Non-PvP Edition)
-- Made by @kreml1nAgent & Antigravity

if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- Cleanup old GUI instances if they exist to prevent duplicates on re-injection
local CoreGui = game:GetService("CoreGui")
for _, name in ipairs({"TumbaMegaSystem", "TumbaStatusIndicator", "TumbaMobileToggle", "TumbaMobileHUD", "TumbaHubLoader", "LanguagePrompt"}) do
    local old = CoreGui:FindFirstChild(name)
    if old then
        pcall(function() old:Destroy() end)
    end
end

-- Auto-join Discord Server on load (Runs only ONCE to prevent auto-inject spam)
task.spawn(function()
    local inviteCode = "DGhWJNuKBS"
    local fileName = "tumbaHub/DiscordInvited.txt"
    
    if isfile and isfile(fileName) then
        return -- Already invited, skip to avoid spam on teleports / auto-inject
    end

    if writefile then
        pcall(function()
            if not isfolder("tumbaHub") then makefolder("tumbaHub") end
            writefile(fileName, "true")
        end)
    end
    
    local httpService = game:GetService("HttpService")
    
    -- Method 1: Discord Desktop RPC (opens app directly)
    pcall(function()
        local body = httpService:JSONEncode({
            nonce = httpService:GenerateGUID(false),
            args = {
                invite = { code = inviteCode },
                code = inviteCode
            },
            cmd = "INVITE_BROWSER"
        })
        
        local req = request or (syn and syn.request) or (http and http.request)
        if req then
            for _, port in ipairs({6463, 6464, 6465, 6466}) do
                task.spawn(function()
                    pcall(function()
                        req({
                            Method = "POST",
                            Url = "http://127.0.0.1:" .. tostring(port) .. "/rpc?v=1",
                            Headers = {
                                ["Content-Type"] = "application/json",
                                Origin = "https://discord.com"
                            },
                            Body = body
                        })
                    end)
                end)
            end
        end
    end)
    
    -- Method 2: setclipboard fallback (copies to clipboard)
    if setclipboard then
        pcall(function()
            setclipboard("https://discord.gg/" .. inviteCode)
        end)
    end
end)

local LocalPlayer = game:GetService("Players").LocalPlayer
local canChat = game:GetService("TextChatService").ChatVersion == Enum.ChatVersion.TextChatService
local safeUsername = LocalPlayer.Name:gsub(" ", "%%20")

local regionCode = "Unknown"
pcall(function()
    regionCode = game:GetService("LocalizationService"):GetCountryRegionForPlayerAsync(LocalPlayer)
end)

-- Initialize the global Mega table
Mega = {
    Objects = {
        Connections = {},
        GUI = nil,
        PlayerListItems = {},
        Toggles = {},
        Sliders = {},
        Dropdowns = {},
        KeybindButtons = {},
        TabFrames = {}
    },
    UserData = {
        username = LocalPlayer.Name,
        userId = LocalPlayer.UserId,
        jobId = game.JobId,
        placeId = game.PlaceId,
        canChat = canChat,
        region = regionCode
    },
    Features = {},
    LoadedModules = {}
}

getgenv().Mega = Mega

-- Configure repository base URL
local baseRepoURL = shared.TumbaHubRepoURL or "https://raw.githubusercontent.com/zxcbest957-pixel/tumba-hub/main/tumbaHub/"
Mega.RepositoryBaseURL = baseRepoURL

function Mega.GetImageFromURL(url, fileName)
    local folderPath = "tumbaHub/icons_v2/"
    local fullPath = folderPath .. fileName
    
    if isfile and writefile and makefolder and getcustomasset then
        if not isfolder("tumbaHub") then makefolder("tumbaHub") end
        if not isfolder(folderPath) then makefolder(folderPath) end

        if not isfile(fullPath) then
            if url and url ~= "" then
                local success, data = pcall(function() return game:HttpGet(url) end)
                if success and data and #data > 0 then
                    writefile(fullPath, data)
                else
                    warn("TumbaHub: Failed to download icon from " .. url)
                end
            end
        end
        if isfile(fullPath) then
            local success, asset = pcall(function() return getcustomasset(fullPath) end)
            if success and asset then
                return asset
            end
        end
    end
    return "rbxassetid://13388222306"
end

-- Module Loader
function Mega.LoadModule(path)
    if Mega.LoadedModules[path] then
        return
    end
    Mega.LoadedModules[path] = true

    local content = nil
    local success = false
    
    -- 1. Try local files first for development if DevMode is enabled
    if shared.TumbaHubDevMode and isfile and readfile then
        local possiblePaths = {
            "tumba hub games/tumbaHub/" .. path,
            "tumbaHub/" .. path,
            path
        }
        for _, p in ipairs(possiblePaths) do
            if isfile(p) then
                success, content = pcall(readfile, p)
                if success and content and #content > 0 then break end
            end
        end
    end

    -- 2. Fetch from GitHub HttpGet (default behavior for users)
    if not success or not content then
        local url = Mega.RepositoryBaseURL .. path
        success, content = pcall(function() return game:HttpGet(url, true) end)
        if success and (content:find("404: Not Found") or content:lower():match("timeout") or #content < 10) then 
            success = false
            content = nil 
        end
    end

    -- 3. Fallback to local files if remote fails and we didn't try them yet
    if not success or not content then
        if not shared.TumbaHubDevMode and isfile and readfile then
            local possiblePaths = {
                "tumba hub games/tumbaHub/" .. path,
                "tumbaHub/" .. path,
                path
            }
            for _, p in ipairs(possiblePaths) do
                if isfile(p) then
                    success, content = pcall(readfile, p)
                    if success and content and #content > 0 then break end
                end
            end
        end
    end

    if success and content then
        local chunk, err = loadstring("return function(Mega, game, script) " .. content .. " end")
        if chunk then
            local moduleFunc = chunk()
            local runSuccess, runErr = pcall(moduleFunc, Mega, game, script)
            if not runSuccess then
                warn("Execution error in module:", path, "|", runErr)
                Mega.LoadedModules[path] = nil
            end
        else
            warn("Syntax error in module:", path, "|", err)
            Mega.LoadedModules[path] = nil
        end
    else
        warn("Failed to load module:", path)
        Mega.LoadedModules[path] = nil
    end
end

-- Load bootstrap services
Mega.LoadModule("core/services.lua")

-- Initialize loader screen
Mega.LoadModule("gui/loader_screen.lua")
local loaderUI = nil
if Mega.Loader then
    loaderUI = Mega.Loader.Create()
end

local function InitializePhase(phaseId, moduleList)
    if loaderUI and loaderUI.SetStage then 
        loaderUI.SetStage(phaseId) 
    end
    local count = #moduleList
    for i, path in ipairs(moduleList) do
        if loaderUI and loaderUI.Update then
            local overallPercent = (i / count) * 100
            local phaseNames = {
                network = "Connecting to Server...",
                core = "Loading Core Systems...",
                features = "Injecting Features...",
                ui = "Building Interface..."
            }
            local loadingText = phaseNames[phaseId] or ("Loading " .. string.upper(phaseId) .. "...")
            loaderUI.Update(overallPercent, loadingText)
        end
        Mega.LoadModule(path)
        task.wait(0.12)
    end
end

-- PHASE 1: NETWORK HANDSHAKE & METADATA
InitializePhase("network", {
    "core/metadata.lua"
})

-- PHASE 2: BUILDING CORE ENVIRONMENT
InitializePhase("core", {
    "core/dumper.lua",
    "core/settings.lua",
    "core/localization.lua",
    "core/config.lua"
})

-- PHASE 3: SYNCING SYSTEM FEATURES
InitializePhase("features", {
    "library/notifications.lua",
    "library/ui_builder.lua",
    "core/mobile_hud.lua",
    "features/esp.lua",
    "features/speed.lua",
    "features/fly.lua",
    "features/spider.lua",
    "features/spinbot.lua",
    "features/noclip.lua",
    "features/antiknockback.lua",
    "features/spectate_players.lua",
    "features/staff_detector.lua",
    "features/ai_chat.lua"
})

-- PHASE 4: FINALIZING INTERFACE
InitializePhase("ui", {
    "gui/main_window.lua"
})

-- Finish Initialization
if loaderUI then
    loaderUI.Update(100, Mega.GetText and Mega.GetText("loader_ready") or "Loaded successfully!")
    task.wait(0.5)
    loaderUI.Destroy()
end

-- Auto-load config & start background auto-save
if Mega.ConfigSystem then
    task.spawn(function()
        Mega.ConfigSystem.LoadLastConfig()
        Mega.ConfigSystem.StartAutosave(5)
    end)
end

-- Load game-specific scripts if they exist
task.spawn(function()
    local placeFile = "games/" .. tostring(game.PlaceId) .. ".lua"
    local gameFile = "games/" .. tostring(game.GameId) .. ".lua"
    
    local loadedSpecific = false
    
    -- Check local place file
    if isfile and isfile("tumbaHub/" .. placeFile) then
        Mega.LoadModule(placeFile)
        loadedSpecific = true
    elseif isfile and isfile("tumbaHub/" .. gameFile) then
        Mega.LoadModule(gameFile)
        loadedSpecific = true
    end
    
    if not loadedSpecific then
        -- Try game specific from remote base repo URL
        local success = pcall(function()
            Mega.LoadModule(placeFile)
        end)
        if not success or not Mega.LoadedModules[placeFile] then
            pcall(function()
                Mega.LoadModule(gameFile)
            end)
        end
    end
end)

print("🔥 TUMBA MEGA SYSTEM GAMES (UNIVERSAL) LOADED SUCCESSFULLY!")
print("🎮 Press RightShift to toggle the main menu")

-- === AUTO-INJECT ON TELEPORT ===
local queue_on_teleport = queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport) or queueonteleport
if queue_on_teleport then
    local teleportCode = [[
        task.wait(1)
        if shared.TumbaHubDevMode and isfile and readfile then
            if isfile("tumbaHub/tumbaHub.lua") then
                loadstring(readfile("tumbaHub/tumbaHub.lua"))()
            elseif isfile("tumba hub games/tumbaHub/tumbaHub.lua") then
                loadstring(readfile("tumba hub games/tumbaHub/tumbaHub.lua"))()
            else
                loadstring(game:HttpGet("https://raw.githubusercontent.com/zxcbest957-pixel/tumba-hub/main/tumbaHub/tumbaHub.lua", true))()
            end
        else
            loadstring(game:HttpGet("https://raw.githubusercontent.com/zxcbest957-pixel/tumba-hub/main/tumbaHub/tumbaHub.lua", true))()
        end
    ]]
    queue_on_teleport(teleportCode)
    print("🔄 Teleport queue injector active.")
end
