local library = loadstring(game:HttpGet("https://pastebin.com/raw/vff1bQ9F"))()
local window = library.CreateLib("Made by Novaz#5792, Modded by PurpleApple#9562", _G.Theme)
local main = window:NewTab("Auto Farm")
local section = main:NewSection("Auto Farm")
local toggles = {}
local plr = game.Players.LocalPlayer
local cha = plr.Character
local hrp = cha.HumanoidRootPart

section:NewButton("Redeem Codes", "Redeem All Codes", function()
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
end)

section:NewToggle("Auto Attack", "Auto Clicks the sword", function(a)
  b = a
  while b and wait(0.0001) do
    for i,v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
      if v:IsA("Tool") then
        v:Activate()
      end
    end
  end
end)

section:NewToggle("Auto Rebirth", "Automatically Rebirths", function(lor)
  por = lor
  while por and task.wait() do
    game:GetService("ReplicatedStorage").Framework.Modules.Shared.Internal.Modules:FindFirstChild("2 | Network").Remotes.s_controller_rebirth:InvokeServer({})
    plr.PlayerGui.Main:FindFirstChild("Rebirth").Visible = false
  end
end)

section:NewToggle("Auto Egg", "Auto Hatches Selected Egg", function(lpr)
  lit = lpr
  while lit and task.wait() do
    local args = {
      [1] = {
        [1] = p
      }
    }
    game:GetService("ReplicatedStorage").Framework.Modules.Shared.Internal.Modules:FindFirstChild("2 | Network").Remotes.s_controller_buyegg:InvokeServer(unpack(args))
  end
end)

section:NewDropdown("Select Egg", "Select an Egg", {"Beach Egg", "Forest Egg", "Dominus Egg", "Dragon Egg", "Alien Egg", "Arctic Egg", "Zomie Egg", "Hell Egg", "Heaven Egg"}, function(l)
  p = l
end)

section:NewButton("Give Best Pet", "Made by PurpleApple. Gives best pet", function()
  loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/sidescripts/main/shitass%20fe%20script",true))()
end)

section:NewToggle("Remove Lag", "Removes stuff that causes lag", function(rl)
  rl2 = rl
  while rl2 and task.wait() do
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
end)
section:NewButton("Remove Bloat", "Removes useless stuff that doesnt affect gameplay", function()
  game:GetService("Players").LocalPlayer.PlayerGui.Main.HUD.Right:Destroy()
  game:GetService("Players").LocalPlayer.PlayerGui.Main.AutoClicker:Destroy()
  game:GetService("Players").LocalPlayer.PlayerGui.Main.FloppaBtn:Destroy()
  game:GetService("Players").LocalPlayer.PlayerGui.Main.DarkMatter:Destroy()
  game:GetService("Players").LocalPlayer.PlayerGui.Main.Limited2:Destroy()
  game:GetService("Players").LocalPlayer.PlayerGui.Main.LimitedTime:Destroy()
  game:GetService("Players").LocalPlayer.PlayerGui.Main.Sunburst:Destroy()
  game:GetService("Players").LocalPlayer.PlayerGui.Items.ElectricKatana:Destroy()
end)
