local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

local XRay = {}

local wasEnabled = false

local function setTransparency(value)
    -- MetaBlocks textures
    for _, v in pairs(ReplicatedFirst.MetaBlocks:GetChildren()) do
        if v.Name == "Stone" or v.Name == "Dirt" then
            for _, texture in pairs(v:GetChildren()) do
                texture.Transparency = value
            end
        end
    end

    -- Physical blocks
    for _, v in pairs(ReplicatedFirst.Blocks:GetChildren()) do
        if v.Name == "Stone" or v.Name == "Dirt" then
            v.Transparency = value
        end
    end
end

local function refreshCharacter()
    local character = Players.LocalPlayer.Character
    if not character then return end

    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local pos = hrp.Position
    task.wait()
    hrp.CFrame = CFrame.new(30000, 180, 30000)
    task.wait()
    hrp.CFrame = CFrame.new(pos)
end

function XRay.start()
    wasEnabled = true
    setTransparency(1)
    refreshCharacter()
end

function XRay.stop()
    setTransparency(0)

    if wasEnabled then
        refreshCharacter()
        wasEnabled = false
    end
end

return XRay
