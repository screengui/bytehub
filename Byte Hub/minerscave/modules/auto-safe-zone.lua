local AutoSafeZone = {}

local Players = game:GetService("Players")
local LP = Players.LocalPlayer

local running = false
local thread

local SAFE_CFRAME = CFrame.new(1000 * 3, 60 * 3, 1000 * 3)

local function checkHealth()
	local char = LP.Character
	if not char then return end

	local humanoid = char:FindFirstChild("Humanoid")
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not humanoid or not hrp then return end

	if humanoid.Health <= humanoid.MaxHealth * 0.4 then
		hrp.CFrame = SAFE_CFRAME
	end
end

local function loop()
	while running do
		checkHealth()
		task.wait(0.25)
	end
end

function AutoSafeZone.start()
	if running then return end
	running = true
	thread = task.spawn(loop)
end

function AutoSafeZone.stop()
	running = false
end

return AutoSafeZone
