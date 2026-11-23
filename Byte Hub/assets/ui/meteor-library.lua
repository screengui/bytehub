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

    API
      GuiLibrary:CreateWindow(name)              -> window
      window:CreateModule{ Name, Description, Function, Array, Default }
      window:CreateButton{ Name, Function }
      window:CreateLabel{ Text }
      window:CreateSeparator{ Name }
      module:CreateToggle{ Name, Default, Function }
      module:CreateSlider{ Name, Min, Max, Default, Decimals, Step, Function }
      module:CreatePicker{ Name, Options, Default, Function }
      module:CreateButton{ Name, Function }
      module:CreateSeparator{ Name }
      module:CreateSettings()                    -- opens the module screen
      module:SetEnabled(bool), module:Toggle(), module:SetKeybind(key)
      GuiLibrary:Toggle() / GuiLibrary:SetVisible(bool)
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
GuiLibrary.Connections = {}
GuiLibrary.CapturingKeybind = false
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
}

-- backwards compatible aliases used by older scripts
Palette.Color = Palette.Accent
Palette.Color2 = Palette.SliderLeft
GuiLibrary.Palette = Palette

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

local ConfigPath = "Meteor/Configs/config.json"
local LegacyConfigPath = "Blaze/Configs/config.json"
local Config = { windows = {}, modules = {} }

local function save()
    if RunService:IsStudio() or not writefile then return end

    local ok = pcall(function()
        if isfolder then
            if not isfolder("Meteor") then makefolder("Meteor") end
            if not isfolder("Meteor/Configs") then makefolder("Meteor/Configs") end
        end
        if isfile and isfile(ConfigPath) then delfile(ConfigPath) end
        writefile(ConfigPath, HttpService:JSONEncode(Config))
    end)

    return ok
end

local function loadConfig()
    if RunService:IsStudio() or not isfile then return end

    local path
    if isfile(ConfigPath) then
        path = ConfigPath
    elseif isfile(LegacyConfigPath) then
        path = LegacyConfigPath
    end
    if not path then return end

    local ok, raw = pcall(function()
        return HttpService:JSONDecode(readfile(path))
    end)
    if not ok or type(raw) ~= "table" then return end

    local loaded = {
        windows = type(raw.windows) == "table" and raw.windows or {},
        modules = type(raw.modules) == "table" and raw.modules or {},
    }

    -- migrate the old flat format: Config[moduleName] = { Name = windowName, ... }
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

    Config = loaded
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

-- Tooltip ------------------------------------------------------

local Tooltip = new("Frame", {
    Size = UDim2.fromOffset(0, 0),
    AutomaticSize = Enum.AutomaticSize.XY,
    BackgroundColor3 = Palette.BackgroundHovered,
    BackgroundTransparency = 0.05,
    BorderSizePixel = 0,
    Visible = false,
    ZIndex = 120,
}, ScreenGui)
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
        TooltipLabel.Text = text
        Tooltip.Visible = true
    end)
    guiObject.MouseLeave:Connect(function()
        Tooltip.Visible = false
    end)
end

connect(RunService.RenderStepped, function()
    if not Tooltip.Visible then return end
    local mouse = UserInputService:GetMouseLocation()
    local viewport = viewportSize()
    Tooltip.Position = UDim2.fromOffset(
        math.clamp(mouse.X + 14, 0, math.max(viewport.X - Tooltip.AbsoluteSize.X - 4, 0)),
        math.clamp(mouse.Y + 14, 0, math.max(viewport.Y - Tooltip.AbsoluteSize.Y - 4, 0))
    )
end)

-- Search -------------------------------------------------------

local SearchFrame = new("Frame", {
    Size = UDim2.fromOffset(200, 24),
    Position = UDim2.new(0.5, 0, 0, 40),
    AnchorPoint = Vector2.new(0.5, 0),
    BackgroundColor3 = Palette.Background,
    BackgroundTransparency = BODY_TRANSPARENCY,
    BorderSizePixel = 0,
    ZIndex = 5,
}, ScreenGui)
new("UIStroke", { Color = Palette.Outline, Thickness = 1, Transparency = 0.3 }, SearchFrame)

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
    ZIndex = 6,
}, SearchFrame)

