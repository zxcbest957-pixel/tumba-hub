-- features/esp.lua
-- Universal Player ESP and 3D Gorilla Mode Chams

Mega.Features.ESP = {}

local Services = Mega.Services
local States = Mega.States
local Settings = Mega.Settings

local espFolder = Instance.new("Folder", Services.CoreGui)
espFolder.Name = "TumbaESP_Container"

local playerEspConnections = {}
if not Mega.Objects.ESP then Mega.Objects.ESP = {} end
if not Mega.Objects.GorillaConnections then Mega.Objects.GorillaConnections = {} end

-- Gorilla Mode Settings & Logic
local GORILLA_MESH_ID = "rbxassetid://430330296"
local GORILLA_TEXTURE_ID = "rbxassetid://430330316"

local function ApplyGorillaModel(character)
    if not character then return end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end

    if character:FindFirstChild("GorillaChamsPart") then return end

    -- Hide original body parts
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.Transparency = 1
        elseif part:IsA("Accessory") then
            local handle = part:FindFirstChild("Handle")
            if handle then handle.Transparency = 1 end
        end
    end

    -- Create Gorilla part
    local gorillaPart = Instance.new("Part")
    gorillaPart.Name = "GorillaChamsPart"
    gorillaPart.Size = Vector3.new(2, 2, 2)
    gorillaPart.Transparency = 0
    gorillaPart.CanCollide = false
    gorillaPart.Anchored = false
    gorillaPart.Massless = true
    gorillaPart.CFrame = rootPart.CFrame * CFrame.new(0, -1, 0)

    local mesh = Instance.new("SpecialMesh")
    mesh.MeshId = GORILLA_MESH_ID
    mesh.TextureId = GORILLA_TEXTURE_ID
    mesh.Scale = Vector3.new(0.022, 0.022, 0.022) 
    mesh.Parent = gorillaPart

    local weld = Instance.new("Weld")
    weld.Name = "GorillaWeld"
    weld.Part0 = rootPart
    weld.Part1 = gorillaPart
    weld.C0 = CFrame.new(0, -1.2, 0)
    weld.Parent = gorillaPart

    gorillaPart.Parent = character
end

local function RemoveGorillaModel(character)
    if not character then return end
    
    local gorillaPart = character:FindFirstChild("GorillaChamsPart")
    if gorillaPart then gorillaPart:Destroy() end

    -- Restore body parts visibility
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.Transparency = 0
        elseif part:IsA("Accessory") then
            local handle = part:FindFirstChild("Handle")
            if handle then handle.Transparency = 0 end
        end
    end
end

local function UpdateAllPlayersGorilla()
    local currentTime = tick()
    local lp = Services.Players.LocalPlayer
    for _, player in pairs(Services.Players:GetPlayers()) do
        if player ~= lp and player.Character then
            if States.Visuals.GorillaMode then
                ApplyGorillaModel(player.Character)
                
                local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
                local humanoid = player.Character:FindFirstChild("Humanoid")
                local gorillaPart = player.Character:FindFirstChild("GorillaChamsPart")
                if rootPart and humanoid and gorillaPart then
                    local weld = gorillaPart:FindFirstChild("GorillaWeld")
                    if weld then
                        local velocity = rootPart.AssemblyLinearVelocity
                        local horizontalSpeed = Vector3.new(velocity.X, 0, velocity.Z).Magnitude
                        local verticalSpeed = velocity.Y
                        local turnSpeed = rootPart.AssemblyAngularVelocity.Y
                        
                        local baseC0 = CFrame.new(0, -1.2, 0)
                        
                        if humanoid.FloorMaterial == Enum.Material.Air then
                            local fallTiltX = math.clamp(-verticalSpeed / 50, -0.6, 0.6)
                            weld.C0 = baseC0 * CFrame.Angles(fallTiltX, 0, 0)
                        elseif horizontalSpeed > 1 then
                            local speedMultiplier = math.clamp(horizontalSpeed / 16, 0.5, 2.5)
                            local animationCycle = currentTime * 15 * speedMultiplier
                            
                            local bounceY = math.abs(math.sin(animationCycle)) * 0.6
                            local swayX = math.sin(animationCycle / 2) * 0.3
                            local leanForward = -0.3 * speedMultiplier
                            local turnLean = math.clamp(-turnSpeed * 0.1, -0.5, 0.5)
                            
                            weld.C0 = baseC0 * CFrame.new(swayX * 0.5, bounceY, 0) * CFrame.Angles(leanForward, swayX, turnLean)
                        else
                            local breatheCycle = math.sin(currentTime * 3) * 0.05
                            local lookAroundCycle = math.sin(currentTime * 0.5) * 0.15
                            
                            weld.C0 = baseC0 * CFrame.new(0, breatheCycle, 0) * CFrame.Angles(0, lookAroundCycle, 0)
                        end
                    end
                end
            else
                RemoveGorillaModel(player.Character)
            end
        end
    end
