local UILibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/oceanlib/refs/heads/main/Library.lua",true))()

local Window = UILibrary:CreateWindow("Murder Mystery V")
local Tab = Window:CreateTab("Main")
local Tab2 = Window:CreateTab("Game")

--default values
local weapon = "DefaultKnife"
local amount = 1
local coin = 1000
local effect = "Knifeception"
local perk = "Trap"

Tab:AddTextbox("Amount", "1", function(text)
    amount = text
end)

Tab:AddTextbox("Weapon Name", "DefaultKnife", function(text)
    weapon = text
end)

Tab:AddButton("Give Weapon", function()
		   for i = 1, amount do
		   		   task.spawn(function()
		   		   		game.ReplicatedStorage.Buy:FireServer(weapon, "Weapons", "Credits", 0)
		   		   end)
		   		   task.wait()
		   end
end)

Tab:AddTextbox("Effect Name", "Knifeception", function(text)
    effect = text
end)

Tab:AddButton("Give Effect", function()
		   for i = 1, amount do
		   		   task.spawn(function()
		   		   		game.ReplicatedStorage.Buy:FireServer(effect, "Effects", "Credits", 0)
		   		   end)
		   		   task.wait()
		   end
end)

Tab:AddTextbox("Perk Name", "Trap", function(text)
    perk = text
end)

Tab:AddButton("Give Perk", function()
		   for i = 1, amount do
		   		   task.spawn(function()
		   		   		game.ReplicatedStorage.Buy:FireServer(perk, "Perks", "Credits", 0)
		   		   end)
		   		   task.wait()
		   end
end)

Tab:AddTextbox("Coin Amount", "1000", function(text)
    coin = text
end)

Tab:AddButton("Give Coins", function()
		   game.ReplicatedStorage.Buy:FireServer("Waves_K", "Weapons", "Credits", -coin)
end)

Tab2:AddButton("Give Knife", function()
		   game.ReplicatedStorage.GiveKnife:FireServer()
end)

Tab2:AddButton("Give Gun", function()
		   game.ReplicatedStorage.GiveGun:FireServer()
end)

Tab2:AddButton("Give Both", function()
		   game.ReplicatedStorage.GiveKnife:FireServer()
    game.ReplicatedStorage.GiveGun:FireServer()
end)
