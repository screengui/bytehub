loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/bytehub/refs/heads/main/Byte%20Hub/minerscave/modules/Essentials.lua"))()
local function checkHealth()
    local character = game.Players.LocalPlayer.Character
    if not character then return end
        
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
        
    local healthThreshold = humanoid.MaxHealth * 0.4
    if humanoid.Health <= healthThreshold then
        game:Shutdown()
    end
end
      
local function healthLoop()
    while _G.CombatLog do
        checkHealth()
        task.wait()
    end
end
      
if _G.useTaskSpawn then
    task.spawn(healthLoop)
else
    healthLoop()
end
