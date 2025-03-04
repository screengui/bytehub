local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/bytehub/refs/heads/main/ByteHubOrion.lua",true))()
lib.SelectedTheme = "ByteHub"
local Window = lib:MakeWindow({Name = "Clickers Hub Loader", HidePremium = false, SaveConfig = true, ConfigFolder = "OrionTest", IntroText = "Clickers Hub", IntroIcon = "rbxassetid://18371225897"})

local sg = Window:MakeTab({
  Name = "Supported Games",
  Icon = "rbxassetid://18407871907",
  PremiumOnly = false
})

local mt = Window:MakeTab({
  Name = "Main",
  Icon = "rbxassetid://18371225897",
  PremiumOnly = false
})

local status = "Unsupported"

if game.PlaceId == 9600578307 then -- Pet Clicks Simulator X
  status = "Supported"
  sg:AddButton({
    Name = "Pet Clicks Simulator X",
    Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/bytehub/refs/heads/main/Clickers%20Hub/Pet%20Clicks%20Simulator%20X.lua",true))()
    end
  })
elseif game.PlaceId == 17003365237 then -- Lebron Clicker
  status = "Supported"
  sg:AddButton({
    Name = "Pet Clicks Simulator X",
    Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/bytehub/refs/heads/main/Clickers%20Hub/Lebron%20Clicker.lua",true))()
    end
  })
elseif game.PlaceId == 5098929086 then -- TAPPING SIMULATOR
  status = "Supported"
  sg:AddButton({
    Name = "TAPPING SIMULATOR",
    Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/bytehub/refs/heads/main/Clickers%20Hub/TAPPING%20SIMULATOR.lua",true))()
    end
  })
end

sg:AddButton({
  Name = "Pet Clicks Simulator X",
  Callback = function()
    setclipboard(9600578307)
    
    lib:MakeNotification({
      Name = "Copied to clipboard.",
      Content = "Successfully copied Place ID to clipboard!",
      Image = "rbxassetid://4483345998",
      Time = 5
    })
  end
})

sg:AddButton({
  Name = "Lebron Clicker",
  Callback = function()
    setclipboard(17003365237)
    
    lib:MakeNotification({
      Name = "Copied to clipboard.",
      Content = "Successfully copied Place ID to clipboard!",
      Image = "rbxassetid://4483345998",
      Time = 5
    })
  end
})

sg:AddButton({
  Name = "TAPPING SIMULATOR",
  Callback = function()
    setclipboard(5098929086)
    
    lib:MakeNotification({
      Name = "Copied to clipboard.",
      Content = "Successfully copied Place ID to clipboard!",
      Image = "rbxassetid://4483345998",
      Time = 5
    })
  end
})

mt:AddLabel("Status: " .. status .. " | " .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name)
