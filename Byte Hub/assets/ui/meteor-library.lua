--[[
    Meteor UI Library
    A Roblox recreation of Meteor Client's ClickGUI (themes/meteor).

    Matches the real theme where it counts:
      accent         145, 61, 226
      background      20, 20, 20  (200 alpha)
      module fill     50, 50, 50
      slider left    100, 35, 170
      slider handle  130,  0, 255
      text           255, 255, 255
      secondary text 150, 150, 150

    Windows are draggable category panels with a purple header, modules are
    centred rows that fill in when hovered/enabled and grow a 2px accent bar,
    and right clicking a module opens its settings screen.

    Search is its own draggable window: typing lists matching modules inside it
    (left click toggles, right click opens settings) while the category windows
    stay visible.

    The top of the screen carries Meteor's tab bar (Modules, Config, GUI, HUD,
    Friends, Macros). Only the Modules tab shows the category windows and the
    search window; every other tab opens Meteor's settings screen for that
    system, and each of those rows is live: toggles toggle, sliders drag,
    dropdowns cycle, colour rows open a colour picker, and buttons act on the
    GUI/HUD/lists. Settings are saved next to the window layout. On touch
    devices a floating button opens and closes the GUI without a keyboard.

    API
      GuiLibrary:CreateWindow(name)              -> window
      window:CreateModule{ Name, Description, Function, Array, Default }
      window:CreateButton{ Name, Description, Function }  -- also returns a
                                                 -- settings host (button.Button
                                                 -- is the visible TextButton)
      window:CreateLabel{ Text }
      window:CreateSeparator{ Name }
      module:CreateToggle{ Name, Default, Function }
      module:CreateSlider{ Name, Min, Max, Default, Decimals, Step, Function }
      module:CreatePicker{ Name, Options, Default, Function }
      module:CreateTextBox{ Name, Default, Placeholder, MaxLength, Function }
      module:CreateButton{ Name, Function }
      module:CreateSeparator{ Name }
      module:CreateSettings()                    -- opens the module screen
      module:SetEnabled(bool), module:Toggle(), module:SetKeybind(key)

    Window buttons accept the same Create* settings as modules (Toggle,
    Slider, Picker, TextBox, Button, Label, Separator); right click or a long
    touch press opens them. Text boxes are drawn like Meteor's StringSetting:
    one full width field per row, the setting name as the placeholder, and a
    right click empties it.
      GuiLibrary:Toggle() / GuiLibrary:SetVisible(bool)
      GuiLibrary:ResetLayout() / GuiLibrary:ArrangeWindows()
      GuiLibrary:SetScale(number)                 -- GUI scale, 0.5 - 2
      GuiLibrary:SetFont(font)                    -- recolours every existing text
      GuiLibrary:SetPaletteColor(key, color)      -- live theme edit
      GuiLibrary:SetArraylistVisible(bool)
      GuiLibrary.Settings                         -- saved settings table

    The tabs at the top open Meteor's other screens: Config (ConfigScreen),
    GUI (GuiScreen), HUD (HudScreen), Friends (FriendsScreen) and Macros
    (MacrosScreen), each as a draggable window of working setting rows.
    Meteor settings that only make sense in Minecraft (title screen, accounts,
    proxies, chat prefix/feedback, Starscript colours, rotation/team colour,
    HUD editor snapping) are left out; everything else is wired up here.
]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TextService = game:GetService("TextService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local lplr = Players.LocalPlayer

--==============================================================
-- Palette (Meteor defaults, see MeteorGuiTheme.java)
--==============================================================

local GuiLibrary = {}
GuiLibrary.Windows = {}
GuiLibrary.WindowOrder = {}
GuiLibrary.Modules = {}
GuiLibrary.Connections = {}
GuiLibrary.CapturingKeybind = false
GuiLibrary.ActiveTab = "Modules"
GuiLibrary.ArraylistVisible = false
GuiLibrary.Info = {
    Name = "Meteor",
    Version = "2.00",
    Build = "Release",
}

local Palette = {
    Font = Enum.Font.Jura,
    TextSize = 16,

    Accent = Color3.fromRGB(145, 61, 226),
    Background = Color3.fromRGB(20, 20, 20),
    BackgroundHovered = Color3.fromRGB(30, 30, 30),
    BackgroundPressed = Color3.fromRGB(40, 40, 40),
    ModuleBackground = Color3.fromRGB(50, 50, 50),
    Outline = Color3.fromRGB(0, 0, 0),
    Separator = Color3.fromRGB(70, 70, 70),

    Text = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(150, 150, 150),

    Checkbox = Color3.fromRGB(145, 61, 226),
    SliderLeft = Color3.fromRGB(100, 35, 170),
    SliderRight = Color3.fromRGB(50, 50, 50),
    SliderHandle = Color3.fromRGB(130, 0, 255),

    Plus = Color3.fromRGB(50, 255, 50),
    Minus = Color3.fromRGB(255, 50, 50),
    Favorite = Color3.fromRGB(250, 215, 0),
    Friend = Color3.fromRGB(0, 255, 180),
}

-- backwards compatible aliases used by older scripts
Palette.Color = Palette.Accent
Palette.Color2 = Palette.SliderLeft
GuiLibrary.Palette = Palette

--==============================================================
-- Theme colours
--==============================================================

-- The palette entries the GUI tab can edit. Entries that share an RGB with an
-- earlier key (checkbox and slider-right follow accent and module background)
-- are left out, so one row always owns exactly one colour.
local ThemeKeys = {
    "Accent",
    "Background",
    "BackgroundHovered",
    "BackgroundPressed",
    "ModuleBackground",
    "Outline",
    "Separator",
    "Text",
    "TextSecondary",
    "SliderLeft",
    "SliderHandle",
    "Plus",
    "Minus",
    "Favorite",
    "Friend",
}

local PaletteDefaults = {}
local ThemeKeyByColor = {}
local ThemeRegistry = {}
local GuiScale

for _, key in ipairs(ThemeKeys) do
    PaletteDefaults[key] = Palette[key]
end

local function rebuildThemeLookup()
    ThemeKeyByColor = {}
    for _, key in ipairs(ThemeKeys) do
        local color = Palette[key]
        if not ThemeKeyByColor[color] then
            ThemeKeyByColor[color] = key
        end
    end
end

rebuildThemeLookup()

-- Elements remember which palette colour they were built with, so editing a
-- colour in the GUI tab can recolour the interface without rebuilding it.
local function registerThemeColor(instance, property, value)
    local key = ThemeKeyByColor[value]
    if not key then return end

    local records = ThemeRegistry[key]
    if not records then
        records = {}
        ThemeRegistry[key] = records
    end

    table.insert(records, { Instance = instance, Property = property })
end

local WINDOW_MIN_WIDTH = 108
local WINDOW_MAX_WIDTH = 220
local HEADER_HEIGHT = 24
local ROW_HEIGHT = 22
local BODY_TRANSPARENCY = 0.22

--==============================================================
-- Small helpers
--==============================================================

local function new(className, properties, parent)
    local instance = Instance.new(className)
    for key, value in pairs(properties or {}) do
        instance[key] = value
    end
    if parent then
        instance.Parent = parent
    end

    for key, value in pairs(properties or {}) do
        if typeof(value) == "Color3" then
            registerThemeColor(instance, key, value)
        end
    end

    return instance
end

local function connect(signal, callback)
    local connection = signal:Connect(callback)
    table.insert(GuiLibrary.Connections, connection)
    return connection
end

local function tweenTo(instance, properties, time)
    local tween = TweenService:Create(
        instance,
        TweenInfo.new(time or 0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        properties
    )
    tween:Play()
    return tween
end

local function textWidth(text, size, font)
    return TextService:GetTextSize(
        tostring(text),
        size or Palette.TextSize,
        font or Palette.Font,
        Vector2.new(1000, 1000)
    ).X
end

local function viewportSize()
    local camera = Workspace.CurrentCamera
    return camera and camera.ViewportSize or Vector2.new(1280, 720)
end

local function uiScale()
    return GuiScale and GuiScale.Scale or 1
end

-- Size of the layout in the units UDim2 offsets are measured in. The GUI is
-- scaled by a UIScale, so at scale 2 one layout unit covers two screen pixels.
local function layoutSize()
    local viewport = viewportSize()
    local scale = uiScale()
    return Vector2.new(viewport.X / scale, viewport.Y / scale)
end

-- Drags `frame` by grabbing `handle`. Movement is accumulated from InputObject.Delta
-- so it never mixes coordinate spaces (GUI inset / scale) and works for Frames as
-- well as buttons, as long as the handle receives input. The position is kept in the
-- same space as UDim2 offset (never AbsolutePosition, which is shifted by the GUI
-- inset and made the window jump on the first frame of a drag).
local function makeDraggable(handle, frame, onEnd)
    local dragging = false
    local position

    -- Top-left of the frame in ScreenGui offset space, independent of its anchor.
    local function offsetPosition()
        local viewport = layoutSize()
        local size = frame.AbsoluteSize / uiScale()
        return Vector2.new(
            frame.Position.X.Scale * viewport.X + frame.Position.X.Offset - size.X * frame.AnchorPoint.X,
            frame.Position.Y.Scale * viewport.Y + frame.Position.Y.Offset - size.Y * frame.AnchorPoint.Y
        )
    end

    local function start()
        if dragging then return end

        position = offsetPosition()
        frame.AnchorPoint = Vector2.zero
        frame.Position = UDim2.fromOffset(position.X, position.Y)
        dragging = true
    end

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            start()
        end
    end)

    if handle:IsA("GuiButton") then
        handle.MouseButton1Down:Connect(start)
    end

    connect(UserInputService.InputChanged, function(input)
        if not dragging then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement
            and input.UserInputType ~= Enum.UserInputType.Touch then return end

        local scale = uiScale()
        local delta = input.Delta / scale
        local nextPosition = Vector2.new(position.X + delta.X, position.Y + delta.Y)

        local viewport = layoutSize()
        local size = frame.AbsoluteSize / scale
        nextPosition = Vector2.new(
            math.clamp(nextPosition.X, 0, math.max(viewport.X - size.X, 0)),
            math.clamp(nextPosition.Y, 0, math.max(viewport.Y - size.Y, 0))
        )

        position = nextPosition
        frame.Position = UDim2.fromOffset(math.round(nextPosition.X), math.round(nextPosition.Y))
    end)

    connect(UserInputService.InputEnded, function(input)
        if not dragging then return end
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
            and input.UserInputType ~= Enum.UserInputType.Touch then return end

        dragging = false
        if onEnd then onEnd(position) end
    end)
end

local function inputName(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then return "Mouse1" end
    if input.UserInputType == Enum.UserInputType.MouseButton2 then return "Mouse2" end
    if input.UserInputType == Enum.UserInputType.MouseButton3 then return "Mouse3" end

    if input.UserInputType == Enum.UserInputType.Keyboard
        or input.UserInputType == Enum.UserInputType.Gamepad1 then
        local keyCode = input.KeyCode
        if keyCode == Enum.KeyCode.Unknown then return nil end
        if keyCode == Enum.KeyCode.Backspace then return "None" end
        return tostring(keyCode):gsub("Enum.KeyCode.", "")
    end

    return nil
end

local function createCheckmark(parent)
    local holder = new("Frame", {
        Size = UDim2.fromOffset(12, 12),
        BackgroundTransparency = 1,
    }, parent)

    new("Frame", {
        Size = UDim2.fromOffset(2, 5),
        BackgroundColor3 = Palette.Text,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.36, 0.6),
        Rotation = -45,
    }, holder)

    new("Frame", {
        Size = UDim2.fromOffset(2, 8),
        BackgroundColor3 = Palette.Text,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.63, 0.47),
        Rotation = 45,
    }, holder)

    return holder
end

--==============================================================
-- Config
--==============================================================

local ConfigDirectory = "Meteor/Configs"
local ConfigPath = ConfigDirectory .. "/config.json"
local LegacyConfigPath = "Blaze/Configs/config.json"
local AutoLoadPath = ConfigDirectory .. "/autoload.txt"
local ActiveConfigName = "config"
local Config = { windows = {}, modules = {}, settings = {}, friends = {}, macros = {} }

local function ensureConfigDirectory()
    if not isfolder or not makefolder then
        return true
    end

    if not isfolder("Meteor") then makefolder("Meteor") end
    if not isfolder(ConfigDirectory) then makefolder(ConfigDirectory) end
    return true
end

local function cleanConfigName(name)
    name = tostring(name or ""):gsub("^%s+", ""):gsub("%s+$", "")
    name = name:gsub("%.json$", "")
    if name == "" or name == "." or name == ".." then return nil end
    if name:find("[/\\\\]") or name:find("[%c]") then return nil end
    return name
end

local function configFile(name)
    local safeName = cleanConfigName(name)
    if not safeName then return nil end
    return ConfigDirectory .. "/" .. safeName .. ".json"
end

local function encodeConfig(data)
    return HttpService:JSONEncode(data)
end

local function decodeConfig(path)
    if not readfile or not isfile or not isfile(path) then
        return nil, "Config file not found."
    end

    local ok, decoded = pcall(function()
        return HttpService:JSONDecode(readfile(path))
    end)
    if not ok or type(decoded) ~= "table" then
        return nil, "Invalid config file."
    end
    return decoded
end

local function writeConfigFile(path, data)
    if RunService:IsStudio() or not writefile then
        return false, "File writing is unavailable."
    end

    local ok, err = pcall(function()
        ensureConfigDirectory()
        writefile(path, encodeConfig(data))
    end)
    if ok then return true end
    return false, tostring(err)
end

local function save()
    local path = configFile(ActiveConfigName) or ConfigPath
    local ok = writeConfigFile(path, Config)
    return ok
end

local function normalizeConfig(raw)
    if type(raw) ~= "table" then return nil end

    local loaded = {
        windows = type(raw.windows) == "table" and raw.windows or {},
        modules = type(raw.modules) == "table" and raw.modules or {},
        settings = type(raw.settings) == "table" and raw.settings or {},
        friends = type(raw.friends) == "table" and raw.friends or {},
        macros = type(raw.macros) == "table" and raw.macros or {},
    }

    -- Migrate the old flat format: Config[moduleName] = { Name = windowName, ... }
    for moduleName, data in pairs(raw) do
        if type(data) == "table" and type(data.Name) == "string" and data.Name ~= "" then
            if data.Name ~= "windows" and data.Name ~= "modules" then
                local key = data.Name .. "/" .. moduleName
                if not loaded.modules[key] then
                    local settings = {}
                    for settingName, value in pairs(data.Toggles or {}) do
                        if type(value) == "table" then settings[settingName] = value.Enabled end
                    end
                    for settingName, value in pairs(data.Pickers or {}) do
                        if type(value) == "table" then settings[settingName] = value.Option end
                    end
                    for settingName, value in pairs(data.Sliders or {}) do
                        if type(value) == "table" then settings[settingName] = value.Value end
                    end
                    loaded.modules[key] = {
                        Enabled = data.Enabled,
                        Keybind = data.Keybind,
                        Settings = settings,
                    }
                end
            end
        end
    end
    return loaded
end

local function loadConfig()
    if RunService:IsStudio() or not readfile or not isfile then return end

    -- Autoload takes priority; otherwise retain compatibility with the original
    -- config.json and the older Blaze location.
    if isfile(AutoLoadPath) then
        local ok, name = pcall(readfile, AutoLoadPath)
        if ok then
            name = cleanConfigName(name)
            local path = name and configFile(name)
            if path and isfile(path) then
                local raw = decodeConfig(path)
                local normalized = raw and normalizeConfig(raw)
                if normalized then
                    Config = normalized
                    ActiveConfigName = name
                    return
                end
            end
        end
    end

    local path
    if isfile(ConfigPath) then
        path = ConfigPath
        ActiveConfigName = "config"
    elseif isfile(LegacyConfigPath) then
        path = LegacyConfigPath
    end
    if not path then return end

    local raw = decodeConfig(path)
    local normalized = raw and normalizeConfig(raw)
    if normalized then Config = normalized end
end

local function windowConfig(name)
    Config.windows[name] = Config.windows[name] or {}
    return Config.windows[name]
end

local function moduleConfig(windowName, moduleName)
    local key = windowName .. "/" .. moduleName
    Config.modules[key] = Config.modules[key] or {}
    local config = Config.modules[key]
    config.Settings = config.Settings or {}
    return config
