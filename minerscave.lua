loadstring(game:HttpGet("https://rawscripts.net/raw/Baseplate-adonis-and-newindex-bypass-source-12378",true))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/sidescripts/main/Watermark.lua",true))()
game.Players.LocalPlayer.PlayerGui.WatermarkGui.Watermark.Visible = false
local syn = getgenv().syn
getgenv().syn = false
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
getgenv().syn = syn

local Window = OrionLib:MakeWindow({Name = "Minerscave | Byte Hub", HidePremium = false, SaveConfig = true, ConfigFolder = "OrionTest", IntroEnabled = false})
-- vars

local player = game:GetService("Players").LocalPlayer
local Gamemode = Instance.new('IntValue', player.Character)
Gamemode.Name = [[Gamemode]]
local Demo = game.ReplicatedStorage.GameRemotes.Demo or game.Workspace.Demo
local ESP = loadstring(game:HttpGet("https://kiriot22.com/releases/ESP.lua"))()
local IBM = false
local NeededIBM = false
local BBA = false
local abb = game.ReplicatedStorage.GameRemotes.AcceptBreakBlock
local bb = game.ReplicatedStorage.GameRemotes.BreakBlock
local blocks = workspace.Blocks

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

function combatLog()
  if cl then
    spawn(function()
      while cl do
        local function checkHealth()
          local character = player.Character
          if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
              local threshold = humanoid.MaxHealth * 0.4
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

function noFall()
    if nf then
        while nf and task.wait() do
            Demo.Parent = game.Workspace
        end
    else
        while not nf and task.wait() do
            if Demo.Parent == game.Workspace then
                Demo.Parent = game.ReplicatedStorage.GameRemotes
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

function watermark()
    if wa then
        while wa and task.wait() do
            game.Players.LocalPlayer.PlayerGui.WatermarkGui.Watermark.Visible = true
        end
    elseif not wa then
        while not wa and task.wait(0.1) do
            game.Players.LocalPlayer.PlayerGui.WatermarkGui.Watermark.Visible = false
        end
    end
end

function playeresp()
    if pe then
        while pe and task.wait() do
            ESP:Toggle(true)
            ESP.Players = true
            ESP.Boxes = true
            ESP.Names = true
        end
    elseif not pe then
        while not pe and task.wait() do
            ESP:Toggle(false)
            ESP.Players = false
            ESP.Boxes = false
            ESP.Names = false
        end
    end
end

function instamine()
  if im then
    spawn(function()
      while im and task.wait() do
        player.Character.Gamemode.Value = 1
      end
      if im == false then
        player.Character.Gamemode.Value = 0
      end
    end)
  end
end

function fastbreak()
  if fb then
    spawn(function()
      while fb and task.wait() do
        IBM = true
        abb:InvokeServer()
      end
    end)
  end
end

function nuker()
  if nk then
    spawn(function()
      while nk and task.wait() do
        for _, v in pairs(blocks:GetDescendants()) do
          if v:IsA('MeshPart') then
            pos = v.Position
            if (player.Character.HumanoidRootPart.Position - pos).magnitude < 20 then
              bb:FireServer(pos.x/3, pos.y/3, pos.z/3)
              abb:InvokeServer()
              wait()
            end
          end
        end
      end
    end)
  end
end

--tabs
local Credits = Window:MakeTab({
	Name = "Credits",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

Credits:AddLabel("Made by PurpleApple#9562/@inconsistenttutorialuploader")
Credits:AddLabel("Byte Hub (Minecraft)")
Credits:AddLabel("Version 2.3")
Credits:AddLabel("UI Library: Orion UI")
Credits:AddLabel("Thanks to Minkasig for letting me skid his script")
Credits:AddLabel("Dupe GUI: Argentum Exploitz")
Credits:AddLabel("Open-Sourced")

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

cs:AddButton({
  Name = "Arcade Recode Client",
  Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/archives/main/Arcade%20Recode%20Client",true))()
  end    
})

local lp = Window:MakeTab({
  Name = "Movement",
  Icon = "rbxassetid://4483345998",
  PremiumOnly = false
})

lp:AddToggle({
  Name = "No Fall",
  Default = false,
  Callback = function(nfd)
    nf = nfd
    noFall(nfd)
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

local vs = Window:MakeTab({
  Name = "Visuals",
  Icon = "rbxassetid://4483345998",
  PremiumOnly = false
})

vs:AddToggle({
  Name = "Chest ESP",
  Default = false,
  Callback = function(c)
    ce = c
    ChestESP(c)
	end    
})

vs:AddToggle({
  Name = "Player ESP",
  Default = false,
  Callback = function(p)
    pe = p
    playeresp(p)
	end    
})

vs:AddToggle({
  Name = "Watermark",
  Default = false,
  Callback = function(w)
    wa = w
    watermark(w)
	end    
})

local wr = Window:MakeTab({
  Name = "World",
  Icon = "rbxassetid://4483345998",
  PremiumOnly = false
})

wr:AddToggle({
  Name = "Instamine (Client-sided)",
  Default = false,
  Callback = function(i)
    im = i
    instamine(i)
	end    
})

wr:AddToggle({
  Name = "Fast Break",
  Default = false,
  Callback = function(f)
    fb = f
    fastbreak(f)
	end    
})

wr:AddToggle({
  Name = "Nuker",
  Default = false,
  Callback = function(n)
    nk = n
    nuker(n)
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
  Name = "Dupe First Chest Slot (Press Z)",
  Callback = function()
    loadstring(game:HttpGet("https://pastebin.com/raw/TkAm8wV8",true))()
  end    
})

local ot = Window:MakeTab({
  Name = "Other",
  Icon = "rbxassetid://4483345998",
  PremiumOnly = false
})

ot:AddButton({
  Name = "Infinite Yield",
  Callback = function()
    loadstring(game:HttpGet("https://gist.githubusercontent.com/raw/b8d379c1e296ade8305c2fe4df652537"))()
  end    
})

ot:AddButton({
  Name = "SimplySpy V3",
  Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/78n/SimpleSpy/main/SimpleSpySource.lua"))()
  end    
})

ot:AddButton({
  Name = "SimplySpy Mobile",
  Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/REDzHUB/RS/main/SimpleSpyMobile"))()
  end    
})

ot:AddButton({
  Name = "Unload GUI",
  Callback = function()
    OrionLib:Destroy()
  end    
})
