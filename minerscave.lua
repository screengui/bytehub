loadstring(game:HttpGet("https://rawscripts.net/raw/Baseplate-adonis-and-newindex-bypass-source-12378",true))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/sidescripts/main/Watermark.lua",true))()
game.Players.LocalPlayer.PlayerGui.WatermarkGui.Watermark.Visible = false
loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/sidescripts/refs/heads/main/open%20button%20for%20mobile.lua",true))()
local Library = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local Window = Fluent:CreateWindow({
  Title = "Minecraft (Byte Hub) v3.1",
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
local strafeEnabled = false
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameRemotes = ReplicatedStorage:WaitForChild("GameRemotes")
local Attack = GameRemotes:WaitForChild("Attack")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local features = {}
local gameremotes = game:GetService("ReplicatedStorage").GameRemotes
local moveitems = gameremotes:FindFirstChild("MoveItem") or gameremotes:FindFirstChild("MoveItems")
local sortitems = gameremotes:FindFirstChild("SortItem") or gameremotes:FindFirstChild("SortItems")
local usetables = false

local oldhmmi
local oldhmmnc
oldhmmi = hookmetamethod(game, "__index", function(self, method)
  if self == player and method:lower() == "kick" then
    return error("Expected ':' not '.' calling member function Kick", 2)
  end
  return oldhmmi(self, method)
end)
oldhmmnc = hookmetamethod(game, "__namecall", function(self, ...)
	  if self == player and getnamecallmethod():lower() == "kick" then
	    return
	  end
  return oldhmmnc(self, ...)
	end)
--func

local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge

    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            local distance = (v.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).magnitude
            if distance < shortestDistance then
                closestPlayer = v.Character
                shortestDistance = distance
            end
        end
    end

    return closestPlayer
end

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
  while cl do
    local function checkHealth()
      local char = player.Character
      local humanoid = char.Humanoid
      local threshold = humanoid.MaxHealth * 0.4
      if humanoid.Health <= threshold then
        game:Shutdown()
      end
    end
    while cl and wait(1) do
      checkHealth()
    end
  end
end

function combatTp()
  while ct do
    local function checkHealth2()
      local character2 = player.Character
      if character2 then
        local humanoid2 = character:FindFirstChild("Humanoid")
        if humanoid2 then
          local threshold2 = humanoid.MaxHealth * 0.4
          if humanoid2.Health <= threshold2 then
            character2.HumanoidRootPart.CFrame = CFrame.new(math.floor(1000 * 3), math.floor(60 * 3), math.floor(1000 * 3))
          end
        end
      end
    end
      
    while cl and wait(1) do
      checkHealth2()
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
  if cesp then
    spawn(function()
      while cesp and task.wait() do
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

function lavaESP()
  if lesp then
    spawn(function()
      while lesp and task.wait() do
        local rootFolder = workspace.Fluid
        
        local function findChestParts(folder)
          local foundParts = {}
          local children = folder:GetChildren()
          for _, item in pairs(children) do
            if item.Name == "Lava" then
              table.insert(foundParts, item)
            end
          end
          return foundParts
        end

        local function createOutline(target)
          if not target:FindFirstChild("LAVA_out") then
            local outline = Instance.new("BoxHandleAdornment")
            outline.Name = "LAVA_out"
            outline.Parent = target
            outline.Adornee = target
            outline.AlwaysOnTop = true
            outline.ZIndex = 0
            outline.Size = target.Size
            outline.Transparency = 0.3
            outline.Color = BrickColor.new("Deep orange")
          end
        end

        local function exploreFolders(folder)
          for _, subfolder in pairs(folder:GetChildren()) do
            if subfolder:IsA("Folder") then
              local chestParts = findChestParts(subfolder)
              for _, chest in ipairs(chestParts) do
                createOutline(chest)
              end
              exploreFolders(subfolder)
            end
          end
        end

        exploreFolders(rootFolder)
        wait()
      end
    end)
  else
    for _, descendant in ipairs(workspace:GetDescendants()) do
      if descendant:FindFirstChild("LAVA_out") then
        descendant.LAVA_out:Destroy()
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
        local function breakBlocksBelowPlayer()
          local playerPos = player.Character.HumanoidRootPart.Position / 3
          local roundedX = math.floor(playerPos.x)
          local roundedY = math.floor(playerPos.y - 1)
          local roundedZ = math.floor(playerPos.z)
          
          bb:FireServer(roundedX, roundedY, roundedZ)
          abb:InvokeServer()
        end
        breakBlocksBelowPlayer()
      end
    end)
  end
end

function enderchest()
  if ec then
    while ec and wait() do
      game:GetService("Players").LocalPlayer.PlayerGui.HUDGui.Inventory.Chest.Visible = true
      game:GetService("Players").LocalPlayer.PlayerGui.HUDGui.Inventory.Crafting.Visible = false
      game:GetService("Players").LocalPlayer.PlayerGui.HUDGui.Inventory.Mirror.Visible = false
      game:GetService("Players").LocalPlayer.PlayerGui.HUDGui.Inventory.ResultSlot.Visible = false
      game:GetService("Players").LocalPlayer.PlayerGui.HUDGui.Inventory.Slots.Slot100.Visible = false
      game:GetService("Players").LocalPlayer.PlayerGui.HUDGui.Inventory.Slots.Slot101.Visible = false
      game:GetService("Players").LocalPlayer.PlayerGui.HUDGui.Inventory.Slots.Slot102.Visible = false
      game:GetService("Players").LocalPlayer.PlayerGui.HUDGui.Inventory.Slots.Slot103.Visible = false
      game:GetService("Players").LocalPlayer.PlayerGui.HUDGui.Inventory.Slots.Slot80.Visible = false
      game:GetService("Players").LocalPlayer.PlayerGui.HUDGui.Inventory.Slots.Slot81.Visible = false
      game:GetService("Players").LocalPlayer.PlayerGui.HUDGui.Inventory.Slots.Slot82.Visible = false
      game:GetService("Players").LocalPlayer.PlayerGui.HUDGui.Inventory.Slots.Slot83.Visible = false
      game:GetService("Players").LocalPlayer.PlayerGui.HUDGui.Inventory.Slots.Slot84.Visible = false
      game:GetService("Players").LocalPlayer.PlayerGui.HUDGui.Inventory.Slots.Slot85.Visible = false
      game:GetService("Players").LocalPlayer.PlayerGui.HUDGui.Inventory.Slots.Slot86.Visible = false
      game:GetService("Players").LocalPlayer.PlayerGui.HUDGui.Inventory.Slots.Slot87.Visible = false
      game:GetService("Players").LocalPlayer.PlayerGui.HUDGui.Inventory.Slots.Slot88.Visible = false
    end
  end
end

function infhealth()
  while infh do
    game:GetService("ReplicatedStorage").GameRemotes.MoveItem:InvokeServer(101, 9, true)
    game:GetService("ReplicatedStorage").GameRemotes.MoveItem:InvokeServer(9, 101, true)
    wait()
  end
end

function cheststealer()
  local argsList = {}
  for i = 36, 62 do
    table.insert(argsList, {i, i - 27, true})
  end

  for _, args in ipairs(argsList) do
    task.spawn(function()
        game:GetService("ReplicatedStorage").GameRemotes.MoveItem:InvokeServer(unpack(args))
    end)
  end
end

function chestdumper()
  local argsList2 = {}
  
  for i = 9, 35 do
    table.insert(argsList2, {i, i + 27, true})
  end
  
  for _, args in ipairs(argsList2) do
    task.spawn(function()
        game:GetService("ReplicatedStorage").GameRemotes.MoveItem:InvokeServer(unpack(args))
    end)
  end
end



local Tabs = {
  Credits = Window:AddTab({ Title = "Credits", Icon = "info" }),
  cs = Window:AddTab({ Title = "Combat", Icon = "swords" }),
  lp = Window:AddTab({ Title = "Player", Icon = "user" }),
  vs = Window:AddTab({ Title = "Visuals", Icon = "eye" }),
  wr = Window:AddTab({ Title = "World", Icon = "globe" }),
  dt = Window:AddTab({ Title = "Dupe", Icon = "copy" }),
  ot = Window:AddTab({ Title = "Others", Icon = "list" }),
}

Tabs.Credits:AddParagraph({
  Title = "Made by PurpleApple",
  Content = "UI Library: Fluent\nv3.1\nCredits to Minkasig for some of the features\nDupe Gui: Argentum\nOpen-Sourced\nSocials:"
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

local atptoggle = Tabs.cs:AddToggle("Auto Combat TP",
{
  Title = "Auto Safe Zone", 
  Description = "Auto Combat Log, but it teleports you to a safe zone.",
  Default = false,
  Callback = function(c2)
    ct = c2
    combatTp(c2)
  end 
}) 


Tabs.cs:AddButton({
  Title = "Arcade Recode Client",
  Description = "",
  Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/archives/main/Arcade%20Recode%20Client",true))()
  end
})

Tabs.lp:AddParagraph({
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

local infhtog = Tabs.lp:AddToggle("Infi HP",
{
  Title = "Infinite Health", 
  Description = "Increases your hp (only works with emerald leggings)",
  Default = false,
  Callback = function(infihp)
    infh = infihp
    infhealth(infihp)
  end 
}) 

local xinput = Tabs.lp:AddInput("xinput", {
  Title = "X Coordinate:",
  Description = "Input Description",
  Default = "",
  Placeholder = "Placeholder",
  Numeric = false, -- Only allows numbers
  Finished = false, -- Only calls callback when you press enter
  Callback = function(xi)
    xip = xi
  end
})

local yinput = Tabs.lp:AddInput("yinput", {
  Title = "Y Coordinate:",
  Description = "Input Description",
  Default = "",
  Placeholder = "Placeholder",
  Numeric = false, -- Only allows numbers
  Finished = false, -- Only calls callback when you press enter
  Callback = function(yi)
    yip = yi
  end
})

local zinput = Tabs.lp:AddInput("zinput", {
  Title = "Z Coordinate:",
  Description = "Input Description",
  Default = "",
  Placeholder = "Placeholder",
  Numeric = false, -- Only allows numbers
  Finished = false, -- Only calls callback when you press enter
  Callback = function(zi)
    zip = zi
  end
})

Tabs.lp:AddButton({
  Title = "Teleport to Coordinates",
  Description = "Teleports to the given coordinatex",
  Callback = function()
    local xtppos = math.floor(xip * 3)
    local ytppos = math.floor(yip * 3)
    local ztppos = math.floor(zip * 3)
    local humanroot = game.Players.LocalPlayer.Character.HumanoidRootPart
    
    humanroot.CFrame = CFrame.new(xtppos, ytppos, ztppos)
  end
})

local cesptog = Tabs.vs:AddToggle("Chest ESP",
{
  Title = "Chest ESP", 
  Description = "Makes you see chests through blocks",
  Default = false,
  Callback = function(c)
    cesp = c
    ChestESP(c)
  end 
}) 

local lesptog = Tabs.vs:AddToggle("Lava ESP",
{
  Title = "Lava ESP", 
  Description = "Makes you see lava through blocks",
  Default = false,
  Callback = function(l)
    lesp = l
    lavaESP(l)
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

Tabs.vs:AddButton({
  Title = "XRay GUI",
  Description = "Loads the XRay GUI by creepypro123",
  Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/archives/refs/heads/main/ORE%20ESP%20creepypro123",true))()
  end
})

local ectog = Tabs.vs:AddToggle("Enderchest",
{
  Title = "More Slots", 
  Description = "Gives you more inventory space",
  Default = false,
  Callback = function(echest)
    ec = echest
    enderchest(echest)
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
  Description = "Breaks blocks below you",
  Default = false,
  Callback = function(n)
    nk = n
    nuker(n)
  end 
})

Tabs.wr:AddButton({
  Title = "Chest Stealer",
  Description = "Steals Everything from a chest",
  Callback = function()
    cheststealer()
  end
})

Tabs.wr:AddButton({
  Title = "Chest Dumper",
  Description = "Dumps everything into a chest",
  Callback = function()
    chestdumper()
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

Tabs.dt:AddButton({
  Title = "Get Infinite Items",
  Description = "Select the item first then execute this",
  Callback = function()
    local args = {
      [1] = -1,
      [2] = 0,
      [3] = true,
      [4] = -99e99+100
    }
    local args2 = {[1] = {}}
    if usetables then
      args2[1][1] = args[1]
      args2[1][2] = args[2]
      args2[1][3] = args[3]
      args2[1][4] = args[4]
      moveitems:InvokeServer(unpack(args2))
    else
      moveitems:InvokeServer(unpack(args))
    end
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
  Description = "Destroys Fluent UI",
  Callback = function()
    Fluent:Destroy()
    game.Players.LocalPlayer.PlayerGui.WatermarkGui.Watermark:Destroy()
  end
})
