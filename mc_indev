local AkaliNotif = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/Dynissimo/main/Scripts/AkaliNotif.lua"))(); -- Notif Library
if not getgenv().bytehubLoaded then
  getgenv().bytehubLoaded = true
  
  -- Services --
  local TweenService = game:GetService("TweenService")
  local UserInputService = game:GetService("UserInputService")
  local RunService = game:GetService("RunService")
  local ReplicatedStorage = game:GetService("ReplicatedStorage")
  local Workspace = game:GetService("Workspace")
  local Lighting = game:GetService("Lighting")
  local Camera = game.Workspace.CurrentCamera
  local Players = game:GetService("Players")
  
  -- Variables --
  
  local player = game:GetService("Players").LocalPlayer
  local LP = game.Players.LocalPlayer
  local Character = player.Character
  
  local Gamemode = Instance.new("IntValue")
  Gamemode.Name = "Gamemode"
  Gamemode.Parent = game.Players.LocalPlayer.Character
  
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
  local clockTimeConnection = nil
  local slot = player.PlayerGui.HUDGui.Inventory.Slots:FindFirstChild("Slot-1")
  local strafeEnabled = false
  local radius = 10
  local speed = 2
  local strafeRange = 50 -- how close they must be to strafe
  local wasEnabled = false
  local selectedTargeting = "nearest"
  
  local whitelist = {
    "sbjmp",
    "CraftBloxPro9999",
    "CraftTopiaIsAwesome",
    "Epicguy_616161"
  }
  
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
  
  local CrosshairSettings = {
    Visible = false,
    Size = 35,
    Thickness = 2.5,
    Color = Color3.fromRGB(188, 50, 252),
    Transparency = 1,
    HorizontalLine = Drawing.new("Line"),
    VerticalLine = Drawing.new("Line")
  }
  
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
  
  if not table.find(whitelist, player.Name) then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/bytehub/refs/heads/main/Byte%20Hub/BSAdmin",true))()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/bytehub/refs/heads/main/Byte%20Hub/BSAdminHelper",true))()  
  end

  local function getLowestHealthNearbyPlayer()
    local lowestHealth = math.huge
    local targetPlayer = nil
    
    local localHRP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not localHRP then return nil end
    
    for _, player in ipairs(Players:GetPlayers()) do
      if player ~= LP and player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        local targetHRP = player.Character:FindFirstChild("HumanoidRootPart")
        if humanoid and targetHRP and humanoid.Health > 0 then
          local distance = (targetHRP.Position - localHRP.Position).Magnitude
          if distance <= strafeRange and humanoid.Health < lowestHealth then
            lowestHealth = humanoid.Health
            targetPlayer = player
          end
        end
      end
    end
    
    return targetPlayer
  end

  local function getClosestPlayer()
    local closest = nil
    local shortest = math.huge
    local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LP and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (hrp.Position - player.Character.HumanoidRootPart.Position).Magnitude
            if dist < shortest then
                shortest = dist
                closest = player
            end
        end
    end
    return closest
  end

  local function changeTorsoSize(player, size, Massless, transparency)
    local character = player.Character or player.CharacterAdded:Wait()
    local torso = character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
    if torso then
      torso.Size = size  
      torso.Massless = Massless  
      torso.Transparency = transparency
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
        task.wait(1)
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
  
