local Library = loadstring(game:HttpGet("https://pastebin.com/raw/vff1bQ9F"))()
local Window = Library.CreateLib("TITLE", "Sentinel")
local Tab = Window:NewTab("Themes (W.I.P)")
local ts = Tab:NewSection("Themes")
ts:NewButton("Light Theme", "Turns into Light Theme", function()
  getgenv().Theme = "LightTheme"
  loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/bytehub/main/t1.lua",true))()
end)
ts:NewButton("Dark Theme", "Turns into Dark Theme", function()
  getgenv().Theme = "DarkTheme"
  loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/bytehub/main/t1.lua",true))()
end)
ts:NewButton("Grape Theme", "Turns into Grape Theme", function()
  getgenv().Theme = "GrapeTheme"
  loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/bytehub/main/t1.lua",true))()
end)
ts:NewButton("Blood Theme", "Turns into Blood Theme", function()
  getgenv().Theme = "BloodTheme"
  loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/bytehub/main/t1.lua",true))()
end)
ts:NewButton("Ocean Theme", "Turns into Ocean Theme", function()
  getgenv().Theme = "Ocean"
  loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/bytehub/main/t1.lua",true))()
end)
ts:NewButton("Midnight Theme", "Turns into Midnight Theme", function()
  getgenv().Theme = "Midnight"
  loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/bytehub/main/t1.lua",true))()
end)
ts:NewButton("Sentinel Theme", "Turns into Sentinel Theme", function()
  getgenv().Theme = "Sentinel"
  loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/bytehub/main/t1.lua",true))()
end)
ts:NewButton("Serpent Theme", "Turns into Serpent Theme", function()
  getgenv().Theme = "Serpent"
  loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/bytehub/main/t1.lua",true))()
end) 
ts:NewButton("Synapse Theme", "Turns into Synapse Theme", function()
  getgenv().Theme = "Synapse"
  loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/bytehub/main/t1.lua",true))()
end)
ts:NewButton("Default Theme", "Turns into Default Theme", function()
  loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/bytehub/main/t1.lua",true))()
end)
