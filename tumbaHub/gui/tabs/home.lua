-- gui/tabs/home.lua
-- Content for the "HOME" tab (Universal & Non-PvP)

local tabKey = "tab_home"
local UI = Mega.UI
local GetText = Mega.GetText

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

-- Add this frame to the global list of tab frames
Mega.Objects.TabFrames[tabKey] = TabFrame

-- Updates Section
UI.CreateSection(TabFrame, "section_updates_list")

local UpdateText = Instance.new("TextLabel")
UpdateText.Size = UDim2.new(0.9, 0, 0, 80)
UpdateText.BackgroundTransparency = 1
UpdateText.Text = GetText("update_text_v5_1")
UpdateText.TextColor3 = Mega.Settings.Menu.TextColor
UpdateText.TextSize = 13
UpdateText.Font = Enum.Font.Gotham
UpdateText.TextXAlignment = Enum.TextXAlignment.Left
UpdateText.TextYAlignment = Enum.TextYAlignment.Top
UpdateText.TextWrapped = true
UpdateText.Parent = TabFrame

-- Status Section
UI.CreateSection(TabFrame, "section_status")

if not Mega.States.System then Mega.States.System = {} end
if Mega.States.System.AutoSave == nil then Mega.States.System.AutoSave = Mega.Settings.System.AutoSave end
if Mega.States.System.PerformanceMode == nil then Mega.States.System.PerformanceMode = Mega.Settings.System.PerformanceMode end
if Mega.States.System.ShowStatusIndicator == nil then Mega.States.System.ShowStatusIndicator = Mega.Settings.System.ShowStatusIndicator end

UI.CreateToggle(TabFrame, "toggle_autosave", "System.AutoSave", function(state)
    Mega.Settings.System.AutoSave = state
end)
UI.CreateToggle(TabFrame, "toggle_perf_mode", "System.PerformanceMode", function(state)
    Mega.Settings.System.PerformanceMode = state
end)
UI.CreateToggle(TabFrame, "toggle_status_indicator", "System.ShowStatusIndicator", function(state)
    Mega.Settings.System.ShowStatusIndicator = state
    if Mega.UpdateStatus then Mega.UpdateStatus() end
end)

-- Quick Access
UI.CreateSection(TabFrame, "section_quick_access")

UI.CreateButton(TabFrame, "button_esp_toggle", function()
    if Mega.Objects.Toggles["toggle_esp"] then
        Mega.Objects.Toggles["toggle_esp"](not Mega.States.ESP.Enabled)
    end
end)
UI.CreateButton(TabFrame, "button_speed_toggle", function()
    if Mega.Objects.Toggles["toggle_speed"] then
        Mega.Objects.Toggles["toggle_speed"](not Mega.States.Player.Speed)
    end
end)

-- Stats
UI.CreateSection(TabFrame, "section_stats")

local StatsLabel = Instance.new("TextLabel")
StatsLabel.Size = UDim2.new(0.9, 0, 0, 100)
StatsLabel.BackgroundTransparency = 1
StatsLabel.TextColor3 = Mega.Settings.Menu.TextColor
StatsLabel.TextSize = 14
StatsLabel.Font = Enum.Font.Gotham
StatsLabel.TextXAlignment = Enum.TextXAlignment.Left
StatsLabel.TextYAlignment = Enum.TextYAlignment.Top
StatsLabel.Parent = TabFrame

local lastStatsUpdate = 0
Mega.Objects.Connections.HomeStatsUpdate = Mega.Services.RunService.Stepped:Connect(function()
    if TabFrame.Visible then
        local now = tick()
        if now - lastStatsUpdate >= 1 then
            lastStatsUpdate = now
            if Mega.Database and Mega.Database.Stats then
                StatsLabel.Text = GetText("stats_label", 
                    Mega.Database.Stats.Kills or 0, 
                    Mega.Database.Stats.Deaths or 0, 
                    math.floor((Mega.Database.Stats.PlayTime or 0) / 60)
                )
            end
        end
    end
end)
