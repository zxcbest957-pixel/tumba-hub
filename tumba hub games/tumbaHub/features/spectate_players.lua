-- features/spectate_players.lua
-- Logic for Spectate Player (Camera tracking other players)

if not Mega.Features then Mega.Features = {} end
Mega.Features.SpectatePlayers = {}

local Services = Mega.Services
local States = Mega.States

if not Mega.Objects.SpectateConnections then Mega.Objects.SpectateConnections = {} end
local connections = Mega.Objects.SpectateConnections

local function stopLoop()
    if connections.SpectateLoop then
        connections.SpectateLoop:Disconnect()
        connections.SpectateLoop = nil
    end
end

local function startLoop()
    if not connections.SpectateLoop then
        connections.SpectateLoop = Services.RunService.Heartbeat:Connect(function()
            if States.Player.SpectateTarget then
                local target = States.Player.SpectateTarget
                if target and target.Parent and target.Character and target.Character:FindFirstChildOfClass("Humanoid") then
                    local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
                    local targetHum = target.Character:FindFirstChildOfClass("Humanoid")
                    
                    if targetRoot and targetHum and targetHum.Health > 0 then
                        local camera = Services.Workspace.CurrentCamera
                        if camera then
                            camera.CameraType = Enum.CameraType.Scriptable
                            camera.CFrame = targetRoot.CFrame * CFrame.new(0, 5, 15)
                        end
                    else
                        Mega.Features.SpectatePlayers.StopSpectate()
                    end
                else
                    Mega.Features.SpectatePlayers.StopSpectate()
                end
            else
                stopLoop()
            end
        end)
    end
end

function Mega.Features.SpectatePlayers.Spectate(targetPlayer)
    States.Player.SpectateTarget = targetPlayer
    if targetPlayer then
        startLoop()
    else
        stopLoop()
        local camera = Services.Workspace.CurrentCamera
        if camera then
            camera.CameraType = Enum.CameraType.Custom
        end
    end
end

function Mega.Features.SpectatePlayers.StopSpectate()
    Mega.Features.SpectatePlayers.Spectate(nil)
    if Mega.ShowNotification then
        Mega.ShowNotification(Mega.GetText("notify_spectate_stop"))
    end
end

if States.Player.SpectateTarget then
    startLoop()
end

return Mega.Features.SpectatePlayers
