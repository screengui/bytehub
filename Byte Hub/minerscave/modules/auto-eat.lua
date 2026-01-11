local AutoEat = {}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LP = Players.LocalPlayer
local ConsumeRemote = ReplicatedStorage:WaitForChild("GameRemotes"):WaitForChild("ConsumeItem")

local running = false
local taskThread

local function getInventory()
	local char = LP.Character or LP.CharacterAdded:Wait()
	return char:WaitForChild("Inventory")
end

local function getSelectedSlot()
	local char = LP.Character or LP.CharacterAdded:Wait()
	return char:WaitForChild("SelectedSlot").Value
end

local function loop()
	while running do
		pcall(function()
			ConsumeRemote:InvokeServer(
				getInventory(),
				getSelectedSlot()
			)
		end)
		task.wait() -- you can tune this (e.g. 0.2)
	end
end

function AutoEat.start()
	if running then return end
	running = true
	taskThread = task.spawn(loop)
end

function AutoEat.stop()
	running = false
end

return AutoEat
