--[[
    Meteor UI Library — example script
    ----------------------------------
    Shows how to load the library and build a window with modules, settings,
    binds and buttons.

    Controls:
      RightShift            show / hide the whole GUI
      Left click a module   toggle it
      Right click a module  open its settings screen (on touch, hold ~0.35s)
      Drag a window header  move it
      Chevron in the header collapse / expand the window

    The library builds no windows by itself: this script creates the demo
    windows (Main, Combat, Movement, Player, Render, Extra) that the library
    used to ship, then adds the "Example" window on top of them.
]]

local LIBRARY_URL = "https://raw.githubusercontent.com/screengui/bytehub/refs/heads/main/Byte%20Hub/assets/ui/meteor-library.lua"

-- Reuse the library if the script is re-executed, so we don't stack GUIs.
if not shared.GuiLibrary then
    loadstring(game:HttpGet(LIBRARY_URL, true))()
end

local GuiLibrary = shared.GuiLibrary
assert(GuiLibrary, "Meteor UI Library failed to load")

--==============================================================
-- Demo windows
--==============================================================
-- The library ships no windows of its own, so everything the old demo
-- build used to create lives here: Meteor's category windows, the modules
-- inside them, and the settings each module shows.

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


local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer

--==============================================================
-- Window
--==============================================================

local Example = GuiLibrary:CreateWindow("Example")

-- Place the example window on its own line below the demo windows so it never
-- sticks out past the right or bottom edge of the screen.
do
    local camera = workspace.CurrentCamera
    local viewport = camera and camera.ViewportSize or Vector2.new(1280, 720)
    local y = 40
    for _, window in ipairs(GuiLibrary.WindowOrder) do
        if window ~= Example then
            -- AbsoluteSize can still be 0 on the frame the window is created,
            -- so fall back to the size the library just assigned.
            local height = math.max(window.Frame.AbsoluteSize.Y, window.Frame.Size.Y.Offset)
            y = math.max(y, window.Frame.Position.Y.Offset + height + 8)
        end
    end

    Example.Frame.Position = UDim2.fromOffset(8, math.clamp(y, 40, math.max(viewport.Y - 120, 40)))
end

-- Plain text and section headers inside a window.
Example:CreateLabel({
    Text = "This window is built by meteor-example.lua — every widget below is a few lines of Lua.",
    Name = "Intro",
})
Example:CreateSeparator({ Name = "Modules" })

--==============================================================
-- A module with real settings
--==============================================================

-- Module: Toggle = the module itself. Settings = the rows inside its
-- right-click screen. Nothing runs until the user enables it.

local lightingState = {
    Enabled = false,
    Brightness = 2,
    Time = "Day",
}
local savedLighting = nil
local restoreOnDisable = true

local TIMES = { Day = 14, Sunset = 18, Night = 2 }

local function applyLighting()
    if not lightingState.Enabled then
        -- Put the game's lighting back the way we found it.
        if savedLighting then
            if restoreOnDisable then
                Lighting.Brightness = savedLighting.Brightness
                Lighting.ClockTime = savedLighting.ClockTime
            end
            savedLighting = nil
        end
        return
    end

    savedLighting = savedLighting or {
        Brightness = Lighting.Brightness,
        ClockTime = Lighting.ClockTime,
    }

    Lighting.Brightness = lightingState.Brightness
    Lighting.ClockTime = TIMES[lightingState.Time] or 14
end

local Ambience = Example:CreateModule({
    Name = "Ambience",
    Description = "Overrides the world lighting while enabled.",
    Function = function(enabled)
        lightingState.Enabled = enabled
        applyLighting()
    end,
})

-- Slider: Function fires while dragging, and the value is saved when released.
Ambience:CreateSlider({
    Name = "Brightness",
    Min = 0,
    Max = 3,
    Default = 2,
    Decimals = 1,
    Function = function(value)
        lightingState.Brightness = value
        applyLighting()
    end,
})

-- Picker: Function fires with the chosen option (right click cycles backwards).
Ambience:CreatePicker({
    Name = "Time",
    Options = { "Day", "Sunset", "Night" },
    Default = "Day",
    Function = function(option)
        lightingState.Time = option
        applyLighting()
    end,
})

-- A checkbox row inside the settings screen (state is saved automatically).
Ambience:CreateToggle({
    Name = "Restore lighting",
    Default = true,
    Function = function(state)
        restoreOnDisable = state
    end,
})

-- A button inside the settings screen.
Ambience:CreateButton({
    Name = "Print current values",
    Function = function()
        print(("[Meteor example] brightness %.1f, time %s")
            :format(lightingState.Brightness, lightingState.Time))
    end,
})

--==============================================================
-- A toggle-only module
--==============================================================

local announceWithTime = false

local Announcer = Example:CreateModule({
    Name = "Announcer",
    Description = "Prints a line when you toggle it.",
    Function = function(enabled)
        if enabled and announceWithTime then
            print(("[Meteor example] Announcer enabled at %s"):format(os.date("%H:%M:%S")))
        else
            print(("[Meteor example] Announcer %s"):format(enabled and "enabled" or "disabled"))
        end
    end,
})

Announcer:CreateToggle({
    Name = "Include time",
    Default = false,
    Function = function(state)
        announceWithTime = state
    end,
})

-- Modules can be driven from code too:
--   Announcer:Toggle()
--   Announcer:SetEnabled(true)
--   Announcer:SetKeybind("F")     -- same as clicking its Bind row
--   Ambience:CreateSettings()     -- same as right clicking it

--==============================================================
-- Window buttons
--==============================================================

Example:CreateSeparator({ Name = "Actions" })

Example:CreateButton({
    Name = "Toggle Ambience",
    Function = function()
        Ambience:Toggle()
    end,
})

Example:CreateButton({
    Name = "Toggle the GUI (RightShift)",
    Function = function()
        GuiLibrary:Toggle()
    end,
})

Example:CreateButton({
    Name = "Open Ambience settings",
    Function = function()
        Ambience:CreateSettings()
    end,
})

Example:CreateButton({
    Name = "Remove this GUI",
    Function = function()
        GuiLibrary:Destroy()
        shared.GuiLibrary = nil
    end,
})