end

function Mega.Features.ESP.SetGorillaEnabled(state)
    States.Visuals.GorillaMode = state
    for _, conn in pairs(Mega.Objects.GorillaConnections) do
        pcall(function() conn:Disconnect() end)
    end
    table.clear(Mega.Objects.GorillaConnections)
    
    if state then
        Mega.Objects.GorillaConnections.Loop = Services.RunService.Heartbeat:Connect(function()
            if not States.Visuals.GorillaMode then return end
            UpdateAllPlayersGorilla()
        end)
    else
        for _, player in pairs(Services.Players:GetPlayers()) do
            if player.Character then
                RemoveGorillaModel(player.Character)
            end
        end
    end
end

-- --- Drawing ESP ---
local function CreateESP(player)
    if player == Services.Players.LocalPlayer then return end

    local esp = {
        boxOutline = Drawing.new("Square"),
        box = Drawing.new("Square"),
        name = Drawing.new("Text"),
        distance = Drawing.new("Text"),
        toolText = Drawing.new("Text"),
        healthBarBack = Drawing.new("Square"),
        healthBarFront = Drawing.new("Square"),
        healthText = Drawing.new("Text"),
        tracer = Drawing.new("Line"),
        skeleton = {},
        chams = Instance.new("Highlight")
    }

    esp.chams.Name = player.Name .. "_Chams"
    esp.chams.Parent = espFolder
    esp.chams.Enabled = false
    esp.chams.FillTransparency = 0.5
    esp.chams.OutlineTransparency = 0.2

    local skeletonLinks = {"Head_Torso", "Torso_LeftArm", "Torso_RightArm", "Torso_LeftLeg", "Torso_RightLeg", "LeftArm_LeftHand", "RightArm_RightHand", "LeftLeg_LeftFoot", "RightLeg_RightFoot"}
    for _, linkName in ipairs(skeletonLinks) do
        local line = Drawing.new("Line")
        line.Visible = false
        line.Thickness = 1.5
        line.ZIndex = 2
        esp.skeleton[linkName] = line
    end

    esp.boxOutline.Visible = false
    esp.boxOutline.Thickness = 4
    esp.boxOutline.Filled = false
    esp.boxOutline.Color = Color3.new(0, 0, 0)
    esp.boxOutline.ZIndex = 0

    esp.box.Visible = false
    esp.box.Thickness = 2
    esp.box.Filled = false
    esp.box.ZIndex = 1

    esp.name.Visible = false
    esp.name.Size = 14
    esp.name.Center = true
    esp.name.Outline = true
    esp.name.ZIndex = 1

    esp.distance.Visible = false
    esp.distance.Size = 12
    esp.distance.Center = true
    esp.distance.Outline = true
    esp.distance.ZIndex = 1
    
    esp.toolText.Visible = false
    esp.toolText.Size = 12
    esp.toolText.Center = true
    esp.toolText.Outline = true
    esp.toolText.ZIndex = 1

    esp.healthBarBack.Visible = false
    esp.healthBarBack.Thickness = 1
    esp.healthBarBack.Color = Color3.fromRGB(0, 0, 0)
    esp.healthBarBack.Filled = true

    esp.healthBarFront.Visible = false
    esp.healthBarFront.Thickness = 1
    esp.healthBarFront.Filled = true
    
    esp.healthText.Visible = false
    esp.healthText.Size = 10
    esp.healthText.Center = false
    esp.healthText.Outline = true
    esp.healthText.ZIndex = 1

    esp.tracer.Visible = false
    esp.tracer.Thickness = 1
    esp.tracer.ZIndex = 1

    Mega.Objects.ESP[player] = esp
