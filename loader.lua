if game.PlaceId == 13890902087 then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/bytehub/refs/heads/main/Math%20Boxing",true))()
elseif game.PlaceId == 10476933477 then
	loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/bytehub/refs/heads/main/Strong%20Ninja%20Simulator%20Modded.lua",true))()
elseif game.PlaceId == 6741970382 then
	loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/bytehub/refs/heads/main/zombielab.lua",true))()
end

if game.ReplicatedStorage.AssetsMod ~= nil then
	pcall(function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/bytehub/refs/heads/main/minerscave.lua",true))()
		end)
end
	
if game.ReplicatedStorage.VampireStuff ~= nil then
        pcall(function()
                        loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/bytehub/refs/heads/main/mmchub.lua",true))()
        end)
end
