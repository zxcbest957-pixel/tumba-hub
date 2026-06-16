-- features/antiknockback.lua
-- Universal physics-based velocity dampener to prevent knockback / pushes

if not Mega.Features then Mega.Features = {} end
Mega.Features.AntiKnockback = {}

local Services = Mega.Services
local LocalPlayer = Services.Players.LocalPlayer
local States = Mega.States

if not States.Player then States.Player = {} end
if States.Player.AntiKnockback == nil then States.Player.AntiKnockback = false end
if States.Player.KnockbackStrength == nil then States.Player.KnockbackStrength = 0 end

if not Mega.Objects.AntiKnockbackConnections then Mega.Objects.AntiKnockbackConnections = {} end
local connections = Mega.Objects.AntiKnockbackConnections

local function CleanupConnections()
    for k, conn in pairs(connections) do
        if typeof(conn) == "RBXScriptConnection" then conn:Disconnect() end
    end
    table.clear(connections)
end

-- Universal physical fix (Stepped lock)
local function PhysicsAntiKB()
    if not States.Player.AntiKnockback then return end
    
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChild("Humanoid")
    if not hrp or not hum then return end

    -- Remove body movement objects that push the player
    for _, obj in ipairs(hrp:GetChildren()) do
        if obj:IsA("BodyVelocity") or obj:IsA("LinearVelocity") or obj:IsA("BodyForce") or obj:IsA("BodyPosition") or obj:IsA("VectorForce") or obj:IsA("AlignPosition") then
            local name = obj.Name
            if name ~= "TumbaFlyVelocity" and name ~= "TumbaFlyGyro" then
                pcall(function() obj:Destroy() end)
            end
        end
    end

    -- Dampen linear velocity
    local currentVel = hrp.AssemblyLinearVelocity
    local horizontalVel = Vector3.new(currentVel.X, 0, currentVel.Z)
    local walkSpeed = hum.WalkSpeed
    
    if horizontalVel.Magnitude > walkSpeed + 1 then
        local strengthMultiplier = (States.Player.KnockbackStrength or 0) / 100
        local targetDir = hum.MoveDirection * walkSpeed
        
        local newHorizontal = horizontalVel:Lerp(targetDir, 1 - strengthMultiplier)
        hrp.AssemblyLinearVelocity = Vector3.new(newHorizontal.X, currentVel.Y, newHorizontal.Z)
    end
end

function Mega.Features.AntiKnockback.SetEnabled(state)
    States.Player.AntiKnockback = state
    CleanupConnections()
    
    if state then
        connections.AntiKBStepped = Services.RunService.Stepped:Connect(PhysicsAntiKB)
        connections.AntiKBHeartbeat = Services.RunService.Heartbeat:Connect(PhysicsAntiKB)
    end
end

if States.Player.AntiKnockback then
    Mega.Features.AntiKnockback.SetEnabled(true)
end

return Mega.Features.AntiKnockback
