if game.PlaceId == 13890902087 then
  loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/bytehub/refs/heads/main/Math%20Boxing",true))()
elseif game.PlaceId == 10476933477 then
  loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/bytehub/refs/heads/main/Strong%20Ninja%20Simulator%20Modded.lua",true))()
elseif game.PlaceId == 6741970382 then
  loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/bytehub/refs/heads/main/zombielab.lua",true))()
elseif game.PlaceId == 15686049105 then
  loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/bytehub/refs/heads/main/Longest%20flag%20wins.lua",true))()
else
  print("Not Supported")
  game.Players.LocalPlayer:Kick("Game is not supported")
end
