local Attack = game.ReplicatedStorage.GameRemotes.Attack

local function attackLoop()
		while _G.KillAura do
		    local lpChar = game.Players.LocalPlayer.Character
        local lpHRP = lpChar and lpChar:FindFirstChild("HumanoidRootPart")
        
        if lpHRP then
            local target = selectedTargeting == "lowest" and getLowestHealthNearbyPlayer() or getClosestPlayer()

            if target and target.Character then
                local tHRP = target.Character:FindFirstChild("HumanoidRootPart")
                if tHRP then
                    local d = lpHRP.Position - tHRP.Position
                    if (d.X*d.X + d.Z*d.Z) <= RANGE_SQ then
                        Attack:InvokeServer(target.Character)
                    end
                end
            end
        end
		    task.wait(delay)
		 end
  end

	if ka then
		  task.spawn(attackLoop)
  end
end
