-- features/spider.lua
-- Logic for Spider (Climbing walls when moving towards them)

if not Mega.Features then Mega.Features = {} end
Mega.Features.Spider = {}

local Services = Mega.Services
local LocalPlayer = Services.Players.LocalPlayer
local States = Mega.States

if not States.Player then States.Player = {} end
if States.Player.Spider == nil then States.Player.Spider = false end
if States.Player.SpiderMode == nil then States.Player.SpiderMode = "Velocity" end
if States.Player.SpiderSpeed == nil then States.Player.SpiderSpeed = 30 end

if not Mega.Objects.SpiderConnections then Mega.Objects.SpiderConnections = {} end
local connections = Mega.Objects.SpiderConnections

local function CleanupConnections()
    for k, conn in pairs(connections) do
        if typeof(conn) == "RBXScriptConnection" then conn:Disconnect() end
    end
    table.clear(connections)
end

function Mega.Features.Spider.SetEnabled(state)
    States.Player.Spider = state
    CleanupConnections()
    
    if state then
        local rayCheck = RaycastParams.new()
        local activeWall = nil
        
        connections.SpiderLoop = Services.RunService.Heartbeat:Connect(function(dt)
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            
            if root and hum and hum.Health > 0 then
                rayCheck.FilterDescendantsInstances = {char, Services.Workspace.CurrentCamera}
                rayCheck.FilterType = Enum.RaycastFilterType.Exclude
                
                local vec = hum.MoveDirection * 2.5
                local ray = Services.Workspace:Raycast(root.Position - Vector3.new(0, 1.5, 0), vec, rayCheck)
                
                if activeWall and not ray then
                    root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, 0, root.AssemblyLinearVelocity.Z)
                end
                
                activeWall = ray
                if activeWall and ray.Normal.Y == 0 then
                    local speed = States.Player.SpiderSpeed or 30
                    
                    if States.Player.SpiderMode == "CFrame" then
                        root.CFrame = root.CFrame + Vector3.new(0, speed * dt, 0)
                        root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, 0, root.AssemblyLinearVelocity.Z)
                    elseif States.Player.SpiderMode == "Velocity" then
                        root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, speed, root.AssemblyLinearVelocity.Z)
                    end
                end
            end
        end)
    end
end

if States.Player.Spider then
    Mega.Features.Spider.SetEnabled(true)
end

return Mega.Features.Spider