end

local function RemoveESP(player)
    if Mega.Objects.ESP[player] then
        for k, drawing in pairs(Mega.Objects.ESP[player]) do
            if k == "skeleton" then
                for _, line in pairs(drawing) do line:Remove() end
            elseif k == "chams" then
                pcall(function() drawing:Destroy() end)
            else
                pcall(function() drawing:Remove() end)
            end
        end
        Mega.Objects.ESP[player] = nil
    end
end

local function UpdateESPColors()
    local lp = Services.Players.LocalPlayer
    for player, esp in pairs(Mega.Objects.ESP) do
        if player and player.Parent and player.Character then
            local isTeam = lp and player.Team and lp.Team and (player.Team == lp.Team)
            local color = States.ESP.EnemyColor or Color3.fromRGB(255, 0, 0)
            
            if States.ESP.UseTeamColor and player.Team and player.Team.TeamColor then
                color = player.Team.TeamColor.Color
            elseif isTeam then
                color = States.ESP.TeamColor or Color3.fromRGB(0, 255, 0)
            else
                color = States.ESP.EnemyColor or Color3.fromRGB(255, 0, 0)
            end

            esp.box.Color = color
            esp.name.Color = color
            esp.distance.Color = color
            esp.toolText.Color = color
            esp.tracer.Color = color
            esp.chams.FillColor = color
            esp.chams.OutlineColor = color
            for _, line in pairs(esp.skeleton) do
                line.Color = color
            end
        end
    end
end

local function setESPVisibility(esp, visible)
    esp.boxOutline.Visible = visible
    esp.box.Visible = visible
    esp.name.Visible = visible
    esp.distance.Visible = visible
    esp.toolText.Visible = visible
    esp.healthBarBack.Visible = visible
    esp.healthBarFront.Visible = visible
    esp.healthText.Visible = visible
    esp.tracer.Visible = visible
    esp.chams.Enabled = false
    for _, line in pairs(esp.skeleton) do line.Visible = false end
end

local function drawSkeleton(esp, char, camera, isVisible)
    if not isVisible then 
        for _, line in pairs(esp.skeleton) do line.Visible = false end
        return 
    end
    
    local parts = {
        Head = char:FindFirstChild("Head"),
        Torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso"),
        LeftArm = char:FindFirstChild("LeftUpperArm") or char:FindFirstChild("Left Arm"),
        RightArm = char:FindFirstChild("RightUpperArm") or char:FindFirstChild("Right Arm"),
        LeftLeg = char:FindFirstChild("LeftUpperLeg") or char:FindFirstChild("Left Leg"),
        RightLeg = char:FindFirstChild("RightUpperLeg") or char:FindFirstChild("Right Leg"),
        LeftHand = char:FindFirstChild("LeftHand") or char:FindFirstChild("Left Arm"),
        RightHand = char:FindFirstChild("RightHand") or char:FindFirstChild("Right Arm"),
        LeftFoot = char:FindFirstChild("LeftFoot") or char:FindFirstChild("Left Leg"),
        RightFoot = char:FindFirstChild("RightFoot") or char:FindFirstChild("Right Leg"),
    }
    
    local function drawLine(part1, part2, lineObj)
        if part1 and part2 then
            local pos1, vis1 = camera:WorldToViewportPoint(part1.Position)
            local pos2, vis2 = camera:WorldToViewportPoint(part2.Position)
            if vis1 or vis2 then
                lineObj.Visible = true
                lineObj.From = Vector2.new(pos1.X, pos1.Y)
                lineObj.To = Vector2.new(pos2.X, pos2.Y)
            else
                lineObj.Visible = false
            end
        else
            lineObj.Visible = false
        end
    end

    drawLine(parts.Head, parts.Torso, esp.skeleton["Head_Torso"])
    drawLine(parts.Torso, parts.LeftArm, esp.skeleton["Torso_LeftArm"])
    drawLine(parts.Torso, parts.RightArm, esp.skeleton["Torso_RightArm"])
    drawLine(parts.Torso, parts.LeftLeg, esp.skeleton["Torso_LeftLeg"])
    drawLine(parts.Torso, parts.RightLeg, esp.skeleton["Torso_RightLeg"])
    drawLine(parts.LeftArm, parts.LeftHand, esp.skeleton["LeftArm_LeftHand"])
    drawLine(parts.RightArm, parts.RightHand, esp.skeleton["RightArm_RightHand"])
    drawLine(parts.LeftLeg, parts.LeftFoot, esp.skeleton["LeftLeg_LeftFoot"])
    drawLine(parts.RightLeg, parts.RightFoot, esp.skeleton["RightLeg_RightFoot"])
