local AkaliNotif = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/Dynissimo/main/Scripts/AkaliNotif.lua"))(); -- Notif Library
if not getgenv().bytehubLoaded then
  getgenv().bytehubLoaded = true
  
  -- Services --
  local TweenService = game:GetService("TweenService")
  local UserInputService = game:GetService("UserInputService")
  local RunService = game:GetService("RunService")
  local ReplicatedStorage = game:GetService("ReplicatedStorage")
  local Workspace = game:GetService("Workspace")
  
  -- Variables --
  
  local player = game:GetService("Players").LocalPlayer
  local LP = game.Players.LocalPlayer
  local Character = player.Character
  local Gamemode = Instance.new('IntValue', player.Character)
  Gamemode.Name = [[Gamemode]]
  local ESP = loadstring(game:HttpGet("https://kiriot22.com/releases/ESP.lua"))()
  local metaBlocks = game.ReplicatedFirst:FindFirstChild("MetaBlocks")
  local blocks = workspace.Blocks
  local strafeEnabled = false
  local features = {}
  local usetables = false
  local isMobile
  local isPC
  local hasGiveExploit
  local delay = 0
  local useTaskSpawn = false
  
  -- Remotes --
  local gameremotes = ReplicatedStorage.GameRemotes
  local GameRemotes = ReplicatedStorage.GameRemotes
  local Demo = gameremotes:FindFirstChild("Demo") or Workspace:FindFirstChild("Demo")
  local abb = gameremotes.AcceptBreakBlock
  local bb = gameremotes.BreakBlock
  local Attack = gameremotes:WaitForChild("Attack")
  local moveitems = gameremotes:FindFirstChild("MoveItem") or gameremotes:FindFirstChild("MoveItems")
  local sortitems = gameremotes:FindFirstChild("SortItem") or gameremotes:FindFirstChild("SortItems")
  local useblock = gameremotes.UseBlock
  
  -- Anti Kick --
  
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
  
  -- Functions --

  if game.ReplicatedStorage:FindFirstChild("admingui") then
    hasGiveExploit = true
    local Notify = AkaliNotif.Notify;

    Notify({
      Description = "Might want to try giving urself stuff ;) (Dupe Tab)!";
      Title = "Give Exploit Detected!";
      Duration = 3;
    });
  else
    hasGiveExploit = false
  end
  
  function KillAura()
    local localPlayer = game.Players.LocalPlayer

    local function attackLoop()
      while ka do
        for _, player in ipairs(game.Players:GetPlayers()) do
          if player ~= localPlayer and player.Character then
            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart and (localPlayer:DistanceFromCharacter(humanoidRootPart.Position) < 16) then
              game.ReplicatedStorage.GameRemotes.Attack:InvokeServer(player.Character)
            end
          end
        end
        task.wait(delay)
      end
    end

    if useTaskSpawn then
      task.spawn(attackLoop) -- Runs attackLoop asynchronously
    else
      attackLoop() -- Runs attackLoop normally (blocking)
    end
  end
  
  function CombatLog()
    local function checkHealth()
      local character = player.Character
      if not character then return end

      local humanoid = character:FindFirstChildOfClass("Humanoid")
      if not humanoid then return end
      
      local healthThreshold = humanoid.MaxHealth * 0.4
        if humanoid.Health <= healthThreshold then
          game:Shutdown()
        end
    end
    
    local function healthLoop()
        while cl do
            checkHealth()
            task.wait(0.25)
        end
    end

    if useTaskSpawn then
        task.spawn(healthLoop) -- Runs the loop asynchronously
    else
        healthLoop() -- Runs normally (blocking)
    end
  end
  
  function CombatTp()
    local function checkHealth2()
      local character = player.Character
      if not character then return end

      local humanoid = character:FindFirstChild("Humanoid")
      local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
      if not humanoid or not humanoidRootPart then return end

      local healthThreshold = humanoid.MaxHealth * 0.4
      if humanoid.Health <= healthThreshold then
        local teleportPosition = CFrame.new(1000 * 3, 60 * 3, 1000 * 3)
        humanoidRootPart.CFrame = teleportPosition
      end
    end

    local function tpLoop()
      while ctp do
        checkHealth2()
        task.wait(0.25)
      end
    end

    if useTaskSpawn then
      task.spawn(tpLoop) -- Runs asynchronously
    else
      tpLoop() -- Runs normally (blocking)
    end
  end
  
  function noFall()
    if nf then
      if Demo.Parent == GameRemotes then
        Demo.Parent = Workspace
      end
    else
      if Demo.Parent == Workspace then
        Demo.Parent = GameRemotes
      end
    end
  end
  
  function Jesus()
    local fluidFolder = Workspace:FindFirstChild("Fluid")
    if not je or not fluidFolder then return end

    local function waterLoop()
      while je do
        for _, child in pairs(fluidFolder:GetChildren()) do
          for _, grandchild in pairs(child:GetChildren()) do
            if grandchild:IsA("BasePart") and (grandchild.Name == "Water" or grandchild.Name == "Lava") then
              grandchild.CanCollide = true
            end
          end
        end
        task.wait()
      end

      -- Reset water collision when loop ends
      for _, child in pairs(fluidFolder:GetChildren()) do
        for _, grandchild in pairs(child:GetChildren()) do
          if grandchild:IsA("BasePart") and (grandchild.Name == "Water" or grandchild.Name == "Lava") then
            grandchild.CanCollide = false
          end
        end
      end
    end

    if useTaskSpawn then
      task.spawn(waterLoop) -- Runs asynchronously
    else
      waterLoop() -- Runs normally (blocking)
    end
  end
  
  function ChestESP()
    if not cesp then return end
    
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
      if not part:FindFirstChild("BoxHandleAdornment") then
        local a = Instance.new("BoxHandleAdornment", part)
        a.Adornee = part
        a.AlwaysOnTop = true
        a.ZIndex = 0
        a.Size = part.size
        a.Transparency = 0.5
        a.Color = BrickColor.new("Bright orange")
      end
    end
    
    while cesp do
      local chestParts = findChestParts()
      
      for _, part in ipairs(chestParts) do
        outlinePart(part)
      end
      task.wait()
    end
    
    for _, descendant in ipairs(workspace:GetDescendants()) do
      local highlight = descendant:FindFirstChild("BoxHandleAdornment")
      if highlight then
        highlight:Destroy()
      end
    end
  end

  function ChestESP()
    if not cesp then return end

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
      if not part:FindFirstChild("BoxHandleAdornment") then
        local a = Instance.new("BoxHandleAdornment")
        a.Adornee = part
        a.AlwaysOnTop = true
        a.ZIndex = 0
        a.Size = part.Size
        a.Transparency = 0.5
        a.Color = BrickColor.new("Bright orange")
        a.Parent = part
      end
    end

    local function chestLoop()
      while cesp do
        local chestParts = findChestParts()
        for _, part in ipairs(chestParts) do
          outlinePart(part)
        end
        task.wait()
      end

      -- Cleanup when `cesp` is false
      for _, descendant in ipairs(workspace:GetDescendants()) do
        local highlight = descendant:FindFirstChild("BoxHandleAdornment")
        if highlight then
          highlight:Destroy()
        end
      end
    end

    if useTaskSpawn then
      task.spawn(chestLoop) -- Runs asynchronously
    else
      chestLoop() -- Runs normally (blocking)
    end
  end
  
  function LavaESP()
    if not lesp then return end
    
    local function findLava()
      local lavaBlocks = {}
        for _, folder in pairs(workspace.Fluid:GetChildren()) do
          if folder:IsA("Folder") then
            for _, item in pairs(folder:GetChildren()) do
              if item.Name == "Lava" then
                table.insert(lavaBlocks, item)
              end
            end
          end
        end
      return lavaBlocks
    end
    
    local function createOutline(target)
      if not target:FindFirstChild("BoxHandleAdornment") then
        local b = Instance.new("BoxHandleAdornment")
        b.Adornee = target
        b.AlwaysOnTop = true
        b.ZIndex = 0
        b.Size = target.Size
        b.Transparency = 0.5
        b.Color = BrickColor.new("Deep orange")
        b.Parent = target
      end
    end

    local function lavaLoop()
      while lesp do
        local lavaParts = findLava()
        for _, part in ipairs(lavaParts) do
          createOutline(part)
        end
        task.wait()
      end
        
      -- Cleanup when `lesp` is set to false
      for _, descendant in ipairs(workspace:GetDescendants()) do
        local bha = descendant:FindFirstChild("BoxHandleAdornment")
        if bha then
          bha:Destroy()
        end
      end
    end

    if useTaskSpawn then
      task.spawn(lavaLoop) -- Runs asynchronously
    else
      lavaLoop() -- Runs normally (blocking)
    end
  end

  function playeresp()
    while pesp do
      for _, players in pairs(game.Players:GetPlayers()) do
        if players ~= LP and not players.Character:FindFirstChild("Highlight") then
          Instance.new("Highlight", players.Character)
        end
      end
      task.wait()
    end
    for _, players in pairs(game.Players:GetPlayers()) do
      local highlight = players.Character:FindFirstChild("Highlight")
      if highlight then
        highlight:Destroy()
      end
    end
  end

  function InstaMine()
    player.Character.Gamemode.Value = im and 1 or 0
  end

  function FastBreak()
    while fb do
      abb:InvokeServer()
      task.wait()
    end
  end

  function Nuker()
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
  
  function Nuker3()
    while nk3 do
        local playerPos = player.Character.HumanoidRootPart.Position / 3
        local baseX, baseY, baseZ =
            math.floor(playerPos.X),
            math.floor(playerPos.Y - 1),
            math.floor(playerPos.Z)

        -- Collect positions
        local positions = {}
        for offsetX = -1, 1 do
            for offsetZ = -1, 1 do
                local roundedX = baseX + offsetX
                local roundedY = baseY
                local roundedZ = baseZ + offsetZ

                table.insert(positions, {roundedX, roundedY, roundedZ})
            end
        end
      
      bb:FireServer(positions[1], positions[2], positions[3])
      abb:InvokeServer()
        task.wait()
    end
