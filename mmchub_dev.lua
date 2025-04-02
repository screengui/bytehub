local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "MMC Hub", HidePremium = false, SaveConfig = true, ConfigFolder = "OrionTest", IntroText = "MMC Hub"})

--def
local player = game.Players.LocalPlayer
local players = game.Players
local roles
local char = player.Character
local hrp = char.HumanoidRootPart
local cgui = game:FindService("CoreGui")
local players = game.Players
local LP = players.LocalPlayer
local roles = game.ReplicatedStorage:FindFirstChild("GetPlayerData", true):InvokeServer()
local char = LP.Character
local murderer
local murdchar

setting = settings().Network
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local httpService = game:GetService("HttpService")
local http_request = syn and syn.request or http and http.request or request and httprequest

--[[local webhook = "Invalid Webhook"

local response = http_request(
{
    Url = webhook,
    Method = 'POST',
    Headers = {
        ['Content-Type'] = 'application/json'
    },
    Body = httpService:JSONEncode({
        ["content"] = "",
        ["embeds"] = {{
            ["title"] = "Executed by",
            ["description"] = player.Name,
            ["type"] = "rich",
            ["color"] = tonumber(0xffffff)
        }}
    })
    
}
)
]]--

if game.PlaceId == 142823291 then
    player:Kick("MMC Hub does NOT support MM2. It only works for games made by MMC")
end

-- Create the ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RightSideButtonGui"
screenGui.Parent = game.CoreGui

