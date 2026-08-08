--!strict
-- Services
local TweenService = game:GetService("TweenService")
local ContentProvider = game:GetService("ContentProvider")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--------------------------------------------------------------------------------
-- CONFIGURATION
--------------------------------------------------------------------------------
getgenv().CONFIG = {
	-- Timing & Progress
	SimulatedMinDuration = 1.7, -- Minimum seconds screen displays
	MaxDuration = 1.7,          -- Maximum total seconds screen displays before forcing completion
	FadeOutDuration = 1.0,      -- Fade-out animation length
	
	-- Color Palette
	Colors = {
		BackgroundInner = Color3.fromRGB(32, 12, 16),
		BackgroundOuter = Color3.fromRGB(12, 6, 8),
		PrimaryText     = Color3.fromRGB(245, 247, 250),
		SecondaryText   = Color3.fromRGB(160, 165, 175),
		Accent          = Color3.fromRGB(220, 20, 60),
		AccentGlow      = Color3.fromRGB(255, 60, 80),
		BarBackground   = Color3.fromRGB(42, 18, 22),
		ParticleColor   = Color3.fromRGB(255, 180, 195),
	},
	
	-- Visual Styling
	CornerRadius = UDim.new(0, 8),
	FontPrimary  = Enum.Font.GothamMedium,
	FontBold     = Enum.Font.GothamBold,
	
	-- Particles
	ParticleCount = 22,
	
	-- Loading Status Messages
	StatusMessages = {
		"Initializing Core Engine...",
		"Loading Variables...",
		"Fetching Instances...",
		"Connecting Data Streams...",
		"Finalizing Interface...",
		"Ready!"
	}
}

--------------------------------------------------------------------------------
-- UI CREATION HELPERS
--------------------------------------------------------------------------------
local function createInstance<T>(className: string, properties: {[string]: any}): T
	local instance = Instance.new(className)
	for prop, val in pairs(properties) do
		(instance :: any)[prop] = val
	end
	return instance :: T
end

-- Create ScreenGui
local screenGui = createInstance("ScreenGui", {
	Name = "ProfessionalLoadingScreen",
	IgnoreGuiInset = true,
	ResetOnSpawn = false,
	DisplayOrder = 999,
	Parent = PlayerGui
})

-- Main Canvas Container
local mainFrame = createInstance("Frame", {
	Name = "MainFrame",
	Size = UDim2.fromScale(1, 1),
	BackgroundColor3 = getgenv().CONFIG.Colors.BackgroundInner,
	BorderSizePixel = 0,
	Parent = screenGui
})

-- Background Gradient
local bgGradient = createInstance("UIGradient", {
	Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, getgenv().CONFIG.Colors.BackgroundInner),
		ColorSequenceKeypoint.new(1, getgenv().CONFIG.Colors.BackgroundOuter)
	}),
	Rotation = 45,
	Parent = mainFrame
})

-- Background Floating Particles Container
local particleContainer = createInstance("Frame", {
	Name = "ParticleContainer",
	Size = UDim2.fromScale(1, 1),
	BackgroundTransparency = 1,
	ClipsDescendants = true,
	Parent = mainFrame
})

-- Central Content Container
local centerContent = createInstance("CanvasGroup", {
	Name = "CenterContent",
	Size = UDim2.fromScale(0.4, 0.35),
	Position = UDim2.fromScale(0.5, 0.5),
	AnchorPoint = Vector2.new(0.5, 0.5),
	BackgroundTransparency = 1,
	GroupTransparency = 0,
	Parent = mainFrame
})

-- Responsive Constraint
createInstance("UIAspectRatioConstraint", {
	AspectRatio = 1.5,
	AspectType = Enum.AspectType.FitWithinMaxSize,
	DominantAxis = Enum.DominantAxis.Width,
	Parent = centerContent
})

-- Spinner Ring Container
local spinnerContainer = createInstance("Frame", {
	Name = "SpinnerContainer",
	Size = UDim2.fromOffset(72, 72),
	Position = UDim2.fromScale(0.5, 0.18),
	AnchorPoint = Vector2.new(0.5, 0.5),
	BackgroundTransparency = 1,
	Parent = centerContent
})

local spinnerRing = createInstance("ImageLabel", {
	Name = "SpinnerRing",
	Size = UDim2.fromScale(1, 1),
	BackgroundTransparency = 1,
	Image = "rbxassetid://6015805344",
	ImageColor3 = getgenv().CONFIG.Colors.Accent,
	ImageTransparency = 0.1,
	Parent = spinnerContainer
})

