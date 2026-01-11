loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/bytehub/refs/heads/main/Byte%20Hub/minerscave/modules/Essentials.lua"))()
local function checkHealth()
    local character = game.Players.LocalPlayer.Character
    if not character then return end
    local humanoid = character:FindFirstChild("Humanoid")
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not humanoidRootPart then return end
    local healthThreshold = humanoid.MaxHealth * 0.4
    if humanoid.Health <= healthThreshold then
        local teleportPosition = CFrame.new(1000 * 3, 60 * 3, 1000 * 3)
        humanoidRootPart.CFrame = teleportPosition
    end
end
      
local function tpLoop()
    while _G.CombatTp do
        checkHealth()
        task.wait(0.25)
    end
end
      
if _G.useTaskSpawn then
    task.spawn(tpLoop)
else
    tpLoop()
end