end

loadConfig()

--==============================================================
-- Settings (saved with the layout in the same config file)
--==============================================================

local Settings = Config.settings
GuiLibrary.Settings = Settings

local FontOptions = {
    { Name = "Jura", Font = Enum.Font.Jura },
    { Name = "Code", Font = Enum.Font.Code },
    { Name = "Gotham", Font = Enum.Font.Gotham },
}

local FontNames = {}
local FontMap = {}
for _, option in ipairs(FontOptions) do
    table.insert(FontNames, option.Name)
    FontMap[option.Name] = option.Font
end

local DefaultSettings = {
    customFont = true,
    font = "Jura",
    tooltips = true,
    scale = 1,
    moduleAlignment = "Center",
    hideHud = false,
    hudTextScale = 1,
    hudBorder = 4,
}

for key, value in pairs(DefaultSettings) do
    if Settings[key] == nil then Settings[key] = value end
end

-- Restore the colours and font chosen in the GUI and Config tabs before any of
-- the interface is built, so every element is created with them.
for key, rgb in pairs(Settings.colors or {}) do
    if PaletteDefaults[key] and type(rgb) == "table" and rgb[1] and rgb[2] and rgb[3] then
        Palette[key] = Color3.fromRGB(rgb[1], rgb[2], rgb[3])
    end
end

Palette.Checkbox = Palette.Accent
Palette.Color = Palette.Accent
Palette.Color2 = Palette.SliderLeft
rebuildThemeLookup()

Palette.Font = FontMap[Settings.font] or Enum.Font.Jura
if Settings.customFont == false then
    Palette.Font = Enum.Font.SourceSans
end

--==============================================================
-- Root GUI
--==============================================================

local ScreenGui = new("ScreenGui", {
    Name = "Meteor",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    DisplayOrder = 100,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, lplr:WaitForChild("PlayerGui"))
GuiLibrary.ScreenGui = ScreenGui

-- Everything is parented to one frame carrying a UIScale, so the GUI tab's
-- scale setting can grow or shrink the whole interface and keep it centred.
local GuiRoot = new("Frame", {
    Name = "Root",
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
}, ScreenGui)
GuiScale = new("UIScale", { Scale = 1 }, GuiRoot)
GuiLibrary.Root = GuiRoot

-- The HUD (the arraylist) has its own ScreenGui so it can stay on screen while
-- the ClickGUI itself is closed.
local HudGui = new("ScreenGui", {
    Name = "MeteorHud",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    DisplayOrder = 100,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, lplr:WaitForChild("PlayerGui"))
GuiLibrary.HudGui = HudGui

-- Tooltip ------------------------------------------------------

local Tooltip = new("Frame", {
    Size = UDim2.fromOffset(0, 0),
    AutomaticSize = Enum.AutomaticSize.XY,
    BackgroundColor3 = Palette.BackgroundHovered,
    BackgroundTransparency = 0.05,
    BorderSizePixel = 0,
    Visible = false,
    ZIndex = 120,
}, GuiRoot)
new("UIStroke", { Color = Palette.Outline, Thickness = 1, Transparency = 0.3 }, Tooltip)
new("UIPadding", {
    PaddingTop = UDim.new(0, 4),
    PaddingBottom = UDim.new(0, 4),
    PaddingLeft = UDim.new(0, 6),
    PaddingRight = UDim.new(0, 6),
}, Tooltip)

local TooltipLabel = new("TextLabel", {
    Size = UDim2.fromOffset(0, 0),
    AutomaticSize = Enum.AutomaticSize.XY,
    BackgroundTransparency = 1,
    Font = Palette.Font,
    TextSize = 13,
    TextColor3 = Palette.TextSecondary,
    Text = "",
    RichText = true,
    ZIndex = 121,
}, Tooltip)

local function bindTooltip(guiObject, text)
    if not text or text == "" then return end

    guiObject.MouseEnter:Connect(function()
        if Settings.tooltips == false then return end
        TooltipLabel.Text = text
        Tooltip.Visible = true
    end)
    guiObject.MouseLeave:Connect(function()
        Tooltip.Visible = false
    end)
end

connect(RunService.RenderStepped, function()
    if not Tooltip.Visible then return end
    local scale = uiScale()
    local mouse = UserInputService:GetMouseLocation() / scale
    local viewport = layoutSize()
    local size = Tooltip.AbsoluteSize / scale
    Tooltip.Position = UDim2.fromOffset(
        math.clamp(mouse.X + 14, 0, math.max(viewport.X - size.X - 4, 0)),
        math.clamp(mouse.Y + 14, 0, math.max(viewport.Y - size.Y - 4, 0))
    )
end)

-- Search -------------------------------------------------------
-- In Meteor the search field is a window of its own: typing into it lists the
-- matching modules inside that window instead of hiding the category windows.

local SavedSearch = windowConfig("Search")
local searchPosition, searchAnchor
if type(SavedSearch.Position) == "table" and SavedSearch.Position.X and SavedSearch.Position.Y then
    local viewport = layoutSize()
    searchPosition = UDim2.fromOffset(
        math.clamp(SavedSearch.Position.X, 0, math.max(viewport.X - WINDOW_MIN_WIDTH, 0)),
        math.clamp(SavedSearch.Position.Y, 0, math.max(viewport.Y - HEADER_HEIGHT * 2, 0))
    )
    searchAnchor = Vector2.zero
else
    searchPosition = UDim2.new(0.5, 0, 0, 40)
    searchAnchor = Vector2.new(0.5, 0)
end

local SearchWindow = new("Frame", {
    Name = "Search",
    Size = UDim2.fromOffset(WINDOW_MIN_WIDTH, HEADER_HEIGHT),
    Position = searchPosition,
    AnchorPoint = searchAnchor,
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ZIndex = 6,
}, GuiRoot)
new("UIStroke", { Color = Palette.Outline, Thickness = 1, Transparency = 0.25 }, SearchWindow)

local SearchHeader = new("TextButton", {
    Size = UDim2.new(1, 0, 0, HEADER_HEIGHT),
    BackgroundColor3 = Palette.Accent,
    BorderSizePixel = 0,
    AutoButtonColor = false,
    Text = "",
    ZIndex = 7,
}, SearchWindow)

new("TextLabel", {
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    Font = Palette.Font,
    TextSize = Palette.TextSize,
    TextColor3 = Palette.Text,
    Text = "Search",
    ZIndex = 8,
}, SearchHeader)

local SearchBody = new("Frame", {
    Position = UDim2.fromOffset(0, HEADER_HEIGHT),
    Size = UDim2.new(1, 0, 0, 0),
    AutomaticSize = Enum.AutomaticSize.Y,
    BackgroundColor3 = Palette.Background,
    BackgroundTransparency = BODY_TRANSPARENCY,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    ZIndex = 6,
}, SearchWindow)

new("UIListLayout", {
    SortOrder = Enum.SortOrder.LayoutOrder,
}, SearchBody)

local SearchBoxRow = new("Frame", {
    Size = UDim2.new(1, 0, 0, 24),
    BackgroundTransparency = 1,
    LayoutOrder = 0,
    ZIndex = 7,
}, SearchBody)

local SearchBox = new("TextBox", {
    Size = UDim2.new(1, -16, 1, 0),
    Position = UDim2.fromOffset(8, 0),
    BackgroundTransparency = 1,
    Font = Palette.Font,
    TextSize = 14,
    TextColor3 = Palette.Text,
    PlaceholderText = "Search modules...",
    PlaceholderColor3 = Palette.TextSecondary,
    Text = "",
    ClearTextOnFocus = false,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 8,
}, SearchBoxRow)

local SearchResults = new("Frame", {
    Size = UDim2.new(1, 0, 0, 0),
    AutomaticSize = Enum.AutomaticSize.Y,
    BackgroundTransparency = 1,
    LayoutOrder = 1,
    ZIndex = 7,
}, SearchBody)

new("UIListLayout", {
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 1),
}, SearchResults)

local SearchRows = {}

GuiLibrary.SearchWindow = SearchWindow

local function updateSearchWindow()
    -- Same width rules as a normal window: size to the widest result, clamped.
    local width = WINDOW_MIN_WIDTH
    for moduleTab in pairs(SearchRows) do
        width = math.max(width,
            math.clamp(textWidth(moduleTab.Name, Palette.TextSize) + 28, WINDOW_MIN_WIDTH, WINDOW_MAX_WIDTH))
    end

    SearchWindow.Size = UDim2.fromOffset(width, HEADER_HEIGHT + SearchBody.AbsoluteSize.Y)
end

local function clearSearchResults()
    for _, record in pairs(SearchRows) do
        record.Row:Destroy()
    end
    SearchRows = {}
end

local function refreshSearchRow(moduleTab)
    local record = SearchRows[moduleTab]
    if not record then return end

    record.Fill.BackgroundTransparency = moduleTab.Enabled and 0 or 1
    record.Label.TextColor3 = moduleTab.Enabled and Palette.Accent or Palette.Text
end

local function createSearchRow(moduleTab, order)
    local Row = new("TextButton", {
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Text = "",
        LayoutOrder = order,
        ZIndex = 7,
    }, SearchResults)

    local Fill = new("Frame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Palette.ModuleBackground,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 7,
    }, Row)

    local Label = new("TextLabel", {
        Size = UDim2.new(1, -12, 1, 0),
        Position = UDim2.fromOffset(8, 0),
        BackgroundTransparency = 1,
        Font = Palette.Font,
        TextSize = 14,
        TextColor3 = Palette.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        Text = moduleTab.Name,
        TextTruncate = Enum.TextTruncate.AtEnd,
        ZIndex = 8,
    }, Row)

    local record = { Row = Row, Fill = Fill, Label = Label, Module = moduleTab }
    SearchRows[moduleTab] = record

    Row.MouseButton1Click:Connect(function()
        moduleTab:Toggle()
    end)
    Row.MouseButton2Click:Connect(function()
        moduleTab:CreateSettings()
    end)
    Row.MouseEnter:Connect(function()
        if not moduleTab.Enabled then
            Fill.BackgroundTransparency = 0.5
        end
    end)
    Row.MouseLeave:Connect(function()
        refreshSearchRow(moduleTab)
    end)

    if moduleTab.Description then
        bindTooltip(Row, moduleTab.Description)
    end

    refreshSearchRow(moduleTab)
    return record
end

local function refreshSearchList(query)
    clearSearchResults()

    query = string.lower(tostring(query or ""))
    if query ~= "" then
        local order = 0
        for _, window in ipairs(GuiLibrary.WindowOrder) do
            for _, entry in ipairs(window.Modules) do
                local moduleTab = entry.Module
                if moduleTab and not moduleTab.SkipSearch
                    and string.find(string.lower(moduleTab.Name), query, 1, true) then
                    order += 1
                    createSearchRow(moduleTab, order)
                end
            end
        end
    end

    updateSearchWindow()
end

local function applySearch(query)
    refreshSearchList(query)
end

connect(SearchBox:GetPropertyChangedSignal("Text"), function()
    applySearch(SearchBox.Text)
end)

connect(SearchBody:GetPropertyChangedSignal("AbsoluteSize"), updateSearchWindow)

makeDraggable(SearchHeader, SearchWindow, function(finalPosition)
    SavedSearch.Position = {
        X = math.round(finalPosition.X),
        Y = math.round(finalPosition.Y),
    }
    save()
end)

-- Array list (HUD) ---------------------------------------------

local ArrayFrame = new("Frame", {
    Size = UDim2.fromOffset(0, 0),
    AutomaticSize = Enum.AutomaticSize.X,
    Position = UDim2.new(1, -8, 0, 40),
    AnchorPoint = Vector2.new(1, 0),
    BackgroundTransparency = 1,
    Visible = false,
    ZIndex = 1,
}, HudGui)

local ArrayLayout = new("UIListLayout", {
    SortOrder = Enum.SortOrder.LayoutOrder,
    HorizontalAlignment = Enum.HorizontalAlignment.Right,
    VerticalAlignment = Enum.VerticalAlignment.Top,
}, ArrayFrame)

local ArrayItems = {}

local function updateArrayOrder()
    table.sort(ArrayItems, function(a, b)
        return string.lower(a.Name) < string.lower(b.Name)
    end)

    for index, item in ipairs(ArrayItems) do
        item.LayoutOrder = index
    end
end

local function createArray(moduleName, extraFunc)
    for _, item in ipairs(ArrayItems) do
        if item.Name == moduleName then return end
    end

    local extra = extraFunc and extraFunc() or nil
    local text = moduleName
    if extra and extra ~= "" then
        text = moduleName .. " " .. tostring(extra)
    end

    local label = new("TextLabel", {
        Name = moduleName,
        Size = UDim2.fromOffset(0, 18),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundTransparency = 1,
        Font = Palette.Font,
        TextSize = math.round(16 * (tonumber(Settings.hudTextScale) or 1)),
        TextColor3 = Palette.Accent,
        TextStrokeColor3 = Palette.Outline,
        TextStrokeTransparency = 1 - math.clamp((tonumber(Settings.hudBorder) or 4) / 10, 0, 1),
        TextXAlignment = Enum.TextXAlignment.Right,
        Text = text,
    }, ArrayFrame)

    table.insert(ArrayItems, label)
    updateArrayOrder()
end

local function removeArray(moduleName)
    for index = #ArrayItems, 1, -1 do
        local item = ArrayItems[index]
        if item.Name == moduleName then
            item:Destroy()
            table.remove(ArrayItems, index)
        end
    end
    updateArrayOrder()
end

-- Re-applies the HUD tab's text-scale/border settings to every arraylist entry.
function GuiLibrary:ApplyArraylistSettings()
    local textScale = tonumber(Settings.hudTextScale) or 1
    local border = tonumber(Settings.hudBorder) or 4

    for _, item in ipairs(ArrayItems) do
        item.TextSize = math.round(16 * textScale)
        item.TextStrokeTransparency = 1 - math.clamp(border / 10, 0, 1)
    end
end

function GuiLibrary:UpdateArraylistVisibility()
    local visible = self.ArraylistVisible == true
    if Settings.hideHud and self.Visible then
        visible = false
    end
    ArrayFrame.Visible = visible
end

function GuiLibrary:SetArraylistVisible(state)
    self.ArraylistVisible = state and true or false
    self:UpdateArraylistVisibility()
end

-- HUD tab: "Clear" empties the list, "Reset to default elements" rebuilds it
-- from the modules that are currently enabled.
function GuiLibrary:ClearArraylist()
    for _, item in ipairs(ArrayItems) do
        item:Destroy()
    end
    ArrayItems = {}
end

function GuiLibrary:ResetArraylistElements()
    self:ClearArraylist()

    for _, window in ipairs(self.WindowOrder) do
        for _, entry in ipairs(window.Modules) do
            local moduleTab = entry.Module
            if moduleTab and moduleTab.Enabled and moduleTab.Array then
                createArray(moduleTab.Name, moduleTab.ExtraText)
            end
        end
    end
end


--==============================================================
-- Mobile toggle
--==============================================================

local updateMobileIcon

