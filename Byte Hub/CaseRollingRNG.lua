local gID = 128886701132186

if game.PlaceId ~= gID then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Wrong Game!";
        Text = "This script only works in Case Rolling RNG";
        Duration = 5;
    })
    return
end

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UserInputService,UIS = game:GetService("UserInputService"),game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local NetworkClient = game:GetService("NetworkClient")
local VirtualUser = game:GetService("VirtualUser")

local localPlayer = Players.LocalPlayer

local SCRIPT_VERSION = "v1.8"

-- Configs
local CONFIG_FILE = "ByteHub/CaseRollingRNG/KasumiHub_Config.json"
local SETTINGS_FILE = "ByteHub/CaseRollingRNG/KasumiHub_Settings.json"
local defaultConfig = {
    selectedCase = "Weapon Case",
    openInterval = 1000,
    animationSpeed = 1000,
    openAmount = 1,
    theme = "Dark",
    obbyInterval = 3000,
    antiAFKEnabled = false,
    autoReconnectEnabled = false,
    autoApplyAnimSpeed = true,
    autoApplyOpenInterval = true,
    autoTeleportZone9 = false,
    autoOpen = false,
    obbyEnabled = false
}

local defaultSettings = {
    autoLoadConfig = "None",
    autoLoadEnabled = false
}

local currentConfig = {}
local currentSettings = {}

-- Variables
local remotes = ReplicatedStorage:WaitForChild("Remotes")
local mainEvent = remotes:WaitForChild("MainEvent")

local settingsFolders = {
    localPlayer:FindFirstChild("SettingsFolder"),
    localPlayer:FindFirstChild("Settings"),
    localPlayer:FindFirstChild("PlayerSettings")
}

-- Case Variables
local autoOpen = false
local selectedCase = defaultConfig.selectedCase
local openAmount = 1
local openInterval = defaultConfig.openInterval
local caseDropdown = nil
local animationSpeedInput = nil
local intervalInput = nil

-- Library Variables
local themeDropdown = nil
local darkModeToggle = nil
local configFile = nil
local canChangeTheme = true
local canChangeDropdown = true
local Window = nil
local autoLoadDropdown = nil
local autoLoadToggle = nil
local ConfigNameInput = nil

-- Auto Farm variables
local obbyEnabled = false
local obbyInterval = 3000
local obbyIntervalInput = nil
local autoFarmActive = false

-- UI References for keybinds
local autoOpenToggle = nil
local autoFarmToggle = nil

-- Anti-AFK & Auto-Reconnect
local antiAFKEnabled = false
local antiAFKToggle = nil
local idledConnection = nil
local antiAFKLoop = nil

-- Auto-reconnect variables
local autoReconnectEnabled = false
local autoReconnectToggle = nil
local reconnectAttempts = 0
local MAX_RECONNECT_ATTEMPTS = 30
local RECONNECT_INTERVAL = 6
local lastDisconnectTime = 0
local lastPingTime = tick()
local consecutiveTimeouts = 0

local errorKeywords = {
    ["disconnect"] = true, ["connection"] = true, ["lost"] = true, 
    ["error"] = true, ["kicked"] = true, ["unable"] = true, 
    ["timeout"] = true, ["network"] = true, ["failed"] = true, ["id=17"] = true
}

-- Auto-apply animation speed
local autoApplyAnimSpeed = true
local autoApplyAnimSpeedToggle = nil
local lastAppliedAnimSpeed = nil
local cachedAnimValue = nil

-- Zone 9 Auto-Teleport
local autoTeleportZone9 = false
local autoTeleportZone9Toggle = nil
local zone9Coordinates = Vector3.new(-237, 5, 2376)

-- Obby coordinates
local obbyCoordinates = Vector3.new(160, 564, -845)

local availableCases = {
    "2013 Case", "2013 Winter Case", "2014 Summer Case", "2015 Cobblestone Collection",
    "Chroma Case", "Clutch Case", "Dreams & Nightmares Case", "Fever Case",
    "Fracture Case", "Free Case", "Gamma 2 Case", "Huntsman Weapon Case",
    "Katowice 2014 Challengers Capsule", "Katowice 2014 Legends Capsule",
    "Operation Bravo Case", "Operation Breakout Case", "Operation Hydra Case",
    "Prisma 2 Case", "Recoil Case", "Revolver Case", "St. Marc Collection",
    "VIP Case", "Weapon Case", "Weapon Case 3"
}

local function getCaseOpenSlots()
    for i = 1, #settingsFolders do
        local folder = settingsFolders[i]
        if folder then
            local slots = folder:FindFirstChild("Case Open Slots")
            if slots and slots:IsA("NumberValue") then
                return slots.Value
            end
        end
    end
    
    return 1
end

