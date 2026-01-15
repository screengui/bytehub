-- Services
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- JSONBin info
local BIN_ID = "6968e2ddae596e708fde2aa3"
local BIN_KEY = "$2a$10$PCJCehLoZMNINvvj8XjrZ.93B3iqH/uzGx70aU9lN9i7RY9bZsJuO"
local API_URL = "https://api.jsonbin.io/v3/b/"..BIN_ID

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PrivateChatTunnel"
ScreenGui.Parent = CoreGui
ScreenGui.IgnoreGuiInset = true

-- Chat frame
local ChatFrame = Instance.new("Frame")
ChatFrame.Size = UDim2.new(0, 300, 0, 400)
ChatFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
ChatFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
ChatFrame.Visible = false -- start closed
ChatFrame.Parent = ScreenGui
ChatFrame.Active = true
ChatFrame.Draggable = true -- draggable

local UICorner = Instance.new("UICorner")
UICorner.Parent = ChatFrame

-- Open / Close button
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 100, 0, 40)
ToggleButton.Position = UDim2.new(0.5, -50, 0, 50)
ToggleButton.Text = "Open Chat"
ToggleButton.BackgroundColor3 = Color3.fromRGB(0,120,215)
ToggleButton.TextColor3 = Color3.fromRGB(255,255,255)
ToggleButton.Parent = ScreenGui
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextSize = 18

ToggleButton.MouseButton1Click:Connect(function()
    ChatFrame.Visible = not ChatFrame.Visible
    ToggleButton.Text = ChatFrame.Visible and "Close Chat" or "Open Chat"
end)

-- Scrolling frame for messages
local MessagesFrame = Instance.new("ScrollingFrame")
MessagesFrame.Size = UDim2.new(1, -10, 1, -50)
MessagesFrame.Position = UDim2.new(0,5,0,5)
MessagesFrame.BackgroundTransparency = 1
MessagesFrame.CanvasSize = UDim2.new(0,0,0,0)
MessagesFrame.ScrollBarThickness = 4
MessagesFrame.Parent = ChatFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = MessagesFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0,5)

-- TextBox for input
local InputBox = Instance.new("TextBox")
InputBox.Size = UDim2.new(1, -60, 0, 30)
InputBox.Position = UDim2.new(0,5,1,-35)
InputBox.PlaceholderText = "Type a message..."
InputBox.BackgroundColor3 = Color3.fromRGB(35,35,35)
InputBox.TextColor3 = Color3.fromRGB(255,255,255)
InputBox.ClearTextOnFocus = false
InputBox.Parent = ChatFrame

local SendButton = Instance.new("TextButton")
SendButton.Size = UDim2.new(0,50,0,30)
SendButton.Position = UDim2.new(1,-55,1,-35)
SendButton.Text = "Send"
SendButton.BackgroundColor3 = Color3.fromRGB(0,120,215)
SendButton.TextColor3 = Color3.fromRGB(255,255,255)
SendButton.Parent = ChatFrame

-- Function to fetch chat messages
local function fetchMessages()
    local headers = {["X-Master-Key"] = BIN_KEY}
    local success, res = pcall(function()
        return HttpService:GetAsync(API_URL, false, headers)
    end)
    if success then
        local data = HttpService:JSONDecode(res)
        return data.record or {}
    end
    return {}
end

-- Function to update bin
local function updateMessages(messages)
    local headers = {
        ["Content-Type"] = "application/json",
        ["X-Master-Key"] = BIN_KEY
    }
    local body = HttpService:JSONEncode(messages)
    pcall(function()
        HttpService:PutAsync(API_URL, body, Enum.HttpContentType.ApplicationJson, false, headers)
    end)
end

-- Function to display messages
local function displayMessages(messages)
    -- clear only labels, not the frame itself
    for _, child in ipairs(MessagesFrame:GetChildren()) do
        if child:IsA("TextLabel") then
            child:Destroy()
        end
    end

    for i, msg in ipairs(messages) do
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1,0,0,20)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(255,255,255)
        label.Font = Enum.Font.SourceSans
        label.TextSize = 16
        label.Text = "["..msg.user.."]: "..msg.text
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.LayoutOrder = i
        label.Parent = MessagesFrame
    end

    -- make scrolling frame size match content
    MessagesFrame.CanvasSize = UDim2.new(0,0,0,UIListLayout.AbsoluteContentSize.Y + 10)
    MessagesFrame.CanvasPosition = Vector2.new(0, UIListLayout.AbsoluteContentSize.Y) -- scroll to bottom
end

local function appendMessage(msg)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,0,0,20)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.Font = Enum.Font.SourceSans
    label.TextSize = 16
    label.Text = "["..msg.user.."]: "..msg.text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.LayoutOrder = MessagesFrame.UIListLayout.AbsoluteContentSize.Y + 1
    label.Parent = MessagesFrame

    -- Update CanvasSize so scrolling works
    MessagesFrame.CanvasSize = UDim2.new(0,0,0,MessagesFrame.UIListLayout.AbsoluteContentSize.Y + 10)
end

local function sendMessage(text)
    local msg = {user = LocalPlayer.Name, text = text}
    
    -- append to UI immediately
    appendMessage(msg)
    
    -- update JSONBin
    local messages = fetchMessages()
    table.insert(messages, msg)
    updateMessages(messages)
end

-- Keep track of last messages to avoid duplicates
local lastMessages = {}

-- Function to refresh messages from JSONBin
local function refreshMessages()
    local messages = fetchMessages()
    for i, msg in ipairs(messages) do
        -- only append if we haven't already displayed this message
        local found = false
        for _, m in ipairs(lastMessages) do
            if m.user == msg.user and m.text == msg.text then
                found = true
                break
            end
        end
        if not found then
            appendMessage(msg)
            table.insert(lastMessages, msg)
        end
    end
end

-- RunService loop to periodically fetch new messages
RunService.Heartbeat:Connect(function()
    refreshMessages()
end)

SendButton.MouseButton1Click:Connect(function()
    if InputBox.Text ~= "" then
        sendMessage(InputBox.Text)
        InputBox.Text = ""
    end
end)

InputBox.FocusLost:Connect(function(enterPressed)
    if enterPressed and InputBox.Text ~= "" then
        sendMessage(InputBox.Text)
        InputBox.Text = ""
    end
end)

-- Optional: manually refresh by calling this later
-- local messages = fetchMessages()
-- displayMessages(messages)
