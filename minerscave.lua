loadstring(game:HttpGet("https://rawscripts.net/raw/Baseplate-adonis-and-newindex-bypass-source-12378",true))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/sidescripts/main/Watermark.lua",true))()
game.Players.LocalPlayer.PlayerGui.WatermarkGui.Watermark.Visible = false
local Library = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local Window = Fluent:CreateWindow({
  Title = "Minecraft (Byte Hub) 2.6",
  SubTitle = "by PurpleApple",
  TabWidth = 160,
  Size = UDim2.fromOffset(580, 460),
  Acrylic = false, -- The blur may be detectable, setting this to false disables blur entirely
  Theme = "Dark",
  MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
})

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
  if nf and Demo.Parent == game.ReplicatedStorage.GameRemotes then
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

local Tabs = {
  Credits = Window:AddTab({ Title = "Credits", Icon = "info" }),
  cs = Window:AddTab({ Title = "Combat", Icon = "swords" }),
  lp = Window:AddTab({ Title = "Movement", Icon = "circle-user-round" }),
  vs = Window:AddTab({ Title = "Visuals", Icon = "eye" }),
  wr = Window:AddTab({ Title = "World", Icon = "earth" }),
  dt = Window:AddTab({ Title = "Dupe", Icon = "copy" }),
  ot = Window:AddTab({ Title = "Others", Icon = "ellipsis" })
}

Tabs.Credits:AddParagraph({
  Title = "Made by PurpleApple",
  Content = "UI Library: Fluent\nVersion 2.4\nCredits to Minkasig for some of the features\nDupe Gui: Argentum\nOpen-Sourced\nSocials:"
})

Tabs.Credits:AddButton({
  Title = "YouTube",
  Description = "My YouTube Channel",
  Callback = function()
    setclipboard("https://youtube.com/@inconsistenttutorialuploader")
  end
})
Tabs.Credits:AddButton({
  Title = "Discord",
  Description = "My Discord Server",
  Callback = function()
    setclipboard("https://discord.gg/9y7JM7Anne")
  end
})

Tabs.Credits:AddButton({
  Title = "GitHub",
  Description = "My GitHub Page",
  Callback = function()
    setclipboard("https://github.com/screengui")
  end
})

Tabs.Credits:AddButton({
  Title = "ScriptBlox",
  Description = "My ScriptBlox Account",
  Callback = function()
    setclipboard("https://scriptblox.com/u/tycoonman95")
  end
})

local katoggle = Tabs.cs:AddToggle("Kill Aura",
{
  Title = "Kill Aura", 
  Description = "Attacks people within your reach",
  Default = false,
  Callback = function(k)
    ka = k
    KillAura(k)
  end 
}) 

local acltoggle = Tabs.cs:AddToggle("Auto Combat Log",
{
  Title = "Auto Combat Log", 
  Description = "Automatically leaves when you have less than 30% hp",
  Default = false,
  Callback = function(c)
    cl = c
    combatLog(c)
  end 
}) 

Tabs.cs:AddButton({
  Title = "Arcade Recode Client",
  Description = "",
  Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/archives/main/Arcade%20Recode%20Client",true))()
  end
})

Tabs.Credits:AddParagraph({
  Title = "IMPORTANT!!!",
  Content = "If things dont load, turn No Fall on and off"
})

local nftog = Tabs.lp:AddToggle("No Fall",
{
  Title = "No Fall", 
  Description = "Removes Fall Damage",
  Default = false,
  Callback = function(n)
    nf = n
    noFall(n)
  end 
}) 

local jetog = Tabs.lp:AddToggle("Jesus",
{
  Title = "Jesus", 
  Description = "Walk On Water",
  Default = false,
  Callback = function(j)
    je = j
    Jesus(j)
  end 
}) 

local cesptog = Tabs.vs:AddToggle("Chest DSP",
{
  Title = "Chest ESP", 
  Description = "Makes you see chests through blocks",
  Default = false,
  Callback = function(c)
    cesp = c
    ChestESP(c)
  end 
}) 

local pesptog = Tabs.vs:AddToggle("Player ESP",
{
  Title = "Player ESP", 
  Description = "Makes you see players through blocks",
  Default = false,
  Callback = function(p)
    pesp = p
    PlayerESP(p)
  end 
}) 
local wtog = Tabs.vs:AddToggle("Watermark",
{
  Title = "Watermark", 
  Description = "Adds the Byte Hub watermark",
  Default = false,
  Callback = function(w)
    wa = w
    Watermark(w)
  end 
}) 

local imtog = Tabs.wr:AddToggle("Instamine",
{
  Title = "Instamine", 
  Description = "Instantly Mines, but client-sided",
  Default = false,
  Callback = function(i)
    im = i
    instamine(i)
  end 
}) 

local fbtog = Tabs.wr:AddToggle("Fast Break",
{
  Title = "Fast Break", 
  Description = "Breaks blocks fast (with the correct tools)",
  Default = false,
  Callback = function(f)
    fb = f
    fastbreak(f)
  end 
})

local nktog = Tabs.wr:AddToggle("Nuker",
{
  Title = "Nuker", 
  Description = "Breaks blocks around you in a radius",
  Default = false,
  Callback = function(n)
    nk = n
    nuker(n)
  end 
}) 

Tabs.dt:AddButton({
  Title = "Dupe GUI",
  Description = "Loads the Dupe GUI by Argentum Exploitz",
  Callback = function()
    loadstring(game:HttpGet("https://gist.githubusercontent.com/raw/b8d379c1e296ade8305c2fe4df652537"))()
  end
})

Tabs.dt:AddButton({
  Title = "Dupe First Chest Slot",
  Description = "Dupes the first chest slot by pressing Z",
  Callback = function()
    loadstring(game:HttpGet("https://gist.githubusercontent.com/raw/b8d379c1e296ade8305c2fe4df652537"))()
  end
})

Tabs.ot:AddButton({
  Title = "Infinite Yield",
  Description = "Loads Infinite Yield admin commands",
  Callback = function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
  end
})

Tabs.ot:AddButton({
  Title = "Mobile Keyboard",
  Description = "Loads a mobile OSK",
  Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/advxzivhsjjdhxhsidifvsh/mobkeyboard/main/main.txt", true))()
  end
})

Tabs.ot:AddButton({
  Title = "Remote Spy (Mobile & PC)",
  Description = "Loads a Mobile & PC RemoteSpy",
  Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/REDzHUB/RS/main/SimpleSpyMobile"))()
  end
})

Tabs.ot:AddButton({
  Title = "Destroy UI",
  Description = "Loads a Mobile & PC RemoteSpy",
  Callback = function()
    Fluent:Destroy()
  end
})
