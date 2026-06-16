-- core/settings.lua
-- Contains all default settings, states, and database structures.

Mega.VERSION = "1.0.0"
Mega.BUILD_DATE = "2026.06.16"
Mega.DEVELOPER = "Antigravity & kreml1nAgent"

Mega.Themes = {
    Dark = {
        BackgroundColor = Color3.fromRGB(12, 12, 18),
        SidebarColor = Color3.fromRGB(15, 15, 22),
        ElementColor = Color3.fromRGB(20, 20, 30), 
        ElementHoverColor = Color3.fromRGB(35, 35, 45),
        ToggleOffColor = Color3.fromRGB(60, 60, 80),
        AccentColor = Color3.fromRGB(200, 70, 255),
        SecondaryColor = Color3.fromRGB(0, 255, 255),
        TextColor = Color3.fromRGB(255, 255, 255),
        TextMutedColor = Color3.fromRGB(150, 150, 170),
        IconColor = Color3.fromRGB(150, 150, 170),
        IconActiveColor = Color3.new(1, 1, 1),
        SectionGradient1 = Color3.fromRGB(15, 15, 25),
        SectionGradient2 = Color3.fromRGB(10, 10, 20)
    },
    Vanilla = {
        BackgroundColor = Color3.fromRGB(245, 245, 248),
        SidebarColor = Color3.fromRGB(255, 255, 255),
        ElementColor = Color3.fromRGB(230, 230, 235),
        ElementHoverColor = Color3.fromRGB(215, 215, 220),
        ToggleOffColor = Color3.fromRGB(200, 200, 205),
        AccentColor = Color3.fromRGB(80, 160, 255), -- Pastel blue
        SecondaryColor = Color3.fromRGB(255, 130, 130),
        TextColor = Color3.fromRGB(40, 40, 45),
        TextMutedColor = Color3.fromRGB(130, 130, 140),
        IconColor = Color3.fromRGB(130, 130, 140),
        IconActiveColor = Color3.fromRGB(30, 30, 35),
        SectionGradient1 = Color3.fromRGB(240, 240, 245),
        SectionGradient2 = Color3.fromRGB(230, 230, 235)
    }
}

Mega.Settings = {
    Menu = {
        Width = 950,
        Height = 550,
        CurrentTheme = "Dark",
        Transparency = 0.1,
        CornerRadius = 12,
        AnimationSpeed = 0.25
    },
    System = {
        AntiAFK = true,
        AutoSave = true,
        PerformanceMode = false,
        DebugMode = false,
        Logging = true,
        ShowStatusIndicator = true,
        ShowNotifications = true
    },
    StatusIndicator = {
        RainbowMode = true,
        Scale = 14
    }
}

Mega.States = {
    ESP = {
        Enabled = false,
        Boxes = true,
        Names = true,
        Distance = true,
        Health = true,
        HealthText = true,
        HeldItem = true,
        Outline = false,
        Skeleton = false,
        Chams = false,
        Tracers = true,
        TracerOrigin = "Bottom",
        ShowTeam = false,
        MaxDistance = 1000,
        TeamColor = Color3.fromRGB(0, 255, 0),
        EnemyColor = Color3.fromRGB(255, 0, 0),
        NeutralColor = Color3.fromRGB(255, 255, 0),
        UseTeamColor = true
    },
    Visuals = {
        NoFog = false,
        FullBright = false,
        NightMode = false,
        RemoveShadows = false,
        GorillaMode = false
    },
    Player = {
        Fly = false,
        FlyMode = "Velocity",
        FlySpeed = 24,
        Speed = false,
        SpeedValue = 23,
        SpeedMode = "Velocity",
        SpeedMoveMode = "MoveDirection",
        SpeedTPFrequency = 0.5,
        SpeedPulseLength = 0.5,
        SpeedPulseDelay = 0.5,
        SpeedWallCheck = true,
        SpeedAutoJump = false,
        SpeedCustomJump = false,
        SpeedJumpPower = 30,
        SpeedTPTiming = 0,
        InfiniteJump = false,
        NoClip = false,
        AntiKnockback = false,
        KnockbackStrength = 0,
        SpinBot = false,
        SpinSpeed = 10,
        Spider = false,
        SpiderSpeed = 30,
        SpiderMode = "Velocity",
        SpectateTarget = nil
    },
    Utility = {
        StaffDetector = {
            Enabled = false,
            Mode = "Notify",
            Group = "",
            Role = "",
            Profile = "default",
            Users = ""
        }
    },
    Misc = {},
    Keybinds = {
        Menu = "RightShift"
    },
    Temp = {
        SelectedConfig = "default",
        ThemeName = "Magenta",
        BaseTheme = "Dark",
        ShowNotifications = true
    },
    Localization = {
        CurrentLanguage = "language_english"
    }
}

function Mega.SetTheme(themeName)
    local theme = Mega.Themes[themeName] or Mega.Themes.Dark
    Mega.Settings.Menu.CurrentTheme = themeName
    for k, v in pairs(theme) do
        Mega.Settings.Menu[k] = v
    end
end

-- Initialize default theme
Mega.SetTheme(Mega.Settings.Menu.CurrentTheme)

Mega.Database = {
    Stats = {
        Kills = 0,
        Deaths = 0,
        Headshots = 0,
        PlayTime = 0
    }
}
