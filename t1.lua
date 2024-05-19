local Library = loadstring(game:HttpGet("https://pastebin.com/raw/vff1bQ9F"))()
local Window = Library.CreateLib("Minecraft", getgenv().Theme)

getgenv().KillAura = false

function KillAura()
  loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/sidescripts/main/killaura.lua",true))()
end

function toggleChestEsp()
  loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/sidescripts/main/ChestESP.lua",true))()
end

local ct = Window:NewTab("Credits")
local Credits = ct:NewSection("Credits")
Credits:NewLabel("Made by PurpleApple#9562/@inconsistenttutorialuploader")
Credits:NewLabel("Byte Hub (Minecraft)")
Credits:NewLabel("Version 1.1 (Kavo UI Theme)")
local Main = Window:NewTab("Main")
local mn = Main:NewSection("Main")
mn:NewButton("No Fall Damage", "Removes Fall Damage", function()
    game.ReplicatedStorage.GameRemotes.Demo:Destroy()
end)
mn:NewToggle("KillAura", "Kills players around you within a certain radius", function(state)
    if state then
      getgenv().KillAura = true
      KillAura()
    else
      getgenv().KillAura = Value
    end
end)

local vs = Window:NewTab("Visuals")
local vs2 = vs:NewSection("ESP")
vs2:NewToggle("Chest ESP", "See chests through blocks", function(state)
  if state then
    chestEspEnabled = true
    toggleChestEsp(chestEspEnabled)
  else
      chestEspEnabled = Value
  end
end)
