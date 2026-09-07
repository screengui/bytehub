local AkaliNotif = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/Dynissimo/main/Scripts/AkaliNotif.lua"))(); -- Notif Library
local Notify = AkaliNotif.Notify;
if getgenv().bytehubLoaded then
	Notify({
        Description = "Byte Hub is already loaded!";
        Title = "Error!";
        Duration = 3;
    });
    wait(1)
	return
end

getgenv().bytehubLoaded = true
local version = "pre-release v4.6.1"
-- Services --
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local Camera = game.Workspace.CurrentCamera
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

-- Game Scripts --
local MainScript = game:GetService("Players").LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("MainLocalScript")
local CGlobals = require(MainScript:WaitForChild("CGlobals"))
local BlockInfo = require(ReplicatedStorage:WaitForChild("AssetsMod"):WaitForChild("BlockInfo"))
local ItemInfo = require(ReplicatedStorage:WaitForChild("AssetsMod"):WaitForChild("ItemInfo"))
local ItemLevels = require(ReplicatedStorage:WaitForChild("AssetsMod"):WaitForChild("ItemLevels"))
local BlockHighlights = require(MainScript:WaitForChild("BlockHighlights"))

-- Variables --
local player = game:GetService("Players").LocalPlayer
local mouse = player:GetMouse()
local LP = game.Players.LocalPlayer
local Character = player.Character
  
local ESP = loadstring(game:HttpGet("https://kiriot22.com/releases/ESP.lua"))()
local metaBlocks = game.ReplicatedFirst:FindFirstChild("MetaBlocks")
local ItemInfo = require(ReplicatedStorage:WaitForChild("AssetsMod"):WaitForChild("ItemInfo"))
local blocks = workspace.Blocks
local features = {}
local Inventory = Character:WaitForChild("Inventory")

-- Checks --
local isMobile
local isPC
local currentTarget
local hasGiveExploit

if not game.Players.LocalPlayer.Character:FindFirstChild("Gamemode") then
	local Gamemode = Instance.new("IntValue")
	Gamemode.Name = "Gamemode"
	Gamemode.Parent = game.Players.LocalPlayer.Character
end

-- Placeholders --
local selectedPlayerName = nil
local autoToolConn = nil
local savedName = player.Name
local platform
local platformY = 0

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

if not platform then
	platform = Instance.new("Part")
	platform.Anchored = true
	platform.Size = Vector3.new(5, 1, 5)
	platform.Transparency = 1
	platform.CanCollide = false
	platform.Parent = workspace
end

local TB = false
local usetables = false

local TIERS = {Diamond = 4, Ruby = 3, Iron = 2, Gold = 2, Steel = 2, Stone = 1}
local ARMOR = {Helmet = 103, Chestplate = 102, Leggings = 101, Boots = 100}

local nameProtDefVal = "Protected"

-- Remotes --
local gameremotes = ReplicatedStorage.GameRemotes
local GameRemotes = ReplicatedStorage.GameRemotes
local Demo = gameremotes:FindFirstChild("Demo") or Workspace:FindFirstChild("Demo")
local abb = gameremotes.AcceptBreakBlock
local bb = gameremotes.BreakBlock
local Attack = gameremotes:WaitForChild("Attack")
local moveitems = gameremotes:FindFirstChild("MoveItem") or gameremotes:FindFirstChild("MoveItems")
local MoveItem = ReplicatedStorage:WaitForChild("GameRemotes"):WaitForChild("MoveItem")
local sortitems = gameremotes:FindFirstChild("SortItem") or gameremotes:FindFirstChild("SortItems")
local useblock = gameremotes.UseBlock

-- Adonis Bypass --
--loadstring(game:HttpGet("https://raw.githubusercontent.com/Pixeluted/adoniscries/refs/heads/main/Source.lua",true))()
loadstring(game:HttpGet('https://raw.githubusercontent.com/SUUUUUS00000/MEGGD-Anti-kick/refs/heads/main/MEGGD%20Best%20Anti-kick.lua'))()

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

function TriggerBot()
    if not TB then 
        currentTarget = nil
        return 
    end

    local char = LP.Character
    if not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local viewport = Camera.ViewportSize
    local ray = Camera:ViewportPointToRay(viewport.X/2, viewport.Y/2)

    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {char}
    params.FilterType = Enum.RaycastFilterType.Blacklist

    local result = workspace:Raycast(ray.Origin, ray.Direction * 500, params)

    local newTarget = nil

    if result then
        local character = result.Instance:FindFirstAncestorOfClass("Model")

        if character and character ~= char and character:FindFirstChildOfClass("Humanoid") then
            newTarget = character
        end
    end

    currentTarget = newTarget

    if currentTarget then
        local tHRP = currentTarget:FindFirstChild("HumanoidRootPart")
        local hum = currentTarget:FindFirstChildOfClass("Humanoid")

        if hum and hum.Health > 0 and tHRP then
            local d = hrp.Position - tHRP.Position
            if (d.X*d.X + d.Z*d.Z) <= _G.RANGE_SQ then
                Attack:InvokeServer(currentTarget)
            end
        end
    end
end

local function decode(slot)
	local ok, data = pcall(HttpService.JSONDecode, HttpService, slot.Value)
	return ok and data or nil
end

