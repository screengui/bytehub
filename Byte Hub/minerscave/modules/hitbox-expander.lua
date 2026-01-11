local RunService = game:GetService("RunService")

local function changeTorsoSize(player, size, Massless, transparency)
    local character = player.Character or player.CharacterAdded:Wait()
    local torso = character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
    if torso then
        torso.Size = size  
        torso.Massless = Massless  
        torso.Transparency = transparency
    end
end

if _G.HitboxExpander then
    connection = RunService.Heartbeat:Connect(function()
        for _, player in ipairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer then
                changeTorsoSize(player, Vector3.new(10, 10, 10), true, 0.999)
            end
        end
    end)
else
    if connection then connection:Disconnect() end
        for _, player in ipairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer then
                changeTorsoSize(player, Vector3.new(2, 2, 1), true, 0)
            end
        end
    end
end