-- Touch devices have no RightShift, so give them a button of their own in a
-- second ScreenGui (the main one is disabled while the GUI is closed).
if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
    local MobileGui = new("ScreenGui", {
        Name = "MeteorMobile",
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        DisplayOrder = 101,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    }, lplr:WaitForChild("PlayerGui"))
    GuiLibrary.MobileGui = MobileGui

    local MobileButton = new("TextButton", {
        Name = "MeteorToggle",
        Size = UDim2.fromOffset(46, 46),
        Position = UDim2.new(1, -12, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundColor3 = Palette.Accent,
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Text = "",
        ZIndex = 1,
    }, MobileGui)
    new("UICorner", { CornerRadius = UDim.new(0, 6) }, MobileButton)
    new("UIStroke", { Color = Palette.Outline, Thickness = 1, Transparency = 0.4 }, MobileButton)
    GuiLibrary.MobileButton = MobileButton

    local Icon = new("Frame", {
        Size = UDim2.fromOffset(18, 14),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
    }, MobileButton)

    local function bar(y)
        return new("Frame", {
            Size = UDim2.fromOffset(18, 2),
            Position = UDim2.new(0.5, 0, 0, y),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Palette.Text,
            BorderSizePixel = 0,
        }, Icon)
    end

    local Top, Middle, Bottom = bar(1), bar(7), bar(13)

    -- Hamburger when closed, an X when the GUI is open.
    updateMobileIcon = function()
        local openState = GuiLibrary.Visible
        Middle.BackgroundTransparency = openState and 1 or 0
        Top.Rotation = openState and 45 or 0
        Bottom.Rotation = openState and -45 or 0
        Top.Position = UDim2.new(0.5, 0, 0, openState and 7 or 1)
        Bottom.Position = UDim2.new(0.5, 0, 0, openState and 7 or 13)
    end

    updateMobileIcon()

    MobileButton.MouseButton1Click:Connect(function()
        GuiLibrary:Toggle()
    end)
end

--==============================================================
-- Shared widget rows (module screen + settings)
--==============================================================

local function addSeparator(parent, text)
    local row = new("Frame", {
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
    }, parent)

    local width = text and text ~= "" and (textWidth(text, 12) + 14) or 0

    new("Frame", {
        Size = UDim2.new(0.5, -width / 2, 0, 1),
        Position = UDim2.new(0, 4, 0.5, 0),
        BackgroundColor3 = Palette.Separator,
        BorderSizePixel = 0,
    }, row)

    new("Frame", {
        Size = UDim2.new(0.5, -width / 2, 0, 1),
        Position = UDim2.new(1, -4, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0),
        BackgroundColor3 = Palette.Separator,
        BorderSizePixel = 0,
    }, row)

    if text and text ~= "" then
        new("TextLabel", {
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            Font = Palette.Font,
            TextSize = 12,
            TextColor3 = Palette.TextSecondary,
            Text = text,
        }, row)
    end

    return row
end

local function createToggleRow(parent, labelText, initial, onChanged)
    local row = new("TextButton", {
        Size = UDim2.new(1, 0, 0, 26),
        BackgroundTransparency = 1,
        AutoButtonColor = false,
        Text = "",
    }, parent)

    local hover = new("Frame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Palette.BackgroundHovered,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
    }, row)

    new("TextLabel", {
        Size = UDim2.new(1, -40, 1, 0),
        Position = UDim2.fromOffset(6, 0),
        BackgroundTransparency = 1,
        Font = Palette.Font,
        TextSize = 14,
        TextColor3 = Palette.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        Text = labelText,
    }, row)

    local box = new("Frame", {
        Size = UDim2.fromOffset(12, 12),
        Position = UDim2.new(1, -18, 0.5, -6),
        BackgroundColor3 = Palette.Checkbox,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
    }, row)
    new("UIStroke", { Color = Palette.Outline, Thickness = 1, Transparency = 0.4 }, box)

    local check = createCheckmark(box)
    local state = false

    local widget = {}

    function widget:Set(value, fire, persist)
        state = value and true or false
        box.BackgroundTransparency = state and 0 or 1
        check.Visible = state
        if fire and onChanged then pcall(onChanged, state) end
        if persist then save() end
    end

    function widget:Get()
        return state
    end

    widget:Set(initial, false, false)

    row.MouseEnter:Connect(function()
        tweenTo(hover, { BackgroundTransparency = 0.55 }, 0.1)
    end)
    row.MouseLeave:Connect(function()
        tweenTo(hover, { BackgroundTransparency = 1 }, 0.1)
    end)
    row.MouseButton1Click:Connect(function()
        widget:Set(not state, true, true)
    end)

    return widget
end

local function createBindRow(parent, getBind, setBind)
    local row = new("TextButton", {
        Size = UDim2.new(1, 0, 0, 26),
        BackgroundTransparency = 1,
        AutoButtonColor = false,
        Text = "",
    }, parent)

    local hover = new("Frame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Palette.BackgroundHovered,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
    }, row)

    new("TextLabel", {
        Size = UDim2.new(1, -40, 1, 0),
        Position = UDim2.fromOffset(6, 0),
        BackgroundTransparency = 1,
        Font = Palette.Font,
        TextSize = 14,
        TextColor3 = Palette.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        Text = "Bind",
    }, row)

    local value = new("TextLabel", {
        Size = UDim2.fromOffset(0, 16),
        AutomaticSize = Enum.AutomaticSize.X,
        Position = UDim2.new(1, -8, 0.5, -8),
        AnchorPoint = Vector2.new(1, 0),
        BackgroundTransparency = 1,
        Font = Palette.Font,
        TextSize = 14,
        TextColor3 = Palette.Accent,
        TextXAlignment = Enum.TextXAlignment.Right,
        Text = "",
    }, row)

    local bindWidget = {}
    local capturing = false
    local captureConnection
    local captureToken = 0

    function bindWidget:Refresh()
        value.Text = getBind() or "None"
    end

    local function set(valueName)
        setBind(valueName)
        bindWidget:Refresh()
        save()
    end

    local function stopCapture()
        capturing = false
        GuiLibrary.CapturingKeybind = false
        captureToken += 1
        if captureConnection then
            captureConnection:Disconnect()
            captureConnection = nil
        end
        bindWidget:Refresh()
    end

    local function startCapture()
        if capturing then return end
        capturing = true
        GuiLibrary.CapturingKeybind = true
        value.Text = "Press a key..."
        captureToken += 1
        local token = captureToken

        captureConnection = UserInputService.InputBegan:Connect(function(input)
            if not capturing then return end
            local name = inputName(input)
            if name then
                stopCapture()
                set(name)
            end
        end)

        task.delay(4, function()
            if capturing and token == captureToken then
                stopCapture()
            end
        end)
    end

    row.MouseEnter:Connect(function()
        tweenTo(hover, { BackgroundTransparency = 0.55 }, 0.1)
    end)
    row.MouseLeave:Connect(function()
        tweenTo(hover, { BackgroundTransparency = 1 }, 0.1)
    end)
    row.MouseButton1Click:Connect(startCapture)
    row.MouseButton2Click:Connect(function()
        set("None")
    end)

    bindWidget:Refresh()
    return bindWidget
end

--==============================================================
-- Module screen
--==============================================================

local ModuleOverlay, ModuleFrame, ModuleTitle, ModuleSubtitle
local ModuleBody, ModuleScroll, ModuleContent
local currentModule

local function closeModuleScreen()
    if currentModule then
        currentModule.EnabledRow = nil
        currentModule.BindRow = nil
        if currentModule.SettingsContainer then
            currentModule.SettingsContainer.Parent = nil
        end
    end
    currentModule = nil
    ModuleOverlay.Visible = false
    ModuleFrame.Visible = false
end

-- forward declaration
local openModuleScreen

local function buildModuleScreen()
    ModuleOverlay = new("TextButton", {
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.new(0, 0, 0),
        BackgroundTransparency = 0.4,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Text = "",
        Visible = false,
        ZIndex = 90,
    }, GuiRoot)

    ModuleFrame = new("Frame", {
        Size = UDim2.fromOffset(280, 300),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Palette.Background,
        BackgroundTransparency = BODY_TRANSPARENCY,
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = 91,
    }, GuiRoot)
    new("UIStroke", { Color = Palette.Outline, Thickness = 1, Transparency = 0.2 }, ModuleFrame)

    local header = new("Frame", {
        Size = UDim2.new(1, 0, 0, HEADER_HEIGHT),
        BackgroundColor3 = Palette.Accent,
        BorderSizePixel = 0,
        Active = true,
        ZIndex = 92,
    }, ModuleFrame)

    ModuleTitle = new("TextLabel", {
        Size = UDim2.new(1, -80, 1, 0),
        Position = UDim2.fromOffset(8, 0),
        BackgroundTransparency = 1,
        Font = Palette.Font,
        TextSize = Palette.TextSize,
        TextColor3 = Palette.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        Text = "",
        ZIndex = 93,
    }, header)

    ModuleSubtitle = new("TextLabel", {
        Size = UDim2.fromOffset(44, HEADER_HEIGHT),
        Position = UDim2.new(1, -56, 0, 0),
        BackgroundTransparency = 1,
        Font = Palette.Font,
        TextSize = 12,
        TextColor3 = Color3.fromRGB(220, 220, 220),
        TextXAlignment = Enum.TextXAlignment.Right,
        Text = "",
        ZIndex = 93,
    }, header)

    local close = new("TextButton", {
        Size = UDim2.fromOffset(24, 24),
        Position = UDim2.new(1, -26, 0, 0),
        BackgroundTransparency = 1,
        Font = Palette.Font,
        TextSize = 18,
        TextColor3 = Palette.Text,
        Text = "X",
        ZIndex = 94,
    }, header)
    close.MouseButton1Click:Connect(closeModuleScreen)

    ModuleBody = new("Frame", {
        Size = UDim2.new(1, 0, 1, -HEADER_HEIGHT),
        Position = UDim2.fromOffset(0, HEADER_HEIGHT),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        ZIndex = 92,
    }, ModuleFrame)

    ModuleScroll = new("ScrollingFrame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Palette.TextSecondary,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.fromOffset(0, 0),
        ScrollingDirection = Enum.ScrollingDirection.Y,
        ZIndex = 92,
    }, ModuleBody)

    ModuleContent = new("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        ZIndex = 92,
    }, ModuleScroll)

    new("UIPadding", {
        PaddingTop = UDim.new(0, 6),
        PaddingBottom = UDim.new(0, 6),
        PaddingLeft = UDim.new(0, 6),
        PaddingRight = UDim.new(0, 6),
    }, ModuleContent)

    new("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 2),
    }, ModuleContent)

    makeDraggable(header, ModuleFrame)
    ModuleOverlay.MouseButton1Click:Connect(closeModuleScreen)
end

buildModuleScreen()

openModuleScreen = function(moduleTab)
    if currentModule and currentModule.SettingsContainer then
        currentModule.SettingsContainer.Parent = nil
    end

    currentModule = moduleTab
    ModuleTitle.Text = moduleTab.Name
    ModuleSubtitle.Text = moduleTab.WindowName or ""

    for _, child in ipairs(ModuleContent:GetChildren()) do
        if child:IsA("GuiObject") then
            child:Destroy()
        end
    end

    if moduleTab.Description and moduleTab.Description ~= "" then
        new("TextLabel", {
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Font = Palette.Font,
            TextSize = 13,
            TextColor3 = Palette.TextSecondary,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            Text = moduleTab.Description,
        }, ModuleContent)
    end

    -- Only toggling modules get an Enabled row and a bind; a button is an
    -- action, so its screen holds nothing but its settings.
    if moduleTab.SetEnabled then
        addSeparator(ModuleContent, "Module")
        moduleTab.EnabledRow = createToggleRow(ModuleContent, "Enabled", moduleTab.Enabled, function(state)
            moduleTab:SetEnabled(state)
        end)
    end

    if (moduleTab.SettingCount or 0) > 0 then
        addSeparator(ModuleContent, "Settings")
        moduleTab.SettingsContainer.Parent = ModuleContent
    end

    if moduleTab.SetKeybind then
        addSeparator(ModuleContent, "Bind")
        moduleTab.BindRow = createBindRow(ModuleContent,
            function() return moduleTab.Keybind end,
            function(value) moduleTab:SetKeybind(value) end
        )
    end

    ModuleOverlay.Visible = true
    ModuleFrame.Visible = true
end

