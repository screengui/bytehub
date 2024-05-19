loadstring(game:HttpGet("https://rawscripts.net/raw/Baseplate-adonis-and-newindex-bypass-source-12378",true))()
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "Minecraft (Byte Hub)", HidePremium = false, SaveConfig = true, ConfigFolder = "OrionTest", IntroEnabled = false})


--val
getgenv().KillAura = false

--func
function KillAura()
  loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/sidescripts/main/killaura.lua",true))()
end

local function toggleChestEsp()
  loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/sidescripts/main/ChestESP.lua",true))()
end

--Credits
local Credits = Window:MakeTab({
  Name = "Credits",
  Icon = "rbxassetid://4483345998",
  PremiumOnly = false
})

Credits:AddLabel("Made by PurpleApple#9562/@inconsistenttutorialuploader")
Credits:AddLabel("Byte Hub (Minecraft)")
Credits:AddLabel("Version 1.8 beta 4")
Credits:AddLabel("UI Library: Orion Library")
Credits:AddLabel("Encrypted by MoonSec")
Credits:AddLabel("Huge thanks to BootyBandit™ for helping with the script")
Credits:AddLabel("Dupe GUI: Argentum Exploitz")
Credits:AddLabel("Made the script open source")

--Main
local cs = Window:MakeTab({
  Name = "Combat",
  Icon = "rbxassetid://4483345998",
  PremiumOnly = false
})

cs:AddToggle({
  Name = "Kill Aura",
  Default = false,
  Callback = function(Value)
    getgenv().KillAura = Value
    KillAura()
  end    
})

cs:AddButton({
  Name = "Arcade Recode Client",
  Callback = function()
    loadstring(game:HttpGet("https://pastebin.com/raw/b0m8gUaP",true))()
  end    
})

cs:AddButton({
  Name = "Dizzy Hub",
  Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/dizyhvh/rbx_scripts/main/dizzy_hub/scripts/minerscave_15.lua",true))()
  end
})

local lp = Window:MakeTab({
  Name = "Movement",
  Icon = "rbxassetid://4483345998",
  PremiumOnly = false
})

lp:AddButton({
  Name = "No Fall Damage (Use rspy if not work)",
  Callback = function()
    game.ReplicatedStorage.GameRemotes.Demo:Destroy()
  end    
})


lp:AddButton({
  Name = "Jesus",
  Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/sidescripts/main/Jesus.lua",true))()
  end    
})
--Visuals
local Visuals = Window:MakeTab({
  Name = "Visuals",
  Icon = "rbxassetid://4483345998",
  PremiumOnly = false
})

Visuals:AddToggle({
  Name = "Chest ESP",
  Default = false,
  Callback = function(Value)
    local chestEspEnabled = Value
    toggleChestEsp(chestEspEnabled)
  end    
})


Visuals:AddButton({
  Name = "Watermark",
  Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/sidescripts/main/Watermark.lua",true))()
  end    
})

Visuals:AddButton({
  Name = "ESP (Press B)",
  Callback = function()
    loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-FE-ESP-1174",true))()
  end    
})

Visuals:AddButton({
  Name = "ESP Button (Mobile)",
  Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/sidescripts/main/PressB.lua",true))()
  end    
})

local dt = Window:MakeTab({
  Name = "Dupe",
  Icon = "rbxassetid://4483345998",
  PremiumOnly = false
})

dt:AddButton({
  Name = "Dupe GUI",
  Callback = function()
    loadstring(game:HttpGet("https://gist.githubusercontent.com/raw/b8d379c1e296ade8305c2fe4df652537"))()
  end
})

dt:AddButton({
  Name = "Dupe First Slot (Press Z)",
  Callback = function()
    loadstring(game:HttpGet("https://pastebin.com/raw/TkAm8wV8",true))()
  end
})

local ts = Window:MakeTab({
  Name = "Themes (v1.1 only)",
  Icon = "rbxassetid://4483345998",
  PremiumOnly = false
})

ts:AddButton({
  Name = "Kavo UI Theme Selector for MineCraft (TSMC)",
  Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/bytehub/main/tsmc.lua",true))()
  end    
})

--LocalPlayer
  
local ot = Window:MakeTab({
  Name = "Other",
  Icon = "rbxassetid://4483345998",
  PremiumOnly = false
})

ot:AddButton({
  Name = "Infinite Yield (PC Only)",
  Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source",true))()
  end    
})

ot:AddButton({
  Name = "SimpleSpy V3",
  Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/78n/SimpleSpy/main/SimpleSpySource.lua"))()
  end    
})

ot:AddButton({
  Name = "SimpleSpy Mobile",
  Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/REDzHUB/RS/main/SimpleSpyMobile"))()
  end    
})

ot:AddButton({
  Name = "Dex V4",
  Callback = function()
    loadstring(game:HttpGet("https://pastebin.com/raw/fPP8bZ8Z"))()
  end    
})

ot:AddButton({
  Name = "Dex Mobile (V2)",
  Callback = function()
    loadstring(game:HttpGet("https://cdn.wearedevs.net/scripts/Dex%20Explorer.txt"))()
  end
})

ot:AddButton({
  Name = "Unload GUI",
  Callback = function()
    OrionLib:Destroy()
  end    
})

OrionLib:Init()