local function openCase(caseName, amount)
    if not mainEvent then return false end
    mainEvent:FireServer("OpenCase", caseName, amount)
    return true
end

local function teleportToObby()
    local character = localPlayer.Character
    if character and character.PrimaryPart then
        character:PivotTo(CFrame.new(obbyCoordinates + Vector3.new(0, 5, 0)))
        return true
    end
    return false
end

local function spamJump()
    task.spawn(function()
        while obbyEnabled do
            local character = localPlayer.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")

            if humanoid then
                if humanoid.FloorMaterial ~= Enum.Material.Air then
                    humanoid.Jump = true
                end
            end
            
            task.wait(0.2)
        end
    end)
end

local function teleportToZone9()
    local character = localPlayer.Character
    if character and character.PrimaryPart then
        character:PivotTo(CFrame.new(zone9Coordinates))
        return true
    end
    return false
end

local function startAntiAFK()
    if idledConnection then return end

    idledConnection = localPlayer.Idled:Connect(function()
        if antiAFKEnabled then
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())

            print("Anti-AFK: Prevented idle kick")
        end
    end)
end

local function performReconnect()
    if not autoReconnectEnabled or reconnectAttempts >= MAX_RECONNECT_ATTEMPTS then 
        return 
    end

    reconnectAttempts += 1
    local timeRemaining = (MAX_RECONNECT_ATTEMPTS - reconnectAttempts) * RECONNECT_INTERVAL
    print(string.format("Attempting Reconnect (%d/%d) - %ds remaining", reconnectAttempts, MAX_RECONNECT_ATTEMPTS, timeRemaining))

    task.wait(RECONNECT_INTERVAL)
    
    local success, err = pcall(function()
        TeleportService:Teleport(game.PlaceId, Players.LocalPlayer)
    end)
    
    if not success then
        warn("Teleport failed:", err)
    end
end

local function setupAutoReconnect()
    print("Auto-reconnect initialized...")

    local promptOverlay = CoreGui:WaitForChild("RobloxPromptGui"):WaitForChild("promptOverlay")
    promptOverlay.ChildAdded:Connect(function(child)
        if child.Name == "ErrorPrompt" then
            local messageArea = child:FindFirstChild("MessageArea")
            local errorText = messageArea and messageArea:FindFirstChild("ErrorMessage")
            
            if errorText then
                local text = errorText.Text:lower()
                for word in pairs(errorKeywords) do
                    if text:find(word) then
                        performReconnect()
                        break
                    end
                end
            end
        end
    end)
    
    task.spawn(function()
        while task.wait(15) do
            if autoReconnectEnabled then
                if not game:GetService("RunService"):IsRunning() or not Players.LocalPlayer:IsDescendantOf(game) then
                    performReconnect()
                    break
                end
            end
        end
    end)
end

local autoOpenActive = false

local function startAutoOpenLoop()
    if autoOpenActive then return end
    autoOpenActive = true
    
    task.spawn(function()
        print("Auto Open: Loop started")
        
        local interval = openInterval / 1000
        
        while autoOpen do
            local success = openCase(selectedCase, openAmount)
            
            if not success then
                task.wait(1) 
            end
            
            task.wait(math.max(openInterval / 1000, 0.03)) 
        end
        
        autoOpenActive = false
        print("Auto Open: Loop stopped")
    end)
end

local function startAutoFarmLoop()
    if autoFarmActive then return end
    autoFarmActive = true

    task.spawn(spamJump)
    task.spawn(function()
        print("Auto Farm: Loop started")

        while obbyEnabled do
            local success = teleportToObby()
            
            if not success then
                task.wait(1)
            end

            task.wait(math.max(obbyInterval / 1000, 0.03))
        end
        
        autoFarmActive = false
        print("Auto Farm: Loop stopped")
    end)
end

local function setupKeybinds()
    UIS.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end

        if input.KeyCode ~= Enum.KeyCode.R and input.KeyCode ~= Enum.KeyCode.F then return end
        
        local isCtrl = UIS:IsKeyDown(Enum.KeyCode.LeftControl) or UIS:IsKeyDown(Enum.KeyCode.RightControl)
        if not isCtrl then return end

        if input.KeyCode == Enum.KeyCode.R then
            autoOpen = not autoOpen
            updateToggleUI(autoOpenToggle, autoOpen)
            
            if autoOpen then
                startAutoOpenLoop()
            end
            
        elseif input.KeyCode == Enum.KeyCode.F then
            obbyEnabled = not obbyEnabled
            updateToggleUI(autoFarmToggle, obbyEnabled)
            
            if obbyEnabled then
                startAutoFarmLoop()
            end
        end
    end)
end

function updateToggleUI(toggle, value)
    if toggle and toggle.Set then
        pcall(toggle.Set, toggle, value)
    end
end

