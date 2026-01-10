local Attack = game.ReplicatedStorage.GameRemotes.Attack

local EssentialsModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/bytehub/refs/heads/main/Byte%20Hub/minerscave/modules/Essentials.lua"))()

local function attackLoop()
	while _G.KillAura do
		local lpChar = game.Players.LocalPlayer.Character
        local lpHRP = lpChar and lpChar:FindFirstChild("HumanoidRootPart")
        
        if lpHRP then
            local target = _G.selectedTargeting == "lowest" and EssentialsModule.getLowestHealthNearbyPlayer() or EssentialsModule.getClosestPlayer()

            if target and target.Character then
                local tHRP = target.Character:FindFirstChild("HumanoidRootPart")
                if tHRP then
                    local d = lpHRP.Position - tHRP.Position
                    if (d.X*d.X + d.Z*d.Z) <= _G.RANGE_SQ then
                        Attack:InvokeServer(target.Character)
                    end
                end
            end
        end
		task.wait(_G.delay)
	end
end

if ka then
    task.spawn(attackLoop)
end
