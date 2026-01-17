local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

local RainbowCrosshair = {}
RainbowCrosshair._conn = nil
RainbowCrosshair._running = false

local function showDefaultCrosshair(show)
    for _, v in ipairs(LocalPlayer.PlayerGui.HUDGui:GetChildren()) do
        if v.Name == "Crosshair" then
            v.Visible = show
        end
    end
end

function RainbowCrosshair.start(CrosshairSettings, Camera)
    if RainbowCrosshair._running then return end
    RainbowCrosshair._running = true

    showDefaultCrosshair(false)

    RainbowCrosshair._conn = RunService.RenderStepped:Connect(function()
        local viewport = Camera.ViewportSize / 2
        local axisX, axisY = viewport.X, viewport.Y
        local size = CrosshairSettings.Size / 2

        local hue = (tick() * 0.2) % 1
        local rainbowColor = Color3.fromHSV(hue, 1, 1)

        -- Horizontal
        local H = CrosshairSettings.HorizontalLine
        H.Color = rainbowColor
        H.Thickness = CrosshairSettings.Thickness
        H.Transparency = CrosshairSettings.Transparency
        H.Visible = true
        H.From = Vector2.new(axisX - size, axisY)
        H.To   = Vector2.new(axisX + size, axisY)

        -- Vertical
        local V = CrosshairSettings.VerticalLine
        V.Color = rainbowColor
        V.Thickness = CrosshairSettings.Thickness
        V.Transparency = CrosshairSettings.Transparency
        V.Visible = true
        V.From = Vector2.new(axisX, axisY - size)
        V.To   = Vector2.new(axisX, axisY + size)
    end)
end

function RainbowCrosshair.stop(CrosshairSettings)
    RainbowCrosshair._running = false

    if RainbowCrosshair._conn then
        RainbowCrosshair._conn:Disconnect()
        RainbowCrosshair._conn = nil
    end

    CrosshairSettings.HorizontalLine.Visible = false
    CrosshairSettings.VerticalLine.Visible = false

    showDefaultCrosshair(true)
end

return RainbowCrosshair
