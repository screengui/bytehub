local AkaliNotif = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/Dynissimo/main/Scripts/AkaliNotif.lua"))();
if not getgenv().bytehubLoaded then
  getgenv().bytehubLoaded = true
  local player = game:GetService("Players").LocalPlayer
  local Gamemode = Instance.new('IntValue', player.Character)
  Gamemode.Name = [[Gamemode]]
  local Demo = game.ReplicatedStorage.GameRemotes.Demo or game.Workspace.Demo
  local ESP = loadstring(game:HttpGet("https://kiriot22.com/releases/ESP.lua"))()
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
    local localPlayer = game.Players.LocalPlayer
    local playerPosition = localPlayer.Character:WaitForChild("HumanoidRootPart").Position

    while ka do
      for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
          local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
          if humanoidRootPart and (localPlayer:DistanceFromCharacter(humanoidRootPart.Position) < 16) then
            game.ReplicatedStorage.GameRemotes.Attack:InvokeServer(player.Character)
          end
        end
      end
      
      task.wait()
    end
  end

  function combatLog()
    local function checkHealth()
      local char = player.Character
      local humanoid = char.Humanoid
      local threshold = humanoid.MaxHealth * 0.4
      if humanoid.Health <= threshold then
        game:Shutdown()
      end
    end
    
    while cl do
      checkHealth()
      wait(1)
    end
  end
  
  function combatTp()
    local function checkHealth2()
      local character2 = player.Character
      local humanoid2 = character2:FindFirstChild("Humanoid")
      local threshold2 = humanoid2.MaxHealth * 0.4
      if humanoid2.Health <= threshold2 then
        character2.HumanoidRootPart.CFrame = CFrame.new(math.floor(1000 * 3), math.floor(60 * 3), math.floor(1000 * 3))
      end
    end
    
    while ct do
      checkHealth2()
      wait(1)
    end
  end
  
  function noFall()
    if nf and Demo.Parent == game.ReplicatedStorage.GameRemotes then
      Demo.Parent = game.Workspace
    elseif not nf and Demo.Parent == game.Workspace then
      Demo.Parent = game.ReplicatedStorage.GameRemotes
    end
  end
  function Jesus()
    local fluidFolder = game:GetService("Workspace"):FindFirstChild("Fluid")
    if not je then return end  -- Ensure fluidFolder exists and je is true
    
    while je do
      for _, child in pairs(fluidFolder:GetChildren()) do
        for _, grandchild in pairs(child:GetChildren()) do
          if grandchild:IsA("BasePart") and grandchild.Name == "Water" then
            grandchild.CanCollide = true
          end
        end
      end
      task.wait()
    end
    
    for _, child in pairs(fluidFolder:GetChildren()) do
      for _, grandchild in pairs(child:GetChildren()) do
        if grandchild:IsA("BasePart") and grandchild.Name == "Water" then
          grandchild.CanCollide = false
        end
      end
    end
  end
  
  function ChestESP()
    if not cesp then return end
    while cesp do
      local function findChestParts()
        local childParts = {}
        for _, folder in pairs(workspace.Blocks:GetChildren()) do
          if folder:IsA("Folder") then
            for _, item in pairs(folder:GetChildren()) do
              if item.Name == "Chest" then
                table.insert(childParts, item)
              end
            end
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
      
      local chestParts = findChestParts()
      
      for _, part in ipairs(chestParts) do
        outlinePart(part)
      end
      
      task.wait()
    end
    for _, descendant in ipairs(workspace:GetDescendants()) do
      if descendant:FindFirstChild("CHEST_out") then
        descendant.CHEST_out:Destroy()
      end
    end
  end
  
  function lavaESP()
    if not lesp then return end
    while lesp do
      local function findLavaParts()
        local foundParts = {}
        for _, folder in pairs(workspace.Fluid:GetChildren()) do
          if folder:IsA("Folder") then
            for _, item in pairs(folder:GetChildren()) do
              if item.Name == "Lava" then
                table.insert(foundParts, item)
              end
            end
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
      
      local lavaParts = findLavaParts()
      
      for _, part in ipairs(lavaParts) do
        createOutline(part)
      end
      
      task.wait()
    end
    for _, descendant in ipairs(workspace:GetDescendants()) do
      if descendant:FindFirstChild("LAVA_out") then
        descendant.LAVA_out:Destroy()
      end
    end
  end
  
  function watermark()
    game.Players.LocalPlayer.PlayerGui.WatermarkGui.Watermark.Visible = wa
  end

  function playeresp()
    if pe then
      ESP:Toggle(true)
      ESP.Players = true
      ESP.Boxes = true
      ESP.Names = true
    else
      ESP:Toggle(false)
      ESP.Players = false
      ESP.Boxes = false
      ESP.Names = false
    end
  end

  function instamine()
    player.Character.Gamemode.Value = im and 1 or 0
  end

  function fastbreak()
    while fb do
      abb:InvokeServer()
      task.wait()
    end
  end

  function nuker()
    while nk do
      local playerPos = player.Character.HumanoidRootPart.Position / 3
      local roundedX, roundedY, roundedZ =
        math.floor(playerPos.x), 
        math.floor(playerPos.y - 1), 
        math.floor(playerPos.z)

      bb:FireServer(roundedX, roundedY, roundedZ)
      abb:InvokeServer()

      task.wait()
    end
  end
  
  function enderchest()
    while ec do
      local playerGui = game:GetService("Players").LocalPlayer.PlayerGui
      local inventory = playerGui.HUDGui.Inventory
      
      inventory.Chest.Visible = true
      inventory.Crafting.Visible = false
      inventory.Mirror.Visible = false
      inventory.ResultSlot.Visible = false
      
      local slots = {
        "Slot100", "Slot101", "Slot102", "Slot103",
        "Slot80", "Slot81", "Slot82", "Slot83", "Slot84", 
        "Slot85", "Slot86", "Slot87", "Slot88"
      }

      for _, slotName in ipairs(slots) do
        local slot = inventory.Slots:FindFirstChild(slotName)
        if slot then
          slot.Visible = false
        end
      end

      wait()
    end
  end

  function infhealth()
    while infh do
      moveitems:InvokeServer(101, 9, true)
      moveitems:InvokeServer(9, 101, true)
      task.wait()
    end
  end

  function cheststealer()
    for i = 36, 62 do
      task.spawn(function()
        game:GetService("ReplicatedStorage").GameRemotes.MoveItem:InvokeServer(i, i - 27, true)
      end)
    end
  end
  
  loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/sidescripts/main/Watermark.lua",true))()
  loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/sidescripts/refs/heads/main/open%20button%20for%20mobile.lua",true))()
  loadstring(game:HttpGet("https://rawscripts.net/raw/Baseplate-adonis-and-newindex-bypass-source-12378",true))()
  game.Players.LocalPlayer.PlayerGui.WatermarkGui.Watermark.Visible = false
  local Library = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
  local Window = Fluent:CreateWindow({
    Title = "Minecraft (Byte Hub) v3.2",
    SubTitle = "by PurpleApple",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
  })

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
    Content = "UI Library: Fluent\nv3.2\nCredits to Minkasig for some of the features\nDupe Gui: Argentum\nOpen-Sourced\nSocials:"
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
    Description = "Teleports to the given coordinates",
    Callback = function()
      local xtppos = math.floor(xip * 3)
      local ytppos = math.floor(yip * 3)
      local ztppos = math.floor(zip * 3)
      local humanroot = game.Players.LocalPlayer.Character.HumanoidRootPart
    
      humanroot.CFrame = CFrame.new(xtppos, ytppos, ztppos)
    end
  })

  Tabs.lp:AddButton({
    Title = "Reload Chunks",
    Description = "Reloads Chunks",
    Callback = function()
      local humanroot2 = game.Players.LocalPlayer.Character.HumanoidRootPart
      local pos = Vector3.new(
      math.floor(humanroot2.Position.X),
      math.floor(humanroot2.Position.Y),
      math.floor(humanroot2.Position.Z)
      )
      wait()
      humanroot2.CFrame = CFrame.new(math.floor(10000 * 3), math.floor(60 * 3), math.floor(10000 * 3))
      wait(1)
      humanroot2.CFrame = CFrame.new(pos)
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
      watermark(w)
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
    Title = "Chest Stealer / Dumper",
    Description = "Steals/Dumps everything from/into a chest",
    Callback = function()
      cheststealer()
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
      loadstring(game:HttpGet("https://pastebin.com/raw/nDPZ9s0h",true))()
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
      getgenv().bytehubLoaded = false
      game.Players.LocalPlayer.PlayerGui.WatermarkGui:Destroy()
      game.Players.LocalPlayer.DraggableFrameGui:Destroy()
    end
  })
else
  local Notify = AkaliNotif.Notify;

  Notify({
    Description = "Byte Hub is already loaded!";
    Title = "Error!";
    Duration = 3;
  });
  wait(1)
end