-- Title Label
local titleLabel = createInstance("TextLabel", {
	Name = "TitleLabel",
	Text = "Byte Hub",
	Font = getgenv().CONFIG.FontBold,
	TextSize = 28,
	TextColor3 = getgenv().CONFIG.Colors.PrimaryText,
	Size = UDim2.new(1, 0, 0, 32),
	Position = UDim2.fromScale(0.5, 0.46),
	AnchorPoint = Vector2.new(0.5, 0.5),
	BackgroundTransparency = 1,
	Parent = centerContent
})

-- Subtitle / Status Label
local statusLabel = createInstance("TextLabel", {
	Name = "StatusLabel",
	Text = getgenv().CONFIG.StatusMessages[1],
	Font = getgenv().CONFIG.FontPrimary,
	TextSize = 14,
	TextColor3 = getgenv().CONFIG.Colors.SecondaryText,
	Size = UDim2.new(1, 0, 0, 20),
	Position = UDim2.fromScale(0.5, 0.58),
	AnchorPoint = Vector2.new(0.5, 0.5),
	BackgroundTransparency = 1,
	Parent = centerContent
})

-- Progress Track Background
local trackFrame = createInstance("Frame", {
	Name = "ProgressBarTrack",
	Size = UDim2.new(0.9, 0, 0, 8),
	Position = UDim2.fromScale(0.5, 0.74),
	AnchorPoint = Vector2.new(0.5, 0.5),
	BackgroundColor3 = getgenv().CONFIG.Colors.BarBackground,
	BorderSizePixel = 0,
	ClipsDescendants = true,
	Parent = centerContent
})

createInstance("UICorner", { CornerRadius = getgenv().CONFIG.CornerRadius, Parent = trackFrame })

-- Progress Fill
local fillFrame = createInstance("Frame", {
	Name = "ProgressBarFill",
	Size = UDim2.fromScale(0, 1),
	BackgroundColor3 = getgenv().CONFIG.Colors.Accent,
	BorderSizePixel = 0,
	Parent = trackFrame
})

createInstance("UICorner", { CornerRadius = getgenv().CONFIG.CornerRadius, Parent = fillFrame })

-- Glowing Bar Stroke
local fillGlow = createInstance("UIStroke", {
	Color = getgenv().CONFIG.Colors.AccentGlow,
	Thickness = 1.5,
	Transparency = 0.2,
	Parent = fillFrame
})

-- Percentage Text
local percentLabel = createInstance("TextLabel", {
	Name = "PercentLabel",
	Text = "0%",
	Font = getgenv().CONFIG.FontBold,
	TextSize = 13,
	TextColor3 = getgenv().CONFIG.Colors.PrimaryText,
	Size = UDim2.new(0, 50, 0, 20),
	Position = UDim2.fromScale(0.5, 0.88),
	AnchorPoint = Vector2.new(0.5, 0.5),
	BackgroundTransparency = 1,
	Parent = centerContent
})

--------------------------------------------------------------------------------
-- ANIMATIONS & PARTICLES
--------------------------------------------------------------------------------
local activeTweens: {Tween} = {}
local activeConnections: {RBXScriptConnection} = {}

local function registerTween(tween: Tween): Tween
	tween:Play()
	table.insert(activeTweens, tween)
	return tween
end