end

local function UpdateESP()
    local camera = Services.Workspace.CurrentCamera
    if not camera then return end
    
    local vp = camera.ViewportSize
    local screenCenter = Vector2.new(vp.X / 2, vp.Y / 2)
    local screenBottom = Vector2.new(vp.X / 2, vp.Y)
    local screenTop = Vector2.new(vp.X / 2, 0)
    
    local lp = Services.Players.LocalPlayer
    local localChar = lp and lp.Character
    local localRoot = localChar and localChar:FindFirstChild("HumanoidRootPart")

    for player, esp in pairs(Mega.Objects.ESP) do
        if player == lp then
            RemoveESP(player)
        else
            local isVisible = false
            if player and player.Parent and player.Character and localRoot then
                local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
                local head = player.Character:FindFirstChild("Head")
                local humanoid = player.Character:FindFirstChild("Humanoid")

                if rootPart and head and humanoid and humanoid.Health > 0 then
                    local isTeammate = lp and player.Team and lp.Team and (player.Team == lp.Team)
                    if not (isTeammate and not States.ESP.ShowTeam) then
                        local screenPos, onScreen = camera:WorldToViewportPoint(rootPart.Position)
                        local distance = (localRoot.Position - rootPart.Position).Magnitude

                        local health = humanoid.Health
                        if health ~= health then health = 0 end
                        local maxHealth = humanoid.MaxHealth
                        if maxHealth <= 0 or maxHealth ~= maxHealth then maxHealth = 100 end

                        if onScreen and distance <= States.ESP.MaxDistance and distance > 0.1 then
                            isVisible = true
                            local scale = 1000 / distance
                            local width = scale * 2
                            local height = scale * 3
                            
                            local tOrigin = screenBottom
                            if States.ESP.TracerOrigin == "Top" then tOrigin = screenTop
                            elseif States.ESP.TracerOrigin == "Center" then tOrigin = screenCenter
                            elseif States.ESP.TracerOrigin == "Mouse" then 
                                local mp = Services.UserInputService:GetMouseLocation()
                                tOrigin = Vector2.new(mp.X, mp.Y)
                            end

                            if States.ESP.Boxes then
                                esp.box.Visible = States.ESP.Enabled
                                esp.box.Position = Vector2.new(screenPos.X - width / 2, screenPos.Y - height / 2)
                                esp.box.Size = Vector2.new(width, height)
                                
                                esp.boxOutline.Visible = States.ESP.Enabled and States.ESP.Outline
                                esp.boxOutline.Position = esp.box.Position
                                esp.boxOutline.Size = esp.box.Size
                            else
                                esp.box.Visible = false
                                esp.boxOutline.Visible = false
                            end

                            if States.ESP.Names then
                                esp.name.Visible = States.ESP.Enabled
                                esp.name.Position = Vector2.new(screenPos.X, screenPos.Y - height / 2 - 20)
                                esp.name.Text = player.Name
                            else
                                esp.name.Visible = false
                            end

                            local textOffset = 10
                            if States.ESP.Distance then
                                esp.distance.Visible = States.ESP.Enabled
                                esp.distance.Position = Vector2.new(screenPos.X, screenPos.Y + height / 2 + textOffset)
                                esp.distance.Text = math.floor(distance) .. " st."
                                textOffset = textOffset + 14
                            else
                                esp.distance.Visible = false
                            end
                            
                            if States.ESP.HeldItem then
                                local tool = player.Character:FindFirstChildOfClass("Tool")
                                if tool then
                                    esp.toolText.Visible = States.ESP.Enabled
                                    esp.toolText.Position = Vector2.new(screenPos.X, screenPos.Y + height / 2 + textOffset)
                                    esp.toolText.Text = tool.Name
                                    textOffset = textOffset + 14
                                else
                                    esp.toolText.Visible = false
                                end
                            else
                                esp.toolText.Visible = false
                            end

                            if States.ESP.Health then
                                local healthPercent = math.clamp(health / maxHealth, 0, 1)
                                local barHeight = height * healthPercent
                                local barColor = Color3.fromHSV(0.33 * healthPercent, 1, 1)

                                esp.healthBarBack.Visible = States.ESP.Enabled
                                esp.healthBarBack.Position = Vector2.new(screenPos.X - width / 2 - 7, screenPos.Y - height / 2)
                                esp.healthBarBack.Size = Vector2.new(4, height)

                                esp.healthBarFront.Visible = States.ESP.Enabled
                                esp.healthBarFront.Color = barColor
                                esp.healthBarFront.Position = Vector2.new(screenPos.X - width / 2 - 7, screenPos.Y - height / 2 + (height - barHeight))
                                esp.healthBarFront.Size = Vector2.new(4, barHeight)
                                
                                if States.ESP.HealthText then
                                    esp.healthText.Visible = States.ESP.Enabled
                                    esp.healthText.Position = Vector2.new(screenPos.X - width / 2 - 28, screenPos.Y - height / 2 + (height - barHeight) - 6)
                                    esp.healthText.Text = tostring(math.floor(health))
                                    esp.healthText.Color = barColor
                                else
                                    esp.healthText.Visible = false
                                end
                            else
                                esp.healthBarBack.Visible = false
                                esp.healthBarFront.Visible = false
                                esp.healthText.Visible = false
                            end

                            if States.ESP.Tracers then
                                esp.tracer.Visible = States.ESP.Enabled
                                esp.tracer.From = Vector2.new(screenPos.X, screenPos.Y + height / 2)
                                esp.tracer.To = tOrigin
                            else
                                esp.tracer.Visible = false
                            end
                            
                            if States.ESP.Chams then
                                esp.chams.Adornee = player.Character
                                esp.chams.Enabled = States.ESP.Enabled
                            else
                                esp.chams.Enabled = false
                            end
                        end
                    end
                end
            end
            
            drawSkeleton(esp, player.Character, camera, isVisible and States.ESP.Skeleton and States.ESP.Enabled)

            if not isVisible then
                setESPVisibility(esp, false)
            end
        end
    end
