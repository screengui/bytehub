loadstring(game:HttpGet("https://rawscripts.net/raw/Baseplate-adonis-and-newindex-bypass-source-12378",true))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/sidescripts/main/Watermark.lua",true))()
game.Players.LocalPlayer.PlayerGui.WatermarkGui.Watermark.Visible = false
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/UI-Interface/ArrayField/main/Source.lua'))()
local Window = Rayfield:CreateWindow({
   Name = "ArrayField Example Window",
   LoadingTitle = "ArrayField Interface Suite",
   LoadingSubtitle = "by Arrays",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "ArrayField"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },
   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided",
      FileName = "Key", -- It is recommended to use something unique as other scripts using ArrayField may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like ArrayField to get the key from
      Actions = {
            [1] = {
                Text = 'Click here to copy the key link <--',
                OnPress = function()
                    print('Pressed')
                end,
                }
            },
      Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

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

local Credits = Window:CreateTab("Credits", 4483362458)
Credits:CreateLabel("Made by PurpleApple#9562/@inconsistenttutorialuploader")
Credits:CreateLabel("Byte Hub (Minecraft)")
Credits:CreateLabel("Version 2.2")
Credits:CreateLabel("UI Library: Arrayfield/Rayfield UI")
Credits:CreateLabel("Thanks to Minkasig for letting me skid his script")
Credits:CreateLabel("Dupe GUI: Argentum Exploitz")
Credits:CreateLabel("Open-Sourced")

local cs = Window:CreateTab("Combat", 4483362458)

local killaura = cs:CreateToggle({
    Name = "Kill Aura",
    CurrentValue = false,
    Flag = "aurakill",
    Callback = function(k)
        ka = k
        KillAura(k)
    end,
})

local autolog = cs:CreateToggle({
    Name = "Auto Combat Log",
    CurrentValue = false,
    Flag = "acl",
    Callback = function(clf)
        cl = clf
        combatLog(clf)
    end,
})


local arc = cs:CreateButton({
    Name = "Arcade Recode Client",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/archives/main/Arcade%20Recode%20Client",true))()
    end,
})

local lp = Window:CreateTab("Movement", 4483362458)

local nof = lp:CreateToggle({
    Name = "No Fall",
    CurrentValue = false,
    Flag = "nfall",
    Callback = function(nfd)
        nf = nfd
        noFall(nfd)
    end,
}) 

local wow = lp:CreateToggle({
    Name = "Jesus",
    CurrentValue = false,
    Flag = "wow2",
    Callback = function(j)
        je = j
        Jesus(j)
    end,
}) 

local vs = Window:CreateTab("Visuals", 4483362458)

local cesp = vs:CreateToggle({
    Name = "Chest ESP",
    CurrentValue = false,
    Flag = "cesp1",
    Callback = function(c)
        ce = c
        ChestESP(c)
    end,
}) 

local watm = vs:CreateToggle({
    Name = "Watermark",
    CurrentValue = false,
    Flag = "watmr",
    Callback = function(w)
        wa = w
        watermark(w)
    end,
})

local esptog = vs:CreateToggle({
    Name = "Player ESP",
    CurrentValue = false,
    Flag = "pesp",
    Callback = function(p)
        pe = p
        playeresp(p)
    end,
})

local wr = Window:CreateTab("World", 4483362458)

local imi = wr:CreateToggle({
    Name = "Instamine",
    CurrentValue = false,
    Flag = "ima",
    Callback = function(i)
        im = i
        instamine(i)
    end,
})

local fbtog = wr:CreateToggle({
    Name = "Fast Break",
    CurrentValue = false,
    Flag = "fbflag",
    Callback = function(f)
        fb = f
        fastbreak(f)
    end,
})

local nukertog = wr:CreateToggle({
    Name = "Nuker (breaks some blocks in a certain radius)",
    CurrentValue = false,
    Flag = "nflag",
    Callback = function(n)
        nk = n
        nuker(n)
    end,
})

local dt = Window:CreateTab("Dupe", 4483362458)

local dupegui = dt:CreateButton({
    Name = "Dupe GUI",
    Callback = function()
        loadstring(game:HttpGet("https://gist.githubusercontent.com/raw/b8d379c1e296ade8305c2fe4df652537"))()
    end,
})

local dupez = dt:CreateButton({
    Name = "Dupe First Slot (Press Z)",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/TkAm8wV8",true))()
    end,
})

local ot = Window:CreateTab("Others", 4483362458)

local iy = ot:CreateButton({
    Name = "Infinite Yield",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source",true))()
    end,
})

local rspy3 = ot:CreateButton({
    Name = "SimpleSpy V3",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/78n/SimpleSpy/main/SimpleSpySource.lua"))()
    end,
})

local rspym = ot:CreateButton({
    Name = "SimpleSpy Mobile",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/REDzHUB/RS/main/SimpleSpyMobile"))()
    end,
})

local dexpc = ot:CreateButton({
    Name = "Dex V4",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/fPP8bZ8Z"))()
    end,
})

local dexv2 = ot:CreateButton({
    Name = "Dex V2",
    Callback = function()
        loadstring(game:HttpGet("https://cdn.wearedevs.net/scripts/Dex%20Explorer.txt"))()
    end,
})

local ug = ot:CreateButton({
    Name = "Unload GUI",
    Callback = function()
        Rayfield:Destroy()
    end,
})
