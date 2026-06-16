-- gui/tabs/player.lua
-- Content for the "PLAYER" tab (Universal & Non-PvP Movement Features)

local tabKey = "tab_player"
local UI = Mega.UI

-- Create the container frame for this tab
local TabFrame = Instance.new("ScrollingFrame")
TabFrame.Name = tabKey
TabFrame.Size = UDim2.new(1, 0, 1, 0)
TabFrame.BackgroundTransparency = 1
TabFrame.BorderSizePixel = 0
TabFrame.ScrollBarThickness = 4
TabFrame.ScrollBarImageColor3 = Mega.Settings.Menu.AccentColor
TabFrame.Visible = false
TabFrame.Parent = Mega.Objects.ContentContainer

local ContentLayout = Instance.new("UIListLayout", TabFrame)
ContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
ContentLayout.Padding = UDim.new(0, 8)

ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    TabFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 40)
end)
TabFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 40)

Mega.Objects.TabFrames[tabKey] = TabFrame

--#region -- Movement Section
UI.CreateSection(TabFrame, "section_player_movement")

-- Speedhack setup
task.spawn(function()
    pcall(function() Mega.LoadModule("features/speed.lua") end)
end)

UI.CreateToggleWithSettings(TabFrame, "toggle_speed", "Player.Speed", function(state)
    Mega.States.Player.Speed = state
    if Mega.Features.Speed and Mega.Features.Speed.SetEnabled then 
        Mega.Features.Speed.SetEnabled(state) 
    end
end, {
    UI.CreateDropdown(nil, "dropdown_speed_mode", "Player.SpeedMode", {"Velocity", "Impulse", "CFrame", "TP", "WalkSpeed", "Pulse"}, function(val)
        Mega.States.Player.SpeedMode = val
    end),
    UI.CreateDropdown(nil, "dropdown_speed_move_mode", "Player.SpeedMoveMode", {"MoveDirection", "Direct"}, function(val)
        Mega.States.Player.SpeedMoveMode = val
    end),
    UI.CreateSlider(nil, "slider_speed", "Player.SpeedValue", 1, 150, function(val)
        Mega.States.Player.SpeedValue = val
    end),
    UI.CreateSlider(nil, "slider_speed_tp_frequency", "Player.SpeedTPFrequency", 0, 100, function(val)
        Mega.States.Player.SpeedTPFrequency = val / 100
    end),
    UI.CreateSlider(nil, "slider_speed_pulse_length", "Player.SpeedPulseLength", 0, 100, function(val)
        Mega.States.Player.SpeedPulseLength = val / 100
    end),
    UI.CreateSlider(nil, "slider_speed_pulse_delay", "Player.SpeedPulseDelay", 0, 100, function(val)
        Mega.States.Player.SpeedPulseDelay = val / 100
    end),
    UI.CreateToggle(nil, "toggle_speed_wall_check", "Player.SpeedWallCheck", function(state)
        Mega.States.Player.SpeedWallCheck = state
    end),
    UI.CreateToggle(nil, "toggle_speed_autojump", "Player.SpeedAutoJump", function(state)
        Mega.States.Player.SpeedAutoJump = state
    end),
    UI.CreateToggle(nil, "toggle_speed_customjump", "Player.SpeedCustomJump", function(state)
        Mega.States.Player.SpeedCustomJump = state
    end),
    UI.CreateSlider(nil, "slider_speed_jumppower", "Player.SpeedJumpPower", 1, 100, function(val)
        Mega.States.Player.SpeedJumpPower = val
    end)
})

-- Fly setup
task.spawn(function()
    pcall(function() Mega.LoadModule("features/fly.lua") end)
end)

UI.CreateToggleWithSettings(TabFrame, "toggle_fly", "Player.Fly", function(state)
    Mega.States.Player.Fly = state
    if Mega.Features.Fly and Mega.Features.Fly.SetEnabled then
        Mega.Features.Fly.SetEnabled(state)
    end
end, {
    UI.CreateSlider(nil, "slider_fly_speed", "Player.FlySpeed", 1, 100, function(val)
        Mega.States.Player.FlySpeed = val
    end),
    UI.CreateDropdown(nil, "dropdown_fly_mode", "Player.FlyMode", {"Velocity", "CFrame"}, function(val)
        Mega.States.Player.FlyMode = val
    end)
})

-- Infinite Jump setup
UI.CreateToggle(TabFrame, "toggle_inf_jump", "Player.InfiniteJump")

if not Mega.Objects.Connections.InfiniteJump then
    Mega.Objects.Connections.InfiniteJump = Mega.Services.UserInputService.JumpRequest:Connect(function()
        if Mega.States.Player.InfiniteJump then
            local char = Mega.Services.LocalPlayer.Character
            if char and char:FindFirstChildOfClass("Humanoid") then
                char:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)
end
--#endregion

--#region -- Defense / Utility Section
UI.CreateSection(TabFrame, "section_player_defense")

-- NoClip setup
task.spawn(function()
    pcall(function() Mega.LoadModule("features/noclip.lua") end)
end)
UI.CreateToggle(TabFrame, "toggle_noclip", "Player.NoClip", function(state)
    Mega.States.Player.NoClip = state
    if Mega.Features.NoClip and Mega.Features.NoClip.SetEnabled then 
        Mega.Features.NoClip.SetEnabled(state) 
    end
end)

-- Anti-Knockback setup
task.spawn(function()
    pcall(function() Mega.LoadModule("features/antiknockback.lua") end)
end)
UI.CreateToggleWithSettings(TabFrame, "toggle_antiknockback", "Player.AntiKnockback", function(state)
    Mega.States.Player.AntiKnockback = state
    if Mega.Features.AntiKnockback and Mega.Features.AntiKnockback.SetEnabled then 
        Mega.Features.AntiKnockback.SetEnabled(state) 
    end
end, {
    UI.CreateSlider(nil, "slider_knockback_strength", "Player.KnockbackStrength", 0, 100, function(val)
        Mega.States.Player.KnockbackStrength = val
    end)
})

-- Spider setup
task.spawn(function()
    pcall(function() Mega.LoadModule("features/spider.lua") end)
end)
UI.CreateToggleWithSettings(TabFrame, "toggle_spider", "Player.Spider", function(state)
    Mega.States.Player.Spider = state
    if Mega.Features.Spider and Mega.Features.Spider.SetEnabled then 
        Mega.Features.Spider.SetEnabled(state) 
    end
end, {
    UI.CreateDropdown(nil, "dropdown_spider_mode", "Player.SpiderMode", {"Velocity", "CFrame"}, function(val)
        Mega.States.Player.SpiderMode = val
    end),
    UI.CreateSlider(nil, "slider_spider_speed", "Player.SpiderSpeed", 1, 100, function(val)
        Mega.States.Player.SpiderSpeed = val
    end)
})
--#endregion

--#region -- Fun / Misc Section
UI.CreateSection(TabFrame, "section_utils_fun")

-- Spinbot setup
task.spawn(function()
    pcall(function() Mega.LoadModule("features/spinbot.lua") end)
end)
UI.CreateToggleWithSettings(TabFrame, "toggle_spinbot", "Player.SpinBot", function(state)
    Mega.States.Player.SpinBot = state
    if Mega.Features.SpinBot and Mega.Features.SpinBot.SetEnabled then 
        Mega.Features.SpinBot.SetEnabled(state) 
    end
end, {
    UI.CreateSlider(nil, "slider_spinspeed", "Player.SpinSpeed", 1, 100, function(val)
        Mega.States.Player.SpinSpeed = val
    end)
})
--#endregion
