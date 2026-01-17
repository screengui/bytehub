local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local CrosshairPlus = {}
CrosshairPlus._running = false

local function showDefaultCrosshair(show)
    for _, v in ipairs(LocalPlayer.PlayerGui.HUDGui:GetChildren()) do
        if v.Name == "Crosshair" then
            v.Visible = show
        end
    end
end

function CrosshairPlus.start(CrosshairSettings, Camera)
    CrosshairPlus._running = true

    showDefaultCrosshair(false)

    local viewport = Camera.ViewportSize / 2
    local axisX, axisY = viewport.X, viewport.Y
    local size = CrosshairSettings.Size / 2

    -- Horizontal
    local H = CrosshairSettings.HorizontalLine
    H.Color = CrosshairSettings.Color
    H.Thickness = CrosshairSettings.Thickness
    H.Transparency = CrosshairSettings.Transparency
    H.Visible = true
    H.From = Vector2.new(axisX - size, axisY)
    H.To   = Vector2.new(axisX + size, axisY)

    -- Vertical
    local V = CrosshairSettings.VerticalLine
    V.Color = CrosshairSettings.Color
    V.Thickness = CrosshairSettings.Thickness
    V.Transparency = CrosshairSettings.Transparency
    V.Visible = true
    V.From = Vector2.new(axisX, axisY - size)
    V.To   = Vector2.new(axisX, axisY + size)
end

function CrosshairPlus.stop(CrosshairSettings)
    CrosshairPlus._running = false

    CrosshairSettings.HorizontalLine.Visible = false
    CrosshairSettings.VerticalLine.Visible = false

    showDefaultCrosshair(true)
end

return CrosshairPlus
