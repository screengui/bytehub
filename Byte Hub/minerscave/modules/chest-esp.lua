local Workspace = game:GetService("Workspace")

local ChestESP = {}

local running = false
local loopThread

local function findChestParts()
    local parts = {}

    local blocks = Workspace:FindFirstChild("Blocks")
    if not blocks then return parts end

    for _, folder in pairs(blocks:GetChildren()) do
        if folder:IsA("Folder") then
            for _, item in pairs(folder:GetChildren()) do
                if item.Name == "Chest" and item:IsA("BasePart") then
                    table.insert(parts, item)
                end
            end
        end
    end

    return parts
end

local function outlinePart(part)
    if part:FindFirstChild("ChestESP_Adornment") then return end

    local adorn = Instance.new("BoxHandleAdornment")
    adorn.Name = "ChestESP_Adornment"
    adorn.Adornee = part
    adorn.AlwaysOnTop = true
    adorn.ZIndex = 0
    adorn.Size = part.Size
    adorn.Transparency = 0.5
    adorn.Color = BrickColor.new("Bright orange")
    adorn.Parent = part
end

local function clearESP()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        local adorn = obj:FindFirstChild("ChestESP_Adornment")
        if adorn then
            adorn:Destroy()
        end
    end
end

local function chestLoop()
    while running do
        for _, part in ipairs(findChestParts()) do
            outlinePart(part)
        end
        task.wait(1)
    end

    clearESP()
end

function ChestESP.start()
    if running then return end
    running = true
    loopThread = task.spawn(chestLoop)
end

function ChestESP.stop()
    running = false
end

return ChestESP
