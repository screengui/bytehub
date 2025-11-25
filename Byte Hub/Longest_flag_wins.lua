local version = "v1.1"
local Luna = loadstring(game:HttpGet("https://raw.nebulasoftworks.xyz/luna", true))()
local Window = Luna:CreateWindow({
    Name = "Longest flag wins",
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
    Content = "Thank you for using Byte Hub!"
})

--==VARIABLES==--
local folder = game:GetService("Players").LocalPlayer.PlayerGui.Selector.Frame.Buttons
local lp = game.Players.LocalPlayer
local country = game:GetService("Players").LocalPlayer.Country

--==TABS==--
local Main = Window:CreateTab({
    Name = "Exploits",
    Icon = "view_in_ar",
    ImageSource = "Material",
    ShowTitle = true
})

local AnswerToggle = Main:CreateToggle({
    Name = "Auto Answer",
    Description = nil,
    CurrentValue = false,
    Callback = function(ans)
       		aans = ans
       		while aans do
            local longestName = ""
            for _, descendant in ipairs(folder:GetDescendants()) do
                if not descendant:IsA("UIGridLayout") and not descendant:IsA("UICorner") and not descendant:IsA("UIStroke") and not descendant:IsA("Frame") and #descendant.Name > #longestName then
                		   longestName = descendant.Name
                end
            end
       				   wait(1)
          
            local args = {
                [1] = longestName
            }
          
            game:GetService("ReplicatedStorage").Remotes.SendAnswer:FireServer(unpack(args))
        end
    end
}, "AnswerToggle")

local DiamondToggle = Main:CreateToggle({
    Name = "Auto Farm Diamonds",
    Description = nil,
    CurrentValue = false,
    Callback = function(af)
       		while af and wait() do
       		    local hrp = lp.Character.HumanoidRootPart
       		    for _, v in pairs(workspace:GetDescendants()) do
       		        if v.Name == "Diamond" and v:IsA("BasePart") then
       		            v.CFrame = hrp.CFrame
       		        end
       		    end
       		end
    end
}, "DiamondToggle")

local ChatTag = Main:CreateInput({
    Name = "Custom Chat Tag",
    Description = nil,
    PlaceholderText = "",
    CurrentValue = "",
    Numeric = false,
    MaxCharacters = nil, 
    Enter = false, 
    Callback = function(Text)
        country.Value = Text
    end
}, "ChatTag")