local function applySearch(query)
    for _, window in pairs(GuiLibrary.Windows) do
        if window.ApplyFilter then
            window:ApplyFilter(query)
        end
    end
end

connect(SearchBox:GetPropertyChangedSignal("Text"), function()
    applySearch(SearchBox.Text)
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
}, ScreenGui)

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
        TextSize = 16,
        TextColor3 = Palette.Accent,
        TextStrokeColor3 = Palette.Outline,
        TextStrokeTransparency = 0.6,
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

function GuiLibrary:SetArraylistVisible(state)
    ArrayFrame.Visible = state and true or false
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

local function makeDraggable(handle, frame, onEnd)
    local dragging = false
    local dragStart, startOffset

    handle.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
            and input.UserInputType ~= Enum.UserInputType.Touch then return end

        if frame.AnchorPoint ~= Vector2.zero then
            frame.AnchorPoint = Vector2.zero
            frame.Position = UDim2.fromOffset(frame.AbsolutePosition.X, frame.AbsolutePosition.Y)
        end

        dragging = true
        dragStart = input.Position
        startOffset = Vector2.new(frame.Position.X.Offset, frame.Position.Y.Offset)
    end)

    connect(UserInputService.InputChanged, function(input)
        if not dragging then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement
            and input.UserInputType ~= Enum.UserInputType.Touch then return end

        local delta = input.Position - dragStart
        local position = startOffset + delta

        local viewport = viewportSize()
        local size = frame.AbsoluteSize
        position = Vector2.new(
            math.clamp(position.X, 0, math.max(viewport.X - size.X, 0)),
            math.clamp(position.Y, 0, math.max(viewport.Y - size.Y, 0))
        )

        frame.Position = UDim2.fromOffset(position.X, position.Y)
    end)

    connect(UserInputService.InputEnded, function(input)
        if not dragging then return end
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
            and input.UserInputType ~= Enum.UserInputType.Touch then return end

        dragging = false
        if onEnd then onEnd() end
    end)
