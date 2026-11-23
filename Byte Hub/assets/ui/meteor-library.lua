local Players = game:GetService('Players')
local Lighting = game:GetService('Lighting')
local RunService = game:GetService('RunService')
local TextService = game:GetService('TextService')
local HttpService = game:GetService('HttpService')
local TweenService = game:GetService('TweenService')
local TextChatService = game:GetService('TextChatService')
local UserInputService = game:GetService('UserInputService')

local isMobile = UserInputService.TouchEnabled
local lplr = Players.LocalPlayer

local GuiLibrary = {}
GuiLibrary.Windows = {}
GuiLibrary.Connections = {}
GuiLibrary.Palette = {
    Font = Enum.Font.Jura,
    Color = Color3.fromRGB(255, 90, 40),
    Color2 = Color3.fromRGB(190, 0, 0)
}
GuiLibrary.Info = {
    Name = "Blaze",
    Version = "1.00",
    Build = "Beta",
}

local Path = "Blaze/Configs/config.json"
local Config = {}
function save()
    if RunService:IsStudio() then	
		       return
    end
	
    if isfile(Path) then
        delfile(Path)
    end
    writefile(Path, HttpService:JSONEncode(Config))
end
function load()
    if RunService:IsStudio() then
        return
    end
	
    if isfile(Path) then
        Config = HttpService:JSONDecode(readfile(Path))
    end
end

load()
task.wait(0.1)

local ScreenGui = Instance.new("ScreenGui", lplr.PlayerGui)
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Name = "Blaze"

local SettingsOverlay = Instance.new("Frame", ScreenGui)
SettingsOverlay.Size = UDim2.fromScale(1, 1)
SettingsOverlay.BackgroundColor3 = Color3.new(0, 0, 0)
SettingsOverlay.BackgroundTransparency = 0.4
SettingsOverlay.Visible = false
SettingsOverlay.ZIndex = 50

local ArrayFrame = Instance.new("Frame", ScreenGui)
ArrayFrame.Position = UDim2.fromScale(0.78, 0.2)
ArrayFrame.Size = UDim2.fromScale(0.21, 0.6)
ArrayFrame.BackgroundTransparency = 1
local ArraySort = Instance.new("UIListLayout", ArrayFrame)
ArraySort.SortOrder = Enum.SortOrder.LayoutOrder
ArraySort.HorizontalAlignment = Enum.HorizontalAlignment.Right
ArraySort.VerticalAlignment = Enum.VerticalAlignment.Top

local ArrayItems = {}
local function createArray(Module: string, ExtraFunc)
    local Item = Instance.new("TextLabel", ArrayFrame)
    Item.BorderSizePixel = 0
    Item.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Item.BackgroundTransparency = 0.5
    Item.TextColor3 = GuiLibrary.Palette.Color
    Item.TextSize = 20
    Item.Font = GuiLibrary.Palette.Font
    Item.RichText = true
    Item.Name = Module
    Item.TextXAlignment = Enum.TextXAlignment.Center
	    
    local r, g, b = Item.TextColor3.R * 255, Item.TextColor3.G * 255, Item.TextColor3.B * 255
    local extra = ExtraFunc and ExtraFunc() or ""
    Item.Text = string.format('<font color="rgb(%d,%d,%d)"> %s </font><font color="rgb(170,170,170)">[%s]</font>', r, g, b, Module, extra)
    
    local plainText = Module .. " [" .. extra.."]  "
    if ExtraFunc == "" or ExtraFunc == nil then
        plainText = " "..Module.." "
        Item.Text = string.format('<font color="rgb(%d,%d,%d)"> %s </font>', r, g, b, Module)
    end
    
    Item.Size = UDim2.new(0, TextService:GetTextSize(plainText, Item.TextSize, Item.Font, Vector2.zero).X + 3, 0, 28)
    
    table.insert(ArrayItems, Item)
    table.sort(ArrayItems, function(ItemA, ItemB)
        local plainA = ItemA.Text:gsub("<[^>]->", " ")
        local plainB = ItemB.Text:gsub("<[^>]->", " ")
        return TextService:GetTextSize(plainA, ItemA.TextSize, ItemA.Font, Vector2.zero).X > TextService:GetTextSize(plainB, ItemB.TextSize, ItemB.Font, Vector2.zero).X
    end)
    
    for i,v in ArrayItems do
        v.LayoutOrder = i
    end
end

local function removeArray(Module: string)
    for i,v in ArrayItems do
        if v.Name == Module then
            v:Destroy()
        end
    end