local function applyObbyInterval()
    local input = obbyIntervalInput
    if not input then return false end

    local rawVal = (input.Get and input:Get()) or input.Value or 0
    local num = tonumber(rawVal)

    if num and num > 0 then
        obbyInterval = num
        return true
    end
    
    return false
end

local function saveSettings()
    local settings = {
        autoLoadConfig = currentSettings.autoLoadConfig or defaultSettings.autoLoadConfig,
        autoLoadEnabled = currentSettings.autoLoadEnabled or defaultSettings.autoLoadEnabled
    }
    
    if not isfolder("ByteHub") then
        makefolder("ByteHub")
    end
    
    local success = pcall(function()
        writefile(SETTINGS_FILE, game:GetService("HttpService"):JSONEncode(settings))
    end)
    
    return success
end

local function loadSettings()
    local success, result = pcall(function()
        if isfile(SETTINGS_FILE) then
            local data = readfile(SETTINGS_FILE)
            return game:GetService("HttpService"):JSONDecode(data)
        end
        return nil
    end)
    
    if success and result then
        currentSettings = result
    else
        currentSettings = table.clone(defaultSettings)
        saveSettings()
    end
    
    return currentSettings
end

local function getAvailableConfigs()
    local configs = {"None"}
    local folderPath = "ByteHub/CaseRollingRNG"

    if not isfolder(folderPath) then 
        return configs 
    end

    local success, files = pcall(listfiles, folderPath)
    if not success or not files then return configs end

    for i = 1, #files do
        local file = files[i]
        if file:sub(-5):lower() == ".json" then
            local fileName = file:gsub(folderPath .. "/", ""):gsub(".json", "")
            if not fileName:find("Settings") and fileName ~= "KasumiHub_Settings" then
                table.insert(configs, fileName)
            end
        end
    end

    return configs
end

local function getNumberFromInput(input, default)
    if not input then return default end
    local raw = (input.Get and input:Get()) or input.Value
    return tonumber(raw) or default
end

local function saveConfig(customName)
    if not isfolder("ByteHub/CaseRollingRNG") then
        pcall(makefolder, "ByteHub/CaseRollingRNG")
    end

    local fileName = customName and ("ByteHub/CaseRollingRNG/" .. customName .. ".json") or CONFIG_FILE

    currentConfig = {
        selectedCase = selectedCase,
        openInterval = getNumberFromInput(intervalInput, 1000),
        animationSpeed = getNumberFromInput(animationSpeedInput, 1000),
        obbyInterval = getNumberFromInput(obbyIntervalInput, 3000),
        theme = WindUI:GetCurrentTheme() or "Dark",
        antiAFKEnabled = antiAFKEnabled,
        autoReconnectEnabled = autoReconnectEnabled,
        autoApplyAnimSpeed = autoApplyAnimSpeed,
        autoTeleportZone9 = autoTeleportZone9,
        autoOpen = autoOpen,
        obbyEnabled = obbyEnabled
    }

    local success, err = pcall(function()
        writefile(fileName, HttpService:JSONEncode(currentConfig))
    end)
    
    if success then
        WindUI:Notify({
            Title = "Config Saved",
            Content = "Configuration saved as: " .. (customName or "Default"),
            Duration = 3
        })
    else
        warn("Failed to save config: " .. tostring(err))
    end
    
    return success
end

local function loadConfig(configName)
    configName = configName or "KasumiHub_Config"
    local fileToLoad = nil
    local paths = {
        "ByteHub/CaseRollingRNG/" .. configName .. ".json",
        configName .. ".json",
        (configName == "KasumiHub_Config") and CONFIG_FILE or nil
    }

    for i = 1, #paths do
        local path = paths[i]
        if path and isfile(path) then
            fileToLoad = path
            break
        end
    end

    local loadedData = nil
    if fileToLoad then
        local success, result = pcall(function()
            return HttpService:JSONDecode(readfile(fileToLoad))
        end)
        if success then loadedData = result end
    end

    local source = loadedData or defaultConfig or {}
    currentConfig = source
    selectedCase = source.selectedCase or "Common Case"
    openInterval = source.openInterval or 1000
    obbyInterval = source.obbyInterval or 3000
    antiAFKEnabled = source.antiAFKEnabled or false
    autoReconnectEnabled = source.autoReconnectEnabled or false
    autoTeleportZone9 = source.autoTeleportZone9 or false
    autoOpen = source.autoOpen or false
    obbyEnabled = source.obbyEnabled or false
    
    if source.autoApplyAnimSpeed ~= nil then
        autoApplyAnimSpeed = source.autoApplyAnimSpeed
    else
        autoApplyAnimSpeed = true
    end

    return loadedData ~= nil
end

