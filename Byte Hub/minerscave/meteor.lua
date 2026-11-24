local meteorlib = "https://raw.githubusercontent.com/screengui/bytehub/refs/heads/main/Byte%20Hub/assets/ui/meteor-library.lua"

if not shared.GuiLibrary then
    loadstring(game:HttpGet(meteorlib, true))()
end

local GuiLibrary = shared.GuiLibrary
assert(GuiLibrary, "Meteor UI Library failed to load")

local selectedTargeting = "lowest"
local delay = 0

local function getLowestHealthNearbyPlayer()
    local lowestHealth = math.huge
    local targetPlayer = nil
    
    local localHRP = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not localHRP then return nil end
    
    for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
        if player ~= game.Players.LocalPlayer and player.Character then
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
    local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
        if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (hrp.Position - player.Character.HumanoidRootPart.Position).Magnitude
            if dist < shortest then
                shortest = dist
                closest = player
            end
        end
    end
    return closest
end

GuiLibrary:CreateWindow("Main")
GuiLibrary:CreateWindow("Combat")
GuiLibrary:CreateWindow("Movement")
GuiLibrary:CreateWindow("Player")
GuiLibrary:CreateWindow("Render")
GuiLibrary:CreateWindow("Extra")

GuiLibrary.Windows.Combat:SetVisible(false)
GuiLibrary.Windows.Movement:SetVisible(false)
GuiLibrary.Windows.Player:SetVisible(false)
GuiLibrary.Windows.Render:SetVisible(false)
GuiLibrary.Windows.Extra:SetVisible(false)

local function categoryToggle(windowName)
    return GuiLibrary.Windows.Main:CreateModule({
        Name = windowName,
        Description = "Shows the " .. windowName .. " window.",
        Array = false,
        SkipSearch = true,
        Function = function(state)
            local window = GuiLibrary.Windows[windowName]
            if window then
                window:SetVisible(state)
            end
        end
    })
end
    
categoryToggle("Combat")
categoryToggle("Movement")
categoryToggle("Player")
categoryToggle("Render")
categoryToggle("Extra")

local KillAura = GuiLibrary.Windows.Combat:CreateModule({
    Name = "KillAura",
    Description = "Attacks entities around you.",
    Function = function(state)
        ka = state
        local function attackLoop()
            while ka do
                local lpChar = game.Players.LocalPlayer.Character
                local lpHRP = lpChar and lpChar:FindFirstChild("HumanoidRootPart")
                if lpHRP then
                    local target = selectedTargeting == "lowest" and getLowestHealthNearbyPlayer() or getClosestPlayer()
                    if target and target.Character then
                        local tHRP = target.Character:FindFirstChild("HumanoidRootPart")
                        if tHRP then
                            local d = lpHRP.Position - tHRP.Position
                            if (d.X*d.X + d.Z*d.Z) <= RANGE_SQ then
                                game.ReplicatedStorage.GameRemotes.Attack:InvokeServer(target.Character)
                            end
                        end
                    end
                end
                task.wait(delay)
            end
        end
        if ka then
            task.spawn(attackLoop)
        end
    end
})

KillAura:CreatePicker({
    Name = "Targeting Method",
    Options = { "lowest", "closest" },
    Default = "lowest",
    Function = function(Value)
        selectedTargeting = Options.Value
    end
})

KillAura:CreateSlider({ Name = "Delay", Min = 0, Max = 3, Default = 0, Decimals = 0.1 })
