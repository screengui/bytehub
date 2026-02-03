local TriggerBot = {}

-- services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

-- locals
local LP = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- config
FOVTrigger.Radius = 120
FOVTrigger.Color = Color3.fromRGB(255, 255, 255)
FOVTrigger.Thickness = 2
FOVTrigger.Transparency = 1
FOVTrigger.Enabled = false
FOVTrigger.Remote = game.ReplicatedStorage.GameRemotes.Attack

-- internal
local circle
local connection
local lastFire = 0
local cooldown = 0.15

-- helpers
local function screenCenter()
	local vp = Camera.ViewportSize
	return Vector2.new(vp.X / 2, vp.Y / 2)
end

local function getScreenPos(character)
	local hrp = character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
	if not onScreen then return end

	return Vector2.new(pos.X, pos.Y), hrp.Position
end

local function insideFOV(screenPos)
	return (screenPos - screenCenter()).Magnitude <= FOVTrigger.Radius
end

local function wallCheck(worldPos, character)
	if not _G.FOVWallCheck then
		return true
	end

	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Blacklist
	params.FilterDescendantsInstances = {LP.Character, character}

	local origin = Camera.CFrame.Position
	local direction = (worldPos - origin)

	local result = Workspace:Raycast(origin, direction, params)
	return result == nil
end

-- loop
local function update()
	-- update circle
	circle.Position = screenCenter()
	circle.Radius = FOVTrigger.Radius
	circle.Visible = _G.FOVVisible == true

	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LP and plr.Character then
			local screenPos, worldPos = getScreenPos(plr.Character)
			if screenPos and insideFOV(screenPos) and wallCheck(worldPos, plr.Character) then
				if FOVTrigger.Remote and os.clock() - lastFire >= cooldown then
					FOVTrigger.Remote:FireServer(plr.Character)
					lastFire = os.clock()
				end
			end
		end
	end
end

-- public API
function TriggerBot.start(remote)
	if FOVTrigger.Enabled then return end
	FOVTrigger.Enabled = true
	FOVTrigger.Remote = remote

	-- defaults if nil
	_G.FOVVisible = _G.FOVVisible ~= false
	_G.FOVWallCheck = _G.FOVWallCheck ~= false

	circle = Drawing.new("Circle")
	circle.Filled = false
	circle.Color = FOVTrigger.Color
	circle.Thickness = FOVTrigger.Thickness
	circle.Transparency = FOVTrigger.Transparency
	circle.Visible = _G.FOVVisible

	connection = RunService.RenderStepped:Connect(update)
end

function TriggerBot.stop()
	FOVTrigger.Enabled = false

	if connection then
		connection:Disconnect()
		connection = nil
	end

	if circle then
		circle:Remove()
		circle = nil
	end
end

return TriggerBot
