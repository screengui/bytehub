local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/bytehub/refs/heads/main/ByteHubOrion.lua",true))()
lib.SelectedTheme = "ByteHub"
local Window = lib:MakeWindow({Name = "TAPPING SIMULATOR", HidePremium = false, SaveConfig = true, ConfigFolder = "OrionTest", IntroText = "Clickers Hub", IntroIcon = "rbxassetid://18371225897"})

local sg = Window:MakeTab({
  Name = "Supported Games",
  Icon = "rbxassetid://18407871907",
  PremiumOnly = false
})

sg:AddButton({
  Name = "Execute Loader",
  Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/bytehub/refs/heads/main/Clickers%20Hub/Loader.lua",true))()
    
    lib:MakeNotification({
      Name = "Success!",
      Content = "Successfully executed loader!",
      Image = "rbxassetid://4483345998",
      Time = 5
    })
  end
})

local ft = Window:MakeTab({
  Name = "Auto Farm",
  Icon = "rbxassetid://18371225897",
  PremiumOnly = false
})

ft:AddToggle({
  Name = "Auto Clicker",
  Default = false,
  Callback = function(ac)
    a = ac
    while a do
      task.spawn(function()
        game:GetService("ReplicatedStorage").PlayerClick:FireServer(false)
      end)
      task.wait()
    end
  end
})