local function installSettingsWidgets(owner, settingsConfig, SettingsContainer)
    -- ---- settings widgets ---------------------------------
    -- Everything below is created inside the settings container, which the
    -- module screen reparents while it is open. Modules and window buttons
    -- share these, so a button can hold settings just like a module can.

    function owner:CreateToggle(Table)
        local configValue = settingsConfig.Settings[Table.Name]
        if type(configValue) ~= "boolean" then
            configValue = Table.Default == true
            settingsConfig.Settings[Table.Name] = configValue
        end

        local widget = createToggleRow(SettingsContainer, Table.Name, configValue, function(state)
            settingsConfig.Settings[Table.Name] = state
            if Table.Function then pcall(Table.Function, state) end
        end)

        owner.ConfigWidgets[Table.Name] = {
            Kind = "Toggle",
            Set = function(value, fire)
                widget:Set(value == true, fire == true, false)
            end,
        }
        owner.SettingCount += 1
        return widget
    end

    function owner:CreateSlider(Table)
        local minValue = Table.Min or 0
        local maxValue = Table.Max or 1
        if maxValue <= minValue then maxValue = minValue + 1 end

        local value = tonumber(settingsConfig.Settings[Table.Name])
        if value == nil then value = Table.Default or minValue end
        settingsConfig.Settings[Table.Name] = value

        local row = new("Frame", {
            Size = UDim2.new(1, 0, 0, 30),
            BackgroundTransparency = 1,
        }, SettingsContainer)

        local track = new("TextButton", {
            Size = UDim2.new(1, -12, 0, 18),
            Position = UDim2.fromOffset(6, 6),
            BackgroundColor3 = Palette.SliderRight,
            BorderSizePixel = 0,
            AutoButtonColor = false,
            Text = "",
        }, row)

        new("Frame", {
            Size = UDim2.fromScale(0, 1),
            BackgroundColor3 = Palette.SliderLeft,
            BorderSizePixel = 0,
            Name = "Fill",
        }, track)

        local fill = track:FindFirstChild("Fill")
        local handle = new("Frame", {
            Size = UDim2.new(0, 2, 1, 0),
            BackgroundColor3 = Palette.SliderHandle,
            BorderSizePixel = 0,
        }, track)

        new("TextLabel", {
            Size = UDim2.new(1, -64, 1, 0),
            Position = UDim2.fromOffset(6, 0),
            BackgroundTransparency = 1,
            Font = Palette.Font,
            TextSize = 13,
            TextColor3 = Palette.Text,
            TextXAlignment = Enum.TextXAlignment.Left,
            Text = Table.Name,
        }, track)

        local valueLabel = new("TextLabel", {
            Size = UDim2.fromOffset(54, 18),
            Position = UDim2.new(1, -56, 0, 0),
            BackgroundTransparency = 1,
            Font = Palette.Font,
            TextSize = 13,
            TextColor3 = Palette.Text,
            TextXAlignment = Enum.TextXAlignment.Right,
            Text = "",
        }, track)

        local slider = {}

        local function format(number)
            if Table.Decimals and Table.Decimals > 0 then
                return string.format("%." .. Table.Decimals .. "f", number)
            end
            return tostring(math.floor(number + 0.5))
        end

        local function set(newValue, fire, persist)
            newValue = math.clamp(tonumber(newValue) or minValue, minValue, maxValue)
            if Table.Step and Table.Step > 0 then
                newValue = math.floor((newValue / Table.Step) + 0.5) * Table.Step
                newValue = math.clamp(newValue, minValue, maxValue)
            end

            value = newValue
            slider.Value = newValue
            settingsConfig.Settings[Table.Name] = newValue

            local alpha = (newValue - minValue) / math.max(maxValue - minValue, 1e-6)
            fill.Size = UDim2.fromScale(alpha, 1)
            handle.Position = UDim2.new(alpha, -1, 0, 0)
            valueLabel.Text = format(newValue)

            if fire and Table.Function then pcall(Table.Function, newValue) end
            if persist then save() end
        end

        slider.Value = value
        set(value, false, false)
        slider.Set = function(nextValue, fire)
            set(nextValue, fire == true, false)
        end

        track.InputBegan:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.MouseButton1
                and input.UserInputType ~= Enum.UserInputType.Touch then return end

            local function updateFromX(x)
                local start = track.AbsolutePosition.X
                local size = math.max(track.AbsoluteSize.X, 1)
                local alpha = math.clamp((x - start) / size, 0, 1)
                set(minValue + (maxValue - minValue) * alpha, true, false)
            end

            updateFromX(input.Position.X)

            local movedConnection
            local endedConnection

            movedConnection = UserInputService.InputChanged:Connect(function(moveInput)
                if moveInput.UserInputType == Enum.UserInputType.MouseMovement
                    or moveInput.UserInputType == Enum.UserInputType.Touch then
                    updateFromX(moveInput.Position.X)
                end
            end)

            endedConnection = UserInputService.InputEnded:Connect(function(endInput)
                if endInput.UserInputType == Enum.UserInputType.MouseButton1
                    or endInput.UserInputType == Enum.UserInputType.Touch then
                    movedConnection:Disconnect()
                    endedConnection:Disconnect()
                    save()
                end
            end)
        end)

        owner.ConfigWidgets[Table.Name] = {
            Kind = "Slider",
            Set = function(value, fire)
                slider.Set(value, fire)
            end,
        }
        owner.SettingCount += 1
        return slider
    end

    function owner:CreatePicker(Table)
        local options = Table.Options or {}
        if #options == 0 then
            options = { "None" }
        end

        local current = settingsConfig.Settings[Table.Name]
        local index = table.find(options, current) or table.find(options, Table.Default) or 1
        settingsConfig.Settings[Table.Name] = options[index]

        local row = new("TextButton", {
            Size = UDim2.new(1, 0, 0, 26),
            BackgroundTransparency = 1,
            AutoButtonColor = false,
            Text = "",
        }, SettingsContainer)

        local hover = new("Frame", {
            Size = UDim2.fromScale(1, 1),
            BackgroundColor3 = Palette.BackgroundHovered,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
        }, row)

        new("TextLabel", {
            Size = UDim2.new(1, -100, 1, 0),
            Position = UDim2.fromOffset(6, 0),
            BackgroundTransparency = 1,
            Font = Palette.Font,
            TextSize = 14,
            TextColor3 = Palette.Text,
            TextXAlignment = Enum.TextXAlignment.Left,
            Text = Table.Name,
        }, row)

        local valueLabel = new("TextLabel", {
            Size = UDim2.new(0.5, -8, 1, 0),
            Position = UDim2.new(1, -6, 0, 0),
            AnchorPoint = Vector2.new(1, 0),
            BackgroundTransparency = 1,
            Font = Palette.Font,
            TextSize = 14,
            TextColor3 = Palette.Accent,
            TextXAlignment = Enum.TextXAlignment.Right,
            Text = options[index],
        }, row)

        local list = new("Frame", {
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = Palette.BackgroundHovered,
            BackgroundTransparency = 0.35,
            BorderSizePixel = 0,
            Visible = false,
        }, SettingsContainer)
        new("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
        }, list)

        local picker = { Option = options[index] }

        local function set(newIndex, fire, persist)
            index = ((newIndex - 1) % #options) + 1
            local option = options[index]
            picker.Option = option
            settingsConfig.Settings[Table.Name] = option
            valueLabel.Text = option

            if fire and Table.Function then pcall(Table.Function, option) end
            if persist then save() end
        end

        for optionIndex, option in ipairs(options) do
            local optionRow = new("TextButton", {
                Size = UDim2.new(1, 0, 0, 22),
                BackgroundTransparency = 1,
                AutoButtonColor = false,
                Font = Palette.Font,
                TextSize = 13,
                TextColor3 = Palette.Text,
                Text = option,
                LayoutOrder = optionIndex,
            }, list)

            optionRow.MouseEnter:Connect(function()
                optionRow.TextColor3 = Palette.Accent
            end)
            optionRow.MouseLeave:Connect(function()
                optionRow.TextColor3 = Palette.Text
            end)
            optionRow.MouseButton1Click:Connect(function()
                set(optionIndex, true, true)
                list.Visible = false
            end)
        end

        row.MouseEnter:Connect(function()
            tweenTo(hover, { BackgroundTransparency = 0.55 }, 0.1)
        end)
        row.MouseLeave:Connect(function()
            tweenTo(hover, { BackgroundTransparency = 1 }, 0.1)
        end)
        row.MouseButton1Click:Connect(function()
            list.Visible = not list.Visible
        end)
        row.MouseButton2Click:Connect(function()
            set(index - 1, true, true)
        end)

        picker.Set = function(option, fire)
            local optionIndex = table.find(options, option)
            if optionIndex then
                set(optionIndex, fire == true, false)
            end
        end
        owner.ConfigWidgets[Table.Name] = {
            Kind = "Picker",
            Set = function(value, fire)
                picker.Set(value, fire)
            end,
        }
        owner.SettingCount += 1
        return picker
    end

    function owner:CreateButton(Table)
        local row = new("TextButton", {
            Size = UDim2.new(1, 0, 0, 26),
            BackgroundColor3 = Palette.BackgroundHovered,
            BackgroundTransparency = 0.2,
            BorderSizePixel = 0,
            Font = Palette.Font,
            TextSize = 14,
            TextColor3 = Palette.Text,
            Text = Table.Name,
            AutoButtonColor = false,
        }, SettingsContainer)

        row.MouseEnter:Connect(function()
            tweenTo(row, { BackgroundColor3 = Palette.BackgroundPressed }, 0.1)
        end)
        row.MouseLeave:Connect(function()
            tweenTo(row, { BackgroundColor3 = Palette.BackgroundHovered }, 0.1)
        end)
        row.MouseButton1Click:Connect(function()
            if Table.Function then pcall(Table.Function) end
        end)

        owner.SettingCount += 1
        return row
    end

    function owner:CreateLabel(Table)
        local label = new("TextLabel", {
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Font = Palette.Font,
            TextSize = 13,
            TextColor3 = Palette.TextSecondary,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            Text = Table.Text or Table.Name or "",
        }, SettingsContainer)

        owner.SettingCount += 1
        return label
    end

    function owner:CreateSeparator(Table)
        local separator = addSeparator(SettingsContainer, Table and Table.Name)
        owner.SettingCount += 1
        return separator
    end

    function owner:CreateTextBox(Table)
        local value = settingsConfig.Settings[Table.Name]
        if type(value) ~= "string" then
            value = tostring(Table.Default or "")
            settingsConfig.Settings[Table.Name] = value
        end

        -- Meteor renders StringSetting as a single field that fills the row:
        -- no label, the setting name is the placeholder, a flat fill with the
        -- theme background and a thin black outline.
        local row = new("Frame", {
            Size = UDim2.new(1, 0, 0, 26),
            BackgroundTransparency = 1,
        }, SettingsContainer)

        local box = new("TextBox", {
            Size = UDim2.new(1, 0, 1, -4),
            Position = UDim2.fromOffset(0, 2),
            BackgroundColor3 = Palette.Background,
            BackgroundTransparency = 0.1,
            BorderSizePixel = 0,
            ClipsDescendants = true,
            ClearTextOnFocus = false,
            Font = Palette.Font,
            TextSize = 13,
            TextColor3 = Palette.Text,
            PlaceholderColor3 = Palette.TextSecondary,
            PlaceholderText = Table.Placeholder or Table.Name,
            Text = value,
            TextXAlignment = Enum.TextXAlignment.Left,
        }, row)
        new("UIStroke", { Color = Palette.Outline, Thickness = 1, Transparency = 0.5 }, box)
        new("UIPadding", {
            PaddingLeft = UDim.new(0, 4),
            PaddingRight = UDim.new(0, 4),
        }, box)

        local textBox = { TextBox = box, Value = value }
        local updating = false

        local function set(newValue, fire, persist)
            newValue = tostring(newValue or "")
            if Table.MaxLength and Table.MaxLength > 0 then
                newValue = string.sub(newValue, 1, Table.MaxLength)
            end

            value = newValue
            textBox.Value = newValue
            settingsConfig.Settings[Table.Name] = newValue

            if box.Text ~= newValue then
                updating = true
                box.Text = newValue
                updating = false
            end

            if fire and Table.Function then pcall(Table.Function, newValue) end
            if persist then save() end
        end

        set(value, false, false)

        -- Meteor fires the setting on every edit and saves when the field is
        -- left, so typing never writes the config file once per character.
        box:GetPropertyChangedSignal("Text"):Connect(function()
            if updating then return end
            set(box.Text, true, false)
        end)
        box.FocusLost:Connect(function()
            set(box.Text, true, true)
        end)

        -- right clicking empties the field, like Meteor's text boxes
        box.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton2 then
                set("", true, true)
            end
        end)

        textBox.Set = function(nextValue, fire)
            set(nextValue, fire == true, false)
        end
        owner.ConfigWidgets[Table.Name] = {
            Kind = "TextBox",
            Set = function(nextValue, fire)
                textBox.Set(nextValue, fire)
            end,
        }
        owner.SettingCount += 1
        return textBox
    end

end

--==============================================================
-- Windows
--==============================================================

local WindowCount = 0

function GuiLibrary:CreateWindow(name)
    if self.Windows[name] then
        return self.Windows[name]
    end

    name = tostring(name or "Window")
    local saved = windowConfig(name)
    local collapsed = saved.Collapsed == true
    local wantedVisible = saved.Visible ~= false
    local width = WINDOW_MIN_WIDTH
    local filterActive = false
    local hasMatch = true
    local updating = false

    local viewport = layoutSize()
    local perRow = math.max(math.floor((viewport.X - 16) / 140), 1)
    local column = WindowCount % perRow
    local line = math.floor(WindowCount / perRow)
    local defaultX = 8 + column * 140
    local defaultY = 40 + line * 34

    if type(saved.Position) == "table" and saved.Position.X and saved.Position.Y then
        defaultX, defaultY = saved.Position.X, saved.Position.Y
    end

    -- Never start a window (including one restored from config) with its header
    -- off screen, otherwise it cannot be dragged back.
    defaultX = math.clamp(defaultX, 0, math.max(viewport.X - WINDOW_MIN_WIDTH, 0))
    defaultY = math.clamp(defaultY, 0, math.max(viewport.Y - HEADER_HEIGHT * 2, 0))

    local Window = new("Frame", {
        Name = name,
        Position = UDim2.fromOffset(defaultX, defaultY),
        Size = UDim2.fromOffset(WINDOW_MIN_WIDTH, HEADER_HEIGHT),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Active = true,
        Visible = wantedVisible,
        ZIndex = 2,
    }, GuiRoot)
    new("UIStroke", { Color = Palette.Outline, Thickness = 1, Transparency = 0.25 }, Window)

    local Header = new("TextButton", {
        Size = UDim2.new(1, 0, 0, HEADER_HEIGHT),
        BackgroundColor3 = Palette.Accent,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Text = "",
        ZIndex = 3,
    }, Window)

    new("TextLabel", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Font = Palette.Font,
        TextSize = Palette.TextSize,
        TextColor3 = Palette.Text,
        Text = name,
        TextTruncate = Enum.TextTruncate.AtEnd,
        ZIndex = 4,
    }, Header)

    local Chevron = new("TextButton", {
        Size = UDim2.fromOffset(18, HEADER_HEIGHT),
        Position = UDim2.new(1, -20, 0, 0),
        BackgroundTransparency = 1,
        Font = Palette.Font,
        TextSize = 12,
        TextColor3 = Palette.Text,
        Text = collapsed and ">" or "v",
        AutoButtonColor = false,
        ZIndex = 4,
    }, Header)

    local Body = new("Frame", {
        Position = UDim2.fromOffset(0, HEADER_HEIGHT),
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundColor3 = Palette.Background,
        BackgroundTransparency = BODY_TRANSPARENCY,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        ZIndex = 2,
    }, Window)

    local Scroll = new("ScrollingFrame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Palette.TextSecondary,
        ScrollBarImageTransparency = 0.4,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.fromOffset(0, 0),
        ScrollingDirection = Enum.ScrollingDirection.Y,
        ZIndex = 2,
    }, Body)

    local Content = new("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        ZIndex = 2,
    }, Scroll)

    local Layout = new("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, Content)

    local WindowObject = {
        Name = name,
        ConfigData = saved,
        Frame = Window,
        Header = Header,
        Body = Body,
        Content = Content,
        Modules = {},
        Collapsed = collapsed,
        Visible = wantedVisible,
        FilterActive = false,
        HasMatch = true,
    }

    local function update()
        if updating then return end
        updating = true

        local bodyHeight = 0
        if not collapsed then
            local maxHeight = math.clamp(layoutSize().Y * 0.7, 140, 560)
            bodyHeight = math.clamp(Layout.AbsoluteContentSize.Y, 0, maxHeight)
        end

        Body.Size = UDim2.new(1, 0, 0, bodyHeight)
        Window.Size = UDim2.fromOffset(width, HEADER_HEIGHT + bodyHeight)
        Window.Visible = wantedVisible and GuiLibrary.ActiveTab == "Modules"

        updating = false
    end

    function WindowObject:Refresh()
        update()
    end

    function WindowObject:ResetPosition()
        local view = layoutSize()
        local perRow = math.max(math.floor((view.X - 16) / 140), 1)
        local index = table.find(GuiLibrary.WindowOrder, self) or 1
        local column = (index - 1) % perRow
        local line = math.floor((index - 1) / perRow)

        saved.Position = nil
        Window.AnchorPoint = Vector2.zero
        Window.Position = UDim2.fromOffset(8 + column * 140, 40 + line * 34)
    end

    local function ensureWidth(text)
        local needed = math.clamp(textWidth(text, Palette.TextSize) + 28, WINDOW_MIN_WIDTH, WINDOW_MAX_WIDTH)
        if needed > width then
            width = needed
            update()
        end
    end

    function WindowObject:SetVisible(state)
        wantedVisible = state and true or false
        self.Visible = wantedVisible
        saved.Visible = wantedVisible
        update()
        save()
    end

    function WindowObject:SetCollapsed(state)
        collapsed = state and true or false
        self.Collapsed = collapsed
        saved.Collapsed = collapsed
        Chevron.Text = collapsed and ">" or "v"
        update()
        save()
    end

    function WindowObject:ApplyFilter(query)
        filterActive = query ~= nil and query ~= ""
        local any = false

        for _, moduleRow in ipairs(self.Modules) do
            local match = true
            if filterActive then
                match = string.find(string.lower(moduleRow.Name), string.lower(query), 1, true) ~= nil
            end
            moduleRow.Instance.Visible = match
            if match then any = true end
        end

        hasMatch = any
        self.FilterActive = filterActive
        self.HasMatch = hasMatch
        update()
    end

    function WindowObject:CreateModule(Table)
        assert(type(Table) == "table" and Table.Name, "CreateModule requires a Name")

        local settingsConfig = moduleConfig(name, Table.Name)
        if settingsConfig.Keybind == nil or settingsConfig.Keybind == "Unknown" then
            settingsConfig.Keybind = "None"
        end

        local SettingsContainer = new("Frame", {
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
        }, nil)
        new("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
        }, SettingsContainer)

        local Row = new("TextButton", {
            Size = UDim2.new(1, 0, 0, ROW_HEIGHT),
            BackgroundTransparency = 1,
            AutoButtonColor = false,
            Text = "",
            LayoutOrder = #self.Modules + 1,
            Visible = true,
        }, Content)

        local Fill = new("Frame", {
            Size = UDim2.fromScale(0, 1),
            BackgroundColor3 = Palette.ModuleBackground,
            BackgroundTransparency = 0,
            BorderSizePixel = 0,
            ZIndex = 1,
        }, Row)

        local AccentBar = new("Frame", {
            Size = UDim2.new(0, 2, 0, 0),
            Position = UDim2.new(0, 0, 1, 0),
            AnchorPoint = Vector2.new(0, 1),
            BackgroundColor3 = Palette.Accent,
            BorderSizePixel = 0,
            ZIndex = 2,
        }, Row)

        local Label = new("TextLabel", {
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            Font = Palette.Font,
            TextSize = 14,
            TextColor3 = Palette.Text,
            Text = Table.Name,
            TextTruncate = Enum.TextTruncate.AtEnd,
            ZIndex = 3,
        }, Row)

        local ModuleTab = {
            Name = Table.Name,
            WindowName = name,
            Window = WindowObject,
            Enabled = false,
            Keybind = settingsConfig.Keybind or "None",
            Description = Table.Description,
            ExtraText = Table.ExtraText,
            Array = Table.Array ~= false,
            SkipSearch = Table.SkipSearch == true,
            Instance = Row,
            SettingsContainer = SettingsContainer,
            SettingCount = 0,
            OnToggle = Table.Function,
            ConfigData = settingsConfig,
            ConfigWidgets = {},
        }

        local hovering = false

        local function updateVisual()
            local showFill = ModuleTab.Enabled or hovering
            tweenTo(Fill, { Size = UDim2.fromScale(showFill and 1 or 0, 1) }, 0.12)
            tweenTo(AccentBar, {
                Size = UDim2.new(0, 2, 0, ModuleTab.Enabled and ROW_HEIGHT or 0),
            }, 0.12)
        end

        function ModuleTab:SetEnabled(state, silent)
            state = state and true or false
            self.Enabled = state
            settingsConfig.Enabled = state

            if self.Enabled then
                if self.Array then
                    createArray(self.Name, self.ExtraText)
                end
            else
                removeArray(self.Name)
            end

            if self.EnabledRow and self.EnabledRow.Parent then
                self.EnabledRow:Set(state, false, false)
            end

            updateVisual()
            refreshSearchRow(self)

            if self.OnToggle then
                pcall(self.OnToggle, state)
            end

            if not silent then save() end
        end

        function ModuleTab:Toggle()
            self:SetEnabled(not self.Enabled)
        end

        function ModuleTab:SetKeybind(value)
            self.Keybind = value or "None"
            settingsConfig.Keybind = self.Keybind
            if self.BindRow and self.BindRow.Parent then
                self.BindRow:Refresh()
            end
            save()
        end

        function ModuleTab:CreateSettings()
            openModuleScreen(self)
            return ModuleFrame
        end

        -- click / long press
        Row.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                ModuleTab:Toggle()
            elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
                openModuleScreen(ModuleTab)
            elseif input.UserInputType == Enum.UserInputType.Touch then
                local pressTime = os.clock()
                local endedConnection
                endedConnection = UserInputService.InputEnded:Connect(function(endInput)
                    if endInput.UserInputType ~= Enum.UserInputType.Touch then return end
                    endedConnection:Disconnect()
                    if os.clock() - pressTime >= 0.35 then
                        openModuleScreen(ModuleTab)
                    else
                        ModuleTab:Toggle()
                    end
                end)
            end
        end)

        Row.MouseEnter:Connect(function()
            hovering = true
            updateVisual()
        end)
        Row.MouseLeave:Connect(function()
            hovering = false
            updateVisual()
        end)

        bindTooltip(Row, Table.Description)

        table.insert(self.Modules, {
            Name = Table.Name,
            Instance = Row,
            Module = ModuleTab,
        })
        table.insert(GuiLibrary.Modules, ModuleTab)

        ensureWidth(Table.Name)
        update()
        applySearch(SearchBox.Text)

        if settingsConfig.Enabled then
            task.defer(function()
                ModuleTab:SetEnabled(true, true)
            end)
        end

        -- keybind listener
        connect(UserInputService.InputBegan, function(input, gameProcessed)
            if GuiLibrary.CapturingKeybind then return end
            if input.UserInputType == Enum.UserInputType.Keyboard and gameProcessed then return end

            local bind = ModuleTab.Keybind
            if not bind or bind == "None" then return end

            if input.UserInputType == Enum.UserInputType.Keyboard
                or input.UserInputType == Enum.UserInputType.Gamepad1
                or input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.MouseButton2 then
                if inputName(input) == bind then
                    ModuleTab:Toggle()
                end
            end
        end)

        installSettingsWidgets(ModuleTab, settingsConfig, SettingsContainer)

        return ModuleTab
    end

    function WindowObject:CreateButton(Table)
        assert(type(Table) == "table" and Table.Name, "CreateButton requires a Name")

        -- A button runs an action, but it can carry settings the same way a
        -- module does: right click (or hold on touch) opens its settings screen.
        local settingsConfig = moduleConfig(name, Table.Name)

        local SettingsContainer = new("Frame", {
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
        }, nil)
        new("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
        }, SettingsContainer)

        local Button = new("TextButton", {
            Size = UDim2.new(1, 0, 0, 26),
            BackgroundColor3 = Palette.BackgroundHovered,
            BackgroundTransparency = 0.2,
            BorderSizePixel = 0,
            Font = Palette.Font,
            TextSize = 14,
            TextColor3 = Palette.Text,
            Text = Table.Name,
            AutoButtonColor = false,
            LayoutOrder = #self.Modules + 1,
        }, Content)

        local ButtonModule = {
            Name = Table.Name,
            WindowName = name,
            Window = WindowObject,
            Description = Table.Description,
            Instance = Button,
            Button = Button,
            SettingsContainer = SettingsContainer,
            SettingCount = 0,
            ConfigData = settingsConfig,
            ConfigWidgets = {},
        }

        installSettingsWidgets(ButtonModule, settingsConfig, SettingsContainer)

        function ButtonModule:CreateSettings()
            openModuleScreen(self)
            return ModuleFrame
        end

        function ButtonModule:HasSettings()
            return self.SettingCount > 0
        end

        Button.MouseEnter:Connect(function()
            tweenTo(Button, { BackgroundColor3 = Palette.BackgroundPressed }, 0.1)
        end)
        Button.MouseLeave:Connect(function()
            tweenTo(Button, { BackgroundColor3 = Palette.BackgroundHovered }, 0.1)
        end)

        local longPressed = false

        Button.MouseButton1Click:Connect(function()
            if longPressed then
                longPressed = false
                return
            end
            if Table.Function then pcall(Table.Function) end
        end)

        Button.MouseButton2Click:Connect(function()
            if ButtonModule:HasSettings() then
                ButtonModule:CreateSettings()
            end
        end)

        Button.InputBegan:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.Touch then return end
            local pressTime = os.clock()
            local endedConnection
            endedConnection = UserInputService.InputEnded:Connect(function(endInput)
                if endInput.UserInputType ~= Enum.UserInputType.Touch then return end
                endedConnection:Disconnect()
                if os.clock() - pressTime >= 0.35 and ButtonModule:HasSettings() then
                    longPressed = true
                    ButtonModule:CreateSettings()
                end
            end)
        end)

        table.insert(self.Modules, { Name = Table.Name, Instance = Button })
        table.insert(GuiLibrary.Modules, ButtonModule)
        ensureWidth(Table.Name)
        update()
        applySearch(SearchBox.Text)

        return ButtonModule
    end

    function WindowObject:CreateLabel(Table)
        local Label = new("TextLabel", {
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Font = Palette.Font,
            TextSize = 13,
            TextColor3 = Palette.TextSecondary,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            Text = Table.Text or Table.Name or "",
            LayoutOrder = #self.Modules + 1,
        }, Content)

        new("UIPadding", {
            PaddingLeft = UDim.new(0, 6),
            PaddingRight = UDim.new(0, 6),
            PaddingTop = UDim.new(0, 2),
            PaddingBottom = UDim.new(0, 2),
        }, Label)

        table.insert(self.Modules, { Name = Table.Name or "Label", Instance = Label })
        update()

        return Label
    end

    function WindowObject:CreateSeparator(Table)
        local separator = addSeparator(Content, Table and Table.Name)
        table.insert(self.Modules, { Name = (Table and Table.Name) or "Separator", Instance = separator })
        update()
        return separator
    end

    Chevron.MouseButton1Click:Connect(function()
        WindowObject:SetCollapsed(not collapsed)
    end)

    makeDraggable(Header, Window, function(finalPosition)
        saved.Position = {
            X = math.round(finalPosition.X),
            Y = math.round(finalPosition.Y),
        }
        save()
    end)

    connect(Layout:GetPropertyChangedSignal("AbsoluteContentSize"), update)
    connect(Content:GetPropertyChangedSignal("AbsoluteSize"), update)

    update()

    self.Windows[name] = WindowObject
    GuiLibrary.Windows[name] = WindowObject
    table.insert(GuiLibrary.WindowOrder, WindowObject)
    WindowCount += 1

    if SearchBox.Text ~= "" then
        applySearch(SearchBox.Text)
    end

    return WindowObject
