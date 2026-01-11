local KillAura = {}
local running = false

local Attack = game.ReplicatedStorage.GameRemotes.Attack
local Players = game:GetService("Players")
local LP = Players.LocalPlayer

local Essentials = loadstring(game:HttpGet(
  "https://raw.githubusercontent.com/screengui/bytehub/refs/heads/main/Byte%20Hub/minerscave/modules/Essentials.lua"
))()

local function loop()
	while running do
		local char = LP.Character
		local hrp = char and char:FindFirstChild("HumanoidRootPart")
		if hrp then
			local target =
				_G.selectedTargeting == "lowest"
				and Essentials.getLowestHealthNearbyPlayer()
				or Essentials.getClosestPlayer()

			if target and target.Character then
				local tHRP = target.Character:FindFirstChild("HumanoidRootPart")
				if tHRP then
					local d = hrp.Position - tHRP.Position
					if (d.X*d.X + d.Z*d.Z) <= _G.RANGE_SQ then
						Attack:InvokeServer(target.Character)
					end
				end
			end
		end
		task.wait(_G.delay)
	end
end

function KillAura.start()
	if running then return end
	running = true
	task.spawn(loop)
end

function KillAura.stop()
	running = false
end

return KillAura
