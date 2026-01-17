local Players = game:GetService("Players")

local PlayerESP = {}

local running = false
local loopThread

local function applyESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer then
            local char = player.Character
            if char and not char:FindFirstChild("PlayerESP_Highlight") then
                local h = Instance.new("Highlight")
                h.Name = "PlayerESP_Highlight"
                h.FillTransparency = 0.5
                h.OutlineTransparency = 0
                h.Parent = char
            end
        end
    end
end

local function clearESP()
    for _, player in ipairs(Players:GetPlayers()) do
        local char = player.Character
        if char then
            local h = char:FindFirstChild("PlayerESP_Highlight")
            if h then
                h:Destroy()
            end
        end
    end
end

local function espLoop()
    while running do
        applyESP()
        task.wait()
    end
    clearESP()
end

function PlayerESP.start()
    if running then return end
    running = true
    loopThread = task.spawn(espLoop)
end

function PlayerESP.stop()
    running = false
end

return PlayerESP