end

GuiLibrary.GetWindow = function(self, name)
    return self.Windows[name]
end

--==============================================================
-- Tab screens (Config, GUI, HUD, Friends, Macros)
--==============================================================
-- Meteor opens every tab as a single window in the middle of the screen
-- (see WindowTabScreen), filled with the settings for that system. The rows
-- below mirror the settings each of those screens shows.

local TAB_WINDOW_WIDTH = 300

local function createTabWindow(tabName, width)
    width = width or TAB_WINDOW_WIDTH

    local saved = windowConfig(tabName)
    local hasSaved = type(saved.Position) == "table" and saved.Position.X and saved.Position.Y

    local position
    if hasSaved then
        local viewport = layoutSize()
        position = UDim2.fromOffset(
            math.clamp(saved.Position.X, 0, math.max(viewport.X - width, 0)),
            math.clamp(saved.Position.Y, 0, math.max(viewport.Y - HEADER_HEIGHT * 2, 0))
        )
    else
        position = UDim2.new(0.5, 0, 0.5, 0)
    end

    local window = new("Frame", {
        Name = tabName .. "Tab",
        Size = UDim2.fromOffset(width, HEADER_HEIGHT),
        Position = position,
        AnchorPoint = hasSaved and Vector2.zero or Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = 10,
    }, GuiRoot)
    new("UIStroke", { Color = Palette.Outline, Thickness = 1, Transparency = 0.25 }, window)

    local Header = new("TextButton", {
        Size = UDim2.new(1, 0, 0, HEADER_HEIGHT),
        BackgroundColor3 = Palette.Accent,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Text = "",
        ZIndex = 11,
    }, window)

    new("TextLabel", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Font = Palette.Font,
        TextSize = Palette.TextSize,
        TextColor3 = Palette.Text,
        Text = tabName,
        ZIndex = 12,
    }, Header)

    local Body = new("Frame", {
        Position = UDim2.fromOffset(0, HEADER_HEIGHT),
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundColor3 = Palette.Background,
        BackgroundTransparency = BODY_TRANSPARENCY,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        ZIndex = 10,
    }, window)

    local Scroll = new("ScrollingFrame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Palette.TextSecondary,
        ScrollBarImageTransparency = 0.4,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.fromOffset(0, 0),
        ScrollingDirection = Enum.ScrollingDirection.Y,
        ZIndex = 10,
    }, Body)

    local Content = new("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        ZIndex = 10,
    }, Scroll)

    new("UIPadding", {
        PaddingTop = UDim.new(0, 4),
        PaddingBottom = UDim.new(0, 4),
        PaddingLeft = UDim.new(0, 4),
        PaddingRight = UDim.new(0, 4),
    }, Content)

    local Layout = new("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 1),
    }, Content)

    local updating = false
    local function update()
        if updating then return end
        updating = true

        local maxHeight = math.clamp(layoutSize().Y * 0.7, 140, 560)
        local bodyHeight = math.clamp(Layout.AbsoluteContentSize.Y + 8, 0, maxHeight)

        Body.Size = UDim2.new(1, 0, 0, bodyHeight)
        window.Size = UDim2.fromOffset(width, HEADER_HEIGHT + bodyHeight)

        updating = false
    end

    connect(Content:GetPropertyChangedSignal("AbsoluteSize"), update)
    update()

    makeDraggable(Header, window, function(finalPosition)
        saved.Position = {
            X = math.round(finalPosition.X),
            Y = math.round(finalPosition.Y),
        }
        save()
    end)

    return {
        Frame = window,
        Content = Content,
        Update = update,
    }
end

-- Settings rows in Meteor's shapes: a label on the left and the control on the
-- right, section headers drawn as separators, and full width buttons.
local openColorPicker