local function getTier(name)
    for prefix, tier in pairs(TIERS) do
        if string.find(name, "^" .. prefix) then 
            local afterPrefix = string.sub(name, #prefix + 1, #prefix + 1)
            if afterPrefix == "" or afterPrefix == " " or string.match(afterPrefix, "%u") then
                return tier 
            end
        end
    end
    
    local info = ItemInfo[name]
    return info and (info.tier or info.Tier) or 0
end

local function getArmorType(name)
    for aType, id in pairs(ARMOR) do
        if string.find(name, aType) then 
            return id 
        end
    end
    return nil
end

local function isBetter(new, old)
    local newTier = getTier(new.name)
    local oldTier = getTier(old.name)
    
    local newDur = new.durability or 0
    local oldDur = old.durability or 0

    local newInfo = ItemInfo[new.name]
    local oldInfo = ItemInfo[old.name]
    local newMax = newInfo and newInfo.durability or 100
    local oldMax = oldInfo and oldInfo.durability or 100

    if oldDur <= (oldMax * 0.1) and newDur > (newMax * 0.1) then
        if newTier >= (oldTier - 1) then
            return true
        end
    end

    if newTier > oldTier then
        if newDur > (newMax * 0.1) or oldDur <= (oldMax * 0.05) then
            return true
        end
    elseif newTier == oldTier then
        if newDur > oldDur then
            return true
        end
    end

    if newTier == oldTier and newDur == oldDur then
        return newMax > oldMax
    end

    return false
end

local function autoEquipArmor()
	local inv = player.Character:FindFirstChild("Inventory")
	if not inv then return end

	local best = {
		[103] = {tier = -1, dur = -1, idx = nil},
		[102] = {tier = -1, dur = -1, idx = nil},
		[101] = {tier = -1, dur = -1, idx = nil},
		[100] = {tier = -1, dur = -1, idx = nil}
	}

	for i = 0, 35 do
		local slot = inv:FindFirstChild("Slot" .. i)
		local data = slot and decode(slot)

		if data and data.count >= 1 and data.name then
			local armorSlot = getArmorType(data.name)
			if armorSlot then
				local tier = getTier(data.name)
				local dur = data.durability or 0

				if tier > best[armorSlot].tier or (tier == best[armorSlot].tier and dur > best[armorSlot].dur) then
					best[armorSlot] = {tier = tier, dur = dur, idx = i, name = data.name}
				end
			end
		end
	end

	for slot, item in pairs(best) do
		if item.idx then
			local equipped = decode(inv:FindFirstChild("Slot" .. slot))
			
			if not equipped or equipped.count <= 0 then
				MoveItem:InvokeServer(item.idx, slot, true)
			elseif isBetter(item, equipped) then
				MoveItem:InvokeServer(item.idx, slot, true)
			end
		end
	end
end

player.CharacterAdded:Connect(function(newChar)
	Character = newChar
	Inventory = newChar:WaitForChild("Inventory")
end)

local function getHotbar()
	return player.PlayerGui:FindFirstChild("HUDGui") and player.PlayerGui.HUDGui:FindFirstChild("Hotbar")
end

local function getSlotButton(index)
	local Hotbar = getHotbar()
	if not Hotbar then return nil end
	
	local targetX = index * 40 + 6
	for _, btn in ipairs(Hotbar:GetChildren()) do
		if btn:IsA("TextButton") and btn.Position.X.Offset == targetX then
			return btn
		end
	end
	return nil
end

local function setSlot(index)
	local slot = getSlotButton(index)
	if slot then
		for _, conn in ipairs(getconnections(slot.MouseButton1Click)) do
			conn:Fire()
		end
	end
end

local function decodeSlot(slotVal)
	local success, data = pcall(HttpService.JSONDecode, HttpService, slotVal.Value)
	return success and data and data.count > 0 and data or nil
end

local function getItemSpeed(itemName, reqType, betterTool)
	local itemData = ItemInfo[itemName]
	if itemData and (itemData.tooltype == reqType or itemData.tooltype == betterTool) then
		return ItemLevels.speedMul[itemData.level] or 1
	end
	return 1
end

local function getBestToolSlot(blockName)
	local blockData = BlockInfo[blockName]
	if not blockData then return nil end

	local bestSlot, maxSpeed = nil, 0
	local reqType, betterTool = blockData.toolRequire, blockData.betterTool

	for i = 0, 8 do
		local slotVal = Inventory:FindFirstChild("Slot" .. i)
		if slotVal then
			local data = decodeSlot(slotVal)
			if data then
				local speed = getItemSpeed(data.name, reqType, betterTool)
				if speed > maxSpeed then
					maxSpeed = speed
					bestSlot = i
				end
			end
		end
	end

	return bestSlot
end

local function getSelectedSlot()
	local charModel = workspace:FindFirstChild(player.Name)
	return charModel and charModel:FindFirstChild("SelectedSlot")
end

function InfiniteJump()
end

function ReloadChunk()
	if not require then
		Notify({
        	Description = "Your Executor doesn't support require()!";
        	Title = "Error!";
        	Duration = 3;
    	});
		return 
	end

	local player = game:GetService("Players").LocalPlayer
	local PlayerScripts = player:WaitForChild("PlayerScripts")
	local MainLocalScript = PlayerScripts:WaitForChild("MainLocalScript")
	local _CWorld = MainLocalScript:WaitForChild("CWorld")

	local CWorld = require(_CWorld)

	local world = CWorld.World
	local loadingChunks = CWorld.LoadingChunks
	local renderingChunks = CWorld.RenderingChunks
	local loadingReqQueue = CWorld.LoadingReqQueue
	local processingBlocks = CWorld.ProcessingBlocks

	for cx, yrow in pairs(renderingChunks) do
    	for cy, chunk in pairs(yrow) do
        	if chunk.BlockerPart then
            	pcall(function() chunk.BlockerPart:Destroy() end)
        	end
        	if chunk.vfold then
            	pcall(function() chunk.vfold:Destroy() end)
        	end
        	if chunk.vlfold then
            	pcall(function() chunk.vlfold:Destroy() end)
        	end
    	end
	end

	table.clear(world)
	table.clear(loadingChunks)
	table.clear(renderingChunks)
	table.clear(loadingReqQueue)

	if processingBlocks and typeof(processingBlocks) == "table" then
    	if processingBlocks.clear then
     	    pcall(function() processingBlocks:clear() end)
    	elseif processingBlocks.Contents then
        	table.clear(processingBlocks.Contents)
    	else
        	table.clear(processingBlocks)
    	end
	else
    	warn("processingBlocks missing - continuing anyway")
	end
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

loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/archives/main/inv-viewerV2.lua",true))()
game.Players.LocalPlayer.PlayerGui.invviewer.Enabled = false

--===INLINE FEATURES===--
local killAuraEnabled = false
local targetStrafeEnabled = false
local hitboxConnection
local targetStrafeConnection
local combatLogEnabled = false
local safeZoneEnabled = false
local noFallEnabled = false
local sprintEnabled = false
local autoEatEnabled = false
local jesusEnabled = false
local infiniteHealthEnabled = false
local crosshairConnection
local rainbowCrosshairConnection
local fullbrightSettings = {}
local xrayEnabled = false
local chestESPEnabled = false
local lavaESPEnabled = false
local playerESPEnabled = false
local autoDropEnabled = false
local autoDupeEnabled = false
local armorEnabled = false
local autoToolEnabled = false
local airWalkEnabled = false
local enderChestEnabled = false
local fastBreakEnabled = false
local nukerEnabled = false
local nuker3Enabled = false
local nuker5Enabled = false
local scaffoldEnabled = false
local scaffold3Enabled = false
local highwayXEnabled = false
local highwayZEnabled = false
local targetStrafeTime = 0

local function getLowestHealthNearbyPlayer()
    local lowestHealth = math.huge
    local targetPlayer
    local localCharacter = LP.Character
    local localRoot = localCharacter and localCharacter:FindFirstChild("HumanoidRootPart")
    if not localRoot then return nil end
    for _, targetPlayerCandidate in ipairs(Players:GetPlayers()) do
        local targetCharacter = targetPlayerCandidate.Character
        local humanoid = targetCharacter and targetCharacter:FindFirstChildOfClass("Humanoid")
        local targetRoot = targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")
        if targetPlayerCandidate ~= LP and humanoid and targetRoot and humanoid.Health > 0 then
            local distance = (targetRoot.Position - localRoot.Position).Magnitude
            if distance <= (_G.strafeRange or 50) and humanoid.Health < lowestHealth then
                lowestHealth = humanoid.Health
                targetPlayer = targetPlayerCandidate
            end
        end
    end
    return targetPlayer
end

local function getClosestPlayer()
    local closestPlayer
    local shortestDistance = math.huge
    local localCharacter = LP.Character
    local localRoot = localCharacter and localCharacter:FindFirstChild("HumanoidRootPart")
    if not localRoot then return nil end
    for _, targetPlayer in ipairs(Players:GetPlayers()) do
        local targetCharacter = targetPlayer.Character
        local targetRoot = targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")
        if targetPlayer ~= LP and targetRoot then
            local distance = (localRoot.Position - targetRoot.Position).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                closestPlayer = targetPlayer
            end
        end
    end
    return closestPlayer
end

local function getCombatTarget()
    if _G.selectedTargeting == "lowest" then
        return getLowestHealthNearbyPlayer()
    end
    return getClosestPlayer()
end

local function startKillAura()
    killAuraEnabled = true
end

local function stopKillAura()
    killAuraEnabled = false
end

local function startTargetStrafe()
    targetStrafeEnabled = true
end

local function stopTargetStrafe()
    targetStrafeEnabled = false
    if targetStrafeConnection then
        targetStrafeConnection:Disconnect()
        targetStrafeConnection = nil
    end
end

local function changeTorsoSize(targetPlayer, size, transparency)
    local targetCharacter = targetPlayer.Character
    local torso = targetCharacter and (targetCharacter:FindFirstChild("Torso") or targetCharacter:FindFirstChild("UpperTorso"))
    if torso then
        torso.Size = size
        torso.Massless = true
        torso.Transparency = transparency
    end
end

local function startHitbox()
    hitboxConnection = true
end

local function stopHitbox()
    hitboxConnection = nil
    for _, targetPlayer in ipairs(Players:GetPlayers()) do
        if targetPlayer ~= LP then changeTorsoSize(targetPlayer, Vector3.new(2, 2, 1), 0) end
    end
end

local function startCombatLog()
    combatLogEnabled = true
end

local function stopCombatLog() combatLogEnabled = false end

local function startSafeZone()
    safeZoneEnabled = true
end

local function stopSafeZone() safeZoneEnabled = false end

local function startNoFall()
    noFallEnabled = true
    if Demo.Parent == GameRemotes then Demo.Parent = Workspace end
end

local function stopNoFall()
    noFallEnabled = false
    if Demo.Parent == Workspace then Demo.Parent = GameRemotes end
end

local function startSprint()
    sprintEnabled = true
    local humanoid = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid.WalkSpeed = 20 end
end

local function stopSprint()
    sprintEnabled = false
    local humanoid = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid.WalkSpeed = 12 end
end

local function startAutoEat()
    autoEatEnabled = true
end

local function stopAutoEat() autoEatEnabled = false end

local function startJesus()
    jesusEnabled = true
    local fluidFolder = Workspace:FindFirstChild("Fluid")
    if fluidFolder then
        for _, object in ipairs(fluidFolder:GetDescendants()) do
            if object:IsA("BasePart") and (object.Name == "Water" or object.Name == "Lava") then object.CanCollide = true end
        end
    end
end

local function stopJesus()
    jesusEnabled = false
    local fluidFolder = Workspace:FindFirstChild("Fluid")
    if fluidFolder then
        for _, object in ipairs(fluidFolder:GetDescendants()) do
            if object:IsA("BasePart") and (object.Name == "Water" or object.Name == "Lava") then object.CanCollide = false end
        end
    end
end

local function startInfiniteHealth()
    infiniteHealthEnabled = true
end

local function stopInfiniteHealth() infiniteHealthEnabled = false end

local function showDefaultCrosshair(show)
    for _, object in ipairs(LP.PlayerGui.HUDGui:GetChildren()) do
        if object.Name == "Crosshair" then object.Visible = show end
    end
end

local function startCrosshair(settings)
    showDefaultCrosshair(false)
    local viewport = Camera.ViewportSize / 2
    local size = settings.Size / 2
    settings.HorizontalLine.Color = settings.Color
    settings.HorizontalLine.Thickness = settings.Thickness
    settings.HorizontalLine.Transparency = settings.Transparency
    settings.HorizontalLine.Visible = true
    settings.HorizontalLine.From = Vector2.new(viewport.X - size, viewport.Y)
    settings.HorizontalLine.To = Vector2.new(viewport.X + size, viewport.Y)
    settings.VerticalLine.Color = settings.Color
    settings.VerticalLine.Thickness = settings.Thickness
    settings.VerticalLine.Transparency = settings.Transparency
    settings.VerticalLine.Visible = true
    settings.VerticalLine.From = Vector2.new(viewport.X, viewport.Y - size)
    settings.VerticalLine.To = Vector2.new(viewport.X, viewport.Y + size)
end

local function stopCrosshair(settings)
    settings.HorizontalLine.Visible = false
    settings.VerticalLine.Visible = false
    showDefaultCrosshair(true)
end

local function startRainbowCrosshair(settings)
    showDefaultCrosshair(false)
    rainbowCrosshairConnection = RunService.RenderStepped:Connect(function()
        local viewport = Camera.ViewportSize / 2
        local size = settings.Size / 2
        local color = Color3.fromHSV((tick() * 0.2) % 1, 1, 1)
        settings.HorizontalLine.Color = color
        settings.HorizontalLine.Visible = true
        settings.HorizontalLine.From = Vector2.new(viewport.X - size, viewport.Y)
        settings.HorizontalLine.To = Vector2.new(viewport.X + size, viewport.Y)
        settings.VerticalLine.Color = color
        settings.VerticalLine.Visible = true
        settings.VerticalLine.From = Vector2.new(viewport.X, viewport.Y - size)
        settings.VerticalLine.To = Vector2.new(viewport.X, viewport.Y + size)
    end)
end

local function stopRainbowCrosshair(settings)
    if rainbowCrosshairConnection then rainbowCrosshairConnection:Disconnect() rainbowCrosshairConnection = nil end
    stopCrosshair(settings)
end

local function startFullbright()
    fullbrightSettings = {Brightness = Lighting.Brightness, ClockTime = Lighting.ClockTime, FogEnd = Lighting.FogEnd, GlobalShadows = Lighting.GlobalShadows, OutdoorAmbient = Lighting.OutdoorAmbient}
    Lighting.Brightness = 2
    Lighting.ClockTime = 14
    Lighting.FogEnd = 100000
    Lighting.GlobalShadows = false
    Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
end

local function stopFullbright()
    for property, value in pairs(fullbrightSettings) do Lighting[property] = value end
    fullbrightSettings = {}
end

local function startXRay()
    xrayEnabled = true
    for _, block in ipairs(blocks:GetChildren()) do
        if block:IsA("BasePart") then block.LocalTransparencyModifier = 0.5 end
    end
end

local function stopXRay()
    xrayEnabled = false
    for _, block in ipairs(blocks:GetChildren()) do
        if block:IsA("BasePart") then block.LocalTransparencyModifier = 0 end
    end
end

local function addAdornment(part, name, color)
    if part:FindFirstChild(name) then return end
    local adornment = Instance.new("BoxHandleAdornment")
    adornment.Name = name
    adornment.Adornee = part
    adornment.AlwaysOnTop = true
    adornment.Size = part.Size
    adornment.Transparency = 0.5
    adornment.Color = BrickColor.new(color)
    adornment.Parent = part
end

local function clearAdornment(name)
    for _, object in ipairs(Workspace:GetDescendants()) do
        local adornment = object:FindFirstChild(name)
        if adornment then adornment:Destroy() end
    end
end

local function startChestESP()
    chestESPEnabled = true
end

local function stopChestESP() chestESPEnabled = false end

local function startLavaESP()
    lavaESPEnabled = true
end

local function stopLavaESP() lavaESPEnabled = false end

local function startPlayerESP()
    playerESPEnabled = true
end

local function stopPlayerESP() playerESPEnabled = false end

local function runNuker(size)
    local coordText = LP.PlayerGui.HUDGui.DataFrame.Coord.Text
    local x, y, z = coordText:match("(%-?%d+),%s*(%-?%d+),%s*(%-?%d+)")
    x, y, z = tonumber(x), tonumber(y), tonumber(z)
    if not (x and y and z) then return end

    local radius = math.floor(size / 2)
    for offsetX = -radius, radius do
        for offsetY = -radius, radius do
            for offsetZ = -radius, radius do
                bb:FireServer(x + offsetX, y - 1 + offsetY, z + offsetZ)
                abb:InvokeServer()
            end
        end
    end
end

task.spawn(function()
    local safeZoneAccumulator = 0
    local espAccumulator = 0
    while true do
        local deltaTime = task.wait()
        safeZoneAccumulator += deltaTime
        espAccumulator += deltaTime

        pcall(function()
            if TB then TriggerBot() end
            if infj then
                local jumpHumanoid = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
                if jumpHumanoid then jumpHumanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
            end

            if killAuraEnabled then
                local localCharacter = LP.Character
                local localRoot = localCharacter and localCharacter:FindFirstChild("HumanoidRootPart")
                local target = getCombatTarget()
                local targetRoot = target and target.Character and target.Character:FindFirstChild("HumanoidRootPart")
                if localRoot and targetRoot then
                    local distance = localRoot.Position - targetRoot.Position
                    if distance.X * distance.X + distance.Z * distance.Z <= (_G.RANGE_SQ or 256) then
                        Attack:InvokeServer(target.Character)
                    end
                end
            end

            if targetStrafeEnabled then
                local localCharacter = LP.Character
                local localRoot = localCharacter and localCharacter:FindFirstChild("HumanoidRootPart")
                local target = getCombatTarget()
                local targetRoot = target and target.Character and target.Character:FindFirstChild("HumanoidRootPart")
                if localRoot and targetRoot then
                    targetStrafeTime += deltaTime * (_G.speed or 2)
                    local targetPosition = targetRoot.Position
                    local offset = Vector3.new(math.cos(targetStrafeTime) * (_G.radius or 10), 0, math.sin(targetStrafeTime) * (_G.radius or 10))
                    localRoot.CFrame = CFrame.new(targetPosition + offset, targetPosition)
                end
            end

            if hitboxConnection then
                for _, targetPlayer in ipairs(Players:GetPlayers()) do
                    if targetPlayer ~= LP then changeTorsoSize(targetPlayer, Vector3.new(10, 10, 10), 0.999) end
                end
            end

            local humanoid = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
            if combatLogEnabled and humanoid and humanoid.Health <= humanoid.MaxHealth * 0.4 then game:Shutdown() end
            local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if safeZoneEnabled and root and humanoid and humanoid.Health <= humanoid.MaxHealth * 0.4 and safeZoneAccumulator >= 0.25 then
                root.CFrame = CFrame.new(3000, 180, 3000)
            end

            if autoEatEnabled and Character and Character:FindFirstChild("SelectedSlot") then
                local consumeRemote = GameRemotes:FindFirstChild("ConsumeItem")
                if consumeRemote then pcall(function() consumeRemote:InvokeServer(Inventory, Character.SelectedSlot.Value) end) end
            end
            if infiniteHealthEnabled then
                moveitems:InvokeServer(101, 9, true)
                moveitems:InvokeServer(9, 101, true)
            end
            if armorEnabled then autoEquipArmor() end

            if autoToolEnabled then
                local selectedSlotObj = getSelectedSlot()
                local targetPos = CGlobals.TargetBlockCoordinate
                local targetBlock = CGlobals.BlockUnderMouse
                if selectedSlotObj and targetPos and targetBlock and BlockHighlights.IsBreaking(targetPos) then
                    local bestSlot = getBestToolSlot(targetBlock.Name)
                    if bestSlot and selectedSlotObj.Value ~= bestSlot then setSlot(bestSlot) end
                end
            end

            if airWalkEnabled and Character and Character:FindFirstChild("HumanoidRootPart") then
                platform.Position = Vector3.new(Character.HumanoidRootPart.Position.X, platformY, Character.HumanoidRootPart.Position.Z)
            end
            if enderChestEnabled then
                local inventory = LP.PlayerGui.HUDGui.Inventory
                inventory.Chest.Visible = true
                inventory.Crafting.Visible = false
                inventory.Mirror.Visible = false
                inventory.ResultSlot.Visible = false
                for _, slotName in ipairs({"Slot100", "Slot101", "Slot102", "Slot103", "Slot80", "Slot81", "Slot82", "Slot83", "Slot84", "Slot85", "Slot86", "Slot87", "Slot88"}) do
                    local slot = inventory.Slots:FindFirstChild(slotName)
                    if slot then slot.Visible = false end
                end
            end

            if fastBreakEnabled then abb:InvokeServer() end
            if autoDropEnabled then GameRemotes.DropItem:InvokeServer(true) end
            if nukerEnabled then runNuker(1) end
            if nuker3Enabled then runNuker(3) end
            if nuker5Enabled then runNuker(5) end
            if autoDupeEnabled then chestdupe(2) end

            if espAccumulator >= 0.1 then
                espAccumulator = 0
                if chestESPEnabled then
                    for _, object in ipairs(Workspace:GetDescendants()) do
                        if object:IsA("BasePart") and string.find(object.Name:lower(), "chest") then addAdornment(object, "ChestESP_Adornment", "Bright blue") end
                    end
                end
                if lavaESPEnabled then
                    for _, object in ipairs(Workspace:GetDescendants()) do
                        if object:IsA("BasePart") and object.Name == "Lava" then addAdornment(object, "LavaESP_Adornment", "Deep orange") end
                    end
                end
                if playerESPEnabled then
                    for _, targetPlayer in ipairs(Players:GetPlayers()) do
                        local targetCharacter = targetPlayer.Character
                        if targetPlayer ~= LP and targetCharacter and not targetCharacter:FindFirstChild("PlayerESP_Highlight") then
                            local highlight = Instance.new("Highlight")
                            highlight.Name = "PlayerESP_Highlight"
                            highlight.FillTransparency = 0.5
                            highlight.Parent = targetCharacter
                        end
                    end
                end
            end
        end)

        if not chestESPEnabled then clearAdornment("ChestESP_Adornment") end
        if not lavaESPEnabled then clearAdornment("LavaESP_Adornment") end
        if not playerESPEnabled then
            for _, targetPlayer in ipairs(Players:GetPlayers()) do
                local targetCharacter = targetPlayer.Character
                local highlight = targetCharacter and targetCharacter:FindFirstChild("PlayerESP_Highlight")
                if highlight then highlight:Destroy() end
            end
        end
        if safeZoneAccumulator >= 0.25 then safeZoneAccumulator = 0 end
    end
end)
  
local Fluent = loadstring(game:HttpGet(
    "https://github.com/StyearX/Fluent-Modded/releases/download/Fluent/FluentPro"
))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
local Window = Fluent:CreateWindow({
    Title = "Minecraft (Byte Hub) " .. version,
    SubTitle = "by PurpleApple",
    TabWidth = 160,
    Size = UDim2.fromOffset(560, 300),
    Acrylic = true,
    Theme = "Blood Red",
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
	tp = Window:AddTab({ Title = "Texture Packs", Icon = "list" }),
    st = Window:AddTab({ Title = "Settings", Icon = "settings" }),
}

local Options = Fluent.Options
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
  
Tabs.Credits:AddParagraph({
    Title = "Made by PurpleApple",
    Content = "UI Library: Fluent\n" .. version .. "\nDupe Gui: Argentum\nScaffold: Obos\nOpen-Sourced\nSocials:"
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
		setclipboard("https://discord.gg/9Nzzya6d46")
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
            startKillAura()
		else
            stopKillAura()
		end
	end
})
  
local Toggle = Tabs.cs:AddToggle("Toggle", {
	Title = "Target Strafe (BLATANT)",
    Description = "Circles around your target",
    Default = false,
    Callback = function(state)
        if state then
            startTargetStrafe()
        else
            stopTargetStrafe()
  	    end
    end
})

local Toggle = Tabs.cs:AddToggle("Toggle", {
    Title = "Triggerbot",
    Description = "Automatically attacks your target when you point at them.",
    Default = false,
    Callback = function(state)
        TB = state
    end
})

local hboxtog = Tabs.cs:AddToggle("HitboxToggle", {
    Title = "Hitbox Expander", 
    Description = "Expands other player's hitboxes\nCredits to Ket Hub",
    Default = false,
    Callback = function(state)
        if state then
            startHitbox()
	    else
            stopHitbox()
	    end
    end 
})

local acltog = Tabs.cs:AddToggle("Auto Combat Log", {
    Title = "Auto Combat Log", 
    Description = "Automatically leaves when you have less than 30% hp",
    Default = false,
    Callback = function(state)
        if state then
            startCombatLog()
	    else
            stopCombatLog()
	    end
    end 
}) 

local acttog = Tabs.cs:AddToggle("Auto Combat TP", {
    Title = "Auto Safe Zone", 
    Description = "Auto Combat Log, but it teleports you to a safe zone.",
    Default = false,
    Callback = function(state)
        if state then
            startSafeZone()
	    else
            stopSafeZone()
		end
    end 
}) 

Tabs.cs:AddButton({
    Title = "Vape V4",
    Description = "Executes Vape V4",
    Callback = function()
	    loadstring(game:HttpGet("https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/NewMainScript.lua", true))()
    end
})

local nftog = Tabs.lp:AddToggle("No Fall", {
    Title = "No Fall", 
    Description = "Removes Fall Damage",
    Default = false,
    Callback = function(state)
        if state then
	        startNoFall()
        else
            stopNoFall()
	    end
    end 
}) 

local sptog = Tabs.lp:AddToggle("Sprint", {
    Title = "Sprint", 
    Description = "Makes you a tiny bit faster",
    Default = false,
    Callback = function(state)
        if state then
	        startSprint()
        else
            stopSprint()
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

local eattog = Tabs.lp:AddToggle("EatToggle", {
    Title = "Auto Eat",
    Description = "Automatically eats for you",
    Default = false,
    Callback = function(state)
        if state then
	        startAutoEat()
        else
            stopAutoEat()
	    end
	end
})
	
local jetog = Tabs.lp:AddToggle("Jesus", {
    Title = "Jesus",
    Description = "Walk On Water",
    Default = false,
    Callback = function(state)
        if state then
		    startJesus()
        else
            stopJesus()
	    end
    end
})
	
local Toggle = Tabs.lp:AddToggle("Toggle", {
    Title = "Infinite Health",
    Description = "Increases your hp (only works with emerald leggings)",
    Default = false,
    Callback = function(t)
        if t then
            startInfiniteHealth()
	    else
            stopInfiniteHealth()
	    end
    end 
})

local Toggle = Tabs.lp:AddToggle("ArmorToggle", {
    Title = "Auto Armor",
    Description = "Automatically equips the best armor",
    Default = false,
    Callback = function(aarmor)
        armorEnabled = aarmor
	end
})

local Toggle = Tabs.lp:AddToggle("ToolToggle", {
    Title = "Auto Tool",
    Description = "Automatically finds the best tool for mining\nCredits to 1derby1.",
    Default = false,
    Callback = function(atool)
        autoToolEnabled = atool
	end
})

local ReachToggle = Tabs.lp:AddToggle("Reach", {
    Title = "Reach", 
    Description = "Increases BLOCK INTERACTION range\nNOT ATTACK RANGE",
    Default = false,
    Callback = function(r)
        re = r
        CGlobals["PLAYER_REACH"] = r and 9e9 or 19.5
    end 
})

local Input = Tabs.lp:AddInput("Input", {
    Title = "Walkspeed",
    Description = "Sets your walkspeed amount (Default: 12)",
    Default = "12",
    Placeholder = "Enter a number",
    Numeric = false,
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

local jumptog = Tabs.lp:AddToggle("Infinite Jump", {
    Title = "Infinite Jump/Air Jump",
    Description = "Jump on air infinitely",
    Default = false,
    Callback = function(i)
        infj = i
    end
})

local AirWalkToggle = Tabs.lp:AddToggle("Air Walk", {
    Title = "Air Walk",
    Description = "Walk on air",
    Default = false,
    Callback = function(aw)
        airWalkEnabled = aw
        if airWalkEnabled then
			platformY = Character.HumanoidRootPart.Position.Y - 3
            platform.CanCollide = true
		else
            platform.CanCollide = false
		end
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

local FreezeToggle = Tabs.lp:AddToggle("Freeze", {
    Title = "Freeze", 
    Description = "Freeze yourself in position.",
    Default = false,
    Callback = function(f)
        fr = f
        game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Anchored = fr and true or false
    end 
})

Tabs.lp:AddButton({
    Title = "Suicide",
    Description = "KILL YOURSELF!!!!!",
    Callback = function()
		game:GetService("Players").LocalPlayer.Character.Humanoid.Health = 0
    end
})

local chp = Tabs.vs:AddToggle("CH+", {
    Title = "Crosshair+", 
    Description = "Makes your crosshair look cooler",
    Default = false,
    Callback = function(state)
        if state then
            startCrosshair(CrosshairSettings)
	    else
            stopCrosshair(CrosshairSettings)
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
            startRainbowCrosshair(CrosshairSettings2)
		else
            stopRainbowCrosshair(CrosshairSettings2)
		end
    end 
})
  
local fbtog = Tabs.vs:AddToggle("Fullbright", {
    Title = "Fullbright", 
    Description = "Makes it very bright",
    Default = false,
    Callback = function(state)
        if state then
            startFullbright()
		else
            stopFullbright()
		end
    end 
  }) 
  
local Toggle = Tabs.vs:AddToggle("Toggle", {
    Title = "X-Ray", 
    Description = "Makes you see ores through blocks",
    Default = false,
    Callback = function(state)
        if state then
            startXRay()
		else
            stopXRay()
		end
    end 
}) 
  
  
local cesptog = Tabs.vs:AddToggle("Chest ESP", {
    Title = "Chest ESP", 
    Description = "Makes you see chests through blocks",
    Default = false,
    Callback = function(state)
        if state then
            startChestESP()
		else
            stopChestESP()
		end
    end 
}) 

local lesptog = Tabs.vs:AddToggle("Lava ESP", {
    Title = "Lava ESP", 
    Description = "Makes you see lava through blocks",
    Default = false,
    Callback = function(state)
        if state then
            startLavaESP()
		else
            stopLavaESP()
		end
    end 
}) 

local pesptog = Tabs.vs:AddToggle("Player ESP", {
    Title = "Player ESP", 
    Description = "Makes you see players through blocks",
    Default = false,
    Callback = function(state)
        if state then
            startPlayerESP()
		else
            stopPlayerESP()
		end
    end 
})

local Toggle = Tabs.vs:AddToggle("Chest ESP", {
    Title = "Inventory Viewer", 
    Description = "Makes you see other player's inventories",
    Default = false,
    Callback = function(inv)
        invv = inv
        game.Players.LocalPlayer.PlayerGui.invviewer.Enabled = inv
    end 
}) 

local ectog = Tabs.vs:AddToggle("Enderchest", {
    Title = "More Slots", 
    Description = "Gives you more inventory space",
    Default = false,
    Callback = function(echest)
        enderChestEnabled = echest
    end 
})

local NPtog = Tabs.vs:AddToggle("Name Protect", {
    Title = "Name Protect",
    Description = "Protects your name",
    Default = false,
    Callback = function(state)
        if state then
			getgenv().name = nameProtDefVal

			local Plr = game.Players.LocalPlayer
			for Index, Value in next, game:GetDescendants() do 
				if Value.ClassName == "TextLabel" then 
					local has = string.find(Value.Text,Plr.Name) 
				    if has then 
					    local str = Value.Text:gsub(Plr.Name,name)
					    Value.Text = str 
					end
					Value:GetPropertyChangedSignal("Text"):Connect(function()
						local str = Value.Text:gsub(Plr.Name,name)
						Value.Text = str 
					end)
				end
			end

			game.DescendantAdded:Connect(function(Value)
				if Value.ClassName == "TextLabel" then 
					local has = string.find(Value.Text,Plr.Name)
					Value:GetPropertyChangedSignal("Text"):Connect(function()
						local str = Value.Text:gsub(Plr.Name,name)
						Value.Text = str 
					end)
					if has then 
						local str = Value.Text:gsub(Plr.Name,name)
						Value.Text = str 
					end
				end
			end)
        else
            getgenv().name = savedName

			local Plr = game.Players.LocalPlayer
			for Index, Value in next, game:GetDescendants() do 
				if Value.ClassName == "TextLabel" then 
					local has = string.find(Value.Text,Plr.Name) 
				    if has then 
					    local str = Value.Text:gsub(Plr.Name,name)
					    Value.Text = str 
					end
					Value:GetPropertyChangedSignal("Text"):Connect(function()
						local str = Value.Text:gsub(Plr.Name,name)
						Value.Text = str 
					end)
				end
			end

			game.DescendantAdded:Connect(function(Value)
				if Value.ClassName == "TextLabel" then 
					local has = string.find(Value.Text,Plr.Name)
					Value:GetPropertyChangedSignal("Text"):Connect(function()
						local str = Value.Text:gsub(Plr.Name,name)
						Value.Text = str 
					end)
					if has then 
						local str = Value.Text:gsub(Plr.Name,name)
						Value.Text = str 
					end
				end
			end)
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

local imtog = Tabs.wr:AddToggle("Instamine", {
    Title = "Instamine", 
    Description = "Instantly Mines, but client-sided",
    Default = false,
    Callback = function(i)
        im = i
        player.Character.Gamemode.Value = im and 1 or 0
    end 
})

local fbtog = Tabs.wr:AddToggle("Fast Break", {
    Title = "Fast Break", 
    Description = "Breaks blocks fast (with the correct tools)",
    Default = false,
    Callback = function(f)
        fastBreakEnabled = f
    end 
})

local adstog = Tabs.wr:AddToggle("Toggle", {
    Title = "Auto Drop Selected Item", 
    Description = "Automatically Drops Selected Item",
    Default = false,
    Callback = function(adsi)
        autoDropEnabled = adsi
    end
})
  
Tabs.wr:AddButton({
    Title = "Reload Chunks",
    Description = "Reloads Chunks",
    Callback = function()
        ReloadChunk()
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

local nktog = Tabs.wr:AddToggle("Nuker", {
    Title = "Nuker", 
    Description = "Breaks blocks below you",
    Default = false,
    Callback = function(n)
        nukerEnabled = n
    end 
})
  
local nk3tog = Tabs.wr:AddToggle("Nuker3", {
    Title = "Nuker 3x3", 
    Description = "Breaks blocks around you in a 3³ area",
    Default = false,
    Callback = function(n3)
        nuker3Enabled = n3
    end
})

local nk5tog = Tabs.wr:AddToggle("Nuker5", {
    Title = "Nuker 5x5", 
    Description = "Breaks blocks below you",
    Default = false,
    Callback = function(n5)
        nuker5Enabled = n5
	end
})
  
local ScaffoldToggle = Tabs.wr:AddToggle("Scaffold", {
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

local Scaffold3Toggle = Tabs.wr:AddToggle("Scaffold3", {
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
			_G.CoordsChannel = game.Players.LocalPlayer.PlayerGui.HUDGui.DataFrame.Coord:GetPropertyChangedSignal("Text"):Connect(function()
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

                local positions = {}
                for ox = -1, 1 do
                    for oz = -1, 1 do
                        positions[#positions + 1] = {x + ox, y, z + oz}
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

local HighwayToggleX = Tabs.wr:AddToggle("HighwayBuilder", {
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

            _G.CoordsChannel = game.Players.LocalPlayer.PlayerGui.HUDGui.DataFrame.Coord:GetPropertyChangedSignal("Text"):Connect(function()
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

				local positions = {}
				for ox = -2, 2 do
					positions[#positions + 1] = {x + ox, y, z}
					if ox == -2 or ox == 2 then
						positions[#positions + 1] = {x + ox, y + 1, z}
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
				
			_G.CoordsChannel = game.Players.LocalPlayer.PlayerGui.HUDGui.DataFrame.Coords:GetPropertyChangedSignal("Text"):Connect(function()
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

				local coordText = lp.PlayerGui.HUDGui.DataFrame.Coords.Text
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

local Toggle = Tabs.dt:AddToggle("Toggle", {
    Title = "Auto Dupe Entire Chest", 
    Description = "Automatically dupes entire chest",
    Default = false,
    Callback = function(a2)
        autoDupeEnabled = a2
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
        Numeric = false,
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
    Title = "Load Minerscraft (DISCONTINUED)",
    Description = "Loads ByteHub for Minerscraft\nTHIS SCRIPT HAS BEEN DISCONTINUED AND WILL NO LONGER\nBE UPDATED",
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

Tabs.tp:AddButton({
    Title = "Vanilla Texture Pack",
    Description = "Replaces texture with Minecraft ones",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/bytehub/refs/heads/main/realtexturepack.lua"))()
		ReloadChunk()
    end
})

local kadelay = Tabs.st:AddInput("Input", {
    Title = "Kill Aura Delay",
    Description = "Seconds between each hit (Default: 0)",
    Default = "0",
    Placeholder = "Enter a number",
    Numeric = false,
    Finished = false,
    Callback = function(zi)
        local newDelay = tonumber(zi)
        if newDelay then
            _G.delay = newDelay 
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
    Numeric = false,
    Finished = false,
    Callback = function(tad)
        local newRadius = tonumber(tad)
        if newRadius then
            _G.radius = newRadius
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
    Numeric = false,
    Finished = false,
    Callback = function(tas)
        local newSpeed = tonumber(tas)
        if newSpeed then
            _G.speed = newSpeed
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

local tbdelay = Tabs.st:AddInput("Input", {
    Title = "Triggerbot Delay",
    Description = "Seconds between each hit (Default: 0)",
    Default = "0",
    Placeholder = "Enter a number",
    Numeric = false,
    Finished = false,
    Callback = function(zi)
        local newDelay2 = tonumber(zi)
        if newDelay2 then
            _G.tbdelay = newDelay2 
            Fluent:Notify({
                Title = "Success!",
                Content = "Successfully edited delay",
                SubContent = "Delay: " .. newDelay2,
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

local npval = Tabs.st:AddInput("Input", {
    Title = "Name Protect Name",
    Description = "Replaces the name u get when you enable Name Protect (Default: Protected)",
    Default = "0",
    Placeholder = "Enter a name",
    Numeric = false,
    Finished = false,
    Callback = function(ni)
        local newName = ni
        if newName then
            nameProtDefVal = newName 
            Fluent:Notify({
                Title = "Success!",
                Content = "Successfully edited name",
                SubContent = "Delay: " .. newName,
                Duration = 3
            })
        else
            Fluent:Notify({
                Title = "Error",
                Content = "Invalid Name:" .. zi,
                SubContent = "Please enter a valid name.",
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
    Numeric = false,
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
  
local afktog = Tabs.st:AddToggle("Toggle", {
    Title = "Anti AFK", 
    Description = "Disables disconnection due to idling.",
    Default = false,
    Callback = function(aafk)
        afk = aafk
		if afk then
			for i,v in pairs(getconnections(game:GetService("Players").LocalPlayer.Idled)) do
			    v:Disable()
			end
		else
			for i,v in pairs(getconnections(game:GetService("Players").LocalPlayer.Idled)) do
			    v:Enable()
			end
		end
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
