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

    Note: the library creates its own demo windows (Main, Combat, Movement,
    Player, Render, Extra) every time it runs. The "Example" window below is
    added on top of those.
]]

local LIBRARY_URL = "https://raw.githubusercontent.com/screengui/bytehub/refs/heads/main/Byte%20Hub/assets/ui/meteor-library.lua"

-- Reuse the library if the script is re-executed, so we don't stack GUIs.
if not shared.GuiLibrary then
    loadstring(game:HttpGet(LIBRARY_URL, true))()
end

local GuiLibrary = shared.GuiLibrary
assert(GuiLibrary, "Meteor UI Library failed to load")

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
