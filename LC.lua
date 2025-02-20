local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/bytehub/refs/heads/main/ByteHubOrion.lua",true))()
lib.SelectedTheme = "ByteHub"
local Window = lib:MakeWindow({Name = "Lebron Clicker", HidePremium = false, SaveConfig = true, ConfigFolder = "OrionTest", IntroText = "Clickers Hub", IntroIcon = "rbxassetid://18371225897"})
local player = game.Players.LocalPlayer
local hrp = player.Character.HumanoidRootPart

local sg = Window:MakeTab({
  Name = "Supported Games",
  Icon = "rbxassetid://18407871907",
  PremiumOnly = false
})

sg:AddButton({
  Name = "Pet Clicks Simulator X",
  Callback = function()
    setclipboard(9600578307)
    
    lib:MakeNotification({
      Name = "Copied to clipboard.",
      Content = "Successfully copied Place ID to clipboard!",
      Image = "rbxassetid://4483345998",
      Time = 5
    })
  end
})

sg:AddButton({
  Name = "Lebron Clicker",
  Callback = function()
    setclipboard(17003365237)
    
    lib:MakeNotification({
      Name = "Copied to clipboard.",
      Content = "Successfully copied Place ID to clipboard!",
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

local ht = Window:MakeTab({
  Name = "Auto Hatch",
  Icon = "rbxassetid://18371225897",
  PremiumOnly = false
})

local s1 = ft:AddSection({
  Name = "AutoFarm"
})

ft:AddToggle({
  Name = "Auto Clicker",
  Default = false,
  Callback = function(ac)
    a = ac
    while a and task.wait() do
      task.spawn(function()
        game:GetService("ReplicatedStorage").Remotes.Clicker:FireServer()
      end)
    end
  end
})

ft:AddToggle({
  Name = "Auto Rebirth",
  Default = false,
  Callback = function(ar)
    a2 = ar
    while a2 and task.wait() do
      task.spawn(function()
        game:GetService("ReplicatedStorage").Remotes.Rebirth:FireServer()
      end)
    end
  end
})

ft:AddToggle({
  Name = "Auto Unlock Next Area",
  Default = false,
  Callback = function(aua)
    a3 = aua
    while a3 and task.wait() do
      task.spawn(function()
        game:GetService("ReplicatedStorage").Remotes.Area:FireServer()
      end)
    end
  end
})

local s2 = ft:AddSection({
  Name = "Upgrades"
})

ft:AddToggle({
  Name = "Auto Upgrade 1 (More Walkspeed)",
  Default = false,
  Callback = function(au1)
    a4 = au1
    while a4 and task.wait() do
      task.spawn(function()
        local args = {
          [1] = "1"
        }

        game:GetService("ReplicatedStorage").Remotes.GemUpgrade:FireServer(unpack(args))
      end)
    end
  end
})

ft:AddToggle({
  Name = "Auto Upgrade 2 (More Currency)",
  Default = false,
  Callback = function(au2)
    a5 = au2
    while a5 and task.wait() do
      task.spawn(function()
        local args = {
          [1] = "2"
        }

        game:GetService("ReplicatedStorage").Remotes.GemUpgrade:FireServer(unpack(args))
      end)
    end
  end
})

local s3 = ht:AddSection({
  Name = "Easy Eggs **OP & CHEAP**"
})

ht:AddToggle({
  Name = "Bron (1)",
  Default = false,
  Callback = function(ah1)
    e1 = ah1
    while e1 and task.wait() do
      task.spawn(function()
        local args = {
          [1] = "Bron",
          [2] = 1
        }

        game:GetService("ReplicatedStorage").Remotes.Egg:InvokeServer(unpack(args))
      end)
    end
  end
})

ht:AddToggle({
  Name = "600K Brons (1K)",
  Default = false,
  Callback = function(ah2)
    e2 = ah2
    while e2 and task.wait() do
      task.spawn(function()
        local args = {
          [1] = "600K Brons",
          [2] = 1
        }

        game:GetService("ReplicatedStorage").Remotes.Egg:InvokeServer(unpack(args))
      end)
    end
  end
})

ht:AddToggle({
  Name = "Ez Bron (1K)",
  Default = false,
  Callback = function(ah3)
    e3 = ah3
    while e3 and task.wait() do
      task.spawn(function()
        local args = {
          [1] = "Ez Bron",
          [2] = 1
        }

        game:GetService("ReplicatedStorage").Remotes.Egg:InvokeServer(unpack(args))
      end)
    end
  end
})

local s4 = ht:AddSection({
  Name = "Area 1"
})

ht:AddToggle({
  Name = "Basic Lebrons (100)",
  Default = false,
  Callback = function(ah4)
    e4 = ah4
    while e4 and task.wait() do
      task.spawn(function()
        local args = {
          [1] = "Basic Lebrons",
          [2] = 1
        }

        game:GetService("ReplicatedStorage").Remotes.Egg:InvokeServer(unpack(args))
      end)
    end
  end
})

ht:AddToggle({
  Name = "Funky Lebrons (5K)",
  Default = false,
  Callback = function(ah5)
    e5 = ah5
    while e5 and task.wait() do
      task.spawn(function()
        local args = {
          [1] = "Funky Lebrons",
          [2] = 1
        }

        game:GetService("ReplicatedStorage").Remotes.Egg:InvokeServer(unpack(args))
      end)
    end
  end
})

ht:AddToggle({
  Name = "V2 Brons (10NoNg)",
  Default = false,
  Callback = function(ah6)
    e6 = ah6
    while e6 and task.wait() do
      task.spawn(function()
        local args = {
          [1] = "V2 Brons",
          [2] = 1
        }

        game:GetService("ReplicatedStorage").Remotes.Egg:InvokeServer(unpack(args))
      end)
    end
  end
})

local s5 = ht:AddSection({
  Name = "Area 2"
})

ht:AddToggle({
  Name = "Big Lebrons (50K)",
  Default = false,
  Callback = function(ah7)
    e7 = ah7
    while e7 and task.wait() do
      task.spawn(function()
        local args = {
          [1] = "Big Lebrons",
          [2] = 1
        }

        game:GetService("ReplicatedStorage").Remotes.Egg:InvokeServer(unpack(args))
      end)
    end
  end
})

local s6 = ht:AddSection({
  Name = "Area 3"
})

ht:AddToggle({
  Name = "Small Lebrons (300K)",
  Default = false,
  Callback = function(ah8)
    e8 = ah8
    while e8 and task.wait() do
      task.spawn(function()
        local args = {
          [1] = "Small Lebrons",
          [2] = 1
        }

        game:GetService("ReplicatedStorage").Remotes.Egg:InvokeServer(unpack(args))
      end)
    end
  end
})

local s7 = ht:AddSection({
  Name = "Area 4"
})

ht:AddToggle({
  Name = "Silly Lebrons (5M)",
  Default = false,
  Callback = function(ah9)
    e9 = ah9
    while e9 and task.wait() do
      task.spawn(function()
        local args = {
          [1] = "Silly Lebrons",
          [2] = 1
        }

        game:GetService("ReplicatedStorage").Remotes.Egg:InvokeServer(unpack(args))
      end)
    end
  end
})

local s8 = ht:AddSection({
  Name = "Area 5"
})

ht:AddToggle({
  Name = "Extra Lebrons (250M)",
  Default = false,
  Callback = function(ah10)
    e10 = ah10
    while e10 and task.wait() do
      task.spawn(function()
        local args = {
          [1] = "Extra Lebrons",
          [2] = 1
        }

        game:GetService("ReplicatedStorage").Remotes.Egg:InvokeServer(unpack(args))
      end)
    end
  end
})

local s9 = ht:AddSection({
  Name = "Area 6"
})

ht:AddToggle({
  Name = "New Lebrons (5T)",
  Default = false,
  Callback = function(ah11)
    e11 = ah11
    while e11 and task.wait() do
      task.spawn(function()
        local args = {
          [1] = "New Lebrons",
          [2] = 1
        }

        game:GetService("ReplicatedStorage").Remotes.Egg:InvokeServer(unpack(args))
      end)
    end
  end
})

local s10 = ht:AddSection({
  Name = "Area 7"
})

ht:AddToggle({
  Name = "Colorful Lebrons (1Qd)",
  Default = false,
  Callback = function(ah12)
    e12 = ah12
    while e12 and task.wait() do
      task.spawn(function()
        local args = {
          [1] = "Colorful Lebrons",
          [2] = 1
        }

        game:GetService("ReplicatedStorage").Remotes.Egg:InvokeServer(unpack(args))
      end)
    end
  end
})

local s11 = ht:AddSection({
  Name = "Area 8"
})

ht:AddToggle({
  Name = "Lebron Books (250Qd)",
  Default = false,
  Callback = function(ah13)
    e13 = ah13
    while e13 and task.wait() do
      task.spawn(function()
        local args = {
          [1] = "Lebron Books",
          [2] = 1
        }

        game:GetService("ReplicatedStorage").Remotes.Egg:InvokeServer(unpack(args))
      end)
    end
  end
})

local s12 = ht:AddSection({
  Name = "Area 9"
})

ht:AddToggle({
  Name = "Dogs? (100Sx)",
  Default = false,
  Callback = function(ah14)
    e14 = ah14
    while e14 and task.wait() do
      task.spawn(function()
        local args = {
          [1] = "Dogs?",
          [2] = 1
        }

        game:GetService("ReplicatedStorage").Remotes.Egg:InvokeServer(unpack(args))
      end)
    end
  end
})

local s13 = ht:AddSection({
  Name = "Area 10"
})

ht:AddToggle({
  Name = "Fish? (10Sp)",
  Default = false,
  Callback = function(ah15)
    e15 = ah15
    while e15 and task.wait() do
      task.spawn(function()
        local args = {
          [1] = "Fish?",
          [2] = 1
        }

        game:GetService("ReplicatedStorage").Remotes.Egg:InvokeServer(unpack(args))
      end)
    end
  end
})

local s14 = ht:AddSection({
  Name = "Area 11"
})

ht:AddToggle({
  Name = "Super Lebrons (50Oc)",
  Default = false,
  Callback = function(ah16)
    e16 = ah16
    while e16 and task.wait() do
      task.spawn(function()
        local args = {
          [1] = "Super Lebrons",
          [2] = 1
        }

        game:GetService("ReplicatedStorage").Remotes.Egg:InvokeServer(unpack(args))
      end)
    end
  end
})

local s15 = ht:AddSection({
  Name = "Area 12"
})

ht:AddToggle({
  Name = "Final Lebrons (100No)",
  Default = false,
  Callback = function(ah17)
    e17 = ah17
    while e17 and task.wait() do
      task.spawn(function()
        local args = {
          [1] = "Final Lebrons",
          [2] = 1
        }

        game:GetService("ReplicatedStorage").Remotes.Egg:InvokeServer(unpack(args))
      end)
    end
  end
})

local s16 = ht:AddSection({
  Name = "Area 15"
})

ht:AddToggle({
  Name = "Trophy Lebrons (1UDe)",
  Default = false,
  Callback = function(ah18)
    e18 = ah18
    while e18 and task.wait() do
      task.spawn(function()
        local args = {
          [1] = "Final Lebrons",
          [2] = 1
        }

        game:GetService("ReplicatedStorage").Remotes.Egg:InvokeServer(unpack(args))
      end)
    end
  end
})
