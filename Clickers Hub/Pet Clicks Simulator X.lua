local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/bytehub/refs/heads/main/ByteHubOrion.lua",true))()
lib.SelectedTheme = "ByteHub"
local Window = lib:MakeWindow({Name = "Pet Clicks Simulator X", HidePremium = false, SaveConfig = true, ConfigFolder = "OrionTest", IntroText = "Clickers Hub", IntroIcon = "rbxassetid://18371225897"})
local player = game.Players.LocalPlayer
local hrp = player.Character.HumanoidRootPart

local sg = Window:MakeTab({
  Name = "Supported Games",
  Icon = "rbxassetid://18407871907",
  PremiumOnly = false
})

sg:AddButton({
  Name = "Execute Loader",
  Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/bytehub/refs/heads/main/Clickers%20Hub/Loader.lua",true))()
    
    lib:MakeNotification({
      Name = "Success!",
      Content = "Successfully executed loader!",
      Image = "rbxassetid://4483345998",
      Time = 5
    })
  end
})

local ft = Window:MakeTab({
  Name = "Autofarm",
  Icon = "rbxassetid://18371225897",
  PremiumOnly = false
})

local s1 = ft:AddSection({
  Name = "AutoFarm"
})

ft:AddToggle({
  Name = "Autoclick",
  Default = false,
  Callback = function(ac)
    a = ac
    while a and task.wait() do
      game:GetService("ReplicatedStorage").Events.Click:FireServer()
    end
  end
})

ft:AddToggle({
  Name = "Auto Rebirth",
  Default = false,
  Callback = function(ar)
    a2 = ar
    while a2 and task.wait() do
      local args = {
        [1] = p
      }
      game:GetService("ReplicatedStorage").Events.Rebirth:FireServer(unpack(args))
    end
  end
})



ft:AddDropdown({
  Name = "Choose Rebirth Amount",
  Default = "1",
  Options = {1, 5, 10, 25, 50, 100, 250, 500, 1000, 2500, 5000, 10000, 25000, 50000, 100000, 250000, 500000, 1000000, 2500000, 5000000, 10000000, 25000000, 50000000, 100000000, 250000000, 500000000, 1000000000, 2500000000, 5000000000, 10000000000},
  Callback = function(l)
    p = l
  end    
})

ft:AddToggle({
  Name = "Auto Master",
  Default = false,
  Callback = function(am)
    a5 = am
    while a5 and task.wait() do
      game:GetService("ReplicatedStorage").Functions.IncreaseMastery:InvokeServer()
    end
  end
})

local s2 = ft:AddSection({
  Name = "Eggs"
})

ft:AddDropdown({
  Name = "Select Egg",
  Default = "1",
  Options = {"Basic", "Uncommon", "Samurai", "Ancient", "Cyber", "Tiki", "Volcanic", "Magic", "Easter", "Spring"},
  Callback = function(se)
    s = se
	end    
})

ft:AddToggle({
  Name = "Auto Hatch 1",
  Default = false,
  Callback = function(ah)
    a3 = ah
    while a3 and task.wait do
      local args = {
        [1] = s,
        [2] = "Single"
      }

      game:GetService("ReplicatedStorage").Functions.Hatch:InvokeServer(unpack(args))
    end
  end    
})

ft:AddToggle({
  Name = "Auto Hatch 3",
  Default = false,
  Callback = function(ah3)
    ah2 = ah3
    while ah2 and task.wait do
      local args = {
        [1] = s,
        [2] = "Triple"
      }

      game:GetService("ReplicatedStorage").Functions.Hatch:InvokeServer(unpack(args))
    end
  end
})

local up = Window:MakeTab({
  Name = "Upgrades",
  Icon = "rbxassetid://18422539921",
  PremiumOnly = false
})

local us1 = up:AddSection({
  Name = "Spawn Upgrades"
})

up:AddDropdown({
  Name = "Select Upgrade",
  Default = "1",
  Options = {"ClickMulti", "GemMulti", "GemChance", "RebirthButtons", "MoreStorage", "WalkSpeed", "LuckMulti", "HatchSpeedMulti", "CriticalChance"},
  Callback = function(upit)
    upi = upit
  end
})

up:AddToggle({
  Name = "Auto Upgrade",
  Default = false,
  Callback = function(au)
    a4 = au
    while a4 and task.wait() do
    local args = {
      [1] = "Spawn",
      [2] = upi
    }
    
    game:GetService("ReplicatedStorage").Functions.PurchaseUpgrade:InvokeServer(unpack(args))
    end
  end    
})

local us2 = up:AddSection({
  Name = "Easter Upgrades"
})

up:AddDropdown({
  Name = "Select Upgrade",
  Default = "1",
  Options = {"EasterMulti", "ClickMulti", "GemMulti", "GemChance", "MoreStorage", "WalkSpeed", "LuckMulti", "HatchSpeedMulti"},
  Callback = function(eupit)
    eupi = eupit
  end
})

up:AddToggle({
  Name = "Auto Upgrade",
  Default = false,
  Callback = function(eau)
    ea = eau
    while ea and task.wait() do
      local args = {
        [1] = "Easter",
        [2] = eupi
      }
      
      game:GetService("ReplicatedStorage").Functions.PurchaseUpgrade:InvokeServer(unpack(args))
    end
  end    
})

local tp = Window:MakeTab({
  Name = "Teleports",
  Icon = "rbxassetid://17160136645",
  PremiumOnly = false
})

local rtp = tp:AddSection({
  Name = "Legit Teleport"
})

tp:AddButton({
  Name = "Teleport!",
  Callback = function()
    local args = {
      [1] = ltpw
    }
    
    game:GetService("ReplicatedStorage").Events.Teleport:FireServer(unpack(args))
  end    
})

tp:AddDropdown({
  Name = "Select World",
  Default = "1",
  Options = {"Easter", "Spawn", "Samurai Land", "Ancient Ruins", "Cyber City", "Tiki Island", "Corrupted Volcano", "Magic"},
  Callback = function(ltpf)
    ltpw = ltpf
  end    
})

local ftp = tp:AddSection({
  Name = "Fake Teleport"
})

tp:AddButton({
  Name = "Easter",
  Callback = function()
    hrp.CFrame = CFrame.new(874, 15, 1086)
  end
})

tp:AddButton({
  Name = "Spawn",
  Callback = function()
    hrp.CFrame = CFrame.new(-163, 5, -65)
  end
})

tp:AddButton({
  Name = "Samurai Land",
  Callback = function()
    hrp.CFrame = CFrame.new(-34346, 4.71, -1503)
  end
})

tp:AddButton({
  Name = "Ancient Ruins",
  Callback = function()
    hrp.CFrame = CFrame.new(877, 4, -89958)
  end
})

tp:AddButton({
  Name = "Cyber City",
  Callback = function()
    hrp.CFrame = CFrame.new(18871, 39, -1509)
  end
})

tp:AddButton({
  Name = "Tiki Island",
  Callback = function()
    hrp.CFrame = CFrame.new(49679, 37, -10662)
  end
})

tp:AddButton({
  Name = "Corrupted Volcano",
  Callback = function()
    hrp.CFrame = CFrame.new(-22, 14, 28067)
  end
})

tp:AddButton({
  Name = "Magic",
  Callback = function()
    hrp.CFrame = CFrame.new(18986, -42, 512)
  end
})