end

local WCount = 0
GuiLibrary.CreateWindow = function(self, Name: string)
    local Window = Instance.new("Frame", ScreenGui)
    Window.Name = Name
    Window.Size = UDim2.fromOffset(150, 25.5)	
    Window.Position = UDim2.fromScale(0.1 + (WCount * 0.15), 0.2)
    Window.BackgroundColor3 = Color3.fromRGB(147, 62, 226)
    Window.BorderSizePixel = 0
    Window.Active = true
    Window.Draggable = true
    
    local TextLabel = Instance.new("TextLabel", Window)
    TextLabel.Size = UDim2.fromScale(1, 1)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = Name
    TextLabel.TextColor3 = Color3.fromRGB(255,255,255)
    TextLabel.Font = GuiLibrary.Palette.Font
    TextLabel.TextSize = 20
    
    local Arrow = Instance.new("TextButton", TextLabel)
    Arrow.Size = UDim2.fromOffset(25, 25)
    Arrow.Position = UDim2.new(1, -28, 0.5, -12)
    Arrow.BackgroundTransparency = 1
    Arrow.Text = "▼"
    Arrow.TextColor3 = Color3.fromRGB(255,255,255)
    Arrow.Font = GuiLibrary.Palette.Font
    Arrow.TextSize = 18
    
    local Modules = Instance.new('Frame', TextLabel)
    Modules.Position = UDim2.fromScale(0, 1)
    Modules.Size = UDim2.new(1, 0, 0, 0)
    Modules.AutomaticSize = Enum.AutomaticSize.Y
    Modules.BackgroundTransparency = 1
    local ModulesSort = Instance.new('UIListLayout', Modules)
    ModulesSort.SortOrder = Enum.SortOrder.LayoutOrder
    
    Arrow.MouseButton1Click:Connect(function()
        minimized = not minimized
        Arrow.Text = minimized and "▲" or "▼"
        Modules.Visible = minimized and true or false
    end)
    
    table.insert(GuiLibrary.Connections, UserInputService.InputBegan:Connect(function(Input: InputObject, Gpe: boolean)
        if not Gpe then
            if Input.KeyCode == Enum.KeyCode.DPadDown then
                TextLabel.Visible = not TextLabel.Visible
            elseif Input.KeyCode == Enum.KeyCode.RightShift then
                TextLabel.Visible = not TextLabel.Visible
            end
        end
    end))
    
    WCount += 1
    
    GuiLibrary.Windows[Name] = {
        Frame = Window,
        CreateModule = function(self, Table)
            if Config[Table.Name] == nil then
                Config[Table.Name] = {
                    Frame = Window,
                    Name = Name,
                    Enabled = false,
                    SettingsFrame = nil,
                    Keybind = "Unknown",
                    Toggles = {},
                    Pickers = {},
                    Sliders = {},
                }
            end
            
            local TextButton = Instance.new('TextButton', Modules)
            TextButton.Size = UDim2.new(1, 0, 0, 30)
            TextButton.BackgroundColor3 = Color3.fromRGB(20,20,20)
            TextButton.BackgroundTransparency = 0.25
            TextButton.AutoButtonColor = false
            TextButton.BorderSizePixel = 0
            TextButton.TextXAlignment = Enum.TextXAlignment.Center
            TextButton.TextColor3 = Color3.fromRGB(255,255,255)
            TextButton.TextSize = 20
            TextButton.Text = Table.Name
            TextButton.Font = GuiLibrary.Palette.Font
            local DropdownFrame = Instance.new('Frame', Modules)
            DropdownFrame.Size = UDim2.new(1,0,0,0)
            DropdownFrame.AutomaticSize = Enum.AutomaticSize.Y
            DropdownFrame.BackgroundTransparency = 1
            DropdownFrame.Visible = false
            local DropdownFrameSort = Instance.new('UIListLayout', DropdownFrame)
            DropdownFrameSort.SortOrder = Enum.SortOrder.LayoutOrder
            local KeybindThing = Instance.new("TextButton", DropdownFrame)
            KeybindThing.Size = UDim2.new(1, 0, 0, 30)
            KeybindThing.BackgroundColor3 = Color3.fromRGB(55,55,55)
            KeybindThing.BackgroundTransparency = 0.25
            KeybindThing.AutoButtonColor = false
            KeybindThing.BorderSizePixel = 0
            KeybindThing.TextXAlignment = Enum.TextXAlignment.Left
            KeybindThing.TextColor3 = Color3.fromRGB(255,255,255)
            KeybindThing.TextSize = 20
            KeybindThing.Text = 'Keybind: ' .. Config[Table.Name].Keybind
            KeybindThing.Font = GuiLibrary.Palette.Font

            table.insert(GuiLibrary.Connections, KeybindThing.MouseButton1Down:Connect(function()
                task.wait()
                local Connection
                Connection = UserInputService.InputBegan:Connect(function(Input: InputObject, Gpe: boolean)
                    task.wait()
                    if Input.UserInputType == Enum.UserInputType.Gamepad1 then
                        Config[Table.Name].Keybind = tostring(Input.KeyCode):gsub("Enum.KeyCode.", "")
                        KeybindThing.Text = '  Keybind: ' .. Config[Table.Name].Keybind
                        Connection:Disconnect()
                    else
                        if not Gpe then
                            Config[Table.Name].Keybind = tostring(Input.KeyCode):gsub("Enum.KeyCode.", "")
                            KeybindThing.Text = '  Keybind: ' .. Config[Table.Name].Keybind
                            Connection:Disconnect()
                        end
                    end
                end)
            end))
            
            local ModuleTab = {}
            ModuleTab.Name = Table.Name
            ModuleTab.Enabled = false
            ModuleTab.Instance = TextButton
            
            ModuleTab.Toggle = function(self, Silent: boolean)
                ModuleTab.Enabled = not ModuleTab.Enabled
                Config[Table.Name].Enabled = ModuleTab.Enabled
                if ModuleTab.Enabled then if Table.Array ~= false then createArray(Table.Name, Table.ExtraText) end else if Table.Array ~= false then removeArray(Table.Name) end end
                TweenService:Create(TextButton, TweenInfo.new(0.1), {TextColor3 = ModuleTab.Enabled and GuiLibrary.Palette.Color or Color3.fromRGB(255,255,255)}):Play()
                if Table.Function then pcall(Table.Function, ModuleTab.Enabled) end
                save()
            end
            
            ModuleTab.CreateToggle = function(self, Tab)
                if Config[Table.Name].Toggles[Tab.Name] == nil then
                    Config[Table.Name].Toggles[Tab.Name] = {Enabled = false}
                end
                local ToggleButton = Instance.new('TextButton', DropdownFrame)
                ToggleButton.Size = UDim2.new(1, 0, 0, 30)
                ToggleButton.BackgroundColor3 = Color3.fromRGB(55,55,55)
                ToggleButton.AutoButtonColor = false
                ToggleButton.BorderSizePixel = 0
                ToggleButton.TextXAlignment = Enum.TextXAlignment.Left
                ToggleButton.TextColor3 = Color3.fromRGB(255,255,255)
                ToggleButton.TextSize = 20
                ToggleButton.Text = '  ' .. Tab.Name
                ToggleButton.Font = GuiLibrary.Palette.Font
                
                local ToggleTab = {}
                ToggleTab.Enabled = false
                
                ToggleTab.Toggle = function(self)
                    ToggleTab.Enabled = not ToggleTab.Enabled
                    Config[Table.Name].Toggles[Tab.Name].Enabled = ToggleTab.Enabled
                    TweenService:Create(ToggleButton, TweenInfo.new(0.1), {TextColor3 = ToggleTab.Enabled and GuiLibrary.Palette.Color or Color3.fromRGB(255,255,255)}):Play()
                    if Tab.Function then pcall(Tab.Function, ToggleTab.Enabled) end
                    save()
                end
                
                table.insert(GuiLibrary.Connections, ToggleButton.MouseButton1Down:Connect(function()
                    ToggleTab:Toggle();
                end))
                
                if Config[Table.Name].Toggles[Tab.Name].Enabled then
                    ToggleTab:Toggle();
                end
                
                return ToggleTab
            end
            
            ModuleTab.CreatePicker = function(self, Tab)
                if Config[Table.Name].Pickers[Tab.Name] == nil then
                    Config[Table.Name].Pickers[Tab.Name] = {Option = Tab.Default or Tab.Options[1]}
                end
                
                local PickerButton = Instance.new('TextButton', DropdownFrame)
                PickerButton.Size = UDim2.new(1, 0, 0, 30)
                PickerButton.BackgroundColor3 = Color3.fromRGB(55,55,55)
                PickerButton.AutoButtonColor = false
                PickerButton.BorderSizePixel = 0
                PickerButton.TextXAlignment = Enum.TextXAlignment.Left
                PickerButton.TextColor3 = Color3.fromRGB(255,255,255)
                PickerButton.TextSize = 20
                PickerButton.Text = '  ' .. Tab.Name .. ' - ' .. Config[Table.Name].Pickers[Tab.Name].Option
                PickerButton.Font = GuiLibrary.Palette.Font
                
                local PickerTab = {}
                PickerTab.Option = Config[Table.Name].Pickers[Tab.Name].Option
                
                local Index = 1
                table.insert(GuiLibrary.Connections, PickerButton.MouseButton1Down:Connect(function()
                    Index += 1
                    if Index > #Tab.Options then
                        Index = 1
                    end
                    
                    PickerTab.Option = Tab.Options[Index]
                    PickerButton.Text = '  ' .. Tab.Name .. ' - ' .. PickerTab.Option
                end))
                table.insert(GuiLibrary.Connections, PickerButton.MouseButton2Down:Connect(function()
                    Index -= 1
                    if Index < 1 then
                        Index = #Tab.Options
                    end
                    
                    PickerTab.Option = Tab.Options[Index]
                    PickerButton.Text = '  ' .. Tab.Name .. ' - ' .. PickerTab.Option
                end))
                
                return PickerTab
            end
            
            ModuleTab.CreateSettings = function(self, Tab)
                if self.SettingsFrame then
                    return self.SettingsFrame
                end
                
                self.Name = self.Name or "Module"
                
                local Frame = Instance.new("Frame", SettingsOverlay)
                Frame.Size = UDim2.fromScale(0.4, 0.5)
                Frame.Position = UDim2.fromScale(0.3, 0.25)
                Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                Frame.BorderSizePixel = 0
                Frame.ZIndex = 51
                
                local Topbar = Instance.new("Frame", Frame)
                Topbar.Size = UDim2.new(1, 0, 0, 26)
                Topbar.BackgroundColor3 = Color3.fromRGB(147, 62, 226)
                Topbar.BorderSizePixel = 0
                Topbar.ZIndex = 61
                
                local Title = Instance.new("TextLabel", Topbar)
                Title.Size = UDim2.new(1, -26, 1, 0)
                Title.Position = UDim2.new(0, 6, 0, 0)
                Title.BackgroundTransparency = 1
                Title.Text = self.Name or "Settings"
                Title.TextColor3 = Color3.new(1,1,1)
                Title.Font = GuiLibrary.Palette.Font
                Title.TextSize = 16
                Title.TextXAlignment = Enum.TextXAlignment.Left
                Title.ZIndex = 62
                
                local Close = Instance.new("TextButton", Topbar)
                Close.Size = UDim2.new(0, 30, 0, 30)
                Close.Position = UDim2.new(1, -40, 0, -2)
                Close.Text = "X"
                Close.TextSize = 16
                Close.BackgroundTransparency = 1
                Close.TextColor3 = Color3.new(1, 1, 1)
                Close.Font = GuiLibrary.Palette.Font
                Close.ZIndex = 63
                
                Close.MouseButton1Click:Connect(function()
                    SettingsOverlay.Visible = false
                    Frame.Visible = false
                    
                    -- show window content again
                    for _,w in pairs(GuiLibrary.Windows) do
                        if w.Frame then
                            w.Frame.Visible = true
                        end
                    end
                end)
                
                self.SettingsFrame = Frame
                Frame.Visible = false
                return Frame
            end
            
            local startTick = tick()
            table.insert(GuiLibrary.Connections, TextButton.MouseButton1Down:Connect(function()
                ModuleTab:Toggle(false);
                startTick = tick()
            end))
            if isMobile then
                table.insert(GuiLibrary.Connections, TextButton.MouseButton1Up:Connect(function()
                    if (tick() - startTick) > 0.5 then
                        local SettingsFrame = ModuleTab:CreateSettings()
                        for _, w in pairs(GuiLibrary.Windows) do
                            if w.Frame then
                                w.Frame.Visible = false
                            end
                        end
                        
                        SettingsOverlay.Visible = true
                        SettingsFrame.Visible = true
                    end
                end))
            else
                table.insert(GuiLibrary.Connections, TextButton.MouseButton2Down:Connect(function()
                    local SettingsFrame = ModuleTab:CreateSettings()
                    
                    for _, w in pairs(GuiLibrary.Windows) do
                        if w.Frame then
                            w.Frame.Visible = false
                        end
                    end
                    
                    SettingsOverlay.Visible = true
                    SettingsFrame.Visible = true
                end))
            end
            table.insert(GuiLibrary.Connections, TextButton.MouseButton2Down:Connect(function()
                DropdownFrame.Visible = not DropdownFrame.Visible
            end))
            table.insert(GuiLibrary.Connections, UserInputService.InputBegan:Connect(function(Input: InputObject, Gpe: boolean)
                if Input.UserInputType == Enum.UserInputType.Gamepad1 and Input.KeyCode == Enum.KeyCode[Config[Table.Name].Keybind] then
                    ModuleTab:Toggle(false);
                else
                    if not Gpe and Input.KeyCode ~= Enum.KeyCode.Unknown and Input.KeyCode == Enum.KeyCode[Config[Table.Name].Keybind] then
                        ModuleTab:Toggle(false);
                    end
                end
            end))
			
            if Config[Table.Name].Enabled then
                ModuleTab:Toggle(true);
            end
			
            return ModuleTab
        end,
        
        CreateButton = function(self, Tab)
            local ButtonFrame = Instance.new('Frame', Modules)
            ButtonFrame.Size = UDim2.new(1, 0, 0, 28)
            ButtonFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
            ButtonFrame.BorderSizePixel = 0
            
            local Button = Instance.new('TextButton', ButtonFrame)
            Button.Size = UDim2.new(1, 0, 1, 0)
            Button.BackgroundTransparency = 1
            Button.Text = Tab.Name
            Button.Font = GuiLibrary.Palette.Font
            Button.TextSize = 20
            Button.TextColor3 = Color3.fromRGB(255,255,255)
            
            table.insert(GuiLibrary.Connections,
            Button.MouseButton1Click:Connect(function()
                TweenService:Create(ButtonFrame, TweenInfo.new(0.08), {
                    BackgroundColor3 = GuiLibrary.Palette.Color
                }):Play()
                
                task.wait(0.08)
                
                TweenService:Create(ButtonFrame, TweenInfo.new(0.08), {
                    BackgroundColor3 = Color3.fromRGB(40,40,40)
                }):Play()
                
                if Tab.Function then
                    pcall(Tab.Function)
                end
            end)
            )
            
            return ButtonFrame
        end,
    }
