local NoFall = {}

local RS = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local remotes = RS:WaitForChild("GameRemotes")
local demo = remotes:WaitForChild("Demo")

local enabled = false

function NoFall.start()
	if enabled then return end
	enabled = true

	if demo.Parent == remotes then
		demo.Parent = Workspace
	end
end

function NoFall.stop()
	enabled = false

	if demo.Parent == Workspace then
		demo.Parent = remotes
	end
end

return NoFall