local function updateCaseDropdownProperly()
    if not caseDropdown then return end

    task.spawn(function()
        if not table.find(availableCases, selectedCase) then
            selectedCase = availableCases[1] or defaultConfig.selectedCase
        end

        task.wait(0.2)
        
        local success, err = pcall(function()
            if caseDropdown.Refresh then
                caseDropdown:Refresh(availableCases, true)
            end

            if caseDropdown.Set then
                caseDropdown:Set(selectedCase)
            else
                caseDropdown.Value = selectedCase
            end

            if Window and Window.Flags then
                Window.Flags.CaseSelection = selectedCase
            end
        end)
        
        if not success then
            warn("Dropdown update failed: " .. tostring(err))
        end
    end)
end

local function safeSet(component, value)
    if not component then return end
    pcall(function()
        if component.Set then
            component:Set(value)
        else
            component.Value = value
        end
    end)
end

local function updateAllUI()
    task.spawn(function()
        task.wait(0.2)
        updateCaseDropdownProperly()
        
        if currentConfig.theme then
            pcall(function()
                WindUI:SetTheme(currentConfig.theme)
                safeSet(themeDropdown, currentConfig.theme)
                safeSet(darkModeToggle, currentConfig.theme == "Dark")
            end)
        end

        local toggles = {
            {autoOpenToggle, autoOpen},
            {autoFarmToggle, obbyEnabled},
            {antiAFKToggle, antiAFKEnabled},
            {autoReconnectToggle, autoReconnectEnabled},
            {autoApplyAnimSpeedToggle, autoApplyAnimSpeed},
            {autoTeleportZone9Toggle, autoTeleportZone9},
            {autoLoadToggle, currentSettings.autoLoadEnabled}
        }

        for _, data in ipairs(toggles) do
            safeSet(data[1], data[2])
        end

        safeSet(intervalInput, tostring(openInterval))
        safeSet(obbyIntervalInput, tostring(obbyInterval))
        safeSet(animationSpeedInput, tostring(currentConfig.animationSpeed or 1000))
    end)
end

local function loadConfigWithProperSync(configName)
    local success = loadConfig(configName)
    if success then
        task.spawn(function()
            updateCaseDropdownProperly()
            updateAllUI()
        end)
    end
    return success
end

local function resetToDefault()
    selectedCase = defaultConfig.selectedCase
    openInterval = defaultConfig.openInterval
    openAmount = defaultConfig.openAmount
    obbyInterval = defaultConfig.obbyInterval
    antiAFKEnabled = false
    autoReconnectEnabled = false
    autoApplyAnimSpeed = true
    autoTeleportZone9 = false
    autoOpen = false
    obbyEnabled = false
    
    task.spawn(function()
        task.wait(0.2)
        updateCaseDropdownProperly()
        updateAllUI()
    end)
    
    WindUI:Notify({
        Title = "Reset Complete",
        Content = "All settings reset to default values",
        Duration = 3
    })
end

local function getAvailableCases()
    local cases = {}
    local foundFromGame = false
    
    local caseSources = {
        ReplicatedStorage:FindFirstChild("Cases"),
        ReplicatedStorage:FindFirstChild("CasesFolder"),
        ReplicatedStorage:FindFirstChild("Items") and ReplicatedStorage.Items:FindFirstChild("Cases"),
        workspace:FindFirstChild("Cases"),
        ReplicatedStorage:FindFirstChild("Data") and ReplicatedStorage.Data:FindFirstChild("Cases"),
        game:GetService("ServerStorage"):FindFirstChild("Cases")
    }
    
    for _, caseSource in pairs(caseSources) do
        if caseSource then
            pcall(function()
                for _, case in pairs(caseSource:GetChildren()) do
                    if case.Name and case.Name ~= "" and not table.find(cases, case.Name) then
                        table.insert(cases, case.Name)
                    end
                end
            end)
            if #cases > 0 then
                foundFromGame = true
                break
            end
        end
    end
    
    if #cases == 0 then
        cases = availableCases
        foundFromGame = false
    end
    
    return cases, foundFromGame
end

local function inputToAnimationSpeed(input)
    if input <= 0 then
        return 1
    end
    return input / 100
end

local function setAnimationSpeed(speed)
    if cachedAnimValue then
        cachedAnimValue.Value = speed
        return true
    end

    local settings = localPlayer:FindFirstChild("SettingsFolder") or localPlayer:FindFirstChild("Settings")
    if settings then
        local animSpeed = settings:FindFirstChild("Animation Speed")
        if animSpeed and animSpeed:IsA("NumberValue") then
            cachedAnimValue = animSpeed
            animSpeed.Value = speed
            return true
        end
    end
    
    return false
end

local function applyInterval()
    if intervalInput then
        local value = intervalInput.Get and intervalInput:Get() or intervalInput.Value or "1000"
        local num = tonumber(value)
        if num and num > 0 then
            openInterval = num
            return true
        end
    end
    return false