local function tabRows(parent)
    local order = 0
    local rows = {}

    local function nextOrder()
        order += 1
        return order
    end

    function rows:Separator(text)
        local row = new("Frame", {
            Size = UDim2.new(1, 0, 0, 18),
            BackgroundTransparency = 1,
            LayoutOrder = nextOrder(),
        }, parent)

        local width = textWidth(text, 12) + 14
        new("Frame", {
            Size = UDim2.new(0.5, -width / 2, 0, 1),
            Position = UDim2.new(0, 4, 0.5, 0),
            BackgroundColor3 = Palette.Separator,
            BorderSizePixel = 0,
        }, row)
        new("Frame", {
            Size = UDim2.new(0.5, -width / 2, 0, 1),
            Position = UDim2.new(1, -4, 0.5, 0),
            AnchorPoint = Vector2.new(1, 0),
            BackgroundColor3 = Palette.Separator,
            BorderSizePixel = 0,
        }, row)
        new("TextLabel", {
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            Font = Palette.Font,
            TextSize = 12,
            TextColor3 = Palette.Text,
            Text = text,
        }, row)

        return row
    end

    function rows:Toggle(labelText, value, onChanged)
        local row = new("TextButton", {
            Size = UDim2.new(1, 0, 0, 20),
            BackgroundTransparency = 1,
            AutoButtonColor = false,
            Text = "",
            LayoutOrder = nextOrder(),
        }, parent)

        new("TextLabel", {
            Size = UDim2.new(1, -30, 1, 0),
            Position = UDim2.fromOffset(6, 0),
            BackgroundTransparency = 1,
            Font = Palette.Font,
            TextSize = 13,
            TextColor3 = Palette.Text,
            TextXAlignment = Enum.TextXAlignment.Left,
            Text = labelText,
            TextTruncate = Enum.TextTruncate.AtEnd,
        }, row)

        local box = new("Frame", {
            Size = UDim2.fromOffset(12, 12),
            Position = UDim2.new(1, -6, 0.5, 0),
            AnchorPoint = Vector2.new(1, 0.5),
            BackgroundColor3 = Palette.Background,
            BackgroundTransparency = 0.2,
            BorderSizePixel = 0,
        }, row)

        local tick = new("Frame", {
            Size = UDim2.fromOffset(6, 6),
            Position = UDim2.fromScale(0.5, 0.5),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Palette.Checkbox,
            BorderSizePixel = 0,
            Visible = value and true or false,
        }, box)

        local function set(state)
            value = state and true or false
            tick.Visible = value
            if onChanged then onChanged(value) end
        end

        row.MouseButton1Click:Connect(function()
            set(not value)
        end)

        return {
            Row = row,
            Set = function(nextValue, fire) set(nextValue, fire) end,
            Get = function() return value end,
        }
    end

    function rows:Slider(labelText, minValue, maxValue, value, decimals, onChanged)
        minValue = minValue or 0
        maxValue = maxValue or 1
        value = math.clamp(tonumber(value) or minValue, minValue, maxValue)

        local row = new("Frame", {
            Size = UDim2.new(1, 0, 0, 26),
            BackgroundTransparency = 1,
            LayoutOrder = nextOrder(),
        }, parent)

        new("TextLabel", {
            Size = UDim2.new(1, -60, 0, 14),
            Position = UDim2.fromOffset(6, 0),
            BackgroundTransparency = 1,
            Font = Palette.Font,
            TextSize = 13,
            TextColor3 = Palette.Text,
            TextXAlignment = Enum.TextXAlignment.Left,
            Text = labelText,
            TextTruncate = Enum.TextTruncate.AtEnd,
        }, row)

        local valueLabel = new("TextLabel", {
            Size = UDim2.fromOffset(54, 14),
            Position = UDim2.new(1, -6, 0, 0),
            AnchorPoint = Vector2.new(1, 0),
            BackgroundTransparency = 1,
            Font = Palette.Font,
            TextSize = 13,
            TextColor3 = Palette.Text,
            TextXAlignment = Enum.TextXAlignment.Right,
            Text = "",
        }, row)

        -- The visible bar is 3px tall like WMeteorSlider, but the button that
        -- receives input is taller so it can be grabbed with a finger.
        local track = new("TextButton", {
            Size = UDim2.new(1, -12, 0, 16),
            Position = UDim2.fromOffset(6, 11),
            BackgroundTransparency = 1,
            AutoButtonColor = false,
            Text = "",
        }, row)

        local bar = new("Frame", {
            Size = UDim2.new(1, 0, 0, 3),
            Position = UDim2.new(0, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundColor3 = Palette.SliderRight,
            BorderSizePixel = 0,
        }, track)

        local fill = new("Frame", {
            Size = UDim2.fromScale(0, 1),
            BackgroundColor3 = Palette.SliderLeft,
            BorderSizePixel = 0,
        }, bar)

        local handle = new("Frame", {
            Size = UDim2.fromOffset(7, 7),
            Position = UDim2.new(0, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Palette.SliderHandle,
            BorderSizePixel = 0,
        }, bar)
        new("UICorner", { CornerRadius = UDim.new(1, 0) }, handle)

        local function format(number)
            if decimals and decimals > 0 then
                return string.format("%." .. decimals .. "f", number)
            end
            return tostring(math.floor(number + 0.5))
        end

        local function set(newValue, fire)
            value = math.clamp(tonumber(newValue) or minValue, minValue, maxValue)
            local alpha = (value - minValue) / math.max(maxValue - minValue, 1e-6)

            fill.Size = UDim2.fromScale(alpha, 1)
            handle.Position = UDim2.new(alpha, 0, 0.5, 0)
            valueLabel.Text = format(value)

            if fire and onChanged then onChanged(value) end
        end

        set(value, false)

        track.InputBegan:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.MouseButton1
                and input.UserInputType ~= Enum.UserInputType.Touch then return end

            local function updateFromX(x)
                local start = track.AbsolutePosition.X
                local size = math.max(track.AbsoluteSize.X, 1)
                set(minValue + (maxValue - minValue) * math.clamp((x - start) / size, 0, 1), true)
            end

            updateFromX(input.Position.X)

            local movedConnection
            local endedConnection

            movedConnection = UserInputService.InputChanged:Connect(function(moveInput)
                if moveInput.UserInputType == Enum.UserInputType.MouseMovement
                    or moveInput.UserInputType == Enum.UserInputType.Touch then
                    updateFromX(moveInput.Position.X)
                end
            end)

            endedConnection = UserInputService.InputEnded:Connect(function(endInput)
                if endInput.UserInputType == Enum.UserInputType.MouseButton1
                    or endInput.UserInputType == Enum.UserInputType.Touch then
                    movedConnection:Disconnect()
                    endedConnection:Disconnect()
                end
            end)
        end)

        return {
            Row = row,
            Set = function(nextValue, fire) set(nextValue, fire) end,
            Get = function() return value end,
        }
    end

    function rows:Dropdown(labelText, options, index, onChanged)
        if #options == 0 then options = { "None" } end
        index = math.clamp(index or 1, 1, #options)

        local row = new("TextButton", {
            Size = UDim2.new(1, 0, 0, 20),
            BackgroundTransparency = 1,
            AutoButtonColor = false,
            Text = "",
            LayoutOrder = nextOrder(),
        }, parent)

        new("TextLabel", {
            Size = UDim2.new(1, -130, 1, 0),
            Position = UDim2.fromOffset(6, 0),
            BackgroundTransparency = 1,
            Font = Palette.Font,
            TextSize = 13,
            TextColor3 = Palette.Text,
            TextXAlignment = Enum.TextXAlignment.Left,
            Text = labelText,
            TextTruncate = Enum.TextTruncate.AtEnd,
        }, row)

        local valueLabel = new("TextLabel", {
            Size = UDim2.new(0, 100, 1, 0),
            Position = UDim2.new(1, -18, 0, 0),
            AnchorPoint = Vector2.new(1, 0),
            BackgroundTransparency = 1,
            Font = Palette.Font,
            TextSize = 13,
            TextColor3 = Palette.Text,
            TextXAlignment = Enum.TextXAlignment.Right,
            Text = options[index],
        }, row)

        new("TextLabel", {
            Size = UDim2.fromOffset(10, 20),
            Position = UDim2.new(1, -6, 0, 0),
            AnchorPoint = Vector2.new(1, 0),
            BackgroundTransparency = 1,
            Font = Palette.Font,
            TextSize = 10,
            TextColor3 = Palette.TextSecondary,
            Text = "v",
        }, row)

        row.MouseButton1Click:Connect(function()
            index = (index % #options) + 1
            valueLabel.Text = options[index]
            if onChanged then onChanged(options[index], index) end
        end)

        return row
    end

    function rows:TextInput(labelText, value, onChanged)
        local row = new("Frame", {
            Size = UDim2.new(1, 0, 0, 24),
            BackgroundTransparency = 1,
            LayoutOrder = nextOrder(),
        }, parent)

        new("TextLabel", {
            Size = UDim2.fromOffset(96, 24),
            Position = UDim2.fromOffset(6, 0),
            BackgroundTransparency = 1,
            Font = Palette.Font,
            TextSize = 13,
            TextColor3 = Palette.Text,
            TextXAlignment = Enum.TextXAlignment.Left,
            Text = labelText,
            TextTruncate = Enum.TextTruncate.AtEnd,
        }, row)

        local box = new("TextBox", {
            Size = UDim2.new(1, -108, 0, 20),
            Position = UDim2.fromOffset(104, 2),
            BackgroundColor3 = Palette.Background,
            BackgroundTransparency = 0.4,
            BorderSizePixel = 0,
            Font = Palette.Font,
            TextSize = 13,
            TextColor3 = Palette.Text,
            TextXAlignment = Enum.TextXAlignment.Left,
            Text = tostring(value or ""),
            ClearTextOnFocus = false,
            ZIndex = 11,
        }, row)

        box.FocusLost:Connect(function()
            if onChanged then onChanged(box.Text) end
        end)

        return row
    end

    -- Colour rows show a swatch for one palette key and open the picker on click.
    function rows:Color(labelText, paletteKey)
        local row = new("Frame", {
            Size = UDim2.new(1, 0, 0, 20),
            BackgroundTransparency = 1,
            LayoutOrder = nextOrder(),
        }, parent)

        new("TextLabel", {
            Size = UDim2.new(1, -40, 1, 0),
            Position = UDim2.fromOffset(6, 0),
            BackgroundTransparency = 1,
            Font = Palette.Font,
            TextSize = 13,
            TextColor3 = Palette.Text,
            TextXAlignment = Enum.TextXAlignment.Left,
            Text = labelText,
            TextTruncate = Enum.TextTruncate.AtEnd,
        }, row)

        local swatch = new("Frame", {
            Size = UDim2.fromOffset(24, 10),
            Position = UDim2.new(1, -6, 0.5, 0),
            AnchorPoint = Vector2.new(1, 0.5),
            BackgroundColor3 = Palette[paletteKey] or Palette.Text,
            BorderSizePixel = 0,
        }, row)
        new("UIStroke", { Color = Palette.Outline, Thickness = 1, Transparency = 0.5 }, swatch)

        local button = new("TextButton", {
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            AutoButtonColor = false,
            Text = "",
        }, row)

        button.MouseButton1Click:Connect(function()
            openColorPicker(labelText, Palette[paletteKey], function(color)
                GuiLibrary:SetPaletteColor(paletteKey, color)
            end)
        end)

        return row
    end

    function rows:Button(text, onClick)
        local button = new("TextButton", {
            Size = UDim2.new(1, 0, 0, 20),
            BackgroundColor3 = Palette.Background,
            BackgroundTransparency = BODY_TRANSPARENCY,
            BorderSizePixel = 0,
            AutoButtonColor = false,
            Font = Palette.Font,
            TextSize = 13,
            TextColor3 = Palette.Text,
            Text = text,
            LayoutOrder = nextOrder(),
        }, parent)

        button.MouseEnter:Connect(function()
            button.BackgroundColor3 = Palette.BackgroundHovered
        end)
        button.MouseLeave:Connect(function()
            button.BackgroundColor3 = Palette.Background
        end)
        button.MouseButton1Click:Connect(function()
            if onClick then onClick() end
        end)

        return button
    end

    -- Meteor's confirmed buttons (Clear, Reset, minus) ask once, then run.
    function rows:ConfirmedButton(text, confirmText, onClick)
        local confirming = false

        local button
        button = rows:Button(text, function()
            if confirming then
                confirming = false
                button.Text = text
                if onClick then onClick() end
            else
                confirming = true
                button.Text = confirmText
            end
        end)

        return button
    end

    return rows
end

-- Colour picker -------------------------------------------------
-- Opened by every colour row: three RGB sliders plus a preview, editing the
-- theme live (the palette registry recolours the open GUI as it moves).

local function buildColorPicker()
    local picker = createTabWindow("Color", 240)
    local rows = tabRows(picker.Content)

    local title = new("TextLabel", {
        Size = UDim2.new(1, 0, 0, 16),
        BackgroundTransparency = 1,
        Font = Palette.Font,
        TextSize = 13,
        TextColor3 = Palette.TextSecondary,
        TextXAlignment = Enum.TextXAlignment.Left,
        Text = "",
        LayoutOrder = 0,
    }, picker.Content)

    local preview = new("Frame", {
        Size = UDim2.new(1, 0, 0, 16),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0,
        LayoutOrder = 1,
    }, picker.Content)
    new("UIStroke", { Color = Palette.Outline, Thickness = 1, Transparency = 0.4 }, preview)

    local state = { R = 255, G = 255, B = 255 }
    local target

    local function apply()
        local color = Color3.fromRGB(math.floor(state.R + 0.5), math.floor(state.G + 0.5), math.floor(state.B + 0.5))
        preview.BackgroundColor3 = color
        if target then target(color) end
    end

    local function channel(name, label)
        return rows:Slider(label, 0, 255, state[name], 0, function(value)
            state[name] = value
            apply()
        end)
    end

    local red = channel("R", "red")
    local green = channel("G", "green")
    local blue = channel("B", "blue")

    rows:Button("Close", function()
        picker.Frame.Visible = false
    end)

    function picker:Open(titleText, color, onChanged)
        target = onChanged
        title.Text = titleText

        state.R = math.round(color.R * 255)
        state.G = math.round(color.G * 255)
        state.B = math.round(color.B * 255)

        red:Set(state.R, false)
        green:Set(state.G, false)
        blue:Set(state.B, false)
        preview.BackgroundColor3 = color

        picker.Frame.Visible = true
        picker.Update()
    end

    return picker
end

local colorPicker

openColorPicker = function(titleText, color, onChanged)
    colorPicker = colorPicker or buildColorPicker()

    -- Tucked in the top right so it does not sit on top of the centred tab
    -- screen whose colour row was clicked.
    local view = layoutSize()
    local width = 240
    colorPicker.Frame.AnchorPoint = Vector2.zero
    colorPicker.Frame.Position = UDim2.fromOffset(
        math.clamp(view.X - width - 16, 8, math.max(view.X - width - 8, 8)),
        40
    )

    colorPicker:Open(titleText, color, onChanged)
end

GuiLibrary.TabWindows = {}

-- Apply a named config to the live UI while preserving table references held by
-- modules and windows. This lets loading work without restarting the script.
local function applyConfigData(raw)
    local loaded = normalizeConfig(raw)
    if not loaded then return false, "Invalid config data." end

    local function replaceTable(target, source)
        for key in pairs(target) do target[key] = nil end
        for key, value in pairs(source) do target[key] = value end
    end

    -- Preserve the settings table referenced by the GUI systems.
    replaceTable(Settings, loaded.settings)
    Config.settings = Settings

    -- Preserve per-module config tables captured by each ModuleTab closure.
    for key in pairs(Config.modules) do Config.modules[key] = nil end
    local knownModuleKeys = {}
    for _, moduleTab in ipairs(GuiLibrary.Modules) do
        local key = moduleTab.WindowName .. "/" .. moduleTab.Name
        local incoming = loaded.modules[key] or {}
        local data = moduleTab.ConfigData
        data.Enabled = incoming.Enabled == true
        data.Keybind = incoming.Keybind or "None"
        data.Settings = data.Settings or {}
        replaceTable(data.Settings, type(incoming.Settings) == "table" and incoming.Settings or {})
        Config.modules[key] = data
        knownModuleKeys[key] = true

        for settingName, widget in pairs(moduleTab.ConfigWidgets) do
            local value = data.Settings[settingName]
            if value ~= nil then
                pcall(widget.Set, value, true)
            end
        end
        if moduleTab.SetKeybind then
            moduleTab.Keybind = data.Keybind
            if moduleTab.BindRow and moduleTab.BindRow.Parent then
                moduleTab.BindRow:Refresh()
            end
        end
        if moduleTab.SetEnabled then
            moduleTab:SetEnabled(data.Enabled, true)
        end
    end

    for key, value in pairs(loaded.modules) do
        if not knownModuleKeys[key] then Config.modules[key] = value end
    end

    -- Update saved window data while preserving references captured by windows.
    local incomingWindows = loaded.windows
    for key in pairs(Config.windows) do Config.windows[key] = nil end
    local handledWindows = {}
    for name, windowObject in pairs(GuiLibrary.Windows) do
        local incoming = incomingWindows[name]
        local saved = windowObject.ConfigData
        if incoming and saved then
            replaceTable(saved, incoming)
            Config.windows[name] = saved
            handledWindows[name] = true
            if saved.Position and saved.Position.X and saved.Position.Y then
                windowObject.Frame.Position = UDim2.fromOffset(saved.Position.X, saved.Position.Y)
            end
            if saved.Visible ~= nil then windowObject:SetVisible(saved.Visible) end
            if saved.Collapsed ~= nil then windowObject:SetCollapsed(saved.Collapsed) end
        end
    end
    for name, saved in pairs(incomingWindows) do
        if not handledWindows[name] then Config.windows[name] = saved end
    end

    Config.friends = loaded.friends
    Config.macros = loaded.macros
    Config.settings = Settings
    GuiLibrary.Settings = Settings

    if Settings.scale then GuiLibrary:SetScale(tonumber(Settings.scale) or 1) end
    if Settings.font then
        local font = FontMap[Settings.font] or Enum.Font.Jura
        if Settings.customFont == false then font = Enum.Font.SourceSans end
        GuiLibrary:SetFont(font)
    end
    for key, rgb in pairs(Settings.colors or {}) do
        if PaletteDefaults[key] and type(rgb) == "table"
            and tonumber(rgb[1]) and tonumber(rgb[2]) and tonumber(rgb[3]) then
            GuiLibrary:SetPaletteColor(key, Color3.fromRGB(
                math.clamp(tonumber(rgb[1]), 0, 255),
                math.clamp(tonumber(rgb[2]), 0, 255),
                math.clamp(tonumber(rgb[3]), 0, 255)
            ))
        end
    end
    if GuiLibrary.ApplyArraylistSettings then GuiLibrary:ApplyArraylistSettings() end
    if GuiLibrary.UpdateArraylistVisibility then GuiLibrary:UpdateArraylistVisibility() end
    return true
end

-- Config (ConfigTab.ConfigScreen) ------------------------------

local configTab = createTabWindow("Config")
GuiLibrary.TabWindows.Config = configTab.Frame

do
    local rows = tabRows(configTab.Content)

    local function applyFont()
        local font = FontMap[Settings.font] or Enum.Font.Jura
        if Settings.customFont == false then
            font = Enum.Font.SourceSans
        end
        GuiLibrary:SetFont(font)
        save()
    end

    rows:Separator("Visual")
    rows:Toggle("custom-font", Settings.customFont ~= false, function(state)
        Settings.customFont = state
        applyFont()
    end)
    rows:Dropdown("font", FontNames, math.max(table.find(FontNames, Settings.font) or 1, 1), function(name)
        Settings.font = name
        applyFont()
    end)
    rows:Color("friend-color", "Friend")

    rows:Separator("Config Manager")

    local nameRow = new("Frame", {
        Size = UDim2.new(1, 0, 0, 28),
        BackgroundTransparency = 1,
        LayoutOrder = 5.1,
    }, configTab.Content)
    local nameBox = new("TextBox", {
        Size = UDim2.new(1, -12, 1, -4),
        Position = UDim2.fromOffset(6, 2),
        BackgroundColor3 = Palette.ModuleBackground,
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        ClearTextOnFocus = false,
        Font = Palette.Font,
        TextSize = 13,
        TextColor3 = Palette.Text,
        PlaceholderColor3 = Palette.TextSecondary,
        PlaceholderText = "Config name",
        Text = "config",
        TextXAlignment = Enum.TextXAlignment.Left,
    }, nameRow)
    new("UIPadding", {
        PaddingLeft = UDim.new(0, 6),
        PaddingRight = UDim.new(0, 6),
    }, nameBox)

    local renameRow = new("Frame", {
        Size = UDim2.new(1, 0, 0, 28),
        BackgroundTransparency = 1,
        LayoutOrder = 5.2,
    }, configTab.Content)
    local renameBox = new("TextBox", {
        Size = UDim2.new(1, -12, 1, -4),
        Position = UDim2.fromOffset(6, 2),
        BackgroundColor3 = Palette.ModuleBackground,
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        ClearTextOnFocus = false,
        Font = Palette.Font,
        TextSize = 13,
        TextColor3 = Palette.Text,
        PlaceholderColor3 = Palette.TextSecondary,
        PlaceholderText = "New name (for rename)",
        Text = "",
        TextXAlignment = Enum.TextXAlignment.Left,
    }, renameRow)
    new("UIPadding", {
        PaddingLeft = UDim.new(0, 6),
        PaddingRight = UDim.new(0, 6),
    }, renameBox)

    local configStatus = new("TextLabel", {
        Size = UDim2.new(1, -12, 0, 30),
        BackgroundTransparency = 1,
        Font = Palette.Font,
        TextSize = 12,
        TextColor3 = Palette.TextSecondary,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        Text = "Configs are stored in Meteor/Configs.",
        LayoutOrder = 5.3,
    }, configTab.Content)

    local function setConfigStatus(message, success)
        configStatus.Text = tostring(message)
        configStatus.TextColor3 = success and Palette.Plus or Palette.Minus
    end

    local function selectedConfig()
        local name = cleanConfigName(nameBox.Text)
        if not name then
            setConfigStatus("Enter a valid config name.", false)
            return nil
        end
        return name, configFile(name)
    end

    rows:Button("Save as new", function()
        local name, path = selectedConfig()
        if not name then return end
        if isfile and isfile(path) then
            setConfigStatus("Config already exists. Use Overwrite.", false)
            return
        end
        local ok, err = writeConfigFile(path, Config)
        if ok then
            ActiveConfigName = name
            setConfigStatus("Saved " .. name .. ".", true)
        else
            setConfigStatus("Save failed: " .. tostring(err), false)
        end
    end)

    rows:Button("Load", function()
        local name, path = selectedConfig()
        if not name then return end
        local raw, err = decodeConfig(path)
        if not raw then
            setConfigStatus(err, false)
            return
        end
        local ok, applyError = applyConfigData(raw)
        if ok then
            ActiveConfigName = name
            nameBox.Text = name
            setConfigStatus("Loaded " .. name .. ".", true)
        else
            setConfigStatus(applyError or "Could not apply config.", false)
        end
    end)

    rows:Button("Overwrite", function()
        local name, path = selectedConfig()
        if not name then return end
        local ok, err = writeConfigFile(path, Config)
        if ok then
            ActiveConfigName = name
            setConfigStatus("Overwrote " .. name .. ".", true)
        else
            setConfigStatus("Overwrite failed: " .. tostring(err), false)
        end
    end)

    rows:Button("Delete", function()
        local name, path = selectedConfig()
        if not name then return end
        if not isfile or not isfile(path) then
            setConfigStatus("Config does not exist.", false)
            return
        end
        local ok, err = pcall(function()
            delfile(path)
            if isfile(AutoLoadPath) and readfile(AutoLoadPath) == name then
                delfile(AutoLoadPath)
            end
        end)
        if ok then
            if ActiveConfigName == name then ActiveConfigName = "config" end
            setConfigStatus("Deleted " .. name .. ".", true)
        else
            setConfigStatus("Delete failed: " .. tostring(err), false)
        end
    end)

    rows:Button("Rename", function()
        local oldName, oldPath = selectedConfig()
        local newName = cleanConfigName(renameBox.Text)
        if not oldName then return end
        local newPath = newName and configFile(newName)
        if not newName then
            setConfigStatus("Enter a valid new name.", false)
            return
        end
        if not isfile or not isfile(oldPath) then
            setConfigStatus("Source config does not exist.", false)
            return
        end
        if isfile(newPath) then
            setConfigStatus("A config with that name already exists.", false)
            return
        end
        local ok, err = pcall(function()
            ensureConfigDirectory()
            writefile(newPath, readfile(oldPath))
            delfile(oldPath)
            if isfile(AutoLoadPath) and readfile(AutoLoadPath) == oldName then
                writefile(AutoLoadPath, newName)
            end
        end)
        if ok then
            if ActiveConfigName == oldName then ActiveConfigName = newName end
            nameBox.Text = newName
            renameBox.Text = ""
            setConfigStatus("Renamed " .. oldName .. " to " .. newName .. ".", true)
        else
            setConfigStatus("Rename failed: " .. tostring(err), false)
        end
    end)

    rows:Button("Set as autoload", function()
        local name, path = selectedConfig()
        if not name then return end
        if not isfile or not isfile(path) then
            setConfigStatus("Save this config before setting autoload.", false)
            return
        end
        local ok, err = pcall(function()
            ensureConfigDirectory()
            writefile(AutoLoadPath, name)
        end)
        if ok then
            setConfigStatus(name .. " will load automatically on startup.", true)
        else
            setConfigStatus("Autoload failed: " .. tostring(err), false)
        end
    end)

    rows:Button("Clear autoload", function()
        local ok, err = pcall(function()
            if isfile and isfile(AutoLoadPath) then delfile(AutoLoadPath) end
        end)
        if ok then
            setConfigStatus("Autoload cleared.", true)
        else
            setConfigStatus("Could not clear autoload: " .. tostring(err), false)
        end
    end)

    configTab.Update()
end

-- GUI (GuiTab.GuiScreen + MeteorGuiTheme settings) --------------

local guiTab = createTabWindow("GUI")
GuiLibrary.TabWindows.GUI = guiTab.Frame

do
    local rows = tabRows(guiTab.Content)

    rows:Button("Reset Layout", function()
        GuiLibrary:ResetLayout()
    end)
    rows:Button("Reset Colors", function()
        GuiLibrary:ResetColors()
    end)
    rows:Button("Copy", function()
        GuiLibrary:CopyTheme()
    end)
    rows:Button("Paste", function()
        GuiLibrary:PasteTheme()
    end)

    rows:Separator("General")
    rows:Slider("scale", 0.5, 2, Settings.scale, 2, function(value)
        GuiLibrary:SetScale(value)
    end)

    local alignments = { "Left", "Center", "Right" }
    rows:Dropdown("module-alignment", alignments, math.max(table.find(alignments, Settings.moduleAlignment) or 2, 1), function(name)
        Settings.moduleAlignment = name
        GuiLibrary:ArrangeWindows()
        save()
    end)

    rows:Toggle("modules-help-text", Settings.tooltips ~= false, function(state)
        Settings.tooltips = state
        if not state then Tooltip.Visible = false end
        save()
    end)

    rows:Separator("Colors")
    rows:Color("accent-color", "Accent")
    rows:Color("text-color", "Text")
    rows:Color("text-secondary-text-color", "TextSecondary")
    rows:Color("background-color", "Background")
    rows:Color("hovered-background-color", "BackgroundHovered")
    rows:Color("pressed-background-color", "BackgroundPressed")
    rows:Color("module-background-color", "ModuleBackground")
    rows:Color("outline-color", "Outline")
    rows:Color("separator-color", "Separator")
    rows:Color("slider-handle-color", "SliderHandle")
    rows:Color("slider-left-color", "SliderLeft")
    rows:Color("plus-color", "Plus")
    rows:Color("minus-color", "Minus")
    rows:Color("favorite-color", "Favorite")

    guiTab.Update()
end

-- HUD (HudTab.HudScreen) ---------------------------------------

local hudTab = createTabWindow("HUD")
GuiLibrary.TabWindows.HUD = hudTab.Frame

do
    local rows = tabRows(hudTab.Content)

    rows:Separator("General")
    local textScale = rows:Slider("text-scale", 0.5, 2, Settings.hudTextScale, 2, function(value)
        Settings.hudTextScale = value
        GuiLibrary:ApplyArraylistSettings()
        save()
    end)

    local border = rows:Slider("border", 0, 10, Settings.hudBorder, 0, function(value)
        Settings.hudBorder = value
        GuiLibrary:ApplyArraylistSettings()
        save()
    end)

    rows:Toggle("hide-in-menus", Settings.hideHud == true, function(state)
        Settings.hideHud = state
        GuiLibrary:UpdateArraylistVisibility()
        save()
    end)

    rows:Separator("")
    rows:ConfirmedButton("Clear", "Confirm", function()
        GuiLibrary:ClearArraylist()
    end)
    rows:ConfirmedButton("Reset to default elements", "Confirm", function()
        GuiLibrary:ResetArraylistElements()
    end)

    rows:Separator("")
    rows:Toggle("Active:", GuiLibrary.ArraylistVisible == true, function(state)
        GuiLibrary:SetArraylistVisible(state)
    end)
    rows:Button("Reset", function()
        Settings.hudTextScale = 1
        Settings.hudBorder = 4
        textScale:Set(1, false)
        border:Set(4, false)
        GuiLibrary:ApplyArraylistSettings()
        GuiLibrary:UpdateArraylistVisibility()
        save()
    end)

    hudTab.Update()
end

-- Friends (FriendsTab.FriendsScreen) ---------------------------

local friendsTab = createTabWindow("Friends", 360)
GuiLibrary.TabWindows.Friends = friendsTab.Frame

do
    local list = new("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        LayoutOrder = -1,
    }, friendsTab.Content)
    new("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, list)

    local emptyLabel = new("TextLabel", {
        Size = UDim2.new(1, 0, 0, 18),
        BackgroundTransparency = 1,
        Font = Palette.Font,
        TextSize = 12,
        TextColor3 = Palette.TextSecondary,
        TextXAlignment = Enum.TextXAlignment.Left,
        Text = "No friends added.",
        LayoutOrder = 0,
    }, list)

    local friendNames = Config.friends
    for index = #friendNames, 1, -1 do
        if type(friendNames[index]) ~= "string" then
            table.remove(friendNames, index)
        end
    end

    local friendRows = {}

    local function saveFriends()
        Config.friends = friendNames
        save()
    end

    local function rebuildFriends()
        for _, record in ipairs(friendRows) do
            record.Row:Destroy()
        end

        friendRows = {}
        emptyLabel.Visible = #friendNames == 0

        for index, name in ipairs(friendNames) do
            local row = new("Frame", {
                Size = UDim2.new(1, 0, 0, 20),
                BackgroundTransparency = 1,
                LayoutOrder = index,
            }, list)

            new("TextLabel", {
                Size = UDim2.new(1, -24, 1, 0),
                Position = UDim2.fromOffset(6, 0),
                BackgroundTransparency = 1,
                Font = Palette.Font,
                TextSize = 13,
                TextColor3 = Palette.Friend,
                TextXAlignment = Enum.TextXAlignment.Left,
                Text = name,
                TextTruncate = Enum.TextTruncate.AtEnd,
            }, row)

            local remove = new("TextButton", {
                Size = UDim2.fromOffset(16, 16),
                Position = UDim2.new(1, -6, 0.5, 0),
                AnchorPoint = Vector2.new(1, 0.5),
                BackgroundTransparency = 1,
                AutoButtonColor = false,
                Font = Palette.Font,
                TextSize = 14,
                TextColor3 = Palette.Minus,
                Text = "-",
            }, row)

            remove.MouseButton1Click:Connect(function()
                table.remove(friendNames, index)
                rebuildFriends()
                friendsTab.Update()
                saveFriends()
            end)

            table.insert(friendRows, { Row = row })
        end
    end

    new("Frame", {
        Size = UDim2.new(1, 0, 0, 1),
        BackgroundColor3 = Palette.Separator,
        BorderSizePixel = 0,
        LayoutOrder = 1,
    }, friendsTab.Content)

    local addRow = new("Frame", {
        Size = UDim2.new(1, 0, 0, 22),
        BackgroundTransparency = 1,
        LayoutOrder = 2,
    }, friendsTab.Content)

    local nameBox = new("TextBox", {
        Size = UDim2.new(1, -30, 1, 0),
        BackgroundColor3 = Palette.Background,
        BackgroundTransparency = 0.4,
        BorderSizePixel = 0,
        Font = Palette.Font,
        TextSize = 13,
        TextColor3 = Palette.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        Text = "",
        ClearTextOnFocus = false,
        ZIndex = 11,
    }, addRow)

    local addButton = new("TextButton", {
        Size = UDim2.fromOffset(22, 20),
        Position = UDim2.new(1, -2, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundColor3 = Palette.Background,
        BackgroundTransparency = BODY_TRANSPARENCY,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Font = Palette.Font,
        TextSize = 15,
        TextColor3 = Palette.Plus,
        Text = "+",
    }, addRow)

    local function addFriend()
        local name = string.gsub(nameBox.Text, "^%s*(.-)%s*$", "%1")
        if name == "" then return end

        table.insert(friendNames, name)
        nameBox.Text = ""
        rebuildFriends()
        friendsTab.Update()
        saveFriends()
    end

    addButton.MouseButton1Click:Connect(addFriend)
    nameBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then addFriend() end
    end)

    rebuildFriends()
    friendsTab.Update()
end

-- Macros (MacrosTab.MacrosScreen) ------------------------------
-- Meteor's macros run commands. The Roblox equivalent is a keybind that
-- toggles a module, so a macro stores its own key and the module it targets.

local macrosTab = createTabWindow("Macros", 360)
GuiLibrary.TabWindows.Macros = macrosTab.Frame

do
    local list = new("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        LayoutOrder = -1,
    }, macrosTab.Content)
    new("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, list)

    local emptyLabel = new("TextLabel", {
        Size = UDim2.new(1, 0, 0, 18),
        BackgroundTransparency = 1,
        Font = Palette.Font,
        TextSize = 12,
        TextColor3 = Palette.TextSecondary,
        TextXAlignment = Enum.TextXAlignment.Left,
        Text = "No macros created.",
        LayoutOrder = 0,
    }, list)

    local macros = Config.macros
    for index = #macros, 1, -1 do
        local macro = macros[index]
        if type(macro) ~= "table" then
            table.remove(macros, index)
        else
            macro.Name = tostring(macro.Name or ("Macro " .. index))
            macro.Keybind = macro.Keybind or "None"
            macro.Target = macro.Target or "None"
        end
    end

    local macroRows = {}

    local function moduleNames()
        local names = { "None" }
        for _, window in ipairs(GuiLibrary.WindowOrder) do
            for _, entry in ipairs(window.Modules) do
                if entry.Module and not entry.Module.SkipSearch then
                    table.insert(names, entry.Module.Name)
                end
            end
        end
        return names
    end

    local function findModule(moduleName)
        for _, window in ipairs(GuiLibrary.WindowOrder) do
            for _, entry in ipairs(window.Modules) do
                if entry.Module and entry.Module.Name == moduleName then
                    return entry.Module
                end
            end
        end
    end

    local function saveMacros()
        Config.macros = macros
        save()
    end

    -- Waits for the next key/mouse press and hands its name back.
    local function captureKey(callback)
        local token = (GuiLibrary.KeyCaptureToken or 0) + 1
        GuiLibrary.KeyCaptureToken = token
        GuiLibrary.CapturingKeybind = true

        local connection
        connection = UserInputService.InputBegan:Connect(function(input)
            local name = inputName(input)
            if not name then return end
            GuiLibrary.CapturingKeybind = false
            connection:Disconnect()
            callback(name)
        end)

        task.delay(4, function()
            if GuiLibrary.KeyCaptureToken ~= token then return end
            GuiLibrary.CapturingKeybind = false
            pcall(function() connection:Disconnect() end)
        end)
    end

    local function rebuildMacros()
        for _, record in ipairs(macroRows) do
            record.Row:Destroy()
        end

        macroRows = {}
        emptyLabel.Visible = #macros == 0

        for index, macro in ipairs(macros) do
            local row = new("Frame", {
                Size = UDim2.new(1, 0, 0, 22),
                BackgroundTransparency = 1,
                LayoutOrder = index,
            }, list)

            local nameArea = new("TextButton", {
                Size = UDim2.new(1, -160, 1, 0),
                Position = UDim2.fromOffset(6, 0),
                BackgroundTransparency = 1,
                AutoButtonColor = false,
                Text = "",
            }, row)

            local label = new("TextLabel", {
                Size = UDim2.fromScale(1, 1),
                BackgroundTransparency = 1,
                Font = Palette.Font,
                TextSize = 13,
                TextColor3 = Palette.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                Text = macro.Name,
                TextTruncate = Enum.TextTruncate.AtEnd,
            }, nameArea)

            local editBox = new("TextBox", {
                Size = UDim2.new(1, -160, 0, 18),
                Position = UDim2.fromOffset(6, 2),
                BackgroundColor3 = Palette.Background,
                BackgroundTransparency = 0.4,
                BorderSizePixel = 0,
                Font = Palette.Font,
                TextSize = 13,
                TextColor3 = Palette.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                Text = macro.Name,
                ClearTextOnFocus = false,
                Visible = false,
                ZIndex = 11,
            }, row)

            local function commit()
                local name = string.gsub(editBox.Text, "^%s*(.-)%s*$", "%1")
                if name ~= "" then macro.Name = name end
                editBox.Visible = false
                label.Visible = true
                label.Text = macro.Name
                saveMacros()
            end

            nameArea.MouseButton1Click:Connect(function()
                if editBox.Visible then
                    commit()
                else
                    label.Visible = false
                    editBox.Text = macro.Name
                    editBox.Visible = true
                    editBox:CaptureFocus()
                end
            end)
            editBox.FocusLost:Connect(commit)

            local target = new("TextButton", {
                Size = UDim2.fromOffset(68, 18),
                Position = UDim2.new(1, -152, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = Palette.Background,
                BackgroundTransparency = BODY_TRANSPARENCY,
                BorderSizePixel = 0,
                AutoButtonColor = false,
                Font = Palette.Font,
                TextSize = 12,
                TextColor3 = Palette.TextSecondary,
                Text = macro.Target,
                TextTruncate = Enum.TextTruncate.AtEnd,
            }, row)

            target.MouseButton1Click:Connect(function()
                local names = moduleNames()
                local current = table.find(names, macro.Target) or 1
                macro.Target = names[(current % #names) + 1]
                target.Text = macro.Target
                saveMacros()
            end)

            local key = new("TextButton", {
                Size = UDim2.fromOffset(56, 18),
                Position = UDim2.new(1, -80, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundTransparency = 1,
                AutoButtonColor = false,
                Font = Palette.Font,
                TextSize = 12,
                TextColor3 = Palette.Accent,
                Text = macro.Keybind,
                TextTruncate = Enum.TextTruncate.AtEnd,
            }, row)

            key.MouseButton1Click:Connect(function()
                key.Text = "..."
                captureKey(function(keyName)
                    macro.Keybind = keyName
                    key.Text = keyName
                    saveMacros()
                end)
            end)

            local remove = new("TextButton", {
                Size = UDim2.fromOffset(14, 16),
                Position = UDim2.new(1, -6, 0.5, 0),
                AnchorPoint = Vector2.new(1, 0.5),
                BackgroundTransparency = 1,
                AutoButtonColor = false,
                Font = Palette.Font,
                TextSize = 14,
                TextColor3 = Palette.Minus,
                Text = "-",
            }, row)

            remove.MouseButton1Click:Connect(function()
                table.remove(macros, index)
                rebuildMacros()
                macrosTab.Update()
                saveMacros()
            end)

            table.insert(macroRows, { Row = row })
        end
    end

    new("Frame", {
        Size = UDim2.new(1, 0, 0, 1),
        BackgroundColor3 = Palette.Separator,
        BorderSizePixel = 0,
        LayoutOrder = 1,
    }, macrosTab.Content)

    local create = new("TextButton", {
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundColor3 = Palette.Background,
        BackgroundTransparency = BODY_TRANSPARENCY,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Font = Palette.Font,
        TextSize = 13,
        TextColor3 = Palette.Text,
        Text = "Create",
        LayoutOrder = 2,
    }, macrosTab.Content)

    create.MouseEnter:Connect(function()
        create.BackgroundColor3 = Palette.BackgroundHovered
    end)
    create.MouseLeave:Connect(function()
        create.BackgroundColor3 = Palette.Background
    end)
    create.MouseButton1Click:Connect(function()
        table.insert(macros, { Name = "Macro " .. (#macros + 1), Keybind = "None", Target = "None" })
        rebuildMacros()
        macrosTab.Update()
        saveMacros()
    end)

    rebuildMacros()
    macrosTab.Update()

    -- a macro's key toggles the module it points at
    connect(UserInputService.InputBegan, function(input, gameProcessed)
        if GuiLibrary.CapturingKeybind then return end
        if input.UserInputType == Enum.UserInputType.Keyboard and gameProcessed then return end
        if UserInputService:GetFocusedTextBox() then return end

        local name = inputName(input)
        if not name then return end

        for _, macro in ipairs(macros) do
            if macro.Keybind ~= "None" and macro.Keybind == name then
                local moduleTab = findModule(macro.Target)
                if moduleTab then moduleTab:Toggle() end
                break
            end
        end
    end)
end

--==============================================================
-- Tab bar (the tabs at the top centre of Meteor's GUI)
--==============================================================

local TabNames = { "Modules", "Config", "GUI", "HUD", "Friends", "Macros" }
local TAB_HEIGHT = 22
local TAB_PAD = 6

local TabBar = new("Frame", {
    Name = "TabBar",
    Position = UDim2.new(0.5, 0, 0, 0),
    AnchorPoint = Vector2.new(0.5, 0),
    Size = UDim2.fromOffset(0, TAB_HEIGHT),
    AutomaticSize = Enum.AutomaticSize.X,
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ZIndex = 30,
}, GuiRoot)

new("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal,
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 0),
}, TabBar)

local TabButtons = {}

local function setActiveTab(tabName)
    GuiLibrary.ActiveTab = tabName

    for name, button in pairs(TabButtons) do
        button.BackgroundColor3 = name == tabName and Palette.BackgroundPressed or Palette.Background
    end

    local modulesTab = tabName == "Modules"

    for _, window in pairs(GuiLibrary.Windows) do
        if window.Refresh then window:Refresh() end
    end

    SearchWindow.Visible = modulesTab

    for name, frame in pairs(GuiLibrary.TabWindows or {}) do
        frame.Visible = name == tabName
    end

    if colorPicker then
        colorPicker.Frame.Visible = false
    end

    if not modulesTab then
        closeModuleScreen()
    end
end

for index, tabName in ipairs(TabNames) do
    local button = new("TextButton", {
        Name = tabName,
        Size = UDim2.fromOffset(math.ceil(textWidth(tabName, Palette.TextSize)) + TAB_PAD * 2, TAB_HEIGHT),
        BackgroundColor3 = Palette.Background,
        BackgroundTransparency = BODY_TRANSPARENCY,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Font = Palette.Font,
        TextSize = Palette.TextSize,
        TextColor3 = Palette.Text,
        Text = tabName,
        LayoutOrder = index,
        ZIndex = 30,
    }, TabBar)

    TabButtons[tabName] = button

    button.MouseEnter:Connect(function()
        if GuiLibrary.ActiveTab ~= tabName then
            button.BackgroundColor3 = Palette.BackgroundHovered
        end
    end)
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = GuiLibrary.ActiveTab == tabName and Palette.BackgroundPressed or Palette.Background
    end)
    button.MouseButton1Click:Connect(function()
        setActiveTab(tabName)
    end)
end

setActiveTab(GuiLibrary.ActiveTab)

--==============================================================
-- Visibility
--==============================================================

GuiLibrary.Visible = true

function GuiLibrary:SetVisible(state)
    self.Visible = state and true or false
    ScreenGui.Enabled = self.Visible
    if not self.Visible then
        Tooltip.Visible = false
        closeModuleScreen()
        if colorPicker then colorPicker.Frame.Visible = false end
    end
    self:UpdateArraylistVisibility()
    if updateMobileIcon then updateMobileIcon() end
end

function GuiLibrary:Toggle()
    self:SetVisible(not self.Visible)
end

-- GUI tab: scale ----------------------------------------------

function GuiLibrary:SetScale(value)
    value = math.clamp(tonumber(value) or 1, 0.5, 2)
    Settings.scale = value

    GuiScale.Scale = value
    GuiRoot.Size = UDim2.fromScale(1 / value, 1 / value)

    save()
end

-- Config tab: font ---------------------------------------------

function GuiLibrary:SetFont(font)
    local previous = Palette.Font
    if previous == font then return end

    Palette.Font = font

    for _, descendant in ipairs(GuiRoot:GetDescendants()) do
        if descendant:IsA("TextLabel") or descendant:IsA("TextButton") or descendant:IsA("TextBox") then
            if descendant.Font == previous then
                descendant.Font = font
            end
        end
    end

    for _, item in ipairs(ArrayItems) do
        item.Font = font
    end

    save()
end

-- GUI tab: colours ---------------------------------------------

function GuiLibrary:SetPaletteColor(key, color)
    local previous = Palette[key]
    if typeof(previous) ~= "Color3" or previous == color then return end

    Palette[key] = color
    if key == "Accent" then
        Palette.Checkbox = color
        Palette.Color = color
    elseif key == "SliderLeft" then
        Palette.Color2 = color
    end
    rebuildThemeLookup()

    for _, record in ipairs(ThemeRegistry[key] or {}) do
        pcall(function()
            record.Instance[record.Property] = color
        end)
    end

    Settings.colors = Settings.colors or {}
    Settings.colors[key] = {
        math.round(color.R * 255),
        math.round(color.G * 255),
        math.round(color.B * 255),
    }
    save()
end

function GuiLibrary:ResetColors()
    for _, key in ipairs(ThemeKeys) do
        GuiLibrary:SetPaletteColor(key, PaletteDefaults[key])
    end
    Settings.colors = nil
    save()
end

function GuiLibrary:CopyTheme()
    local snapshot = {}
    for _, key in ipairs(ThemeKeys) do
        local color = Palette[key]
        snapshot[key] = {
            math.round(color.R * 255),
            math.round(color.G * 255),
            math.round(color.B * 255),
        }
    end

    Settings.copiedTheme = snapshot
    save()
    print("Meteor GUI: theme copied")
end

function GuiLibrary:PasteTheme()
    local snapshot = Settings.copiedTheme
    if type(snapshot) ~= "table" then
        print("Meteor GUI: nothing to paste")
        return
    end

    for _, key in ipairs(ThemeKeys) do
        local rgb = snapshot[key]
        if type(rgb) == "table" and rgb[1] and rgb[2] and rgb[3] then
            GuiLibrary:SetPaletteColor(key, Color3.fromRGB(rgb[1], rgb[2], rgb[3]))
        end
    end
end

-- GUI tab: module alignment ------------------------------------

function GuiLibrary:ArrangeWindows()
    local view = layoutSize()
    local scale = uiScale()
    local alignment = Settings.moduleAlignment or "Center"

    for _, window in ipairs(self.WindowOrder) do
        local frame = window.Frame
        if frame then
            local size = frame.AbsoluteSize / scale
            local y = frame.Position.Y.Scale * view.Y + frame.Position.Y.Offset - size.Y * frame.AnchorPoint.Y

            local x
            if alignment == "Left" then
                x = 8
            elseif alignment == "Right" then
                x = view.X - size.X - 8
            else
                x = (view.X - size.X) / 2
            end

            frame.AnchorPoint = Vector2.zero
            frame.Position = UDim2.fromOffset(
                math.round(math.clamp(x, 0, math.max(view.X - size.X, 0))),
                math.round(math.clamp(y, 0, math.max(view.Y - size.Y, 0)))
            )
        end
    end
end

function GuiLibrary:ResetLayout()
    for _, window in ipairs(self.WindowOrder) do
        if window.ResetPosition then window:ResetPosition() end
    end

    SearchWindow.AnchorPoint = Vector2.new(0.5, 0)
    SearchWindow.Position = UDim2.new(0.5, 0, 0, 40)

    for _, frame in pairs(self.TabWindows or {}) do
        frame.AnchorPoint = Vector2.new(0.5, 0.5)
        frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    end

    for _, saved in pairs(Config.windows) do
        saved.Position = nil
    end

    self:ArrangeWindows()
    save()
end

GuiLibrary:SetScale(Settings.scale or 1)
GuiLibrary:ApplyArraylistSettings()
GuiLibrary:UpdateArraylistVisibility()

function GuiLibrary:Destroy()
    for _, connection in ipairs(self.Connections) do
        pcall(function() connection:Disconnect() end)
    end
    self.Connections = {}
    if self.MobileGui then self.MobileGui:Destroy() end
    if self.HudGui then self.HudGui:Destroy() end
    ScreenGui:Destroy()
end

connect(UserInputService.InputBegan, function(input, gameProcessed)
    if GuiLibrary.CapturingKeybind then return end
    if input.UserInputType == Enum.UserInputType.Keyboard and gameProcessed then return end
    if UserInputService:GetFocusedTextBox() then return end

    if input.KeyCode == Enum.KeyCode.RightShift then
        GuiLibrary:Toggle()
    elseif input.UserInputType == Enum.UserInputType.Gamepad1 and input.KeyCode == Enum.KeyCode.DPadDown then
        GuiLibrary:Toggle()
    end
end)

--==============================================================
-- Demo
--==============================================================

GuiLibrary:CreateWindow("Main")
GuiLibrary:CreateWindow("Combat")
GuiLibrary:CreateWindow("Movement")
GuiLibrary:CreateWindow("Player")
GuiLibrary:CreateWindow("Render")
GuiLibrary:CreateWindow("Extra")

-- category windows start closed; config can restore them
GuiLibrary.Windows.Combat:SetVisible(false)
GuiLibrary.Windows.Movement:SetVisible(false)
GuiLibrary.Windows.Player:SetVisible(false)
GuiLibrary.Windows.Render:SetVisible(false)
GuiLibrary.Windows.Extra:SetVisible(false)

local function categoryToggle(windowName)
    return GuiLibrary.Windows.Main:CreateModule({
        Name = windowName,
        Description = "Shows the " .. windowName .. " window.",
        Array = false,
        SkipSearch = true,
        Function = function(state)
            local window = GuiLibrary.Windows[windowName]
            if window then
                window:SetVisible(state)
            end
        end,
    })
end

categoryToggle("Combat")
categoryToggle("Movement")
categoryToggle("Player")
categoryToggle("Render")
categoryToggle("Extra")

GuiLibrary.Windows.Combat:CreateButton({
    Name = "Button",
    Function = function()
        print("Hello World! Button Clicked!")
    end,
})

local KillAura = GuiLibrary.Windows.Combat:CreateModule({
    Name = "KillAura",
    Description = "Attacks entities around you.",
})

KillAura:CreateToggle({ Name = "Only Players", Default = true })
KillAura:CreateSlider({ Name = "Range", Min = 1, Max = 6, Default = 3.5, Decimals = 1 })
KillAura:CreateSlider({ Name = "CPS", Min = 1, Max = 20, Default = 8 })
KillAura:CreatePicker({
    Name = "Rotations",
    Options = { "None", "Legit", "NCP", "Packet" },
    Default = "Legit",
})

local Sprint = GuiLibrary.Windows.Movement:CreateModule({
    Name = "Sprint",
    Description = "Sprints automatically.",
})
Sprint:CreateToggle({ Name = "Omni", Default = false })

local ESP = GuiLibrary.Windows.Render:CreateModule({
    Name = "ESP",
    Description = "Highlights entities through walls.",
})
ESP:CreatePicker({ Name = "Mode", Options = { "Box", "Glow", "2D" }, Default = "Box" })
ESP:CreateSlider({ Name = "Range", Min = 16, Max = 256, Default = 64, Step = 8 })

local Arraylist = GuiLibrary.Windows.Render:CreateModule({
    Name = "Arraylist",
    Description = "Lists enabled modules in the top right.",
    Array = true,
    Function = function(state)
        GuiLibrary:SetArraylistVisible(state)
    end,
})

Arraylist:CreateToggle({ Name = "Shadow", Default = true })

local Extra = GuiLibrary.Windows.Extra:CreateModule({
    Name = "Test",
    Description = "Example module with a few settings.",
})

Extra:CreateToggle({ Name = "Toggle", Default = false })
Extra:CreateSlider({ Name = "Slider", Min = 0, Max = 100, Default = 50 })
Extra:CreatePicker({ Name = "Picker", Options = { "One", "Two", "Three" }, Default = "One" })
Extra:CreateTextBox({
    Name = "Text",
    Placeholder = "Text",
    Default = "Meteor",
    Function = function(value)
        print("Text: " .. value)
    end,
})
Extra:CreateButton({
    Name = "Print",
    Function = function()
        print("Meteor UI Library " .. GuiLibrary.Info.Version)
    end,
})

GuiLibrary.Windows.Extra:CreateButton({
    Name = "Reset bind",
    Function = function()
        Extra:SetKeybind("None")
    end,
})

-- Window buttons can hold settings too: right click (hold on touch) opens them.
local GreetMessage = "Hello World!"

local Greet = GuiLibrary.Windows.Extra:CreateButton({
    Name = "Greet",
    Description = "Prints the message set in its settings.",
    Function = function()
        print(GreetMessage)
    end,
})

Greet:CreateTextBox({
    Name = "Message",
    Placeholder = "Message",
    Default = GreetMessage,
    Function = function(value)
        GreetMessage = value
    end,
})

Greet:CreateToggle({
    Name = "Print twice",
    Default = false,
    Function = function(state)
        if state then
            print(GreetMessage)
        end
    end,
})

shared.GuiLibrary = GuiLibrary
