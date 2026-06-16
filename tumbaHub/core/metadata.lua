-- core/metadata.lua
-- Dynamic Remote Mapping and Game Metadata System
-- Adapted for Universal/Non-PvP games

if not Mega.Metadata then Mega.Metadata = {} end

local HttpService = game:GetService("HttpService")
local MetadataManager = {}
Mega.MetadataManager = MetadataManager

local jsonContent = nil

-- Function to load metadata (e.g. package configs or mappings)
function MetadataManager.Init()
    local fileName = "packages.json"
    local localPath = "tumbaHub/" .. fileName
    
    -- 1. Try local file first
    if isfile and readfile then
        if isfile(localPath) then
            local success, data = pcall(readfile, localPath)
            if success then jsonContent = data end
        end
    end
    
    -- 2. Fetch from GitHub if not found locally
    if not jsonContent and Mega.RepositoryBaseURL then
        local success, data = pcall(game.HttpGet, game, Mega.RepositoryBaseURL .. fileName)
        if success and data and not data:find("404") then
            jsonContent = data
            -- Cache it
            if writefile then
                pcall(function()
                    if not isfolder("tumbaHub") then makefolder("tumbaHub") end
                    writefile(localPath, data)
                end)
            end
        end
    end
    
    if jsonContent then
        local success, decoded = pcall(function() return HttpService:JSONDecode(jsonContent) end)
        if success then
            Mega.Metadata = decoded
        end
    end
end

local remoteCache = {}

-- Function to get a RemoteEvent, RemoteFunction, BindableEvent, or BindableFunction
function Mega.GetRemote(name)
    if remoteCache[name] then return remoteCache[name] end

    local actualName = name
    
    -- Check mapping in metadata if loaded
    if Mega.Metadata and Mega.Metadata.remotes then
        actualName = Mega.Metadata.remotes[name] or name
    end
    
    -- Standard ReplicatedStorage check (fast path)
    local replicatedStorage = game:GetService("ReplicatedStorage")
    local remote = replicatedStorage:FindFirstChild(actualName)
    if remote and (remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") or remote:IsA("BindableEvent") or remote:IsA("BindableFunction")) then
        remoteCache[name] = remote
        return remote
    end
    
    -- Fallback: recursive search
    remote = replicatedStorage:FindFirstChild(actualName, true)
    if remote and (remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") or remote:IsA("BindableEvent") or remote:IsA("BindableFunction")) then
        remoteCache[name] = remote
        return remote
    end
    
    return nil
end

MetadataManager.Init()

return MetadataManager
