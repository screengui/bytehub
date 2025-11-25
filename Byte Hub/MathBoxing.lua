local version = "v1.1"
local Luna = loadstring(game:HttpGet("https://raw.nebulasoftworks.xyz/luna", true))()
local Window = Luna:CreateWindow({
    Name = "Math Boxing",
    Subtitle = "Byte Hub " .. version,
    LogoID = "6031097225",
    LoadingEnabled = true,
    LoadingTitle = "Byte Hub",
    LoadingSubtitle = "by Purple Apple",
    KeySystem = false,
    KeySettings = {
        Title = "Luna Example Key",
        Subtitle = "Key System",
        Note = "Please Enter Your Key To Use Example Hub",
        FileName = "Key", -- the name of the key file. this will be saved in ur RootFolder. However, if you don't have one, it'll save in ur config folder instead
        SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
        Key = {"Example Key"} -- List of keys that will be accepted by the system, please use a system like Pelican or Luarmor that provide key strings based on your HWID since putting a simple string is very easy to bypass
    }
})

Luna:Notification({ 
    Title = "Welcome, " .. game.Players.LocalPlayer.Name,
    Icon = "sparkle",
    ImageSource = "Material",
    Content = "Thank you for using Byte Hub! Credits to OuterTrees."
})

--==VARIABLES==--
_G.AF = 'N'
wait()
_G.AF = 'Y'
local lp = game.Players.LocalPlayer
local ring
local answering = game.ReplicatedStorage.Events.Answer
local rs = game:GetService("RunService")
local oldText, expression, prompt = ''
local pos = 0
local cai

--==TABS==--
local Main = Window:CreateTab({
    Name = "Exploits",
    Icon = "stars",
    ImageSource = "Material",
    ShowTitle = true
})

local AnswerToggle = Main:CreateToggle({
    Name = "Auto Answer",
    Description = nil,
    CurrentValue = false,
    Callback = function(ans)
        while ans and wait() do
            ring = nil
            for _, v in pairs(workspace:GetChildren()) do
                if v.Name == "Ring" then
                    if v.Player1.Value == lp or v.Player2.Value == lp then
                        ring = v
                        break
                    end
                end
            end
            if ring ~= nil then
                prompt = ring.Prompt.BillboardGui.TextLabel.Text
                if oldText ~= prompt and prompt:find("?") then
                    expression = prompt:gsub("%s+", ""):gsub("=%?", "")
                    
                    pos = expression:find("+")
                    if pos then
                        answering:FireServer(tonumber(expression:sub(1, pos - 1)) + tonumber(expression:sub(pos + 1)))
                    else
                        pos = expression:find("x")
                        answering:FireServer(tonumber(expression:sub(1, pos - 1)) * tonumber(expression:sub(pos + 1)))
                    end
				
                    oldText = prompt
                end
            end
            wait()
        end
    end
}, "AnswerToggle") 

local WrongAnswerToggle = Main:CreateToggle({
    Name = "Auto Wrong Answer",
    Description = nil,
    CurrentValue = false,
    Callback = function(wns)
        while wns do
            for i=0,9 do
                if not wns then break end
                answering:FireServer('')
            end
            rs.Stepped:Wait()
        end
    end
}, "WrongAnswerToggle") 

local CustomInput = Main:CreateInput({
    Name = "Custom Answer",
    Description = nil,
    PlaceholderText = "",
    CurrentValue = "", 
    Numeric = false, 
    MaxCharacters = nil, 
    Enter = false, 
    Callback = function(Text)
        cai = Text
    end
}, "CustomInput") 

local SendButton = Main:CreateButton({
    Name = "Send Custom Answer",
    Description = nil, 
    Callback = function()
        answering:FireServer(cai)
    end
})