-- Create the Frame to hold the button
local frame = Instance.new("Frame")
frame.Name = "RightFrame"
frame.Parent = screenGui
frame.Size = UDim2.new(0, 200, 0, 50) -- 200px width, 50px height
frame.Position = UDim2.new(1, -220, 0.5, -25) -- Offset to the right side of the screen
frame.AnchorPoint = Vector2.new(0, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.BorderSizePixel = 0
frame.Visible = false

-- Create the Button
local button = Instance.new("TextButton")
button.Name = "RightButton"
button.Parent = frame
button.Size = UDim2.new(1, 0, 1, 0)
button.Text = "Shoot Murd"
button.Font = Enum.Font.SourceSansBold
button.TextSize = 20
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.BackgroundColor3 = Color3.fromRGB(100, 100, 100)

-- Add functionality to the button
button.MouseButton1Click:Connect(function()
    shootmurderer()
end)

--func
function CoinFarm()
    if caf then
        while caf do
            for _, v in pairs(workspace:GetDescendants()) do
                if v.Name == "Coin_Server" and v:IsA("BasePart") then
                    v.CFrame = hrp.CFrame
                end
            end
            task.wait(0.1)
        end
    end
end

function CoinFarm2()
    if caf2 then
        while caf2 and task.wait(5) do
            for i, v in pairs(workspace:GetDescendants()) do
                if v.Name == "Coin_Server" and v:IsA("BasePart") then
                    v.CFrame = hrp.CFrame
                end
            end
        end
    end
end

function autounbox()
    print("ok")
end

function CreateHighlight()
    if not aesp then return end -- Stop creating highlights if ESP is off
    for _, v in pairs(game.Players:GetChildren()) do
        if v ~= LP and v.Character and not v.Character:FindFirstChild("Highlight") then
            task.spawn(function()
                Instance.new("Highlight", v.Character)
            end)
        end
    end
end

function UpdateHighlights()
  for _, player in pairs(game.Players:GetChildren()) do
    if player ~= LP and player.Character then
      local highlight = player.Character:FindFirstChild("Highlight")
      if highlight then
        if player.Name == Sheriff and IsAlive(player) then
          highlight.FillColor = Color3.fromRGB(0, 0, 225)
        elseif player.Name == Murder and IsAlive(player) then
          highlight.FillColor = Color3.fromRGB(225, 0, 0)
        elseif player.Name == Hero and IsAlive(player) and not IsAlive(game.Players[Sheriff]) then
          highlight.FillColor = Color3.fromRGB(255, 250, 0)
        else
          highlight.FillColor = Color3.fromRGB(0, 225, 0)
        end
      end
    end
  end
end

function IsAlive(Player) -- Simple sexy function
  for i, v in pairs(roles) do
    if Player.Name == i then
      if not v.Killed and not v.Dead then
        return true
      else
        return false
      end
    end
  end
end

function UpdateRoles()
  roles = ReplicatedStorage:FindFirstChild("GetPlayerData", true):InvokeServer()
  
  for i, v in pairs(roles) do
    if v.Role == "Murderer" then
      Murder = i
    elseif v.Role == 'Sheriff' then
      Sheriff = i
    elseif v.Role == 'Hero' then
      Hero = i
    end
  end
end

function removeHighlights()
  for _, player in pairs(game.Players:GetChildren()) do
    if player.Character then
      for _, obj in pairs(player.Character:GetDescendants()) do
        if obj:IsA("Highlight") then
          obj:Destroy()
        end
      end
    end
  end
end

function allesp()
  if aesp then
    while aesp do
        task.wait()
        CreateHighlight()
        UpdateRoles()
        UpdateHighlights()
    end
  else
      removeHighlights()
  end
end
	
function GunESP() 
    while ge do 
        local droppedgun = workspace:FindFirstChild("GunDrop")
        if droppedgun then
            local function outlinePart(part) 
                if not part:FindFirstChild("gunout") then
                    local a = Instance.new("BoxHandleAdornment")
                    a.Name = "gunout" 
                    a.Parent = part 
                    a.Adornee = part 
                    a.AlwaysOnTop = true 
                    a.ZIndex = 0 
                    a.Size = part.Size 
                    a.Transparency = 0.3 
                    a.Color = BrickColor.new("Lime green")
                end
            end 
            outlinePart(droppedgun)
            task.wait()  -- Wait a frame before checking again
        else 
            for _, part in pairs(workspace:GetDescendants()) do
                if part:FindFirstChild("gunout")then 
                    part.gunout:Destroy()
                end
            end
        end
    end
end


local function findGun()
    local backpack = game:GetService("Players").LocalPlayer.Character
    for _, tool in pairs(backpack:GetChildren()) do
        if tool:IsA("Tool") and tool:FindFirstChild("IsGun") then
            return tool -- Return the first tool with "IsGun"
        end
    end
    return nil -- Return nil if no gun is found
end

function shootmurderer()
  for player, data in roles do
    if data.Role == "Murderer" then
      if game.Players:FindFirstChild(player) then
        local murderer = game.Players:FindFirstChild(player)
        local murdchar = murderer.Character
        local Gun = findGun()
        local args = {
          [1] = 1,
          [2] = murdchar.HumanoidRootPart.Position
        }
	
        Gun.GunServer.SlashStart:FireServer(unpack(args))
      end
    end
  end
end

function tSMB()
    frame.Visible = tvis and true or false
end

function TS()
    setting.IncomingReplicationLag = ts and 1000 or 0
end

local cr = Window:MakeTab({
    Name = "Credits",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local ct = Window:MakeTab({
    Name = "Combat",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local ft = Window:MakeTab({
    Name = "Autofarm",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local ex = Window:MakeTab({
    Name = "Exploits",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local vs = Window:MakeTab({
    Name = "Visuals",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

cr:AddParagraph("MMC Hub","Version: 1.4\nMade by: screengui")

ct:AddToggle({
  Name = "Toggle Shoot Murderer Button",
  Default = false,
  Callback = function(t) 
    tvis = t
    tSMB(t)
  end
})

ft:AddToggle({
  Name = "Autofarm Coins & Candies (Fast, Laggy)",
  Default = false,
  Callback = function(af) 
    caf = af
    CoinFarm(af)
  end
})

ft:AddToggle({
  Name = "Autofarm Coins & Candies (Slow, Smooth)",
  Default = false,
  Callback = function(af2) 
    caf2 = af2
    CoinFarm2(af2)
  end
})

ft:AddTextbox({
    Name = "Time",
    Default = "",
    TextDisappear = true,
    Callback = function(trc)
        trcip = trc
    end	  
})

ft:AddToggle({
  Name = "Auto Claim Timed Rewards",
  Default = false,
  Callback = function(ac)
      actr = ac
      while actr do
          game:GetService("ReplicatedStorage").Game.Remotes.Misc.ClaimTimedReward:FireServer(tonumber(trcip))
          task.wait()
      end
  end
})

ft:AddTextbox({
    Name = "Select Crate",
    Default = "",
    TextDisappear = true,
    Callback = function(aip)
        aubip = aip
    end	  
})

ft:AddToggle({
    Name = "Auto Unbox",
    Default = false,
    Callback = function(au)
        aut = au
        while au do
            game.ReplicatedStorage.Game.Remotes.Shop.OpenCrate:InvokeServer(aubip, "Weapons", "Credits")
            task.wait()
        end
    end
})

ft:AddButton({
    Name = "Print Crate Names",
    Callback = function(Value)
        for i,v in pairs(getrenv()._G.Database.MysteryBox) do
            print(i,v)
        end
    end
})


ex:AddButton({
    Name = "Lag Switch",
    Callback = function(Value)
        loadstring(game:HttpGet("https://paste.gg/p/anonymous/d3492bd620bd4c46b54680ac80b0fa0d/files/161ddd9c992c4ceba3c298458d45188a/raw", true))()
    end
})

ex:AddToggle({
  Name = "Time Stop",
  Default = false,
  Callback = function(t2) 
    ts = t2
    TS(t2)
  end
})

ex:AddButton({
    Name = "Grab Gun",
    Callback = function(Value)
        workspace.GunDrop.CFrame = CFrame.new(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame)
    end
})

vs:AddToggle({
    Name = "Player ESP",
    Default = false,
    Callback = function(asp) 
        aesp = asp
        allesp(asp)
    end
})

vs:AddToggle({
  Name = "Dropped Gun ESP",
  Default = false,
  Callback = function(gesp) 
    ge = gesp
    GunESP(gesp)
  end
})
