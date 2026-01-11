local Hitbox = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer

local hbConn
local running = false

local EXPANDED_SIZE = Vector3.new(10, 10, 10)
local NORMAL_SIZE   = Vector3.new(2, 2, 1)

local function changeTorsoSize(player, size, massless, transparency)
	local char = player.Character
	if not char then return end

	local torso = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
	if torso then
		torso.Size = size
		torso.Massless = massless
		torso.Transparency = transparency
	end
end

local function loop()
	hbConn = RunService.Heartbeat:Connect(function()
		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= LP then
				changeTorsoSize(player, EXPANDED_SIZE, true, 0.999)
			end
		end
	end)
end

function Hitbox.start()
	if running then return end
	running = true
	loop()
end

function Hitbox.stop()
	if not running then return end
	running = false

	if hbConn then
		hbConn:Disconnect()
		hbConn = nil
	end

	-- restore hitboxes
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LP then
			changeTorsoSize(player, NORMAL_SIZE, true, 0)
		end
	end
end

return Hitbox