end

-- Initialize ESP for all players
for _, player in pairs(Services.Players:GetPlayers()) do
    CreateESP(player)
end

table.insert(playerEspConnections, Services.Players.PlayerAdded:Connect(function(player)
    CreateESP(player)
end))

table.insert(playerEspConnections, Services.Players.PlayerRemoving:Connect(function(player)
    RemoveESP(player)
end))

function Mega.Features.ESP.SetEnabled(state)
    States.ESP.Enabled = state
    if state then
        if not Mega.Objects.ESPRenderConnection then
            Mega.Objects.ESPRenderConnection = Services.RunService.RenderStepped:Connect(function()
                UpdateESP()
                UpdateESPColors()
            end)
        end
    else
        if Mega.Objects.ESPRenderConnection then
            Mega.Objects.ESPRenderConnection:Disconnect()
            Mega.Objects.ESPRenderConnection = nil
        end
        for player, esp in pairs(Mega.Objects.ESP) do
            setESPVisibility(esp, false)
        end
    end
end

function Mega.Features.ESP.Cleanup()
    Mega.Features.ESP.SetEnabled(false)
    Mega.Features.ESP.SetGorillaEnabled(false)
    for _, conn in ipairs(playerEspConnections) do
        pcall(function() conn:Disconnect() end)
    end
    for player, _ in pairs(Mega.Objects.ESP) do
        RemoveESP(player)
    end
    pcall(function() espFolder:Destroy() end)
end

return Mega.Features.ESP
