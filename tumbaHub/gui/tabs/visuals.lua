-- gui/tabs/visuals.lua
-- Content for the "VISUALS" tab (Universal Atmosphere Controls & Gorilla Mode)

local tabKey = "tab_visuals"
local UI = Mega.UI
local Lighting = Mega.Services.Lighting

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

-- Store original lighting values
local originalFogEnd = Lighting.FogEnd
local originalBrightness = Lighting.Brightness
local originalClockTime = Lighting.ClockTime
local originalGlobalShadows = Lighting.GlobalShadows

-- Atmosphere / Environment Visuals
UI.CreateSection(TabFrame, "toggle_nofog") -- Section name maps to standard or simple text

UI.CreateToggle(TabFrame, "toggle_nofog", "Visuals.NoFog", function(state)
    Lighting.FogEnd = state and 100000 or originalFogEnd
end)

UI.CreateToggle(TabFrame, "toggle_fullbright", "Visuals.FullBright", function(state)
    Lighting.Brightness = state and 2 or originalBrightness
end)

UI.CreateToggle(TabFrame, "toggle_nightmode", "Visuals.NightMode", function(state)
    Lighting.ClockTime = state and 22 or originalClockTime
end)

UI.CreateToggle(TabFrame, "toggle_removeshadows", "Visuals.RemoveShadows", function(state)
    Lighting.GlobalShadows = not state
end)

-- Custom Models / Gorilla Mode
UI.CreateSection(TabFrame, "toggle_gorilla_mode")

task.spawn(function()
    pcall(function() Mega.LoadModule("features/esp.lua") end) -- Gorilla Mode will be implemented inside esp.lua or chams
end)

UI.CreateToggle(TabFrame, "toggle_gorilla_mode", "Visuals.GorillaMode", function(state)
    if Mega.Features.ESP and Mega.Features.ESP.SetGorillaEnabled then
        Mega.Features.ESP.SetGorillaEnabled(state)
    end
end)
