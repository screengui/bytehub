local Sprint = {}

local Players = game:GetService("Players")
local LP = Players.LocalPlayer

local NORMAL_SPEED = 12
local SPRINT_SPEED = 20

local enabled = false

local function getHumanoid()
	local char = LP.Character or LP.CharacterAdded:Wait()
	return char:FindFirstChildOfClass("Humanoid")
end

function Sprint.start()
	if enabled then return end
	enabled = true

	local hum = getHumanoid()
	if hum then
		hum.WalkSpeed = SPRINT_SPEED
	end
end

function Sprint.stop()
	enabled = false

	local hum = getHumanoid()
	if hum then
		hum.WalkSpeed = NORMAL_SPEED
	end
end

return Sprint
