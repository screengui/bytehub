local AkaliNotif = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/Dynissimo/main/Scripts/AkaliNotif.lua"))(); -- Notif Library
if getgenv().bytehubLoaded then
	local Notify = AkaliNotif.Notify;

    Notify({
        Description = "Byte Hub is already loaded!";
        Title = "Error!";
        Duration = 3;
    });
    wait(1)
	return
end

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

if not game.Players.LocalPlayer.Character:FindFirstChild("Gamemode") then
	local Gamemode = Instance.new("IntValue")
	Gamemode.Name = "Gamemode"
	Gamemode.Parent = game.Players.LocalPlayer.Character
end
  
local ESP = loadstring(game:HttpGet("https://kiriot22.com/releases/ESP.lua"))()
local metaBlocks = game.ReplicatedFirst:FindFirstChild("MetaBlocks")
local blocks = workspace.Blocks
local features = {}
local usetables = false
local isMobile
local isPC
local hasGiveExploit
local selectedPlayerName = nil
local clockTimeConnection = nil

-- Configs --
local whitelist = {
    "sbjmp",
    "CraftBloxPro9999",
    "CraftTopiaIsAwesome",
	"MinersCraftPro9999",
    "Epicguy_616161"
}

local CrosshairSettings = {
    Visible = false,
    Size = 35,
    Thickness = 2.5,
    Color = Color3.fromRGB(188, 50, 252),
    Transparency = 1,
    HorizontalLine = Drawing.new("Line"),
    VerticalLine = Drawing.new("Line")
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

-- Adonis Bypass
local NamecallInstanceDetector = nil
for Index, Table in getgc(true) do
    if typeof(Table) ~= "table" then continue end
    if not rawget(Table, "namecallInstance") then continue end
    for SecondIndex, StackContainerTable in Table do
        if typeof(StackContainerTable) ~= "table" then continue end
        for ThirdIndex, Upvalues in StackContainerTable do
            if StackContainerTable[ThirdIndex] ~= "kick" then continue end
            if typeof(StackContainerTable[ThirdIndex + 1]) ~= "function" then continue end
            local FrozenDetectionFunction = StackContainerTable[ThirdIndex + 1]
            for _, DetectionIdentifier in getconstants(FrozenDetectionFunction) do
                if DetectionIdentifier == "namecallInstance" then
                    NamecallInstanceDetector = FrozenDetectionFunction
                end
            end
        end
    end
end
assert(NamecallInstanceDetector, "Error while finding anticheat.")
hookfunction(NamecallInstanceDetector, function()
    return false
end)

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

_G.ArmorAntiLag = game.Players.LocalPlayer.PlayerGui.HUDGui.Inventory.Mirror.VPFrame[""].ChildAdded:Connect(function(child)
    if child:IsA("UnionOperation") then
        task.wait()
        child:Destroy()
    end
end)
  
local function getPlayerNames()
	local t = {}
	for _, p in ipairs(Players:GetPlayers()) do
		table.insert(t, p.Name)
	end
	return t
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

loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/archives/main/inv-viewerV2.lua",true))()
game.Players.LocalPlayer.PlayerGui.invviewer.Enabled = false

--===MODULES===--
local EssentialsModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/bytehub/refs/heads/main/Byte%20Hub/minerscave/modules/Essentials.lua"))()
local KillAura = loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/bytehub/refs/heads/main/Byte%20Hub/minerscave/modules/kill-aura.lua"))()
local TargetStrafe = loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/bytehub/refs/heads/main/Byte%20Hub/minerscave/modules/target-strafe.lua"))()
local Hitbox = loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/bytehub/refs/heads/main/Byte%20Hub/minerscave/modules/hitbox-expander.lua"))()
local CombatLog = loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/bytehub/refs/heads/main/Byte%20Hub/minerscave/modules/auto-combat-log.lua"))()
local AutoSafeZone = loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/bytehub/refs/heads/main/Byte%20Hub/minerscave/modules/auto-safe-zone.lua"))()
local NoFall = loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/bytehub/refs/heads/main/Byte%20Hub/minerscave/modules/no-fall.lua"))()
local Sprint = loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/bytehub/refs/heads/main/Byte%20Hub/minerscave/modules/sprint.lua"))()
local AutoEat = loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/bytehub/refs/heads/main/Byte%20Hub/minerscave/modules/auto-eat.lua"))()
local Jesus = loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/bytehub/refs/heads/main/Byte%20Hub/minerscave/modules/jesus.lua"))()
local InfiniteHealth = loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/bytehub/refs/heads/main/Byte%20Hub/minerscave/modules/infinite-health.lua"))()
local CrosshairPlus = loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/bytehub/refs/heads/main/Byte%20Hub/minerscave/modules/crosshair-plus.lua"))()
local RainbowCrosshair = loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/bytehub/refs/heads/main/Byte%20Hub/minerscave/modules/rainbow-crosshair.lua"))()
local Fullbright = loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/bytehub/refs/heads/main/Byte%20Hub/minerscave/modules/fullbright.lua"))()
local XRay = loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/bytehub/refs/heads/main/Byte%20Hub/minerscave/modules/xray.lua"))()
local ChestESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/bytehub/refs/heads/main/Byte%20Hub/minerscave/modules/chest-esp.lua"))()
local LavaESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/bytehub/refs/heads/main/Byte%20Hub/minerscave/modules/lava-esp.lua"))()
local PlayerESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/bytehub/refs/heads/main/Byte%20Hub/minerscave/modules/player-esp.lua"))()
  

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
local Window = Fluent:CreateWindow({
    Title = "Minecraft (Byte Hub) v4.5",
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
    Content = "UI Library: Fluent\nv4.5\nDupe Gui: Argentum\nScaffold: Obos\nOpen-Sourced\nSocials:"
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

Tabs.cs:AddToggle("Kill Aura", {
	Title = "Kill Aura",
    Description = "Attacks people within your reach",
    Default = false,
    Callback = function(state)
		if state then
			KillAura.start()
		else
			KillAura.stop()
		end
	end
})
  
local Toggle = Tabs.cs:AddToggle("Toggle", {
  Title = "Target Strafe",
  Description = "Circles around your target",
  Default = false,
  Callback = function(state)
      if state then
        TargetStrafe.start()
      else
        TargetStrafe.stop()
  	  end
  end
})

local hboxtog = Tabs.cs:AddToggle("HitboxToggle", {
    Title = "Hitbox Expander", 
    Description = "Expands other player's hitboxes\nCredits to Ket Hub",
    Default = false,
    Callback = function(state)
        if state then
		    Hitbox.start()
	    else
		    Hitbox.stop()
	    end
    end 
})

local acltog = Tabs.cs:AddToggle("Auto Combat Log", {
    Title = "Auto Combat Log", 
    Description = "Automatically leaves when you have less than 30% hp",
    Default = false,
    Callback = function(state)
        if state then
		    CombatLog.start()
	    else
		    CombatLog.stop()
	    end
    end 
}) 

local acttog = Tabs.cs:AddToggle("Auto Combat TP", {
    Title = "Auto Safe Zone", 
    Description = "Auto Combat Log, but it teleports you to a safe zone.",
    Default = false,
    Callback = function(state)
        if state then
		    AutoSafeZone.start()
	    else
		    AutoSafeZone.stop()
		end
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
    Callback = function(state)
      if state then
	    NoFall.start()
      else
        NoFall.stop()
	  end
    end 
  }) 

  local sptog = Tabs.lp:AddToggle("Sprint",
  {
    Title = "Sprint", 
    Description = "Makes you a tiny bit faster",
    Default = false,
    Callback = function(state)
      if state then
	    Sprint.start()
      else
        Sprint.stop()
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

  local eattog = Tabs.lp:AddToggle("EatToggle",
  {
    Title = "Auto Eat",
    Description = "Automatically eats for you",
    Default = false,
    Callback = function(state)
      if state then
	    AutoEat.start()
      else
        AutoEat.stop()
	  end
	end
  })
	
  local jetog = Tabs.lp:AddToggle("Jesus",
  {
  Title = "Jesus",
  Description = "Walk On Water",
  Default = false,
  Callback = function(state)
    if state then
	    Jesus.start()
    else
        Jesus.stop()
	end
  end
  })
	
  local Toggle = Tabs.lp:AddToggle("Toggle",
  {
    Title = "Infinite Health",
    Description = "Increases your hp (only works with emerald leggings)",
    Default = false,
    Callback = function(t)
      if t then
		InfiniteHealth.start(moveitems, _G.useTaskSpawn)
	  else
		InfiniteHealth.stop()
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
  
  local Input = Tabs.lp:AddInput("Jumppower", {
    Title = "Jumppower",
    Description = "Sets your jumppower amount (Default: 25)",
    Default = "25",
    Placeholder = "Enter a number",
    Numeric = false,
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

  local playerDropdown = Tabs.lp:AddDropdown("PlayerTP", {
	Title = "Select Player",
	Description = "Choose a player to teleport to",
	Values = getPlayerNames(),
	Default = nil,
	Callback = function(value)
		selectedPlayerName = value
	end
  })

  Tabs.lp:AddButton({
	Title = "Refresh Player List",
	Description = "Updates the dropdown player list",
	Callback = function()
		playerDropdown:SetValues(getPlayerNames())
		selectedPlayerName = nil
	end
  })

  Tabs.lp:AddButton({
	Title = "Teleport to Player",
	Description = "Teleport to selected player",
	Callback = function()
		if not selectedPlayerName then return end

		local target = Players:FindFirstChild(selectedPlayerName)
		if not target then return end

		local char = LP.Character
		local tChar = target.Character
		if not (char and tChar) then return end

		local hrp = char:FindFirstChild("HumanoidRootPart")
		local tHRP = tChar:FindFirstChild("HumanoidRootPart")
		if not (hrp and tHRP) then return end

		hrp.CFrame = tHRP.CFrame
	end
  })
  
  local chp = Tabs.vs:AddToggle("CH+",
  {
    Title = "Crosshair+", 
    Description = "Makes your crosshair look cooler",
    Default = false,
    Callback = function(state)
      if state then
		CrosshairPlus.start(CrosshairSettings, Camera)
	  else
		CrosshairPlus.stop(CrosshairSettings)
	  end
    end 
  }) 
  
  local rbchtog = Tabs.vs:AddToggle("Toggle", {
    Title = "Rainbow Crosshair", 
    Description = "Makes Crosshair Rainbow\n(Must have Crosshair+ disabled)",
    Default = false,
    Callback = function(state)
        local CrosshairSettings2 = {
          Visible = false,
          Size = 35,
          Thickness = 2.5,
          Color = Color3.fromRGB(188, 50, 252),
          Transparency = 1,
          HorizontalLine = Drawing.new("Line"),
          VerticalLine = Drawing.new("Line")
        }

        if state then
			RainbowCrosshair.start(CrosshairSettings2, Camera)
		else
			RainbowCrosshair.stop(CrosshairSettings2)
		end
    end 
  })
  
  local fbtog = Tabs.vs:AddToggle("Fullbright",
  {
    Title = "Fullbright", 
    Description = "Makes it very bright",
    Default = false,
    Callback = function(state)
        if state then
			Fullbright.start()
		else
			Fullbright.stop()
		end
    end 
  }) 
  
local Toggle = Tabs.vs:AddToggle("Toggle",
{
    Title = "X-Ray", 
    Description = "Makes you see ores through blocks",
    Default = false,
    Callback = function(state)
        if state then
			XRay.start()
		else
			XRay.stop()
		end
    end 
}) 
  
  
local cesptog = Tabs.vs:AddToggle("Chest ESP",
{
    Title = "Chest ESP", 
    Description = "Makes you see chests through blocks",
    Default = false,
    Callback = function(state)
        if state then
			ChestESP.start()
		else
			ChestESP.stop()
		end
    end 
}) 

local lesptog = Tabs.vs:AddToggle("Lava ESP",
{
    Title = "Lava ESP", 
    Description = "Makes you see lava through blocks",
    Default = false,
    Callback = function(state)
        if state then
			LavaESP.start()
		else
			LavaESP.stop()
		end
    end 
}) 

local pesptog = Tabs.vs:AddToggle("Player ESP",
{
    Title = "Player ESP", 
    Description = "Makes you see players through blocks",
    Default = false,
    Callback = function(state)
        if state then
			PlayerESP.start()
		else
			PlayerESP.stop()
		end
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
      player.Character.Gamemode.Value = im and 1 or 0
    end 
  })

  local fbtog = Tabs.wr:AddToggle("Fast Break",
  {
    Title = "Fast Break", 
    Description = "Breaks blocks fast (with the correct tools)",
    Default = false,
    Callback = function(f)
      fb = f
      while fb do
        abb:InvokeServer()
        task.wait()
      end
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
  })
  
  local nk3tog = Tabs.wr:AddToggle("Nuker3",
  {
    Title = "Nuker 3x3", 
    Description = "Breaks blocks around you in a 3³ area",
    Default = false,
    Callback = function(n3)
      nk3 = n3
      if nk3 then
          _G.putanynamehere = task.spawn(function()
              while nk3 do
                  local coordText3 = game:GetService("Players").LocalPlayer.PlayerGui.HUDGui.DataFrame.coordinates.Text
				          local playerPosX, playerPosY, playerPosZ = coordText3:match("(%-?%d+),%s*(%-?%d+),%s*(%-?%d+)")
				          local baseX = tonumber(playerPosX)
				          local baseY = tonumber(playerPosY) - 1
				          local baseZ = tonumber(playerPosZ)

				          local positions = {}
			  
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

  local nk5tog = Tabs.wr:AddToggle("Nuker5",
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
  
  local ScaffoldToggle = Tabs.wr:AddToggle("Scaffold",
  {
    Title = "Scaffold", 
    Description = "Place block below you",
    Default = false,
    Callback = function(S)
      So = S
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
  })

  local Scaffold3Toggle = Tabs.wr:AddToggle("Scaffold3",
  {
    Title = "Scaffold 3x3", 
    Description = "Place blocks in a 3x3 area below you",
    Default = false,
    Callback = function(S3)
      So3 = S3
      if So3 then
        local M_World = require(game.Players.LocalPlayer.PlayerScripts.MainLocalScript.CWorld)
local M_IDs = require(game.ReplicatedStorage.AssetsMod.IDs)
local BlocksByName = M_IDs.ByName.Blocks

local dir = 1

_G.CoordsChannel = game.Players.LocalPlayer.PlayerGui.HUDGui.DataFrame.Coord
:GetPropertyChangedSignal("Text"):Connect(function()

    local lp = game.Players.LocalPlayer
    local char = lp.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return end

    local placeSlot = char.SelectedSlot.Value
    local slotGui = lp.PlayerGui.HUDGui.Inventory.Slots["Slot"..placeSlot]
    if not slotGui or not slotGui.Slot.Display:FindFirstChild("SlotB") then return end

    local realBlock
    for _, v in pairs(slotGui.Slot.Display.SlotB:GetChildren()) do
        realBlock = v.Name
        break
    end
    if not realBlock then return end

    local itemblock_info = BlocksByName[realBlock]
    if not itemblock_info then return end

    local coordText = lp.PlayerGui.HUDGui.DataFrame.Coord.Text
    local x, y, z = coordText:match("(%-?%d+),%s*(%-?%d+),%s*(%-?%d+)")
    if not x then return end

    x = tonumber(x)
    y = tonumber(y) - 1
    z = tonumber(z)

    -- build 3x3 positions
    local positions = {}
    for ox = -1, 1 do
        for oz = -1, 1 do
            positions[#positions + 1] = {x + ox, y, z + oz}
        end
    end

    -- instant placement burst
    for i = 1, #positions do
    task.spawn(function()
        local px, py, pz = unpack(positions[i])

        local block, chunk = M_World.getBlock(px, py, pz)
        local canPlace = false

        if not block then
            canPlace = true
        else
            for _, v in pairs(block) do
                if v == 0 then
                    canPlace = true
                    break
                end
            end
        end

        if not canPlace then return end

        -- client-side prediction
        M_World.placeBlock(px, py, pz, chunk, dir, itemblock_info.id)

        -- server call (this yields, but now isolated)
        local ok, name = game.ReplicatedStorage.GameRemotes.PlaceBlock
            :InvokeServer(px, py, pz, placeSlot, dir)

        if not ok then
            chunk:change(px % 16, py, pz % 16, name)
        end
    end)
							end
end)
    else
        _G.CoordsChannel:Disconnect()
    end
    end 
  })

  local HighwayToggleX = Tabs.wr:AddToggle("HighwayBuilder",
  {
    Title = "Highway Builder X", 
    Description = "Builds a highway below you",
    Default = false,
    Callback = function(H)
      HB = H
      if HB then
        local M_World = require(game.Players.LocalPlayer.PlayerScripts.MainLocalScript.CWorld)
local M_IDs = require(game.ReplicatedStorage.AssetsMod.IDs)
local BlocksByName = M_IDs.ByName.Blocks

local dir = 1

_G.CoordsChannel = game.Players.LocalPlayer.PlayerGui.HUDGui.DataFrame.Coord
:GetPropertyChangedSignal("Text"):Connect(function()

    local lp = game.Players.LocalPlayer
    local char = lp.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return end

    local placeSlot = char.SelectedSlot.Value
    local slotGui = lp.PlayerGui.HUDGui.Inventory.Slots["Slot"..placeSlot]
    if not slotGui or not slotGui.Slot.Display:FindFirstChild("SlotB") then return end

    local realBlock
    for _, v in pairs(slotGui.Slot.Display.SlotB:GetChildren()) do
        realBlock = v.Name
        break
    end
    if not realBlock then return end

    local itemblock_info = BlocksByName[realBlock]
    if not itemblock_info then return end

    local coordText = lp.PlayerGui.HUDGui.DataFrame.Coord.Text
    local x, y, z = coordText:match("(%-?%d+),%s*(%-?%d+),%s*(%-?%d+)")
    if not x then return end

    x = tonumber(x)
    y = tonumber(y) - 1
    z = tonumber(z)

    -- build 3x3 positions
    local positions = {}
    for ox = -2, 2 do
    -- base line
    positions[#positions + 1] = {x + ox, y, z}

    -- raised edges (only ends)
    if ox == -2 or ox == 2 then
        positions[#positions + 1] = {x + ox, y + 1, z}
    end
							end

    -- instant placement burst
    for i = 1, #positions do
    task.spawn(function()
        local px, py, pz = unpack(positions[i])

        local block, chunk = M_World.getBlock(px, py, pz)
        local canPlace = false

        if not block then
            canPlace = true
        else
            for _, v in pairs(block) do
                if v == 0 then
                    canPlace = true
                    break
                end
            end
        end

        if not canPlace then return end

        -- client-side prediction
        M_World.placeBlock(px, py, pz, chunk, dir, itemblock_info.id)

        -- server call (this yields, but now isolated)
        local ok, name = game.ReplicatedStorage.GameRemotes.PlaceBlock
            :InvokeServer(px, py, pz, placeSlot, dir)

        if not ok then
            chunk:change(px % 16, py, pz % 16, name)
        end
    end)
							end
end)
    else
        _G.CoordsChannel:Disconnect()
    end
    end 
  })

local HighwayToggleZ = Tabs.wr:AddToggle("HighwayBuilder", {
    Title = "Highway Builder Z", 
    Description = "Builds a highway below you",
    Default = false,
    Callback = function(H)
        HB = H
        if HB then
            local M_World = require(game.Players.LocalPlayer.PlayerScripts.MainLocalScript.CWorld)
			local M_IDs = require(game.ReplicatedStorage.AssetsMod.IDs)
			local BlocksByName = M_IDs.ByName.Blocks

			local dir = 1
				
			_G.CoordsChannel = game.Players.LocalPlayer.PlayerGui.HUDGui.DataFrame.coordinates:GetPropertyChangedSignal("Text"):Connect(function()
				local lp = game.Players.LocalPlayer
				local char = lp.Character
				local hum = char and char:FindFirstChildOfClass("Humanoid")
				if not hum or hum.Health <= 0 then return end
				local placeSlot = char.SelectedSlot.Value
				local slotGui = lp.PlayerGui.HUDGui.Inventory.Slots["Slot"..placeSlot]
				if not slotGui or not slotGui.Slot.Display:FindFirstChild("SlotB") then return end
				local realBlock
    
				for _, v in pairs(slotGui.Slot.Display.SlotB:GetChildren()) do
					realBlock = v.Name
					break
				end
				if not realBlock then return end
				local itemblock_info = BlocksByName[realBlock]
				if not itemblock_info then return end

				local coordText = lp.PlayerGui.HUDGui.DataFrame.coordinates.Text
				local x, y, z = coordText:match("(%-?%d+),%s*(%-?%d+),%s*(%-?%d+)")
				if not z then return end

				x = tonumber(x)
				y = tonumber(y) - 1
				z = tonumber(z)
						
				local positions = {}
				for oz = -2, 2 do
					positions[#positions + 1] = {x, y, z + oz}
					if oz == -2 or oz == 2 then
						positions[#positions + 1] = {x, y + 1, z + oz}
					end
				end
				
				for i = 1, #positions do
					task.spawn(function()
					    local px, py, pz = unpack(positions[i])
						local block, chunk = M_World.getBlock(px, py, pz)
					    local canPlace = false
									
						if not block then
							canPlace = true
						else
						    for _, v in pairs(block) do
							    if v == 0 then
								    canPlace = true
									break
								end
							end
						end

					    if not canPlace then return end
										
						M_World.placeBlock(px, py, pz, chunk, dir, itemblock_info.id)
							
						local ok, name = game.ReplicatedStorage.GameRemotes.PlaceBlock:InvokeServer(px, py, pz, placeSlot, dir)
									
						if not ok then
							chunk:change(px % 16, py, pz % 16, name)
						end
					end)
				end
			end)
		else
			_G.CoordsChannel:Disconnect()
		end
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
    Description = "Dupes the selected item",
    Callback = function()
	  local slot = game.Players.LocalPlayer.PlayerGui.HUDGui.Inventory.Slots:FindFirstChild("Slot-1")
      local b = slot.SlotNA.Count
      local moveitems = gameremotes:FindFirstChild("MoveItem") or gameremotes:FindFirstChild("MoveItems")
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
    Title = "Dump + Dupe Entire Chest",
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
	  game.Players.LocalPlayer.PlayerGui.invviewer:Destroy()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/bytehub/refs/heads/main/Byte%20Hub/Wolfmoons.lua",true))()
    end
  })

  Tabs.ot:AddButton({
    Title = "Load Minerscraft",
    Description = "Loads ByteHub for Minerscraft",
    Callback = function()
      Fluent:Destroy()
      getgenv().bytehubLoaded = false
      if isMobile then
        game.CoreGui.Toggleui:Destroy()
      end
	  game.Players.LocalPlayer.PlayerGui.invviewer:Destroy()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/bytehub/refs/heads/main/Byte%20Hub/Minerscraft.lua",true))()
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
        _G.delay = newDelay -- Update the delay value dynamically
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
        _G.radius = newRadius -- Update the delay value dynamically
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
        _G.speed = newSpeed -- Update the delay value dynamically
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
      _G.selectedTargeting = Value
    end
  })
  
  local utstog = Tabs.st:AddToggle("Toggle", {
    Title = "Use task.spawn()", 
    Description = "Makes some features run asynchronously\nto prevent blocking.",
    Default = false,
    Callback = function(uts)
        ut = uts
        _G.useTaskSpawn = uts
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
	  game.Players.LocalPlayer.PlayerGui.invviewer:Destroy()
    end
  })
  
Window:SelectTab(1)
SaveManager:SetLibrary(Fluent)
SaveManager:SetFolder("ByteHub/MC")
SaveManager:BuildConfigSection(Tabs.st)
SaveManager:LoadAutoloadConfig()

_G.Fluent = Fluent
_G.Window = Window
_G.Tabs = Tabs
