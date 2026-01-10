loadstring(game:HttpGet("https://raw.githubusercontent.com/Pixeluted/adoniscries/refs/heads/main/Source.lua",true))()
wait()
loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/bytehub/refs/heads/main/Byte%20Hub/minerscave/modules/globals.lua",true))()
-- Anti Kick --
  
local oldhmmi
local oldhmmnc
oldhmmi = hookmetamethod(game, "__index", function(self, method)
  if self == player and method:lower() == "kick" then
    return error("Expected ':' not '.' calling member function Kick", 2)
  end
  return oldhmmi(self, method)
end)
oldhmmnc = hookmetamethod(game, "__namecall", function(self, ...)
  if self == player and getnamecallmethod():lower() == "kick" then
    return
  end
  return oldhmmnc(self, ...)
end)

local function getLowestHealthNearbyPlayer()
  local lowestHealth = math.huge
  local targetPlayer = nil
    
  local localHRP = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
  if not localHRP then return nil end
    
  for _, player in ipairs(game.Players:GetPlayers()) do
    if player ~= game.Players.LocalPlayer and player.Character then
      local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
      local targetHRP = player.Character:FindFirstChild("HumanoidRootPart")
      if humanoid and targetHRP and humanoid.Health > 0 then
        local distance = (targetHRP.Position - localHRP.Position).Magnitude
        if distance <= _G.strafeRange and humanoid.Health < lowestHealth then
          lowestHealth = humanoid.Health
          targetPlayer = player
        end
      end
    end
  end
    
  return targetPlayer
end

local function getClosestPlayer()
  local closest = nil
  local shortest = math.huge
  local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
  if not hrp then return nil end

  for _, player in ipairs(game.Players:GetPlayers()) do
    if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
      local dist = (hrp.Position - player.Character.HumanoidRootPart.Position).Magnitude
      if dist < shortest then
        shortest = dist
        closest = player
      end
    end
  end
  return closest
end

return {
    getLowestHealthNearbyPlayer = getLowestHealthNearbyPlayer,
    getClosestPlayer = getClosestPlayer
}
