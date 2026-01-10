local EssentialsModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/bytehub/refs/heads/main/Byte%20Hub/minerscave/modules/Essentials.lua"))()
local hbConn
local timeAcc = 0

if not _G.TargetStrafe then
  if hbConn then
    hbConn:Disconnect()
    hbConn = nil
  end
  return
end

hbConn = game:GetService("RunService").Heartbeat:Connect(function(dt)
  if not _G.TargetStrafe then return end
  local lpChar = game.Players.LocalPlayer.Character
  local lpHRP = lpChar and lpChar:FindFirstChild("HumanoidRootPart")
  if not lpHRP then return end

  local target = _G.selectedTargeting == "lowest" and EssentialsModule.getLowestHealthNearbyPlayer() or EssentialsModule.getClosestPlayer()
  local tChar = target and target.Character
  local tHRP = tChar and tChar:FindFirstChild("HumanoidRootPart")
  if not tHRP then return end

  timeAcc += dt * _G.speed

  local offset = Vector3.new(
    math.cos(timeAcc) * _G.radius,
    0,
    math.sin(timeAcc) * _G.radius
  )

  local targetPos = tHRP.Position
  lpHRP.CFrame = CFrame.new(targetPos + offset, targetPos)
end)
