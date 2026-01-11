local Jesus = {}

local Workspace = game:GetService("Workspace")

local fluidFolder = Workspace:FindFirstChild("Fluid")
local conn
local enabled = false

local function isWater(part)
	return part:IsA("BasePart")
		and (part.Name == "Water" or part.Name == "Lava")
end

local function setCollision(state)
	if not fluidFolder then return end

	for _, obj in ipairs(fluidFolder:GetDescendants()) do
		if isWater(obj) then
			obj.CanCollide = state
		end
	end
end

function Jesus.start()
	if enabled then return end
	enabled = true
	if not fluidFolder then return end

	setCollision(true)

	conn = fluidFolder.DescendantAdded:Connect(function(obj)
		if enabled and isWater(obj) then
			obj.CanCollide = true
		end
	end)
end

function Jesus.stop()
	if not enabled then return end
	enabled = false

	if conn then
		conn:Disconnect()
		conn = nil
	end

	setCollision(false)
end

return Jesus
