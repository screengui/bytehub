local TargetStrafe = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LP = Players.LocalPlayer
local Essentials = loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/bytehub/refs/heads/main/Byte%20Hub/minerscave/modules/Essentials.lua"))()

local running = false
local hbConn
local timeAcc = 0

local function onHeartbeat(dt)
	if not running then return end

	local char = LP.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local target =
		_G.selectedTargeting == "lowest"
		and Essentials.getLowestHealthNearbyPlayer()
		or Essentials.getClosestPlayer()

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
	hrp.CFrame = CFrame.new(targetPos + offset, targetPos)
end

function TargetStrafe.start()
	if running then return end
	running = true
	timeAcc = 0
	hbConn = RunService.Heartbeat:Connect(onHeartbeat)
end

function TargetStrafe.stop()
	running = false
	if hbConn then
		hbConn:Disconnect()
		hbConn = nil
	end
end

return TargetStrafe