end

GuiLibrary:CreateWindow('Main')
GuiLibrary:CreateWindow('Combat')
GuiLibrary:CreateWindow('Movement')
GuiLibrary:CreateWindow('Player')
GuiLibrary:CreateWindow('Render')
GuiLibrary:CreateWindow('Extra')

game.Players.LocalPlayer.PlayerGui.Blaze.Combat.Visible = false
game.Players.LocalPlayer.PlayerGui.Blaze.Movement.Visible = false
game.Players.LocalPlayer.PlayerGui.Blaze.Player.Visible = false
game.Players.LocalPlayer.PlayerGui.Blaze.Render.Visible = false
game.Players.LocalPlayer.PlayerGui.Blaze.Extra.Visible = false

local CombatUIToggle = GuiLibrary.Windows.Main:CreateModule({
    Name = "Combat",
    Array = false,	
    Function = function(callback)
        game.Players.LocalPlayer.PlayerGui.Blaze.Combat.Visible = callback
    end,
})

local MovementUIToggle = GuiLibrary.Windows.Main:CreateModule({
    Name = "Movement",
    Array = false,
    Function = function(callback)
        game.Players.LocalPlayer.PlayerGui.Blaze.Movement.Visible = callback
    end,
})

local PlayerUIToggle = GuiLibrary.Windows.Main:CreateModule({
    Name = "Player",
    Array = false,
    Function = function(callback)
        game.Players.LocalPlayer.PlayerGui.Blaze.Player.Visible = callback
    end,
})

local RenderUIToggle = GuiLibrary.Windows.Main:CreateModule({
    Name = "Render",
    Array = false,
    Function = function(callback)
        game.Players.LocalPlayer.PlayerGui.Blaze.Render.Visible = callback
    end,
})

local ExtraUIToggle = GuiLibrary.Windows.Main:CreateModule({
    Name = "Extra",
    Array = false,
    Function = function(callback)
        game.Players.LocalPlayer.PlayerGui.Blaze.Extra.Visible = callback
    end,
})

local BtnTest = GuiLibrary.Windows.Combat:CreateButton({
    Name = "Button",
    Array = false,	
    Function = function()
        print("Hello World! Button Clicked!")
    end,
})

local Arraylist = GuiLibrary.Windows.Render:CreateModule({
    Name = "Arraylist",
    Array = true,
    Function = function(callback)
        ArrayFrame.Visible = callback
    end,
})

local Settings = Arraylist:CreateSettings()

shared.GuiLibrary = GuiLibrary
