local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/bytehub/refs/heads/main/ByteHubOrion.lua",true))()
OrionLib.SelectedTheme = "ByteHub"
local Window = OrionLib:MakeWindow({Name = "Longest flag wins (Byte Hub)", HidePremium = false, SaveConfig = true, ConfigFolder = "OrionTest", IntroText = "Byte Hub"})
OrionLib:MakeNotification({
	Name = "Credits",
	Content = "Script Executed",
	Image = "rbxassetid://4483345998",
	Time = 3
})

local folder = game:GetService("Players").LocalPlayer.PlayerGui.Selector.Frame.Buttons
local lp = game.Players.LocalPlayer
local country = game:GetService("Players").LocalPlayer.Country


function cf()
    while caf and wait() do
        local hrp = lp.Character.HumanoidRootPart
        for _, v in pairs(workspace:GetDescendants()) do
            if v.Name == "Diamond" and v:IsA("BasePart") then
                v.CFrame = hrp.CFrame
            end
        end
    end
end

local mn = Window:MakeTab({
    Name = "Exploits👨‍💻",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})



mn:AddToggle({
  Name = "Auto Answer✅",
  Default = false,
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
          
          print(longestName)
      end
  end
})

mn:AddToggle({
  Name = "Autofarm Diamonds",
  Default = false,
  Callback = function(af) 
    caf = af
    cf(af)
  end
})

mn:AddTextbox({
	Name = "Custom Chat Tag",
	Default = "default box input",
    TextDisappear = true,
    Callback = function(ai)
        cai = ai
    end	  
})

mn:AddButton({
    Name = "Set Chat Tag",
    Callback = function(Value)
        country.Value = cai
    end
})