end

loadSettings()

if currentSettings.autoLoadEnabled and currentSettings.autoLoadConfig ~= "None" then
    local configName = currentSettings.autoLoadConfig
    
    local success = loadConfig(configName)
    
    if success then
        if antiAFKEnabled then startAntiAFK() end
        if autoReconnectEnabled then setupAutoReconnect() end
        if autoOpen then startAutoOpenLoop() end
        if obbyEnabled then startAutoFarmLoop() end
        
        print("✅ Auto-loaded configuration:", configName)
    else
        warn("⚠️ Auto-load failed for config:", configName)
    end
end

WindUI:SetTheme(currentConfig.theme or defaultConfig.theme)

Window = WindUI:CreateWindow({
    Title = "Kasumi Hub MODDED",
    Icon = "zap",
    Author = "@kasumichwan, @purpleapple9562",
    Folder = "Kasumi",
    Size = UDim2.fromOffset(580, 490),
    Theme = currentConfig.theme or defaultConfig.theme,
    SideBarWidth = 180,
})

Window:SetToggleKey(Enum.KeyCode.G)

Window:CreateTopbarButton("theme-switcher", "moon", function()
    local newTheme = WindUI:GetCurrentTheme() == "Dark" and "Light" or "Dark"
    WindUI:SetTheme(newTheme)
    if canChangeTheme and darkModeToggle then
        darkModeToggle:Set(newTheme == "Dark")
    end
    if canChangeDropdown and themeDropdown then
        themeDropdown:Set(newTheme)
    end
end, 990)

Window:EditOpenButton({
    Title = "Open Kasumi Hub",
    Icon = "zap",
    CornerRadius = UDim.new(0,12),
    StrokeThickness = 2,
    Color = ColorSequence.new(
        Color3.fromHex("FF0F7B"), 
        Color3.fromHex("F89B29")
    ),
    OnlyMobile = true,
    Enabled = true,
    Draggable = true,
})

local InformationTab = Window:Tab({
    Title = "Information",
    Icon = "info",
    Locked = false
})

local AutoOpenTab = Window:Tab({
    Title = "Auto Open Cases",
    Icon = "package",
    Locked = false
})

local AnimationTab = Window:Tab({
    Title = "Case Opening Speed",
    Icon = "zap",
    Locked = false
})

local AutoFarmTab = Window:Tab({
    Title = "Auto Farm",
    Icon = "dollar-sign",
    Locked = false
})

local SettingsTab = Window:Tab({
    Title = "Settings",
    Icon = "settings",
    Locked = false
})

Window:SelectTab(1)

InformationTab:Paragraph({
    Title = "Script Information",
    Desc = [[Script Originally made by: @kasumichwan
    Cracked & Open-Sourced by: @ScriptCracks
    Modified and Improved by: @purpleapple9562
    
    Script Version: ]] .. tostring(SCRIPT_VERSION) .. [[
    
    Changes:
    Optimized all of the functions
    Removed redundant comments, pcalls and functions
    Added Case Amount Changer
    Added Auto Apply for every input
    
    Remarks:
    Holy this script was heavily made by AI when I analysed it.
    Imagine putting a keysystem for a script you barely even made.
    What a pathetic script maker.
    Anyways thats all I have to say for this.
    If you want to support me, consider joining my discord!
    ]],
})

local discordbtn = InformationTab:Button({
    Title = "Copy Discord Link",
    Icon = "clipboard-copy",
    Callback = function()
        setclipboard("https://discord.gg/9Nzzya6d46")
        WindUI:Notify({
            Title = "Copied Link!",
            Content = "Successfully copied link to clipboard!",
            Duration = 2
        })
    end
})

InformationTab:Button({
    Title = "Refresh Game Data",
    Icon = "refresh-cw",
    Callback = function()
        local newCases, fromGame = getAvailableCases()
        availableCases = newCases
        openAmount = getCaseOpenSlots()
        
        if caseDropdown then
            caseDropdown:Refresh(availableCases)
            updateCaseDropdownProperly()
        end
        
        WindUI:Notify({
            Title = "Data Refreshed",
            Content = string.format("Cases: %d (%s), Slots: %d", 
                #availableCases, 
                fromGame and "from game" or "fallback", 
                openAmount),
            Duration = 4
        })
    end
})

caseDropdown = AutoOpenTab:Dropdown({
    Title = "Select Case to Open",
    Values = availableCases,
    Value = selectedCase,
    SearchBarEnabled = true,
    MenuWidth = 400,
    Flag = "CaseSelection",
    Callback = function(value)
        selectedCase = value
    end
})