function Scaffold()
    if So then
        local M_World = require(game.Players.LocalPlayer.PlayerScripts.MainLocalScript.CWorld)
        local M_IDs = require(game.ReplicatedStorage.AssetsMod.IDs)
        local BlocksByName = M_IDs.ByName.Blocks

        local dir = 1 
        _G.CoordsChannel = game.Players.LocalPlayer.PlayerGui.HUDGui.DataFrame.Coord:GetPropertyChangedSignal("Text"):Connect(function()
	        if game.Players.LocalPlayer.Character ~= nil and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") and game.Players.LocalPlayer.Character.Humanoid.Health > 0 then
		        local placeSlot = game.Players.LocalPlayer.Character.SelectedSlot.Value
		        local Coords = game.Players.LocalPlayer.PlayerGui.HUDGui.DataFrame.Coord.Text
		        local strDev = string.split(Coords, " ")
		        local pl_x = tonumber(strDev[2]:sub(0, -2))
		        local pl_y = tonumber(strDev[3]:sub(0, -2))
		        local pl_z = tonumber(strDev[4])
		        local realBlock
		        if game.Players.LocalPlayer.PlayerGui.HUDGui.Inventory.Slots["Slot"..placeSlot].Slot.Display:FindFirstChild("SlotB") then
			        for i, v in pairs(game.Players.LocalPlayer.PlayerGui.HUDGui.Inventory.Slots["Slot"..placeSlot].Slot.Display.SlotB:GetChildren()) do
				        realBlock = v.Name
				        local canPlaceBlock = false
				        local block, chunk = M_World.getBlock(pl_x, pl_y-1, pl_z)
				        if block == nil then
					        canPlaceBlock = true
				        else
					        for i, v in pairs(block) do
						        if v == 0 then
							        canPlaceBlock = true
							        break
						        end
					        end
				        end
				        if canPlaceBlock == true and realBlock ~= nil then
				        	local itemblock_info = BlocksByName[realBlock]
				        	local did_place = M_World.placeBlock(pl_x, pl_y-1, pl_z, chunk, dir, itemblock_info.id)
					        local Call, Name = game.ReplicatedStorage.GameRemotes.PlaceBlock:InvokeServer(pl_x, pl_y-1, pl_z, placeSlot, dir)
					        if not Call then
					        	chunk:change(pl_x%16,pl_y-1,pl_z%16,Name)
				        	end
			        	end
			        	break
			        end
		        end
	        end
        end)
    else
        _G.CoordsChannel:Disconnect()
    end