-- 1. Continuous Ring Rotation
registerTween(TweenService:Create(
	spinnerRing,
	TweenInfo.new(1.8, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
	{ Rotation = 360 }
))

-- 2. Ambient Gradient Rotation
registerTween(TweenService:Create(
	bgGradient,
	TweenInfo.new(8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
	{ Rotation = 135 }
))

-- 3. Title Gentle Breathing Scale
registerTween(TweenService:Create(
	titleLabel,
	TweenInfo.new(2.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
	{ TextSize = 30 }
))

-- 4. Ambient Particle Engine
local function createParticle()
	local size = math.random(3, 7)
	local particle = createInstance("Frame", {
		Size = UDim2.fromOffset(size, size),
		Position = UDim2.fromScale(math.random(), math.random(10, 11) / 10),
		BackgroundColor3 = getgenv().CONFIG.Colors.ParticleColor,
		BackgroundTransparency = math.random(4, 8) / 10,
		BorderSizePixel = 0,
		Parent = particleContainer
	})
	
	createInstance("UICorner", { CornerRadius = UDim.new(1, 0), Parent = particle })
	
	local targetY = -0.2
	local duration = math.random(6, 14)
	local xOffset = (math.random() - 0.5) * 0.15
	
	local moveTween = TweenService:Create(
		particle,
		TweenInfo.new(duration, Enum.EasingStyle.Linear),
		{
			Position = UDim2.fromScale(math.clamp(particle.Position.X.Scale + xOffset, 0, 1), targetY),
			BackgroundTransparency = 1
		}
	)
	
	moveTween:Play()
	local conn: RBXScriptConnection
	conn = moveTween.Completed:Connect(function()
		conn:Disconnect()
		particle:Destroy()
	end)
end

local particleConn = RunService.Heartbeat:Connect(function()
	if #particleContainer:GetChildren() < getgenv().CONFIG.ParticleCount then
		createParticle()
	end
end)
table.insert(activeConnections, particleConn)

--------------------------------------------------------------------------------
-- ASSET PRELOADING & PROGRESS LOGIC
--------------------------------------------------------------------------------
local function updateProgress(ratio: number)
	ratio = math.clamp(ratio, 0, 1)
	
	-- Smooth fill bar
	local barTween = TweenService:Create(
		fillFrame,
		TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{ Size = UDim2.fromScale(ratio, 1) }
	)
	barTween:Play()
	
	-- Percentage text
	percentLabel.Text = string.format("%d%%", math.floor(ratio * 100))
	
	-- Status text index transition
	local statusIndex = math.clamp(
		math.ceil(ratio * #getgenv().CONFIG.StatusMessages),
		1,
		#getgenv().CONFIG.StatusMessages
	)
	statusLabel.Text = getgenv().CONFIG.StatusMessages[statusIndex]
end

local function runLoadingSequence()
	local startTime = tick()
	local assetsToPreload = workspace:GetChildren()
	local totalAssets = #assetsToPreload
	local loadedAssets = 0
	
	local minDuration = getgenv().CONFIG.SimulatedMinDuration
	local maxDuration = math.max(getgenv().CONFIG.MaxDuration, minDuration)
	
	if totalAssets > 0 then
		for _, asset in ipairs(assetsToPreload) do
			local elapsedTime = tick() - startTime
			if elapsedTime >= maxDuration then
				break
			end
			
			ContentProvider:PreloadAsync({asset})
			loadedAssets += 1
			
			local realProgress = loadedAssets / totalAssets
			local timeProgress = math.clamp(elapsedTime / minDuration, 0, 1)
			
			updateProgress(math.min(realProgress, timeProgress))
			task.wait()
		end
	end
	
	-- Wait for minimum display threshold while capping at max duration
	while (tick() - startTime) < minDuration do
		local elapsedTime = tick() - startTime
		if elapsedTime >= maxDuration then
			break
		end
		updateProgress(elapsedTime / minDuration)
		task.wait(0.03)
	end
	
	updateProgress(1.0)
	task.wait(0.4)
end

--------------------------------------------------------------------------------
-- CLEANUP & DISMISSAL
--------------------------------------------------------------------------------
local function dismissLoadingScreen()
	-- Stop recurring background tasks and cancel active infinite tweens
	for _, conn in ipairs(activeConnections) do
		conn:Disconnect()
	end
	table.clear(activeConnections)
	
	for _, tween in ipairs(activeTweens) do
		tween:Cancel()
	end
	table.clear(activeTweens)
	
	-- Clean remaining particle instances
	particleContainer:ClearAllChildren()

	-- Fade out UI container cleanly using CanvasGroup.GroupTransparency
	local fadeInfo = TweenInfo.new(getgenv().CONFIG.FadeOutDuration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	
	local fadeMain = TweenService:Create(mainFrame, fadeInfo, { BackgroundTransparency = 1 })
	local fadeCenter = TweenService:Create(centerContent, fadeInfo, { GroupTransparency = 1 })
	
	fadeMain:Play()
	fadeCenter:Play()
	
	-- Wait safely for completion
	fadeMain.Completed:Wait()
	
	-- Safe final destruction
	screenGui:Destroy()
end

--------------------------------------------------------------------------------
-- ENTRY POINT
--------------------------------------------------------------------------------
local soundSrc = game:HttpGet("https://github.com/screengui/bytehub/raw/refs/heads/main/Byte%20Hub/assets/sounds/sfx/startUp2.mp3")
writefile("ByteHub/assets/sounds/sfx/startUp2.mp3", soundSrc)
local startUpSound = getcustomasset("ByteHub/assets/sounds/sfx/startUp2.mp3")
local soundInstance = Instance.new("Sound", game:GetService("SoundService"))
soundInstance.SoundId = startUpSound
soundInstance:Play()
runLoadingSequence()
dismissLoadingScreen() 