intervalInput = AutoOpenTab:Input({
    Title = "Opening Interval (ms)",
    Desc = "Time between case opening attempts (best: 100ms to 1000ms)",
    Value = tostring(openInterval),
    Callback = function(value)
        if autoApplyOpenInterval then
            if not autoApplyOpenInterval then return end
            task.spawn(function()
                task.wait(0.5)
                applyInterval()
            end)
        end
    end
})

autoApplyOpenIntervalToggle = AutoOpenTab:Toggle({
    Title = "Enable Auto-Apply Interval",
    Desc = "Automatically apply open interval as you type",
    Value = autoApplyOpenInterval,
    Callback = function(state)
        autoApplyOpenInterval = state
    end
})

AutoOpenTab:Button({
    Title = "Apply Interval",
    Icon = "clock",
    Variant = "Secondary",
    Callback = function()
        applyInterval()
    end
})

autoOpenToggle = AutoOpenTab:Toggle({
    Title = "Enable Auto Opening",
    Desc = "Continuously open selected cases (Ctrl+R to toggle)",
    Value = autoOpen,
    Callback = function(enabled)
        if enabled ~= autoOpen then
            autoOpen = enabled
            
            if enabled then            
                startAutoOpenLoop()
            end
        end
    end
})

amountInput = AutoOpenTab:Input({
    Title = "Open Amount",
    Desc = "Amount of cases to open at once",
    Value = 1,
    InputIcon = "package",
    Type = "Input",
    Placeholder = "Enter amount...",
    Callback = function(input) 
        openAmount = tonumber(input)
    end
})

AutoOpenTab:Button({
    Title = "Open Cases Once",
    Icon = "package",
    Callback = function()
        local success = openCase(selectedCase, openAmount)
        if success then
            WindUI:Notify({
                Title = "Manual Opening",
                Content = string.format("Opened %d x %s", openAmount, selectedCase),
                Duration = 2
            })
        end
    end
})

animationSpeedInput = AnimationTab:Input({
    Title = "Case Opening Animation Speed",
    Desc = "Auto-applies as you type! (best: 1000 to 10000+)",
    Value = tostring(currentConfig.animationSpeed or defaultConfig.animationSpeed),
    Callback = function(value)
        if autoApplyAnimSpeed then
            local inputValue = tonumber(value)
            if inputValue and inputValue > 0 and inputValue ~= lastAppliedAnimSpeed then
                task.spawn(function()
                    task.wait(0.5)
                    local currentValue = animationSpeedInput.Get and animationSpeedInput:Get() or value
                    local finalValue = tonumber(currentValue)
                    
                    if finalValue and finalValue > 0 and finalValue == inputValue then
                        local convertedSpeed = inputToAnimationSpeed(finalValue)
                        local success = setAnimationSpeed(convertedSpeed)
                        if success then
                            lastAppliedAnimSpeed = finalValue
                        end
                    end
                end)
            end
        end
    end
})

autoApplyAnimSpeedToggle = AnimationTab:Toggle({
    Title = "Enable Auto-Apply Speed",
    Desc = "Automatically apply animation speed as you type",
    Value = autoApplyAnimSpeed,
    Callback = function(state)
        autoApplyAnimSpeed = state
    end
})

AnimationTab:Button({
    Title = "Apply Speed Manually",
    Icon = "check",
    Variant = "Primary",
    Callback = function()
        local value = animationSpeedInput.Get and animationSpeedInput:Get() or animationSpeedInput.Value or "1000"
        local inputValue = tonumber(value)
        if inputValue and inputValue > 0 then
            local convertedSpeed = inputToAnimationSpeed(inputValue)
            local success = setAnimationSpeed(convertedSpeed)
            if success then
                lastAppliedAnimSpeed = inputValue
                WindUI:Notify({
                    Title = "Speed Applied",
                    Content = "Animation speed set to: " .. inputValue,
                    Duration = 2
                })
            else
                WindUI:Notify({
                    Title = "Failed",
                    Content = "Failed to set animation speed",
                    Duration = 4
                })
            end
        end
    end
})

AnimationTab:Divider()

AnimationTab:Paragraph({
    Title = "Recommended Settings",
    Desc = [[
â€¢ 100 = Normal speed
â€¢ 500 = 5x faster 
â€¢ 1000 = 10x faster
â€¢ 10000 = 100x faster

You can set it higher!]]
})

AutoFarmTab:Paragraph({
    Title = "Obby Cash Farming",
    Desc = [[Automatically complete obbies to earn cash!

This feature will:
â€¢ Teleport to obby completion platform
â€¢ Automatically collect cash rewards
â€¢ Spam jump for better platform detection

Set your interval and enable to start farming.]]
})

