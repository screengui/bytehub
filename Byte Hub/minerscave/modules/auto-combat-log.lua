local CombatLog = {}

local Players = game:GetService("Players")
local LP = Players.LocalPlayer

local running = false
local thread

local function checkHealth()
	local char = LP.Character
	if not char then return end

	local humanoid = char:FindFirstChildOfClass("Humanoid")
	if not humanoid then return end

	if humanoid.Health <= humanoid.MaxHealth * 0.4 then
		game:Shutdown()
	end
end

local function loop()
	while running do
		checkHealth()
		task.wait()
	end
end

function CombatLog.start()
	if running then return end
	running = true
	thread = task.spawn(loop)
end

function CombatLog.stop()
	running = false
end

return CombatLog
