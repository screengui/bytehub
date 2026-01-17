local Lighting = game:GetService("Lighting")

local Fullbright = {}

local originalSettings = {}
local clockTimeConnection = nil
local running = false

local function enable()
    if running then return end
    running = true

    -- Save original settings once
    if not originalSettings.Brightness then
        originalSettings.Brightness = Lighting.Brightness
        originalSettings.ClockTime = Lighting.ClockTime
        originalSettings.FogEnd = Lighting.FogEnd
        originalSettings.GlobalShadows = Lighting.GlobalShadows
        originalSettings.OutdoorAmbient = Lighting.OutdoorAmbient
    end

    Lighting.Brightness = 2
    Lighting.ClockTime = 14
    Lighting.FogEnd = 100000
    Lighting.GlobalShadows = false
    Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)

    clockTimeConnection = Lighting:GetPropertyChangedSignal("ClockTime"):Connect(function()
        if Lighting.ClockTime < 6 or Lighting.ClockTime > 15 then
            Lighting.ClockTime = 14
        end
    end)
end

local function disable()
    running = false

    if clockTimeConnection then
        clockTimeConnection:Disconnect()
        clockTimeConnection = nil
    end

    if originalSettings.Brightness then
        Lighting.Brightness = originalSettings.Brightness
        Lighting.ClockTime = originalSettings.ClockTime
        Lighting.FogEnd = originalSettings.FogEnd
        Lighting.GlobalShadows = originalSettings.GlobalShadows
        Lighting.OutdoorAmbient = originalSettings.OutdoorAmbient
    end
end

function Fullbright.start()
    enable()
end

function Fullbright.stop()
    disable()
end

return Fullbright