obbyIntervalInput = AutoFarmTab:Input({
    Title = "Farm Interval (ms)",
    Desc = "Time between obby completions (recommended: 3000ms+)",
    Value = tostring(obbyInterval)
    Callback = function(value)
        if autoApplyObbyInterval then
            if not autoApplyObbyInterval then return end
            task.spawn(function()
                task.wait(0.5)
                applyObbyInterval()
            end)
        end
    end
})

autoApplyObbyIntervalToggle = AutoFarmTab:Toggle({
    Title = "Enable Auto-Apply Interval",
    Desc = "Automatically apply open interval as you type",
    Value = autoApplyOpenInterval,
    Callback = function(state)
        autoApplyObbyInterval = state
    end
})

AutoFarmTab:Button({
    Title = "Apply Interval",
    Icon = "clock",
    Variant = "Secondary",
    Callback = function()
        applyObbyInterval()
    end
})

autoFarmToggle = AutoFarmTab:Toggle({
    Title = "Enable Auto Farm",
    Desc = "Automatically complete obbies with spam jumping (Ctrl+F to toggle)",
    Value = obbyEnabled,
    Callback = function(enabled)
        if enabled ~= obbyEnabled then
            obbyEnabled = enabled
            
            if enabled then
                startAutoFarmLoop()
            end
        end
    end
})

AutoFarmTab:Button({
    Title = "Complete Once",
    Icon = "dollar-sign",
    Variant = "Primary",
    Callback = function()
        teleportToObby()
    end
})

AutoFarmTab:Divider()

SettingsTab:Paragraph({
    Title = "Customize Interface",
    Desc = "Personalize your Kasumi Hub experience",
    Image = "palette",
    ImageSize = 20,
    Color = "White"
})

local themes = {}
for themeName, _ in pairs(WindUI:GetThemes()) do
    table.insert(themes, themeName)
end
table.sort(themes)

themeDropdown = SettingsTab:Dropdown({
    Title = "Select Theme",
    Values = themes,
    SearchBarEnabled = true,
    MenuWidth = 280,
    Value = WindUI:GetCurrentTheme(),
    Callback = function(theme)
        canChangeDropdown = false
        WindUI:SetTheme(theme)
        canChangeDropdown = true
    end
})

darkModeToggle = SettingsTab:Toggle({
    Title = "Enable Dark Mode",
    Desc = "Use dark color scheme",
    Value = WindUI:GetCurrentTheme() == "Dark",
    Callback = function(state)
        if canChangeTheme then
            WindUI:SetTheme(state and "Dark" or "Light")
            if canChangeDropdown then
                themeDropdown:Set(state and "Dark" or "Light")
            end
        end
    end
})

WindUI:OnThemeChange(function(theme)
    canChangeTheme = false
    if darkModeToggle then
        darkModeToggle:Set(theme == "Dark")
    end
    canChangeTheme = true
end)

SettingsTab:Divider()

SettingsTab:Paragraph({
    Title = "Connection & Activity",
    Desc = "Manage anti-AFK and auto-reconnect features",
    Image = "wifi",
    ImageSize = 20,
    Color = "White"
})

antiAFKToggle = SettingsTab:Toggle({
    Title = "Enable Anti-AFK",
    Desc = "Prevents idle kick with improved detection",
    Value = antiAFKEnabled,
    Callback = function(state)
        antiAFKEnabled = state
        if antiAFKEnabled then
            startAntiAFK()
        end
    end
})

autoReconnectToggle = SettingsTab:Toggle({
    Title = "Enable Auto-Reconnect",
    Desc = "6 detection methods - 30 tries, 6s interval = 3min total (IMPROVED)",
    Value = autoReconnectEnabled,
    Callback = function(state)
        autoReconnectEnabled = state
        reconnectAttempts = 0
        if autoReconnectEnabled then
            setupAutoReconnect()
        end
    end
})

SettingsTab:Divider()

SettingsTab:Paragraph({
    Title = "Zone 9 Auto-Teleport",
    Desc = "Automatically teleport to Zone 9 when script loads",
    Image = "map-pin",
    ImageSize = 20,
    Color = "White"
})

autoTeleportZone9Toggle = SettingsTab:Toggle({
    Title = "Enable Zone 9 Teleport",
    Desc = "Teleports to Zone 9 twice on startup (3s delay, then 1s delay)",
    Value = autoTeleportZone9,
    Callback = function(state)
        autoTeleportZone9 = state
    end
})

SettingsTab:Button({
    Title = "Teleport to Zone 9 Now",
    Icon = "navigation",
    Variant = "Secondary",
    Callback = function()
        local success = teleportToZone9()
        if success then
            WindUI:Notify({
                Title = "Teleported",
                Content = "Moved to Zone 9",
                Duration = 2
            })
        else
            WindUI:Notify({
                Title = "Teleport Failed",
                Content = "Character not found",
                Duration = 3
            })
        end
    end
})

SettingsTab:Divider()

