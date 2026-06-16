-- features/fly.lua
-- Universal Flight Cheat Module (Velocity and CFrame modes)

if not Mega.Features then Mega.Features = {} end
Mega.Features.Fly = {}

local Services = Mega.Services
local LocalPlayer = Services.Players.LocalPlayer
local States = Mega.States

local connections = {}
local w, s, a, d, space, shift = 0, 0, 0, 0, 0, 0

local function cleanup()
    for _, conn in pairs(connections) do
        pcall(function() conn:Disconnect() end)
    end
    table.clear(connections)
end

function Mega.Features.Fly.SetEnabled(state)
    States.Player.Fly = state
    cleanup()
    
    if state then
        w = Services.UserInputService:IsKeyDown(Enum.KeyCode.W) and -1 or 0
        s = Services.UserInputService:IsKeyDown(Enum.KeyCode.S) and 1 or 0
        a = Services.UserInputService:IsKeyDown(Enum.KeyCode.A) and -1 or 0
        d = Services.UserInputService:IsKeyDown(Enum.KeyCode.D) and 1 or 0
        space = Services.UserInputService:IsKeyDown(Enum.KeyCode.Space) and 1 or 0
        shift = Services.UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and -1 or 0

        connections.Began = Services.UserInputService.InputBegan:Connect(function(input, processed)
            if processed then return end
            local code = input.KeyCode
            if code == Enum.KeyCode.W then w = -1
            elseif code == Enum.KeyCode.S then s = 1
            elseif code == Enum.KeyCode.A then a = -1
            elseif code == Enum.KeyCode.D then d = 1
            elseif code == Enum.KeyCode.Space then space = 1
            elseif code == Enum.KeyCode.LeftShift then shift = -1
            end
        end)
        
        connections.Ended = Services.UserInputService.InputEnded:Connect(function(input)
            local code = input.KeyCode
            if code == Enum.KeyCode.W then w = 0
            elseif code == Enum.KeyCode.S then s = 0
            elseif code == Enum.KeyCode.A then a = 0
            elseif code == Enum.KeyCode.D then d = 0
            elseif code == Enum.KeyCode.Space then space = 0
            elseif code == Enum.KeyCode.LeftShift then shift = 0
            end
        end)
        
        connections.Loop = Services.RunService.PreSimulation:Connect(function(dt)
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if not hrp or not hum or hum.Health <= 0 then return end
            
            local cam = Services.Workspace.CurrentCamera
            if not cam then return end
            
            local lookVector = cam.CFrame.LookVector
            local rightVector = cam.CFrame.RightVector
            
            local flyDir = (rightVector * (a + d) + lookVector * (w + s)).Unit
            if flyDir ~= flyDir then flyDir = Vector3.zero end
            
            local upDir = Vector3.new(0, space + shift, 0)
            local totalDir = (flyDir + upDir)
            if totalDir.Magnitude > 0 then
                totalDir = totalDir.Unit
            end
            
            local speed = States.Player.FlySpeed or 24
            local mode = States.Player.FlyMode or "Velocity"
            
            if mode == "Velocity" then
                hrp.AssemblyLinearVelocity = totalDir * speed
                
                local gyro = hrp:FindFirstChild("TumbaFlyGyro")
                if not gyro then
                    gyro = Instance.new("BodyGyro")
                    gyro.Name = "TumbaFlyGyro"
                    gyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
                    gyro.P = 9000
                    gyro.CFrame = hrp.CFrame
                    gyro.Parent = hrp
                end
                gyro.CFrame = cam.CFrame
            else
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.CFrame = hrp.CFrame + (totalDir * speed * dt)
                
                local gyro = hrp:FindFirstChild("TumbaFlyGyro")
                if gyro then gyro:Destroy() end
            end
        end)
    else
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local gyro = hrp:FindFirstChild("TumbaFlyGyro")
            if gyro then gyro:Destroy() end
        end
    end
end

if States.Player.Fly then
    Mega.Features.Fly.SetEnabled(true)
end

return Mega.Features.Fly
