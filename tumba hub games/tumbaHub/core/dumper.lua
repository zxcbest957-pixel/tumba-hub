-- core/dumper.lua
-- Advanced Game Metadata Dumper for TumbaHub
-- Generates a packages.json file

if not Mega.Dumper then Mega.Dumper = {} end

local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Dumper = {}
Mega.Dumper = Dumper

local SCAN_PATHS = {
    ReplicatedStorage:WaitForChild("TS", 2),
    game:GetService("Players").LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("TS", 2)
}

local function translatePath(obj)
    local path = obj:GetFullName()
    path = path:gsub("%.", "__")
    path = path:gsub("%:", "__")
    return path .. ".json"
end

local function scanForConstants(parent, results)
    for _, child in pairs(parent:GetChildren()) do
        if child:IsA("ModuleScript") then
            local success, data = pcall(function() return require(child) end)
            if success and type(data) == "table" then
                local key = translatePath(child)
                local cleaned = {}
                for k, v in pairs(data) do
                    if type(v) ~= "function" and type(v) ~= "userdata" then
                        cleaned[k] = v
                    end
                end
                results[key] = HttpService:JSONEncode(cleaned)
            end
        end
        if child:IsA("Folder") or child:IsA("Model") then
            scanForConstants(child, results)
        end
    end
end

local function scanRemotes()
    local remotes = {}
    local rbxts = ReplicatedStorage:FindFirstChild("rbxts_include")
    local netManaged = nil
    if rbxts then
        local function findNet(parent)
            local found = parent:FindFirstChild("_NetManaged")
            if found then return found end
            for _, child in pairs(parent:GetChildren()) do
                if child:IsA("Folder") then
                    local res = findNet(child)
                    if res then return res end
                end
            end
            return nil
        end
        netManaged = findNet(rbxts)
    end

    if netManaged then
        print("🔍 TumbaHub Dumper: Scanning " .. netManaged.Name .. " remotes...")
        for _, remote in pairs(netManaged:GetChildren()) do
            remotes[remote.Name] = remote.Name
        end
    end
    
    -- Generic recursive scan in ReplicatedStorage for any RemoteEvent / RemoteFunction
    for _, item in ipairs(ReplicatedStorage:GetDescendants()) do
        if item:IsA("RemoteEvent") or item:IsA("RemoteFunction") then
            if not remotes[item.Name] then
                remotes[item.Name] = item.Name
            end
        end
    end
    
    return remotes
end

function Dumper.Execute()
    print("🚀 TumbaHub Dumper: Starting full game scan...")
    local finalJSON = {
        remotes = scanRemotes()
    }

    for _, path in ipairs(SCAN_PATHS) do
        if path then
            print("📂 TumbaHub Dumper: Scanning " .. path.Name .. "...")
            scanForConstants(path, finalJSON)
        end
    end

    print("💾 TumbaHub Dumper: Encoding to JSON (this may take a moment)...")
    local success, encoded = pcall(function() 
        return HttpService:JSONEncode(finalJSON) 
    end)

    if success then
        if writefile then
            local path = "tumbaHub/packages.json"
            writefile(path, encoded)
            print("✅ TumbaHub Dumper: Success! Saved to '" .. path .. "'")
            print("📊 Total Size: " .. string.format("%.2f", #encoded / 1024 / 1024) .. " MB")
        else
            warn("❌ TumbaHub Dumper: 'writefile' not supported by your executor.")
        end
    else
        warn("❌ TumbaHub Dumper: Failed to encode JSON. Error: " .. tostring(encoded))
    end
end

Mega.DumpGameData = Dumper.Execute

print("🛠 TumbaHub Dumper: Module loaded. Use 'Mega.DumpGameData()' to start.")

return Dumper