end
  
  function EnderChest()
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

      task.wait()
    end
  end

  function infhealth()
    local function healthLoop()
      while infh do
        moveitems:InvokeServer(101, 9, true)
        moveitems:InvokeServer(9, 101, true)
        task.wait()
      end
    end

    if useTaskSpawn then
      task.spawn(healthLoop) -- Runs asynchronously
    else
      healthLoop() -- Runs normally (blocking)
    end
  end

  function cheststealer()
    for i = 36, 62 do
      task.spawn(function()
        game:GetService("ReplicatedStorage").GameRemotes.MoveItem:InvokeServer(i, i - 27, true)
      end)
    end
  end
  
  function chestdupe(mode)
    if mode == 1 then
      sortitems:InvokeServer(36)
    elseif mode == 2 then
      for i = 36, 62 do
        task.spawn(function()
          sortitems:InvokeServer(i)
        end)
      end
    end
  end
  
  function getlava()
    local xlp = math.floor(Character.HumanoidRootPart.Position.X / 3)
    local ylp = math.floor(Character.HumanoidRootPart.Position.Y / 3) - 2
    local zlp = math.floor(Character.HumanoidRootPart.Position.Z / 3)

    local args = {
      [1] = xlp,
      [2] = ylp,
      [3] = zlp,
      [4] = 0
    }
    
    useblock:InvokeServer(unpack(args))
  end
  
  function conv(txt)
    local str = ""
    string.gsub(txt,"%d+",function(e)
      str = str .. e
    end)
    return str;
  end

  if UserInputService.KeyboardEnabled and UserInputService.MouseEnabled then
    isPC = true
    local Notify = AkaliNotif.Notify;
    Notify({
      Description = "PC Detected, Infinite Health might not work...";
      Title = "PC Detected!";
      Duration = 3;
    });
  elseif UserInputService.TouchEnabled then
    isMobile = true
    local Notify = AkaliNotif.Notify;
    Notify({
      Description = "Mobile Device Detected, executing button...";
      Title = "Mobile Device Detected!";
      Duration = 3;
    });
    loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/sidescripts/refs/heads/main/open%20button%20for%20mobile.lua",true))()
  end
  
  loadstring(game:HttpGet("https://rawscripts.net/raw/Baseplate-adonis-and-newindex-bypass-source-12378",true))()
  local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
  local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
  local Window = Fluent:CreateWindow({
    Title = "Minecraft (Byte Hub) v4.0",
    SubTitle = "by PurpleApple",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftShift -- Used when theres no MinimizeKeybind
  })

  local Tabs = {
    Credits = Window:AddTab({ Title = "Credits", Icon = "info" }),
    cs = Window:AddTab({ Title = "Combat", Icon = "swords" }),
    lp = Window:AddTab({ Title = "Player", Icon = "user" }),
    vs = Window:AddTab({ Title = "Visuals", Icon = "eye" }),
    wr = Window:AddTab({ Title = "World", Icon = "globe" }),
    dt = Window:AddTab({ Title = "Dupe", Icon = "copy" }),
    ot = Window:AddTab({ Title = "Others", Icon = "list" }),
    st = Window:AddTab({ Title = "Settings", Icon = "settings" }),
  }

  local Options = Fluent.Options
  
  Tabs.Credits:AddParagraph({
    Title = "Made by PurpleApple",
    Content = "UI Library: Fluent\nv3.9\nDupe Gui: Argentum\nOpen-Sourced\nSocials:"
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

  local katog = Tabs.cs:AddToggle("Kill Aura",
  {
    Title = "Kill Aura", 
    Description = "Attacks people within your reach",
    Default = false,
    Callback = function(k)
      ka = k
      KillAura(k)
    end 
  })

  local acltog = Tabs.cs:AddToggle("Auto Combat Log",
  {
    Title = "Auto Combat Log", 
    Description = "Automatically leaves when you have less than 30% hp",
    Default = false,
    Callback = function(c)
      cl = c
      CombatLog(c)
    end 
  }) 

  local acttog = Tabs.cs:AddToggle("Auto Combat TP",
  {
    Title = "Auto Safe Zone", 
    Description = "Auto Combat Log, but it teleports you to a safe zone.",
    Default = false,
    Callback = function(c2)
      ctp = c2
      CombatTp(c2)
    end 
  }) 


  Tabs.cs:AddButton({
    Title = "Arcade Recode Client",
    Description = "Executes Arcade Recode Client",
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
    Numeric = false,
    Finished = false,
    Callback = function(xi)
      xip = xi
    end
  })

  local yinput = Tabs.lp:AddInput("yinput", {
    Title = "Y Coordinate:",
    Description = "Input Description",
    Default = "",
    Placeholder = "Placeholder",
    Numeric = false,
    Finished = false,
    Callback = function(yi)
      yip = yi
    end
  })

  local zinput = Tabs.lp:AddInput("zinput", {
    Title = "Z Coordinate:",
    Description = "Input Description",
    Default = "",
    Placeholder = "Placeholder",
    Numeric = false,
    Finished = false,
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
      LavaEspState = l
      LavaESP(l)
    end 
  }) 

  local pesptog = Tabs.vs:AddToggle("Player ESP",
  {
    Title = "Player ESP", 
    Description = "Makes you see players through blocks",
    Default = false,
    Callback = function(p)
      pesp = p
      playeresp(p)
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
      EnderChest(echest)
    end 
  })

  local imtog = Tabs.wr:AddToggle("Instamine",
  {
    Title = "Instamine", 
    Description = "Instantly Mines, but client-sided",
    Default = false,
    Callback = function(i)
      im = i
      InstaMine(i)
    end 
  }) 

  local fbtog = Tabs.wr:AddToggle("Fast Break",
  {
    Title = "Fast Break", 
    Description = "Breaks blocks fast (with the correct tools)",
    Default = false,
    Callback = function(f)
      fb = f
      FastBreak(f)
    end 
  })

  local nktog = Tabs.wr:AddToggle("Nuker",
  {
    Title = "Nuker", 
    Description = "Breaks blocks below you",
    Default = false,
    Callback = function(n)
      nk = n
      Nuker(n)
    end 
  })
  
  local nktog = Tabs.wr:AddToggle("Nuker",
  {
    Title = "Nuker 3x3", 
    Description = "Breaks blocks around you",
    Default = false,
    Callback = function(n3)
      nk3 = n3
      Nuker3(n3)
    end 
  })
  
  Tabs.wr:AddButton({
    Title = "Reload Chunks",
    Description = "Reloads Chunks",
    Callback = function()
      local humanroot2 = game.Players.LocalPlayer.Character.HumanoidRootPart

      -- Save the current position of the HumanoidRootPart
      local pos = Vector3.new(
        math.floor(humanroot2.Position.X),
        math.floor(humanroot2.Position.Y),
        math.floor(humanroot2.Position.Z)
      )

      wait()
      -- Move the HumanoidRootPart to a new position (scaled by 3)
      humanroot2.CFrame = CFrame.new(math.floor(10000 * 3), math.floor(60 * 3), math.floor(10000 * 3))
      wait(1)
      -- Move the HumanoidRootPart back to the original position
      humanroot2.CFrame = CFrame.new(pos)
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
    Description = "Dupes the first chest slot",
    Callback = function()
      chestdupe(1)
    end
  })
  
  Tabs.dt:AddButton({
    Title = "Dupe Entire Chest",
    Description = "Dupes the entire chest slot",
    Callback = function()
      chestdupe(2)
    end
  })
  
  Tabs.dt:AddButton({
    Title = "Dupe Entire Chest + Dump",
    Description = "Dumps your inv to a chest, then dupes it",
    Callback = function()
      cheststealer()
      chestdupe(2)
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

  if hasGiveExploit then
    local ginput = Tabs.dt:AddInput("Input", {
      Title = "Item Name",
      Description = "Enter Item Name",
      Default = "",
      Placeholder = "Enter an Item Name",
      Numeric = false, -- Ensure input is numeric
      Finished = false,
      Callback = function(gi)
        gip = gi
      end
    })
    local ainput = Tabs.dt:AddInput("Input", {
      Title = "Amount",
      Description = "Enter Item Amount",
      Default = "",
      Placeholder = "Enter Amount of Items",
      Numeric = true,
      Finished = false,
      Callback = function(ai)
        aip = ai
      end
    })
    Tabs.dt:AddButton({
      Title = "Give Item",
      Description = "Gives selected amount of selected item",
      Callback = function()
        local args = {
          [1] = gip,
          [2] = aip
        }

        game:GetService("ReplicatedStorage").admingui:FireServer(unpack(args))
      end
    })
  end
  
  Tabs.ot:AddButton({
    Title = "Load WolfMoons",
    Description = "Loads ByteHub for WolfMoons",
    Callback = function()
      Fluent:Destroy()
      getgenv().bytehubLoaded = false
      if isMobile then
        game.CoreGui.Toggleui:Destroy()
      end
      loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/bytehub/refs/heads/main/Byte%20Hub/Wolfmoons.lua",true))()
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
  
  local kadelay = Tabs.st:AddInput("Input", {
    Title = "Kill Aura Delay",
    Description = "Seconds between each hit (Default: 0)",
    Default = "0",
    Placeholder = "Enter a number",
    Numeric = false, -- Ensure input is numeric
    Finished = false,
    Callback = function(zi)
      local newDelay = tonumber(zi)
      if newDelay then
        delay = newDelay -- Update the delay value dynamically
      else
        Fluent:Notify({
          Title = "Error",
          Content = "Invalid Delay",
          SubContent = "Please enter a number",
          Duration = 3
        })
      end
    end
  })
  
  local utstog = Tabs.st:AddToggle("Toggle", {
    Title = "Use task.spawn()", 
    Description = "Makes some features run asynchronously\nto prevent blocking.",
    Default = false,
    Callback = function(uts)
        ut = uts
        useTaskSpawn = uts
    end 
  })
  
  Tabs.st:AddDropdown("InterfaceTheme", {
    Title = "Theme",
    Description = "Changes the interface theme.",
    Values = Fluent.Themes,
    Default = Fluent.Theme,
    Callback = function(Value)
      Fluent:SetTheme(Value)
    end
  })

  Tabs.st:AddToggle("TransparentToggle", {
    Title = "Transparency",
    Description = "Makes the interface transparent.",
    Default = Fluent.Transparency,
    Callback = function(Value)
      Fluent:ToggleTransparency(Value)
    end
  })
  
  Tabs.st:AddButton({
    Title = "Destroy UI",
    Description = "Destroys Fluent UI",
    Callback = function()
      Fluent:Destroy()
      getgenv().bytehubLoaded = false
      if isMobile then
        game.CoreGui.Toggleui:Destroy()
      end
    end
  })
  
  Window:SelectTab(1)
else
  local Notify = AkaliNotif.Notify;

  Notify({
    Description = "Byte Hub is already loaded!";
    Title = "Error!";
    Duration = 3;
  });
  wait(1)
end
