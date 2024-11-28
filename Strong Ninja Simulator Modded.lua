local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "Strong Ninja Simulator (Byte Hub)", HidePremium = false, SaveConfig = true, ConfigFolder = "OrionTest", IntroText = "Byte Hub"})
OrionLib:MakeNotification({
	Name = "Credits",
	Content = "Made by Novaz#5792\nModded by PurpleApple",
	Image = "rbxassetid://4483345998",
	Time = 5
})

local mn = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local toggles = {}
local plr = game.Players.LocalPlayer
local cha = plr.Character
local hrp = cha.HumanoidRootPart

mn:AddButton({
    Name = "Redeem All Codes",
    Callback = function(Value)
      local args = {[1] = {[1] = "FREESTRENGTH"}}
      game:GetService("ReplicatedStorage").Framework.Modules.Shared.Internal.Modules:FindFirstChild("2 | Network").Remotes.s_controller_redeemcode:InvokeServer(unpack(args))
      wait()
      local args = {[1] = {[1] = "HELL"}}
      game:GetService("ReplicatedStorage").Framework.Modules.Shared.Internal.Modules:FindFirstChild("2 | Network").Remotes.s_controller_redeemcode:InvokeServer(unpack(args))
      wait()
      local args = {[1] = {[1] = "HEAVEN"}}
      game:GetService("ReplicatedStorage").Framework.Modules.Shared.Internal.Modules:FindFirstChild("2 | Network").Remotes.s_controller_redeemcode:InvokeServer(unpack(args))
      wait()
      local args = {[1] = {[1] = "BELUGA"}}
      game:GetService("ReplicatedStorage").Framework.Modules.Shared.Internal.Modules:FindFirstChild("2 | Network").Remotes.s_controller_redeemcode:InvokeServer(unpack(args))
      wait()
      local args = {[1] = {[1] = "VOID"}}
      game:GetService("ReplicatedStorage").Framework.Modules.Shared.Internal.Modules:FindFirstChild("2 | Network").Remotes.s_controller_redeemcode:InvokeServer(unpack(args))
      wait()
      local args = {[1] = {[1] = "ANIME"}}
      game:GetService("ReplicatedStorage").Framework.Modules.Shared.Internal.Modules:FindFirstChild("2 | Network").Remotes.s_controller_redeemcode:InvokeServer(unpack(args))
      wait()
      local args = {[1] = {[1] = "FREELUCK"}}
      game:GetService("ReplicatedStorage").Framework.Modules.Shared.Internal.Modules:FindFirstChild("2 | Network").Remotes.s_controller_redeemcode:InvokeServer(unpack(args))
      wait()
      local args = {[1] = {[1] = "ILIKEGEMS"}}
      game:GetService("ReplicatedStorage").Framework.Modules.Shared.Internal.Modules:FindFirstChild("2 | Network").Remotes.s_controller_redeemcode:InvokeServer(unpack(args))
    end
})

mn:AddToggle({
  Name = "Auto Attack",
  Default = false,
  Callback = function(a) 
    b = a
    while b and wait() do
      for i,v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
        if v:IsA("Tool") then
          v:Activate()
        end
      end
    end
  end
})

mn:AddToggle({
  Name = "Auto Rebirth",
  Default = false,
  Callback = function(lor) 
    por = lor
    while por and wait() do
      game:GetService("ReplicatedStorage").Framework.Modules.Shared.Internal.Modules:FindFirstChild("2 | Network").Remotes.s_controller_rebirth:InvokeServer({})
      plr.PlayerGui.Main:FindFirstChild("Rebirth").Visible = false
    end
  end
})

mn:AddDropdown({
  Name = "Select Egg",
  Default = "Select Egg",
  Options = {"Beach Egg", "Forest Egg", "Dominus Egg", "Dragon Egg", "Alien Egg", "Arctic Egg", "Zomie Egg", "Hell Egg", "Heaven Egg"},
  Callback = function(l)
    p = l
  	end    
})

mn:AddToggle({
  Name = "Auto Hatch Egg",
  Default = false,
  Callback = function(lpr) 
    lit = lpr
    while lit and wait() do
      local args = {
        [1] = {
          [1] = p
        }
      }
      game:GetService("ReplicatedStorage").Framework.Modules.Shared.Internal.Modules:FindFirstChild("2 | Network").Remotes.s_controller_buyegg:InvokeServer(unpack(args))
    end
  end
})

mn:AddButton({
    Name = "Give Best Pet (must complete dominus quest)",
    Callback = function(Value)
      local args = {
        [1] = {}
      }
      
      game:GetService("ReplicatedStorage").Framework.Modules.Shared.Internal.Modules["2 | Network"].Remotes.s_controller_claimchallenge:InvokeServer(unpack(args))
    end
})

mn:AddToggle({
  Name = "Auto Give Best Pet",
  Default = false,
  Callback = function(gp) 
    gbp = gp
    while gbp and wait() do
      local args = {
        [1] = {}
      }
      
      game:GetService("ReplicatedStorage").Framework.Modules.Shared.Internal.Modules["2 | Network"].Remotes.s_controller_claimchallenge:InvokeServer(unpack(args))
    end
  end
})


mn:AddToggle({
  Name = "Remove Lag",
  Default = false,
  Callback = function(rl) 
    rl2 = rl
    while rl2 and wait() do
      local function delemitters(parent)
        for _, child in ipairs(parent:GetChildren()) do
          if child:IsA("ParticleEmitter") then
            child:Destroy()
          end
          delemitters(child)
        end
      end
      
      delemitters(workspace)
    
      local function delbbg(parent)
        for _, child in ipairs(parent:GetChildren()) do
          if child:IsA("BillboardGui") then
            child:Destroy()
          end
          delbbg(child)
        end
      end
      local path = workspace:WaitForChild("__DEBRIS")
      delbbg(path)
    end
  end
})

mn:AddButton({
    Name = "Remove Bloat",
    Callback = function(Value)
      game:GetService("Players").LocalPlayer.PlayerGui.Main.HUD.Right.Visible = false
      game:GetService("Players").LocalPlayer.PlayerGui.Main.AutoClicker.Visible = false
      game:GetService("Players").LocalPlayer.PlayerGui.Main.FloppaBtn.Visible = false
      game:GetService("Players").LocalPlayer.PlayerGui.Main.DarkMatter.Visible = false
      game:GetService("Players").LocalPlayer.PlayerGui.Main.Limited2.Visible = false
      game:GetService("Players").LocalPlayer.PlayerGui.Main.LimitedTime.Visible = false
      game:GetService("Players").LocalPlayer.PlayerGui.Main.Sunburst.Visible = false
      game:GetService("Players").LocalPlayer.PlayerGui.Items.ElectricKatana.Visible = false
    end
})

OrionLib:Init()
