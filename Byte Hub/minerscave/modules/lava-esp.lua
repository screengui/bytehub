local Workspace = game:GetService("Workspace")

local LavaESP = {}

local running = false
local loopThread

local function findLava()
    local lavaBlocks = {}

    local fluid = Workspace:FindFirstChild("Fluid")
    if not fluid then return lavaBlocks end

    for _, folder in ipairs(fluid:GetChildren()) do
        if folder:IsA("Folder") then
            for _, item in ipairs(folder:GetChildren()) do
                if item.Name == "Lava" and item:IsA("BasePart") then
                    table.insert(lavaBlocks, item)
                end
            end
        end
    end

    return lavaBlocks
end

local function outlinePart(part)
    if part:FindFirstChild("LavaESP_Adornment") then return end

    local adorn = Instance.new("BoxHandleAdornment")
    adorn.Name = "LavaESP_Adornment"
    adorn.Adornee = part
    adorn.AlwaysOnTop = true
    adorn.ZIndex = 0
    adorn.Size = part.Size
    adorn.Transparency = 0.5
    adorn.Color = BrickColor.new("Deep orange")
    adorn.Parent = part
end

local function clearESP()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        local adorn = obj:FindFirstChild("LavaESP_Adornment")
        if adorn then
            adorn:Destroy()
        end
    end
end

local function lavaLoop()
    while running do
        for _, part in ipairs(findLava()) do
            outlinePart(part)
        end
        task.wait()
    end

    clearESP()
end

function LavaESP.start()
    if running then return end
    running = true
    loopThread = task.spawn(lavaLoop)
end

function LavaESP.stop()
    running = false
end

return LavaESP
