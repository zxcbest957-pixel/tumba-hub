-- gui/tabs/utils.lua
-- Content for the "UTILITIES" tab (Universal Utilities only)

local tabKey = "tab_utils"
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

Mega.Objects.TabFrames[tabKey] = TabFrame

-- General Tools Section
UI.CreateSection(TabFrame, "tab_utils")

UI.CreateButton(TabFrame, "button_clear_chat", function()
    local events = Mega.Services.ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
    local sayMessage = events and events:FindFirstChild("SayMessageRequest")
    if sayMessage then
        for i = 1, 50 do
            sayMessage:FireServer(string.rep(" ", i), "All")
        end
    else
        -- Roblox TextChatService fallback
        local textChatService = Mega.Services.TextChatService
        local textChannels = textChatService:FindFirstChild("TextChannels")
        local rbxGeneral = textChannels and textChannels:FindFirstChild("RBXGeneral")
        if rbxGeneral then
            for i = 1, 50 do
                rbxGeneral:SendAsync(string.rep(" ", i))
            end
        end
    end
    if Mega.ShowNotification then
        Mega.ShowNotification(Mega.GetText("notify_chat_cleared"), 2)
    end
end)

UI.CreateButton(TabFrame, "button_reload_script", function()
    if Mega.ShowNotification then
        Mega.ShowNotification(Mega.GetText("notify_reload"), 2)
    end
    if Mega.ReloadGUI then
        Mega.ReloadGUI()
    else
        if Mega.Objects.GUI then Mega.Objects.GUI:Destroy() end
        Mega.LoadModule("gui/main_window.lua")
    end
end)

-- Staff Detector Section
UI.CreateSection(TabFrame, "toggle_staff_detector")

task.spawn(function()
    pcall(function() Mega.LoadModule("features/staff_detector.lua") end)
end)

UI.CreateToggleWithSettings(TabFrame, "toggle_staff_detector", "Utility.StaffDetector.Enabled", function(state)
    Mega.States.Utility.StaffDetector.Enabled = state
    if Mega.Features.StaffDetector and Mega.Features.StaffDetector.SetEnabled then 
        Mega.Features.StaffDetector.SetEnabled(state) 
    end
end, {
    UI.CreateDropdown(nil, "dropdown_staff_detector_mode", "Utility.StaffDetector.Mode", {"Notify", "Uninject", "ServerHop"}, function(val) 
        Mega.States.Utility.StaffDetector.Mode = val 
    end, false),
    Mega.UI.CreateTextBox(nil, "textbox_staff_detector_group", "Utility.StaffDetector.Group"),
    Mega.UI.CreateTextBox(nil, "textbox_staff_detector_role", "Utility.StaffDetector.Role"),
    Mega.UI.CreateTextBox(nil, "textbox_staff_detector_profile", "Utility.StaffDetector.Profile"),
    Mega.UI.CreateTextBox(nil, "textbox_staff_detector_users", "Utility.StaffDetector.Users")
})

ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    TabFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 40)
end)
TabFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 40)
