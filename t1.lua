local Library = loadstring(game:HttpGet("https://pastebin.com/raw/vff1bQ9F"))()
local Window = Library.CreateLib("Minecraft", getgenv().Theme)

function KillAura()
  spawn(function()
    while ka and task.wait() do
      for i,v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer and v.Character and game.Players.LocalPlayer:DistanceFromCharacter(v.Character.HumanoidRootPart.Position) < 16 then
          game.ReplicatedStorage.GameRemotes.Attack:InvokeServer(v.Character)
        end
      end
      for i,v in pairs(game:GetService("Workspace").Animals:GetChildren()) do
        if v:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer:DistanceFromCharacter(v.HumanoidRootPart.Position) < 16 then
          game.ReplicatedStorage.GameRemotes.AttackMob:InvokeServer(v)
        end
      end
      wait()
    end
  end)
end

function ChestESP()
  if ce then
    spawn(function()
      while ce and task.wait() do
        local parentFolder = workspace.Blocks

        local function checkFolderForChildParts(folder)
          local childParts = {}
          local children = folder:GetChildren()
          for _, child in pairs(children) do
            if child.Name == "Chest" then
              table.insert(childParts, child)
            end
          end
          return childParts
        end

        local function outlinePart(part)
          if not part:FindFirstChild("CHEST_out") then
            local a = Instance.new("BoxHandleAdornment")
            a.Name = "CHEST_out"
            a.Parent = part
            a.Adornee = part
            a.AlwaysOnTop = true
            a.ZIndex = 0
            a.Size = part.Size
            a.Transparency = 0.3
            a.Color = BrickColor.new("Bright orange")
          end
        end

        local function iterateAndCheckFolders(parent)
          for _, folder in pairs(parent:GetChildren()) do
            if folder:IsA("Folder") then
              local childParts = checkFolderForChildParts(folder)
              for _, childPart in ipairs(childParts) do
                outlinePart(childPart)
              end
              iterateAndCheckFolders(folder)
            end
          end
        end

        iterateAndCheckFolders(parentFolder)
        wait()
      end
    end)
  else
    for _, part in ipairs(workspace:GetDescendants()) do
      if part:FindFirstChild("CHEST_out") then
        part.CHEST_out:Destroy()
      end
    end
  end
end

local ct = Window:NewTab("Credits")
local Credits = ct:NewSection("Credits")

Credits:NewLabel("Made by PurpleApple#9562/@inconsistenttutorialuploader")
Credits:NewLabel("Byte Hub (Minecraft)")
Credits:NewLabel("Version 1.9 (Kavo UI Theme)")
Credits:NewLabel("Made the script open source")

local Combat = Window:NewTab("Combat")
local cs = Combat:NewSection("Combat")

cs:NewToggle("KillAura", "Kills players around you within a certain radius", function(k)
  ka = k
  KillAura(k)
end)

local cl = Combat:NewSection("Clients")

cl:NewButton("Arcade Recode Client", "Launches the Arcade Client", function()
  loadstring(game:HttpGet("https://pastebin.com/raw/b0m8gUaP",true))()
end)

cl:NewButton("Dizzy Hub", "Launches Dizzy Hub", function()
  loadstring(game:HttpGet("https://raw.githubusercontent.com/dizyhvh/rbx_scripts/main/dizzy_hub/scripts/minerscave_15.lua",true))()
end)

local lp = Window:NewTab("Movement")
local mm = lp:NewSection("Credits")

mm:NewButton("No Fall Damage", "Removes Fall Damage", function()
  game.ReplicatedStorage.GameRemotes.Demo:Destroy()
end)

local vs = Window:NewTab("Visuals")
local vs2 = vs:NewSection("ESP")

vs2:NewToggle("Chest ESP", "See chests through blocks", function(c)
  ce = c
  ChestESP(c)
end)

vs2:NewButton("Watermark", "Adds the Byte Hub watermark", function()
  loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/sidescripts/main/Watermark.lua",true))()
end)

vs2:NewButton("Player Esp (Press B)", "Player ESP", function()
  loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-FE-ESP-1174",true))()
end)

vs2:NewButton("Esp Button", "Button that presses B for ESP", function()
  loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-FE-ESP-1174",true))()
end)

local dp = Window:NewTab("Dupe")
local dt = vs:NewSection("Dupes")
dt:NewButton("Dupe First Slot (Press Z)", "Dupes the first chest slot if you press Z", function()
  loadstring(game:HttpGet("https://pastebin.com/raw/TkAm8wV8",true))()
end)
local dg = vs:NewSection("Dupe GUI")
dt:NewButton("Dupe GUI", "Loads Argentum Exploitz GUI", function()
  loadstring(game:HttpGet("https://gist.githubusercontent.com/raw/b8d379c1e296ade8305c2fe4df652537"))()
end)

local ts = Window:NewTab("Themes")
local th = ts:NewSection("Themes")
th:NewButton("Revert to Original UI", "Reverts to Orion Lib", function()
  loadstring(game:HttpGet("https://raw.githubusercontent.com/screengui/bytehub/main/minerscave.lua",true))()
  task.wait()
end)