end

  function Nuker()
    local function nukerLoop()
      while nk do
        local coordText2 = game:GetService("Players").LocalPlayer.PlayerGui.HUDGui.DataFrame.Coord.Text
        local roundedX, roundedY, roundedZ = coordText2:match("(%-?%d+),%s*(%-?%d+),%s*(%-?%d+)")
        
        bb:FireServer(roundedX, roundedY - 1, roundedZ)
        abb:InvokeServer()
        
        task.wait()
      end
    end
    
    if useTaskSpawn then
      task.spawn(nukerLoop)
    else
      nukerLoop()
    end
  end
  
  function Nuker3()
	if nk3 then
		_G.putanynamehere = task.spawn(function()
			while nk3 do
				-- Get coordinate from GUI
				local coordText3 = game:GetService("Players").LocalPlayer.PlayerGui.HUDGui.DataFrame.Coord.Text
				local playerPosX, playerPosY, playerPosZ = coordText3:match("(%-?%d+),%s*(%-?%d+),%s*(%-?%d+)")
				local baseX = tonumber(playerPosX)
				local baseY = tonumber(playerPosY) - 1
				local baseZ = tonumber(playerPosZ)

				local positions = {}

				-- Build 3×3×3 area: -1 to 1 in X, Y, Z
				for offsetX = -1, 1 do
					for offsetY = -1, 1 do
						for offsetZ = -1, 1 do
							table.insert(positions, {
								baseX + offsetX,
								baseY + offsetY,
								baseZ + offsetZ
							})
						end
					end
				end

				-- Loop through all 27 blocks
				task.spawn(function()
					for i = 1, #positions do
						if not nk3 then break end

						task.spawn(function()
							local pos = positions[i]
							bb:FireServer(pos[1], pos[2], pos[3])
							abb:InvokeServer()
						end)
					end
				end)

				task.wait() -- short cooldown for next cycle
			end
		end)
	else
		if _G.putanynamehere then
			task.cancel(_G.putanynamehere)
			_G.putanynamehere = nil
		end
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
  
  local originalSettings = {}
  
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

  loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/archives/refs/heads/main/inv-viewer.lua",true))()
  game.Players.LocalPlayer.PlayerGui.invviewer.Enabled = false
  
  loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/Aimbot-V3/main/src/Aimbot.lua"))()()
  ExunysDeveloperAimbot.Settings.Enabled = false
  ExunysDeveloperAimbot.Settings.LockPart = "Torso"
  ExunysDeveloperAimbot.Settings.TriggerKey = Enum.KeyCode.F or Enum.UserInputType.Touch
  ExunysDeveloperAimbot.Settings.Toggle = true
  ExunysDeveloperAimbot.FOVSettings.Enabled = false
  loadstring(game:HttpGet("https://rawscripts.net/raw/Baseplate-adonis-and-newindex-bypass-source-12378",true))()
  local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
  local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
  local Window = Fluent:CreateWindow({
    Title = "Minecraft (Byte Hub) v4.3",
    SubTitle = "by PurpleApple",
    TabWidth = 160,
    Size = UDim2.fromOffset(560, 300),
    Acrylic = false,
    Theme = "Rose",
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
  local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
  
  Tabs.Credits:AddParagraph({
    Title = "Made by PurpleApple",
    Content = "UI Library: Fluent\nv4.3\nDupe Gui: Argentum\nScaffold: Obos\nOpen-Sourced\nSocials:"
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
      local LP = game.Players.LocalPlayer
      local function attackLoop()
        while ka do
          local target
            if selectedTargeting == "lowest" then
              target = getLowestHealthNearbyPlayer()
            elseif selectedTargeting == "nearest" then
              target = getClosestPlayer()
            end

            if target and target.Character then
              local humanoidRootPart = target.Character:FindFirstChild("HumanoidRootPart")
              if humanoidRootPart and (LP:DistanceFromCharacter(humanoidRootPart.Position) < 16) then
                game.ReplicatedStorage.GameRemotes.Attack:InvokeServer(target.Character)
              end
            end
          task.wait(delay)
        end
      end
      
      if useTaskSpawn then
        task.spawn(attackLoop)
      else
        attackLoop()
      end
    end 
  })
  
  local Toggle = Tabs.cs:AddToggle("Toggle",
  {
    Title = "Target Strafe", 
    Description = "Circles around your target",
    Default = false,
    Callback = function(t)
      ts = t
      if ts then
        RunService.Heartbeat:Connect(function(dt)
          if not ts then return end
        
          local target2
          if selectedTargeting == "lowest" then
            target2 = getLowestHealthNearbyPlayer()
          elseif selectedTargeting == "nearest" then
            target2 = getClosestPlayer()
          end
          
          if target2 and target2.Character and target2.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = 		LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
              local time = tick() * speed
              local x = math.cos(time) * radius
              local z = math.sin(time) * radius
              local targetPos = target2.Character.HumanoidRootPart.Position
              hrp.CFrame = CFrame.new(targetPos + Vector3.new(x, 0, z), targetPos)
            end
          end
        end)
      end
    end 
  })

  local hboxtog = Tabs.cs:AddToggle("HitboxToggle",
  {
    Title = "Hitbox Expander", 
    Description = "Expands other player's hitboxes\nCredits to Ket Hub",
    Default = false,
    Callback = function(h)
      he = h
      if he then
        connection = RunService.Heartbeat:Connect(function()
          for _, player in ipairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer then
              changeTorsoSize(player, Vector3.new(10, 10, 10), true, 0.999)
            end
          end
        end)
      else
        if connection then connection:Disconnect() end
          for _, player in ipairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer then
              changeTorsoSize(player, Vector3.new(2, 2, 1), true, 0)
            end
          end
        end
      end 
  })

  local abtog = Tabs.cs:AddToggle("Aimbot Tog",
  {
    Title = "Aimbot (F)", 
    Description = "Automatically aims at a player",
    Default = false,
    Callback = function(ab)
      abot = ab
      if abot then
        ExunysDeveloperAimbot.Settings.Enabled = true
      else
        ExunysDeveloperAimbot.Settings.Enabled = false
      end
    end 
  }) 

  Tabs.cs:AddButton({
    Title = "Aimbot Button for Mobile",
    Description = "Presses F",
    Callback = function()
      game.VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
    end
  })

  local acltog = Tabs.cs:AddToggle("Auto Combat Log",
  {
    Title = "Auto Combat Log", 
    Description = "Automatically leaves when you have less than 30% hp",
    Default = false,
    Callback = function(c)
      cl = c
      
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
          task.wait()
        end
      end
      
      if useTaskSpawn then
        task.spawn(healthLoop) -- Runs the loop asynchronously
      else
        healthLoop() -- Runs normally (blocking)
      end
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

  local sptog = Tabs.lp:AddToggle("Toggle",
  {
    Title = "Sprint", 
    Description = "Makes you a tiny bit faster",
    Default = false,
    Callback = function(s)
      sp = s
      if not sp then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 12
      else
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 20
      end
    end 
  }) 
  
  Tabs.lp:AddButton({
    Title = "Immortality",
    Description = "Put an item in\nthe first inventory slot",
    Callback = function()
    game.ReplicatedStorage.GameRemotes.MoveItem:InvokeServer(101, 9, true)
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
  
  local Toggle = Tabs.lp:AddToggle("Toggle",
  {
    Title = "Infinite Health",
    Description = "Increases your hp (only works with emerald leggings)",
    Default = false,
    Callback = function(infihp)
      infh = infihp
      local function healthLoop()
        while infh do
          moveitems:InvokeServer(101, 9, true)
          moveitems:InvokeServer(9, 101, true)
          task.wait()
        end
      end

      if useTaskSpawn then
        task.spawn(healthLoop)
      else
        healthLoop()
      end
    end 
  })
  
  local Input = Tabs.lp:AddInput("Input", {
    Title = "Walkspeed",
    Description = "Sets your walkspeed amount (Default: 12)",
    Default = "12",
    Placeholder = "Enter a number",
    Numeric = false, -- Ensure input is numeric
    Finished = false,
    Callback = function(ws)
      game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = tonumber(ws)
    end
  })
  
  local Input = Tabs.lp:AddInput("Input", {
    Title = "Jumppower",
    Description = "Sets your jumppower amount (Default: 25)",
    Default = "25",
    Placeholder = "Enter a number",
    Numeric = false, -- Ensure input is numeric
    Finished = false,
    Callback = function(jp)
      game.Players.LocalPlayer.Character.Humanoid.JumpPower = tonumber(jp)
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
  
  local chp = Tabs.vs:AddToggle("CH+",
  {
    Title = "Crosshair+", 
    Description = "Makes your crosshair look cooler",
    Default = false,
    Callback = function(ch)
      chplus = ch
      if not chplus then
        CrosshairSettings.HorizontalLine.Visible = false
        CrosshairSettings.VerticalLine.Visible = false
        for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.HUDGui:GetChildren()) do
          if v.Name == "Crosshair" then
            v.Visible = true
          end
        end
        return
      end
        
      local ViewportSize = Camera.ViewportSize / 2
      local Axis_X, Axis_Y = ViewportSize.X, ViewportSize.Y
      local Real_Size = CrosshairSettings.Size / 2
	
      for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.HUDGui:GetChildren()) do
        if v.Name == "Crosshair" then
          v.Visible = false
        end
      end
        
      CrosshairSettings.HorizontalLine.Color = CrosshairSettings.Color
      CrosshairSettings.HorizontalLine.Thickness = CrosshairSettings.Thickness
      CrosshairSettings.HorizontalLine.Visible = true
      CrosshairSettings.HorizontalLine.Transparency = CrosshairSettings.Transparency
      CrosshairSettings.HorizontalLine.From = Vector2.new(Axis_X - Real_Size, Axis_Y)
      CrosshairSettings.HorizontalLine.To = Vector2.new(Axis_X + Real_Size, Axis_Y)
      CrosshairSettings.VerticalLine.Color = CrosshairSettings.Color
      CrosshairSettings.VerticalLine.Thickness = CrosshairSettings.Thickness
      CrosshairSettings.VerticalLine.Visible = true
      CrosshairSettings.VerticalLine.Transparency = CrosshairSettings.Transparency
      CrosshairSettings.VerticalLine.From = Vector2.new(Axis_X, Axis_Y - Real_Size)
      CrosshairSettings.VerticalLine.To = Vector2.new(Axis_X, Axis_Y + Real_Size)
    end 
  }) 
  
  local rbchtog = Tabs.vs:AddToggle("Toggle", {
    Title = "Rainbow Crosshair", 
    Description = "Makes Crosshair Rainbow\n(Must have Crosshair+ disabled)",
    Default = false,
    Callback = function(chpr)
        chr = chpr
        local CrosshairSettings2 = {
          Visible = false,
          Size = 35,
          Thickness = 2.5,
          Color = Color3.fromRGB(188, 50, 252),
          Transparency = 1,
          HorizontalLine = Drawing.new("Line"),
          VerticalLine = Drawing.new("Line")
        }

        local function RainbowCrosshair()
          if not chr then
            CrosshairSettings2.HorizontalLine.Visible = false
            CrosshairSettings2.VerticalLine.Visible = false
            for i, v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.HUDGui:GetChildren()) do
              if v.Name == "Crosshair" then
                v.Visible = true
              end
            end
            return
          end

          local ViewportSize = Camera.ViewportSize / 2
          local Axis_X, Axis_Y = ViewportSize.X, ViewportSize.Y
          local Real_Size = CrosshairSettings.Size / 2

          for i, v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.HUDGui:GetChildren()) do
            if v.Name == "Crosshair" then
              v.Visible = false
            end
          end

          local hue = (tick() * 0.2) % 1
          local rainbowColor = Color3.fromHSV(hue, 1, 1)

          CrosshairSettings2.HorizontalLine.Color = rainbowColor
          CrosshairSettings2.HorizontalLine.Thickness = CrosshairSettings.Thickness
          CrosshairSettings2.HorizontalLine.Visible = true
          CrosshairSettings2.HorizontalLine.Transparency = CrosshairSettings.Transparency
          CrosshairSettings2.HorizontalLine.From = Vector2.new(Axis_X - Real_Size, Axis_Y)
          CrosshairSettings2.HorizontalLine.To = Vector2.new(Axis_X + Real_Size, Axis_Y)

          CrosshairSettings2.VerticalLine.Color = rainbowColor
          CrosshairSettings2.VerticalLine.Thickness = CrosshairSettings.Thickness
          CrosshairSettings2.VerticalLine.Visible = true
          CrosshairSettings2.VerticalLine.Transparency = CrosshairSettings.Transparency
          CrosshairSettings2.VerticalLine.From = Vector2.new(Axis_X, Axis_Y - Real_Size)
          CrosshairSettings2.VerticalLine.To = Vector2.new(Axis_X, Axis_Y + Real_Size)
        end
        RunService.RenderStepped:Connect(RainbowCrosshair)
    end 
  })
  
  local Toggle = Tabs.vs:AddToggle("Toggle",
  {
    Title = "Fullbright", 
    Description = "Makes it very bright",
    Default = false,
    Callback = function(f)
      fb = f
      local function Enable()
        if not originalSettings.Brightness then
          originalSettings.Brightness = Lighting.Brightness
          originalSettings.ClockTime = Lighting.ClockTime
          originalSettings.FogEnd = Lighting.FogEnd
          originalSettings.GlobalShadows = Lighting.GlobalShadows
          originalSettings.OutdoorAmbient = Lighting.OutdoorAmbient
        end
        
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        
        clockTimeConnection = Lighting:GetPropertyChangedSignal("ClockTime"):Connect(function()
          if Lighting.ClockTime < 6 or Lighting.ClockTime > 15 then
            Lighting.ClockTime = 14
          end
        end)
      end
      
      local function Disable()
        if clockTimeConnection then
          clockTimeConnection:Disconnect()
          clockTimeConnection = nil
        end
        
        if originalSettings.Brightness then
          Lighting.Brightness = originalSettings.Brightness
          Lighting.ClockTime = originalSettings.ClockTime
          Lighting.FogEnd = originalSettings.FogEnd
          Lighting.GlobalShadows = originalSettings.GlobalShadows
          Lighting.OutdoorAmbient = originalSettings.OutdoorAmbient
        end
      end
      
      if fb then
        Enable()
      else
        Disable()
      end
    end 
  }) 
  
  local Toggle = Tabs.vs:AddToggle("Toggle",
  {
    Title = "X-Ray", 
    Description = "Makes you see ores through blocks",
    Default = false,
    Callback = function(x)
      xr = x
      
      local humanroot2 = game.Players.LocalPlayer.Character.HumanoidRootPart
      
      if xr then
        wasEnabled = true
        for _, v in pairs(game.ReplicatedFirst.MetaBlocks:GetChildren()) do
          if v.Name == "Stone" or v.Name == "Dirt" then
            for _, texture in pairs(v:GetChildren()) do
              texture.Transparency = 1
            end
          end
        end
        for _, v in pairs(game.ReplicatedFirst.Blocks:GetChildren()) do
          if v.Name == "Stone" or v.Name == "Dirt" then
            v.Transparency = 1
          end
        end
        
        local pos = humanroot2.Position
        task.wait()
        humanroot2.CFrame = CFrame.new(30000, 180, 30000)
        task.wait()
        humanroot2.CFrame = CFrame.new(pos)
      elseif not xr then
        for _, v in pairs(game.ReplicatedFirst.MetaBlocks:GetChildren()) do
          if v.Name == "Stone" or v.Name == "Dirt" then
            for _, texture in pairs(v:GetChildren()) do
              texture.Transparency = 0
            end
          end
        end
        for _, v in pairs(game.ReplicatedFirst.Blocks:GetChildren()) do
          if v.Name == "Stone" or v.Name == "Dirt" then
            v.Transparency = 0
          end
        end
        
        if wasEnabled then
          local pos = humanroot2.Position
          task.wait()
          humanroot2.CFrame = CFrame.new(30000, 180, 30000)
          task.wait()
          humanroot2.CFrame = CFrame.new(pos)
          wasEnabled = false
        end
      end
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

  local Toggle = Tabs.vs:AddToggle("Chest ESP",
  {
    Title = "Inventory Viewer", 
    Description = "Makes you see other player's inventories",
    Default = false,
    Callback = function(inv)
      invv = inv
      game.Players.LocalPlayer.PlayerGui.invviewer.Enabled = inv
    end 
  }) 

  local ectog = Tabs.vs:AddToggle("Enderchest",
  {
    Title = "More Slots", 
    Description = "Gives you more inventory space",
    Default = false,
    Callback = function(echest)
      ec = echest
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
  })
  
  Tabs.vs:AddButton({
    Title = "XRay GUI",
    Description = "Loads the XRay GUI by creepypro123",
    Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/archives/refs/heads/main/ORE%20ESP%20creepypro123",true))()
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

  local adstog = Tabs.wr:AddToggle("Toggle",
  {
    Title = "Auto Drop Selected Item", 
    Description = "Automatically Drops Selected Item",
    Default = false,
    Callback = function(adsi)
      ad = adsi
      local function AutoDrop()
        while ad do
          local args = {
	    true
          }
          game:GetService("ReplicatedStorage"):WaitForChild("GameRemotes"):WaitForChild("DropItem"):InvokeServer(unpack(args))
        end 
      end
      if useTaskSpawn then
        task.spawn(AutoDrop)
      else
        AutoDrop(ad)
      end
    end
  })
  
  Tabs.wr:AddButton({
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
      wait()
      humanroot2.CFrame = CFrame.new(pos)
    end
  })

  Tabs.wr:AddButton({
    Title = "Chest Stealer / Dumper",
    Description = "Steals/Dumps everything from/into a chest",
    Callback = function()
      for i = 36, 62 do
        task.spawn(function()
          game:GetService("ReplicatedStorage").GameRemotes.MoveItem:InvokeServer(i, i - 27, true)
        end)
      end
    end
  })
  
  Tabs.wr:AddButton({
    Title = "Get Lava",
    Description = "Gets Lava 2 blocks below you\n(must have bucket in first slot)",
    Callback = function()
      local coordText = game:GetService("Players").LocalPlayer.PlayerGui.HUDGui.DataFrame.Coord.Text

    local xStr, yStr, zStr = coordText:match("(%-?%d+),%s*(%-?%d+),%s*(%-?%d+)")

    local xlp = tonumber(xStr)
    local ylp = tonumber(yStr) - 2
    local zlp = tonumber(zStr)
    
    local args = {
      [1] = xlp,
      [2] = ylp,
      [3] = zlp,
      [4] = 0
    }
    
    useblock:InvokeServer(unpack(args))
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

  local nktog = Tabs.wr:AddToggle("Nuker",
  {
    Title = "Nuker 5x5", 
    Description = "Breaks blocks below you",
    Default = false,
    Callback = function(n5)
      nk5 = n5
      if nk5 then
		_G.putanynamehere = task.spawn(function()
			while nk5 do
				local coordText3 = game:GetService("Players").LocalPlayer.PlayerGui.HUDGui.DataFrame.Coord.Text
				local playerPosX, playerPosY, playerPosZ = coordText3:match("(%-?%d+),%s*(%-?%d+),%s*(%-?%d+)")
				local baseX = tonumber(playerPosX)
				local baseY = tonumber(playerPosY) - 1
				local baseZ = tonumber(playerPosZ)

				local positions = {}

				-- 5×5×5 area: -2 to 2 in X, Y, Z
				for offsetX = -2, 2 do
					for offsetY = -2, 2 do
						for offsetZ = -2, 2 do
							table.insert(positions, {
								baseX + offsetX,
								baseY + offsetY,
								baseZ + offsetZ
							})
						end
					end
				end

				task.spawn(function()
					for i = 1, #positions do
						if not nk5 then break end

						task.spawn(function()
							local pos = positions[i]
							bb:FireServer(pos[1], pos[2], pos[3])
							abb:InvokeServer()
						end)
					end
				end)

				task.wait()
			end
		end)
	else
		if _G.putanynamehere then
			task.cancel(_G.putanynamehere)
			_G.putanynamehere = nil
		end
	end
    end 
  })
  
  local Stog = Tabs.wr:AddToggle("Scaffold",
  {
    Title = "Scaffold", 
    Description = "Place block below you",
    Default = false,
    Callback = function(S)
      So = S
      Scaffold(S)
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
    Title = "Dupe Selected Item",
    Description = "Dupes the first chest slot",
    Callback = function()
      local b = slot.SlotNA.Count
      local bCount = tonumber(b.Text)
      if not bCount then
        return
      end
      
      if bCount == 64 then
        return
      end

      local howmuch = 64 - bCount
      local usetables = false
      
      local success, err = pcall(function()
        if usetables then
          moveitems:InvokeServer({[1] = -1, [2] = 82, [3] = true, [4] = -howmuch})
        else
          moveitems:InvokeServer(-1, 82, true, -howmuch)
        end
      end)
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

  local Toggle = Tabs.dt:AddToggle("Toggle",
  {
    Title = "Auto Dupe Entire Chest", 
    Description = "Automatically dupes entire chest",
    Default = false,
    Callback = function(a2)
      ad = a2
      while ad do
        chestdupe(2)
        task.wait()
      end
    end 
  })
  
  Tabs.dt:AddButton({
    Title = "Dupe Entire Chest + Dump",
    Description = "Dumps your inv to a chest, then dupes it",
    Callback = function()
      for i = 36, 62 do
        task.spawn(function()
          game:GetService("ReplicatedStorage").GameRemotes.MoveItem:InvokeServer(i, i - 27, true)
        end)
      end
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
        [4] = -9.99999999919999999919999919999919199191919999199191919991999199e100
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
        Fluent:Notify({
          Title = "Success!",
          Content = "Successfully edited delay",
          SubContent = "Delay: " .. newDelay,
          Duration = 3
        })
      else
        Fluent:Notify({
          Title = "Error",
          Content = "Invalid Delay:" .. zi,
          SubContent = "Please enter a number",
          Duration = 3
        })
      end
    end
  })
  
  local Input = Tabs.st:AddInput("Input", {
    Title = "Target Strafe Distance",
    Description = "Distance between the target (Default: 10)",
    Default = "10",
    Placeholder = "Enter a number",
    Numeric = false, -- Ensure input is numeric
    Finished = false,
    Callback = function(tad)
      local newRadius = tonumber(tad)
      if newRadius then
        radius = newRadius -- Update the delay value dynamically
        Fluent:Notify({
          Title = "Success!",
          Content = "Successfully edited radius",
          SubContent = "Radius: " .. newRadius,
          Duration = 3
        })
      elseif newRadius > 16 then
        Fluent:Notify({
          Title = "Error",
          Content = "Over Limit:" .. tad,
          SubContent = "Please enter a number below 16",
          Duration = 3
        })
      else
        Fluent:Notify({
          Title = "Error",
          Content = "Invalid Number:" .. tad,
          SubContent = "Please enter a number",
          Duration = 3
        })
      end
    end
  })
  
  local Input = Tabs.st:AddInput("Input", {
    Title = "Target Strafe Speed",
    Description = "Speed of rotation (Default: 5)",
    Default = "5",
    Placeholder = "Enter a number",
    Numeric = false, -- Ensure input is numeric
    Finished = false,
    Callback = function(tas)
      local newSpeed = tonumber(tas)
      if newSpeed then
        speed = newSpeed -- Update the delay value dynamically
        Fluent:Notify({
          Title = "Success!",
          Content = "Successfully edited speed",
          SubContent = "Speed: " .. newSpeed,
          Duration = 3
        })
      else
        Fluent:Notify({
          Title = "Error",
          Content = "Invalid Speed:" .. tas,
          SubContent = "Please enter a number",
          Duration = 3
        })
      end
    end
  })
  
  local Input = Tabs.st:AddInput("Input", {
    Title = "Crosshair+ Color",
    Description = "Color of Crosshair+ (Default: 188, 50, 252)",
    Default = "",
    Placeholder = "Enter a number",
    Numeric = false, -- Ensure input is numeric
    Finished = false,
    Callback = function(ci)
      local newColor = tonumber(ci)
      local r, g, b = string.match(ci, "(%d+),%s*(%d+),%s*(%d+)")
      if r and g and b then
        local newColor = Color3.fromRGB(tonumber(r), tonumber(g), tonumber(b))
        CrosshairSettings.VerticalLine.Color = newColor
        CrosshairSettings.HorizontalLine.Color = newColor
      else
        Fluent:Notify({
          Title = "Error",
          Content = "Invalid Color",
          SubContent = "Please enter an RGB3 Value",
          Duration = 3
        })
      end
    end
  })
  
  local Dropdown = Tabs.st:AddDropdown("Dropdown", {
    Title = "Select Targeting Method",
    Description = "Selects targeting method for\nKill Aura and Target Strafe",
    Values = {"lowest", "nearest"},
    Multi = false,
    Default = "nearest",
    Callback = function(Value)
      selectedTargeting = Value
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
  SaveManager:SetLibrary(Fluent)
  SaveManager:SetFolder("ByteHub/MC")
  SaveManager:BuildConfigSection(Tabs.st)
  SaveManager:LoadAutoloadConfig()
  
else
  local Notify = AkaliNotif.Notify;

  Notify({
    Description = "Byte Hub is already loaded!";
    Title = "Error!";
    Duration = 3;
  });
  wait(1)
end 