end

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
    }, ScreenGui)

    ModuleFrame = new("Frame", {
        Size = UDim2.fromOffset(280, 300),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Palette.Background,
        BackgroundTransparency = BODY_TRANSPARENCY,
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = 91,
    }, ScreenGui)
    new("UIStroke", { Color = Palette.Outline, Thickness = 1, Transparency = 0.2 }, ModuleFrame)

    local header = new("Frame", {
        Size = UDim2.new(1, 0, 0, HEADER_HEIGHT),
        BackgroundColor3 = Palette.Accent,
        BorderSizePixel = 0,
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
        Padding = UDim2.fromOffset(0, 2),
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

    addSeparator(ModuleContent, "Module")
    moduleTab.EnabledRow = createToggleRow(ModuleContent, "Enabled", moduleTab.Enabled, function(state)
        moduleTab:SetEnabled(state)
    end)

    if moduleTab.SettingCount > 0 then
        addSeparator(ModuleContent, "Settings")
        moduleTab.SettingsContainer.Parent = ModuleContent
    end

    addSeparator(ModuleContent, "Bind")
    moduleTab.BindRow = createBindRow(ModuleContent,
        function() return moduleTab.Keybind end,
        function(value) moduleTab:SetKeybind(value) end
    )

    ModuleOverlay.Visible = true
    ModuleFrame.Visible = true
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

    local viewport = viewportSize()
    local perRow = math.max(math.floor((viewport.X - 16) / 140), 1)
    local column = WindowCount % perRow
    local line = math.floor(WindowCount / perRow)
    local defaultX = 8 + column * 140
    local defaultY = 40 + line * 34

    if type(saved.Position) == "table" and saved.Position.X and saved.Position.Y then
        defaultX, defaultY = saved.Position.X, saved.Position.Y
    end

    local Window = new("Frame", {
        Name = name,
        Position = UDim2.fromOffset(defaultX, defaultY),
        Size = UDim2.fromOffset(WINDOW_MIN_WIDTH, HEADER_HEIGHT),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Active = true,
        Visible = wantedVisible,
        ZIndex = 2,
    }, ScreenGui)
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
            local maxHeight = math.clamp(viewportSize().Y * 0.7, 140, 560)
            bodyHeight = math.clamp(Layout.AbsoluteContentSize.Y, 0, maxHeight)
        end

        Body.Size = UDim2.new(1, 0, 0, bodyHeight)
        Window.Size = UDim2.fromOffset(width, HEADER_HEIGHT + bodyHeight)
        Window.Visible = wantedVisible and (not filterActive or hasMatch)

        updating = false
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
            Instance = Row,
            SettingsContainer = SettingsContainer,
            SettingCount = 0,
            OnToggle = Table.Function,
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

        -- ---- settings widgets ---------------------------------
        -- everything below is created inside the module's settings container,
        -- which the module screen reparents while it is open.

        function ModuleTab:CreateToggle(Table)
            local configValue = settingsConfig.Settings[Table.Name]
            if type(configValue) ~= "boolean" then
                configValue = Table.Default == true
                settingsConfig.Settings[Table.Name] = configValue
            end

            local widget = createToggleRow(SettingsContainer, Table.Name, configValue, function(state)
                settingsConfig.Settings[Table.Name] = state
                if Table.Function then pcall(Table.Function, state) end
            end)

            self.SettingCount += 1
            return widget
        end

        function ModuleTab:CreateSlider(Table)
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

            self.SettingCount += 1
            return slider
        end

        function ModuleTab:CreatePicker(Table)
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

            self.SettingCount += 1
            return picker
        end

        function ModuleTab:CreateButton(Table)
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

            self.SettingCount += 1
            return row
        end

        function ModuleTab:CreateLabel(Table)
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

            self.SettingCount += 1
            return label
        end

        function ModuleTab:CreateSeparator(Table)
            local separator = addSeparator(SettingsContainer, Table and Table.Name)
            self.SettingCount += 1
            return separator
        end

        return ModuleTab
    end

    function WindowObject:CreateButton(Table)
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

        Button.MouseEnter:Connect(function()
            tweenTo(Button, { BackgroundColor3 = Palette.BackgroundPressed }, 0.1)
        end)
        Button.MouseLeave:Connect(function()
            tweenTo(Button, { BackgroundColor3 = Palette.BackgroundHovered }, 0.1)
        end)
        Button.MouseButton1Click:Connect(function()
            if Table.Function then pcall(Table.Function) end
        end)

        table.insert(self.Modules, { Name = Table.Name, Instance = Button })
        ensureWidth(Table.Name)
        update()
        applySearch(SearchBox.Text)

        return Button
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

    makeDraggable(Header, Window, function()
        saved.Position = {
            X = Window.AbsolutePosition.X,
            Y = Window.AbsolutePosition.Y,
        }
        save()
    end)

    connect(Layout:GetPropertyChangedSignal("AbsoluteContentSize"), update)
    connect(Content:GetPropertyChangedSignal("AbsoluteSize"), update)

    update()

    self.Windows[name] = WindowObject
    GuiLibrary.Windows[name] = WindowObject
    WindowCount += 1

    if SearchBox.Text ~= "" then
        WindowObject:ApplyFilter(SearchBox.Text)
    end

    return WindowObject
end

GuiLibrary.GetWindow = function(self, name)
    return self.Windows[name]
end

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
    end
end

function GuiLibrary:Toggle()
    self:SetVisible(not self.Visible)
end

function GuiLibrary:Destroy()
    for _, connection in ipairs(self.Connections) do
        pcall(function() connection:Disconnect() end)
    end
    self.Connections = {}
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

shared.GuiLibrary = GuiLibrary
