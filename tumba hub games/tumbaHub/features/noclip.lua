-- features/noclip.lua
-- Logic for NoClip (Walking through obstacles)

if not Mega.Features then Mega.Features = {} end
Mega.Features.NoClip = {}

local Services = Mega.Services
local LocalPlayer = Services.Players.LocalPlayer
local States = Mega.States

if not States.Player then States.Player = {} end
if States.Player.NoClip == nil then States.Player.NoClip = false end

if not Mega.Objects.NoClipConnections then Mega.Objects.NoClipConnections = {} end
local connections = Mega.Objects.NoClipConnections

local function CleanupConnections()
    for k, conn in pairs(connections) do
        if typeof(conn) == "RBXScriptConnection" then conn:Disconnect() end
    end
    table.clear(connections)
end

function Mega.Features.NoClip.SetEnabled(state)
    States.Player.NoClip = state
    CleanupConnections()
    
    if state then
        connections.NoClipLoop = Services.RunService.Stepped:Connect(function()
            local char = LocalPlayer.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
end

if States.Player.NoClip then
    Mega.Features.NoClip.SetEnabled(true)
end

return Mega.Features.NoClip