SettingsTab:Paragraph({
    Title = "Auto-load Settings",
    Desc = "Configure which config to automatically load on startup",
    Image = "settings-2",
    ImageSize = 20,
    Color = "White"
})

autoLoadToggle = SettingsTab:Toggle({
    Title = "Enable Auto-load Config",
    Desc = "Automatically load selected config on startup",
    Value = currentSettings.autoLoadEnabled or false,
    Callback = function(state)
        currentSettings.autoLoadEnabled = state
        saveSettings()
    end
})

local availableConfigs = getAvailableConfigs()
autoLoadDropdown = SettingsTab:Dropdown({
    Title = "Auto-load Config",
    Values = availableConfigs,
    Value = currentSettings.autoLoadConfig or "None",
    SearchBarEnabled = true,
    MenuWidth = 280,
    Callback = function(config)
        currentSettings.autoLoadConfig = config
        saveSettings()
    end
})

SettingsTab:Button({
    Title = "Refresh Config List",
    Icon = "refresh-cw",
    Callback = function()
        local newConfigs = getAvailableConfigs()
        if autoLoadDropdown and autoLoadDropdown.Refresh then
            autoLoadDropdown:Refresh(newConfigs)
        end
    end
})

SettingsTab:Divider()

SettingsTab:Paragraph({
    Title = "Configuration Manager",
    Desc = "Save and load your settings",
    Image = "save",
    ImageSize = 20,
    Color = "White"
})

local configName = "kasumi-config"

ConfigNameInput = SettingsTab:Input({
    Title = "Config Name",
    Value = configName,
    Callback = function(value)
        configName = value or "kasumi-config"
    end
})

SettingsTab:Button({
    Title = "Save Configuration",
    Icon = "save",
    Variant = "Primary",
    Callback = function()
        local name = ConfigNameInput.Get and ConfigNameInput:Get() or configName
        saveConfig(name)
    end
})

SettingsTab:Button({
    Title = "Load Configuration",
    Icon = "folder-open",
    Variant = "Secondary",
    Callback = function()
        local name = ConfigNameInput.Get and ConfigNameInput:Get() or configName
        
        if loadConfigWithProperSync(name) then
            if antiAFKEnabled then startAntiAFK() end
            if autoReconnectEnabled then setupAutoReconnect() end
            if autoOpen then startAutoOpenLoop() end
            if obbyEnabled then startAutoFarmLoop() end
            
            WindUI:Notify({
                Title = "Config Loaded",
                Content = name .. " loaded - Case: " .. selectedCase,
                Duration = 3
            })
        else
            WindUI:Notify({
                Title = "Load Error", 
                Content = "Failed to load config: " .. name,
                Icon = "x",
                Duration = 3
            })
        end
    end
})

SettingsTab:Button({
    Title = "Reset to Default",
    Icon = "rotate-ccw",
    Variant = "Destructive",
    Callback = function()
        resetToDefault()
    end
})

SettingsTab:Divider()

setupKeybinds()

task.spawn(function()
    task.wait(2)
    
    local newCases, fromGame = getAvailableCases()
    availableCases = newCases
    openAmount = getCaseOpenSlots()
    
    if caseDropdown then
        caseDropdown:Refresh(availableCases)
    end

    if autoTeleportZone9 then
        task.spawn(function()
            task.wait(3)
            local success1 = teleportToZone9()
            if success1 then
                print("âœ… Teleported to Zone 9 (1/2)")
            end
            
            task.wait(1)
            local success2 = teleportToZone9()
            if success2 then
                print("âœ… Teleported to Zone 9 (2/2)")
            end
        end)
    end
    
    if currentSettings.autoLoadEnabled and currentSettings.autoLoadConfig ~= "None" then
        task.spawn(function()
            task.wait(0.5)
            updateCaseDropdownProperly()
            updateAllUI()
        end)
        
        WindUI:Notify({
            Title = "Kasumi Hub " .. SCRIPT_VERSION,
            Content = string.format("Auto-loaded: %s\nCase: %s (%d cases, %d slots)", 
                currentSettings.autoLoadConfig,
                selectedCase,
                #availableCases, 
                openAmount),
            Duration = 6
        })
    else
        if not table.find(availableCases, selectedCase) then
            selectedCase = availableCases[1] or defaultConfig.selectedCase
        end
        
        task.spawn(function()
            task.wait(0.5)
            updateCaseDropdownProperly()
            updateAllUI()
        end)
        
        WindUI:Notify({
            Title = "Kasumi Hub MODDED " .. SCRIPT_VERSION,
            Content = string.format("Ready! Case: %s\n%d cases, %d slots\nCtrl+R/F for keybinds", 
                selectedCase,
                #availableCases, 
                openAmount),
            Duration = 6
        })
    end
end)