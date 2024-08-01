loadstring(game:HttpGet("https://rawscripts.net/raw/Baseplate-adonis-and-newindex-bypass-source-12378",true))()
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "Minecraft (Byte Hub)", HidePremium = false, SaveConfig = true, ConfigFolder = "OrionTest", IntroEnabled = false})

local player = game:GetService("Players").LocalPlayer

--func
function KillAura()
  spawn(function()
    while ka and task.wait() do
      for i,v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer and v.Character and game.Players.LocalPlayer:DistanceFromCharacter(v.Character.HumanoidRootPart.Position) < 16 then
          game.ReplicatedStorage.GameRemotes.Attack:InvokeServer(v.Character)
        end
      end
      for i,v in pairs(game:GetService("Workspace").Animals:GetChildren()) do
        if v:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer:DistanceFromCharacter(v.HumanoidRootPart.Position) < 16 then
          game.ReplicatedStorage.GameRemotes.AttackMob:InvokeServer(v)
        end
      end
      wait()
    end
  end)
end

function ChestESP()
  if ce then
    spawn(function()
      while ce and task.wait() do
        local parentFolder = workspace.Blocks

        local function checkFolderForChildParts(folder)
          local childParts = {}
          local children = folder:GetChildren()
          for _, child in pairs(children) do
            if child.Name == "Chest" then
              table.insert(childParts, child)
            end
          end
          return childParts
        end

        local function outlinePart(part)
          if not part:FindFirstChild("CHEST_out") then
            local a = Instance.new("BoxHandleAdornment")
            a.Name = "CHEST_out"
            a.Parent = part
            a.Adornee = part
            a.AlwaysOnTop = true
            a.ZIndex = 0
            a.Size = part.Size
            a.Transparency = 0.3
            a.Color = BrickColor.new("Bright orange")
          end
        end

        local function iterateAndCheckFolders(parent)
          for _, folder in pairs(parent:GetChildren()) do
            if folder:IsA("Folder") then
              local childParts = checkFolderForChildParts(folder)
              for _, childPart in ipairs(childParts) do
                outlinePart(childPart)
              end
              iterateAndCheckFolders(folder)
            end
          end
        end

        iterateAndCheckFolders(parentFolder)
        wait()
      end
    end)
  else
    for _, part in ipairs(workspace:GetDescendants()) do
      if part:FindFirstChild("CHEST_out") then
        part.CHEST_out:Destroy()
      end
    end
  end
end

function Jesus()
  local fluidFolder = game:GetService("Workspace"):FindFirstChild("Fluid")
  if je then
    spawn(function()
      while je and task.wait() do
        for _, child in pairs(fluidFolder:GetChildren()) do
          for _, grandchild in pairs(child:GetChildren()) do
            if grandchild:IsA("BasePart") and grandchild.Name == "Water" then
              grandchild.CanCollide = true
            end
            if je == false then
              grandchild.CanCollide = false
            end
          end
        end
      end
    end)
  end
end

function combatLog()
  if cl then
    spawn(function()
      while cl do
        local function checkHealth()
          local character = player.Character
          if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
              local threshold = humanoid.MaxHealth * 0.3
              if humanoid.Health <= threshold then
                player:Kick("Combat Logged by ByteHub")
              end
            end
          end
        end
      
        while wait(1) do
          checkHealth()
        end
      end
    end)
  end
end

--Credits
local Credits = Window:MakeTab({
  Name = "Credits",
  Icon = "rbxassetid://4483345998",
  PremiumOnly = false
})

Credits:AddLabel("Made by PurpleApple#9562/@inconsistenttutorialuploader")
Credits:AddLabel("Byte Hub (Minecraft)")
Credits:AddLabel("Version 2.0")
Credits:AddLabel("UI Library: Orion Library")
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
  Callback = function(k)
    ka = k
    KillAura(k)
  end    
})

cs:AddToggle({
  Name = "Auto Combat Log",
  Default = false,
  Callback = function(clf)
    cl = clf
    combatLog(clf)
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


lp:AddToggle({
  Name = "Jesus",
  Default = false,
  Callback = function(j)
    je = j
    Jesus(j)
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
  Callback = function(c)
    ce = c
    ChestESP(c)
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
