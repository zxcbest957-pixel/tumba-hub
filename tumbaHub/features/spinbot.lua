-- features/spinbot.lua
-- Logic for SpinBot (rotates the player horizontally)

if not Mega.Features then Mega.Features = {} end
Mega.Features.SpinBot = {}

local Services = Mega.Services
local LocalPlayer = Services.Players.LocalPlayer
local States = Mega.States

if not States.Player then States.Player = {} end
if States.Player.SpinBot == nil then States.Player.SpinBot = false end
if States.Player.SpinSpeed == nil then States.Player.SpinSpeed = 10 end

if not Mega.Objects.SpinBotConnections then Mega.Objects.SpinBotConnections = {} end
local connections = Mega.Objects.SpinBotConnections

local function CleanupConnections()
    for k, conn in pairs(connections) do
        if typeof(conn) == "RBXScriptConnection" then conn:Disconnect() end
    end
    table.clear(connections)
end

function Mega.Features.SpinBot.SetEnabled(state)
    States.Player.SpinBot = state
    CleanupConnections()
    
    if state then
        connections.SpinBotLoop = Services.RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local speed = States.Player.SpinSpeed or 10
                hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(speed), 0)
            end
        end)
    end
end

if States.Player.SpinBot then
    Mega.Features.SpinBot.SetEnabled(true)
end

return Mega.Features.SpinBot
